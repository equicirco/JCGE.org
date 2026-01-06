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

@testset "JCGEBlocks.FactorSupplyBlock" begin
    sets = JCGECore.Sets([:g1], [:a1], [:lab, :cap], [:hh])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (FF = Dict(:lab => 10.0, :cap => 5.0),)
    block = JCGEBlocks.FactorSupplyBlock(:factor_supply, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.HouseholdDemandBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        FF = Dict((:lab, :hh1) => 10.0),
        ssp = Dict(:hh1 => 0.2),
        tau_d = Dict(:hh1 => 0.1),
        alpha = Dict((:g1, :hh1) => 0.6, (:g2, :hh1) => 0.4),
    )
    block = JCGEBlocks.HouseholdDemandBlock(:hh, Symbol[], Symbol[], Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.MarketClearingBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1, :a2], [:lab], [:hh1, :hh2])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1, :a2 => :g2))
    block = JCGEBlocks.MarketClearingBlock(:mkt, Symbol[], Symbol[])
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.PriceLinkBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        pWe = Dict(:g1 => 1.0, :g2 => 1.0),
        pWm = Dict(:g1 => 1.0, :g2 => 1.0),
    )
    block = JCGEBlocks.PriceLinkBlock(:prices, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.NumeraireBlock" begin
    sets = JCGECore.Sets([:g1], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    block = JCGEBlocks.NumeraireBlock(:num, :factor, :lab, 1.0)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.equations)
end
