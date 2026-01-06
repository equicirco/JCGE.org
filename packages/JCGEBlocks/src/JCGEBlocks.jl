module JCGEBlocks

using JCGECore
using JCGEKernel
using JuMP

export DummyBlock
export ProductionBlock
export FactorSupplyBlock
export HouseholdDemandBlock
export MarketClearingBlock
export PriceLinkBlock
export NumeraireBlock

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

struct FactorSupplyBlock <: JCGECore.AbstractBlock
    name::Symbol
    factors::Vector{Symbol}
    params::NamedTuple
end

struct HouseholdDemandBlock <: JCGECore.AbstractBlock
    name::Symbol
    households::Vector{Symbol}
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    params::NamedTuple
end

struct MarketClearingBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
end

struct PriceLinkBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct NumeraireBlock <: JCGECore.AbstractBlock
    name::Symbol
    kind::Symbol
    label::Symbol
    value::Float64
end

function global_var(base::Symbol, idxs::Symbol...)
    if isempty(idxs)
        return base
    end
    return Symbol(string(base), "_", join(string.(idxs), "_"))
end

function var_name(block::FactorSupplyBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::FactorSupplyBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::HouseholdDemandBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::HouseholdDemandBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::MarketClearingBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::MarketClearingBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::PriceLinkBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PriceLinkBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::NumeraireBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::NumeraireBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::ProductionBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
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
        constraint = model isa JuMP.Model ? @NLconstraint(model, Y[i] == JCGECore.getparam(block.params, :b, i) * prod(F[(h, i)] ^ JCGECore.getparam(block.params, :beta, h, i) for h in factors)) : nothing
        register_eq!(ctx, block, :eqpy, i; info="Y[i] == b[i] * prod(F[h,i]^beta[h,i])", constraint=constraint)

        for h in factors
            constraint = model isa JuMP.Model ? @NLconstraint(model, F[(h, i)] == JCGECore.getparam(block.params, :beta, h, i) * py[i] * Y[i] / pf[h]) : nothing
            register_eq!(ctx, block, :eqF, h, i; info="F[h,i] == beta[h,i] * py[i] * Y[i] / pf[h]", constraint=constraint)
        end

        for j in commodities
            constraint = model isa JuMP.Model ? @constraint(model, X[(j, i)] == JCGECore.getparam(block.params, :ax, j, i) * Z[i]) : nothing
            register_eq!(ctx, block, :eqX, j, i; info="X[j,i] == ax[j,i] * Z[i]", constraint=constraint)
        end

        constraint = model isa JuMP.Model ? @constraint(model, Y[i] == JCGECore.getparam(block.params, :ay, i) * Z[i]) : nothing
        register_eq!(ctx, block, :eqY, i; info="Y[i] == ay[i] * Z[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, pz[i] == JCGECore.getparam(block.params, :ay, i) * py[i] + sum(JCGECore.getparam(block.params, :ax, j, i) * pq[j] for j in commodities)) : nothing
        register_eq!(ctx, block, :eqpzs, i; info="pz[i] == ay[i]*py[i] + sum(ax[j,i]*pq[j])", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::FactorSupplyBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    for h in factors
        var = ensure_var!(ctx, model, var_name(block, :FF, h))
        constraint = model isa JuMP.Model ? @constraint(model, var == JCGECore.getparam(block.params, :FF, h)) : nothing
        register_eq!(ctx, block, :eqFF, h; info="FF[h] == endowment[h]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::HouseholdDemandBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    households = isempty(block.households) ? spec.model.sets.institutions : block.households
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Xp = Dict{Tuple{Symbol,Symbol},Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    Sp = Dict{Symbol,Any}()
    Td = Dict{Symbol,Any}()
    Y = Dict{Symbol,Any}()

    for i in commodities
        pq[i] = ensure_var!(ctx, model, var_name(block, :pq, i))
    end

    for h in factors
        pf[h] = ensure_var!(ctx, model, var_name(block, :pf, h))
    end

    for hh in households
        Sp[hh] = ensure_var!(ctx, model, var_name(block, :Sp, hh))
        Td[hh] = ensure_var!(ctx, model, var_name(block, :Td, hh))
        Y[hh] = ensure_var!(ctx, model, var_name(block, :Y, hh))
    end

    for i in commodities, hh in households
        Xp[(i, hh)] = ensure_var!(ctx, model, var_name(block, :Xp, i, hh))
    end

    for hh in households
        constraint = model isa JuMP.Model ? @constraint(model, Y[hh] == sum(pf[h] * JCGECore.getparam(block.params, :FF, h, hh) for h in factors)) : nothing
        register_eq!(ctx, block, :eqY, hh; info="Y[hh] == sum(pf[h] * FF[h,hh])", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, Sp[hh] == JCGECore.getparam(block.params, :ssp, hh) * Y[hh]) : nothing
        register_eq!(ctx, block, :eqSp, hh; info="Sp[hh] == ssp[hh] * Y[hh]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, Td[hh] == JCGECore.getparam(block.params, :tau_d, hh) * Y[hh]) : nothing
        register_eq!(ctx, block, :eqTd, hh; info="Td[hh] == tau_d[hh] * Y[hh]", constraint=constraint)

        for i in commodities
            constraint = model isa JuMP.Model ? @NLconstraint(model, Xp[(i, hh)] == JCGECore.getparam(block.params, :alpha, i, hh) * (Y[hh] - Sp[hh] - Td[hh]) / pq[i]) : nothing
            register_eq!(ctx, block, :eqXp, i, hh; info="Xp[i,hh] == alpha[i,hh] * (Y - Sp - Td) / pq[i]", constraint=constraint)
        end
    end

    return nothing
end

function JCGECore.build!(block::MarketClearingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Q = Dict{Symbol,Any}()
    Xp = Dict{Tuple{Symbol,Symbol},Any}()
    Xg = Dict{Symbol,Any}()
    Xv = Dict{Symbol,Any}()
    X = Dict{Tuple{Symbol,Symbol},Any}()
    F = Dict{Tuple{Symbol,Symbol},Any}()
    FF = Dict{Symbol,Any}()

    for i in commodities
        Q[i] = ensure_var!(ctx, model, var_name(block, :Q, i))
        Xg[i] = ensure_var!(ctx, model, var_name(block, :Xg, i))
        Xv[i] = ensure_var!(ctx, model, var_name(block, :Xv, i))
    end

    for h in factors
        FF[h] = ensure_var!(ctx, model, var_name(block, :FF, h))
    end

    for i in commodities, hh in spec.model.sets.institutions
        Xp[(i, hh)] = ensure_var!(ctx, model, var_name(block, :Xp, i, hh))
    end

    for j in commodities, i in spec.model.sets.activities
        X[(j, i)] = ensure_var!(ctx, model, var_name(block, :X, j, i))
    end

    for h in factors, i in spec.model.sets.activities
        F[(h, i)] = ensure_var!(ctx, model, var_name(block, :F, h, i))
    end

    for i in commodities
        constraint = model isa JuMP.Model ? @constraint(model, Q[i] == sum(Xp[(i, hh)] for hh in spec.model.sets.institutions) + Xg[i] + Xv[i] + sum(X[(i, j)] for j in spec.model.sets.activities)) : nothing
        register_eq!(ctx, block, :eqQ, i; info="Q[i] == sum(Xp[i,hh]) + Xg[i] + Xv[i] + sum(X[i,j])", constraint=constraint)
    end

    for h in factors
        constraint = model isa JuMP.Model ? @constraint(model, FF[h] == sum(F[(h, i)] for i in spec.model.sets.activities)) : nothing
        register_eq!(ctx, block, :eqF, h; info="FF[h] == sum(F[h,i])", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::PriceLinkBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    pe = Dict{Symbol,Any}()
    pm = Dict{Symbol,Any}()
    epsilon = ensure_var!(ctx, model, var_name(block, :epsilon))

    for i in commodities
        pe[i] = ensure_var!(ctx, model, var_name(block, :pe, i))
        pm[i] = ensure_var!(ctx, model, var_name(block, :pm, i))
    end

    for i in commodities
        constraint = model isa JuMP.Model ? @constraint(model, pe[i] == epsilon * JCGECore.getparam(block.params, :pWe, i)) : nothing
        register_eq!(ctx, block, :eqpe, i; info="pe[i] == epsilon * pWe[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, pm[i] == epsilon * JCGECore.getparam(block.params, :pWm, i)) : nothing
        register_eq!(ctx, block, :eqpm, i; info="pm[i] == epsilon * pWm[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::NumeraireBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    model = ctx.model
    if model isa JuMP.Model
        if block.kind == :factor
            pf = ensure_var!(ctx, model, var_name(block, :pf, block.label))
            JuMP.fix(pf, block.value; force=true)
        elseif block.kind == :commodity
            pq = ensure_var!(ctx, model, var_name(block, :pq, block.label))
            JuMP.fix(pq, block.value; force=true)
        elseif block.kind == :exchange
            epsilon = ensure_var!(ctx, model, var_name(block, :epsilon))
            JuMP.fix(epsilon, block.value; force=true)
        else
            error("Unknown numeraire kind: $(block.kind)")
        end
    end
    register_eq!(ctx, block, :numeraire; info="numeraire fixed", constraint=nothing)
    return nothing
end

end # module
