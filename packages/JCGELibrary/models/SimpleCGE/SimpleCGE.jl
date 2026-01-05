module SimpleCGE

using JCGECore
using JCGEBlocks

export model, baseline, scenario, datadir

"""
Return a minimal RunSpec for quick testing and development.
"""
function model()
    sets = JCGECore.Sets([:good], [:activity], [:lab], [:hh])
    mappings = JCGECore.Mappings(Dict(:activity => :good))
    blocks = Any[JCGEBlocks.DummyBlock(:simple)]
    ms = JCGECore.ModelSpec(blocks, sets, mappings)
    closure = JCGECore.ClosureSpec(:W)
    scenario = JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}())
    spec = JCGECore.RunSpec("SimpleCGE", ms, closure, scenario)
    JCGECore.validate(spec)
    return spec
end

baseline() = model()

function scenario(name::Symbol)
    return JCGECore.ScenarioSpec(name, Dict{Symbol,Any}())
end

datadir() = joinpath(@__DIR__, "data")

end # module
