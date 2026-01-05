module JCGEBlocks

using JCGECore
using JCGEKernel
using JuMP

export DummyBlock
export ProductionBlock

"Minimal example block used to validate end-to-end wiring."
struct DummyBlock <: JCGECore.AbstractBlock
    name::Symbol
end

function JCGECore.build!(block::DummyBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    JCGEKernel.register_variable!(ctx, Symbol(block.name, :_x), 1.0)
    JCGEKernel.register_equation!(ctx; tag=:dummy_eq, block=block.name, payload="x==1 (placeholder)")
    return nothing
end

struct ProductionBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    commodities::Vector{Symbol}
    params::NamedTuple
end

function var_name(block::ProductionBlock, base::Symbol, idxs::Symbol...)
    if isempty(idxs)
        return Symbol(string(block.name), "_", base)
    end
    return Symbol(string(block.name), "_", base, "_", join(string.(idxs), "_"))
end

function ensure_var!(ctx::JCGEKernel.KernelContext, model, name::Symbol; lower=0.00001, start=nothing)
    if haskey(ctx.variables, name)
        return ctx.variables[name]
    end
    if model isa JuMP.Model
        if start === nothing
            v = @variable(model, lower_bound=lower, base_name=string(name))
        else
            v = @variable(model, lower_bound=lower, base_name=string(name), start=start)
        end
    else
        v = (name=name)
    end
    JCGEKernel.register_variable!(ctx, name, v)
    return v
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ProductionBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function JCGECore.build!(block::ProductionBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities

    b = block.params.b
    beta = block.params.beta
    ay = block.params.ay
    ax = block.params.ax

    model = ctx.model
    Y = Dict{Symbol,Any}()
    Z = Dict{Symbol,Any}()
    py = Dict{Symbol,Any}()
    pz = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    F = Dict{Tuple{Symbol,Symbol},Any}()
    X = Dict{Tuple{Symbol,Symbol},Any}()

    for i in activities
        Y[i] = ensure_var!(ctx, model, var_name(block, :Y, i))
        Z[i] = ensure_var!(ctx, model, var_name(block, :Z, i))
        py[i] = ensure_var!(ctx, model, var_name(block, :py, i))
        pz[i] = ensure_var!(ctx, model, var_name(block, :pz, i))
    end

    for j in commodities
        pq[j] = ensure_var!(ctx, model, var_name(block, :pq, j))
    end

    for h in factors
        pf[h] = ensure_var!(ctx, model, var_name(block, :pf, h))
    end

    for h in factors, i in activities
        F[(h, i)] = ensure_var!(ctx, model, var_name(block, :F, h, i))
    end

    for j in commodities, i in activities
        X[(j, i)] = ensure_var!(ctx, model, var_name(block, :X, j, i))
    end

    for i in activities
        constraint = model isa JuMP.Model ? @NLconstraint(model, Y[i] == b[i] * prod(F[(h, i)] ^ beta[(h, i)] for h in factors)) : nothing
        register_eq!(ctx, block, :eqpy, i; info="Y[i] == b[i] * prod(F[h,i]^beta[h,i])", constraint=constraint)

        for h in factors
            constraint = model isa JuMP.Model ? @NLconstraint(model, F[(h, i)] == beta[(h, i)] * py[i] * Y[i] / pf[h]) : nothing
            register_eq!(ctx, block, :eqF, h, i; info="F[h,i] == beta[h,i] * py[i] * Y[i] / pf[h]", constraint=constraint)
        end

        for j in commodities
            constraint = model isa JuMP.Model ? @constraint(model, X[(j, i)] == ax[(j, i)] * Z[i]) : nothing
            register_eq!(ctx, block, :eqX, j, i; info="X[j,i] == ax[j,i] * Z[i]", constraint=constraint)
        end

        constraint = model isa JuMP.Model ? @constraint(model, Y[i] == ay[i] * Z[i]) : nothing
        register_eq!(ctx, block, :eqY, i; info="Y[i] == ay[i] * Z[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, pz[i] == ay[i] * py[i] + sum(ax[(j, i)] * pq[j] for j in commodities)) : nothing
        register_eq!(ctx, block, :eqpzs, i; info="pz[i] == ay[i]*py[i] + sum(ax[j,i]*pq[j])", constraint=constraint)
    end

    return nothing
end

end # module
