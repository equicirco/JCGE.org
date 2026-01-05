using Test
using JCGEBlocks
using JCGECore
using JCGEKernel

@testset "JCGEBlocks" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1, :a2], [:lab], [:hh])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1, :a2 => :g2))
    params = (
        b = Dict(:a1 => 1.0, :a2 => 1.0),
        beta = Dict((:lab, :a1) => 1.0, (:lab, :a2) => 1.0),
        ay = Dict(:a1 => 1.0, :a2 => 1.0),
        ax = Dict(
            (:g1, :a1) => 0.0, (:g2, :a1) => 0.0,
            (:g1, :a2) => 0.0, (:g2, :a2) => 0.0,
        ),
    )
    block = JCGEBlocks.ProductionBlock(:prod, Symbol[], Symbol[], Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end
