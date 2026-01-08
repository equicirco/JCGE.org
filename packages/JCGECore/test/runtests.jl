using Test
using JCGECore

@testset "JCGECore" begin
    sets = Sets([:a], [:a], [:f], [:h])
    mappings = Mappings(Dict(:a => :a))
    closure = ClosureSpec(:p)
    scenario = ScenarioSpec(:baseline, Dict{Symbol,Any}())
    sections = [section(:production, Any[]), section(:trade, Any[])]
    tpl = template("Demo"; required_sections=[:production, :trade])
    spec = build_spec(
        tpl,
        sets,
        mappings,
        sections;
        closure=closure,
        scenario=scenario,
        allowed_sections=[:production, :trade],
        required_nonempty=Symbol[],
    )
    @test spec.name == "Demo"
    @test length(spec.model.blocks) == 0
end
