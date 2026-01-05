module JCGEKernel

using DualSignals
using JuMP
using JCGECore

export KernelContext, register_variable!, register_equation!, list_equations
export equation_residuals, summarize_residuals, to_dualsignals
export solve!
export run!

"Minimal kernel context with registries."
mutable struct KernelContext
    variables::Dict{Symbol,Any}
    equations::Vector{NamedTuple}
    model::Union{JuMP.Model,Nothing}
end

KernelContext(; model::Union{JuMP.Model,Nothing}=nothing) = KernelContext(Dict{Symbol,Any}(), NamedTuple[], model)

"Register a variable handle under a symbolic name."
function register_variable!(ctx::KernelContext, name::Symbol, handle)
    ctx.variables[name] = handle
    return handle
end

"Register an equation with tags and an opaque payload."
function register_equation!(ctx::KernelContext; tag::Symbol, block::Symbol, payload)
    push!(ctx.equations, (tag=tag, block=block, payload=payload))
    return nothing
end

list_equations(ctx::KernelContext) = ctx.equations

function solve!(ctx::KernelContext; optimizer=nothing)
    model = ctx.model
    model isa JuMP.Model || error("KernelContext.model is not set; provide a JuMP.Model to solve.")
    if optimizer !== nothing
        JuMP.set_optimizer(model, optimizer)
    end
    JuMP.optimize!(model)
    return model
end

function run!(spec; optimizer=nothing, dataset_id::String="jcge", tol::Real=1e-6, description::Union{String,Nothing}=nothing)
    model = JuMP.Model()
    ctx = KernelContext(model=model)
    for block in spec.model.blocks
        JCGECore.build!(block, ctx, spec)
    end
    solve!(ctx; optimizer=optimizer)
    summary = summarize_residuals(ctx; tol=tol)
    signals = to_dualsignals(ctx; dataset_id=dataset_id, tol=tol, description=description)
    return (context=ctx, summary=summary, signals=signals)
end

function equation_residuals(ctx::KernelContext)
    out = NamedTuple[]
    for eq in ctx.equations
        payload = eq.payload
        if payload isa NamedTuple && haskey(payload, :residual)
            push!(out, (tag=eq.tag, block=eq.block, indices=get(payload, :indices, ()), residual=payload.residual))
        end
    end
    return out
end

function summarize_residuals(ctx::KernelContext; tol::Real=1e-6)
    res = equation_residuals(ctx)
    if isempty(res)
        return (count=0, max_abs=0.0, worst=nothing, above_tol=0)
    end
    absvals = map(r -> abs(r.residual), res)
    max_idx = argmax(absvals)
    worst = res[max_idx]
    above_tol = count(x -> x > tol, absvals)
    return (count=length(res), max_abs=absvals[max_idx], worst=worst, above_tol=above_tol)
end

function to_dualsignals(ctx::KernelContext; dataset_id::String="jcge",
    description::Union{String,Nothing}=nothing,
    tol::Real=1e-6)
    res = equation_residuals(ctx)
    components = Dict{String,DualSignals.Component}()
    constraints = DualSignals.Constraint[]
    solutions = DualSignals.ConstraintSolution[]

    for r in res
        component_id = string(r.block)
        if !haskey(components, component_id)
            components[component_id] = DualSignals.Component(
                component_id=component_id,
                component_type=DualSignals.ComponentType.other,
                name=component_id,
            )
        end
        constraint_id = string(r.block, ":", r.tag, ":", join(string.(r.indices), ","))
        push!(constraints, DualSignals.Constraint(
            constraint_id=constraint_id,
            kind=DualSignals.ConstraintKind.other,
            sense=DualSignals.ConstraintSense.eq,
            component_ids=[component_id],
        ))
        slack = abs(r.residual)
        push!(solutions, DualSignals.ConstraintSolution(
            constraint_id=constraint_id,
            dual=0.0,
            slack=slack,
            is_binding=slack <= tol,
        ))
    end

    metadata = DualSignals.DatasetMetadata(description=description)
    return DualSignals.DualSignalsDataset(
        dataset_id=dataset_id,
        metadata=metadata,
        components=collect(values(components)),
        constraints=constraints,
        constraint_solutions=solutions,
        variables=nothing,
    )
end

end # module
