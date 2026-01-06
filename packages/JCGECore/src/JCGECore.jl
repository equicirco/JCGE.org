module JCGECore

export Sets, Mappings, ModelSpec, ClosureSpec, ScenarioSpec, RunSpec
export AbstractBlock, calibrate!, build!, report
export validate
export getparam

"Canonical set containers (minimal placeholder)."
struct Sets
    commodities::Vector{Symbol}
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    institutions::Vector{Symbol}
end

"Canonical mapping containers (minimal placeholder)."
struct Mappings
    activity_to_output::Dict{Symbol,Symbol}
end

"Model structure: selected blocks and high-level configuration."
struct ModelSpec
    blocks::Vector{Any}          # typically Vector{<:AbstractBlock}
    sets::Sets
    mappings::Mappings
end

"Closure choices (minimal placeholder)."
struct ClosureSpec
    numeraire::Symbol
end

"Scenario changes (delta relative to baseline; minimal placeholder)."
struct ScenarioSpec
    name::Symbol
    shocks::Dict{Symbol,Any}
end

"Full run specification."
struct RunSpec
    name::String
    model::ModelSpec
    closure::ClosureSpec
    scenario::ScenarioSpec
end

"Abstract interface for model blocks."
abstract type AbstractBlock end

"Calibration hook (default: not implemented)."
function calibrate!(block::AbstractBlock, data, benchmark, params)
    throw(MethodError(calibrate!, (block, data, benchmark, params)))
end

"Build hook (default: not implemented)."
function build!(block::AbstractBlock, ctx, spec::RunSpec)
    throw(MethodError(build!, (block, ctx, spec)))
end

"Reporting hook (default: not implemented)."
function report(block::AbstractBlock, solution)
    throw(MethodError(report, (block, solution)))
end

"Validate that the RunSpec is structurally consistent (minimal checks)."
function validate(spec::RunSpec)
    isempty(spec.model.sets.commodities) && error("Sets.commodities is empty")
    isempty(spec.model.sets.activities) && error("Sets.activities is empty")
    isempty(spec.model.sets.factors) && error("Sets.factors is empty")
    isempty(spec.model.sets.institutions) && error("Sets.institutions is empty")
    return true
end

"Get parameter values from dict- or table-like containers."
function getparam(params, name::Symbol, idxs...)
    hasproperty(params, name) || error("Missing parameter: $(name)")
    data = getproperty(params, name)
    return getindex(data, idxs...)
end

end # module
