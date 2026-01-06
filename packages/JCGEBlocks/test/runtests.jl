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
    block = JCGEBlocks.ProductionBlock(:prod, Symbol[], Symbol[], Symbol[], :cd_leontief, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.ProductionCDBlock" begin
    sets = JCGECore.Sets([:g1], [:a1], [:lab], [:hh])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        b = Dict(:a1 => 1.0),
        beta = Dict((:lab, :a1) => 1.0),
    )
    block = JCGEBlocks.ProductionBlock(:cd_prod, Symbol[], Symbol[], Symbol[], :cd, params)
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

@testset "JCGEBlocks.HouseholdDemandCDBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        FF = Dict(:lab => 10.0),
        alpha = Dict(:g1 => 0.6, :g2 => 0.4),
    )
    block = JCGEBlocks.HouseholdDemandBlock(:hh_simple, Symbol[], Symbol[], Symbol[], :cd, :X, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.HouseholdDemandCDXpBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        FF = Dict(:lab => 10.0),
        alpha = Dict(:g1 => 0.6, :g2 => 0.4),
    )
    block = JCGEBlocks.HouseholdDemandBlock(:hh_agg, Symbol[], Symbol[], Symbol[], :cd, :Xp, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.HouseholdDemandCDHHBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        FF = Dict((:lab, :hh1) => 10.0),
        ssp = Dict(:hh1 => 0.2),
        tau_d = Dict(:hh1 => 0.1),
        alpha = Dict((:g1, :hh1) => 0.6, (:g2, :hh1) => 0.4),
    )
    block = JCGEBlocks.HouseholdDemandBlock(:hh, [:hh1], Symbol[], Symbol[], :cd, :Xp, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.GoodsMarketClearingBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1, :a2], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1, :a2 => :g2))
    block = JCGEBlocks.GoodsMarketClearingBlock(:goods_mkt, Symbol[])
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.FactorMarketClearingBlock" begin
    sets = JCGECore.Sets([:g1], [:a1, :a2], [:lab, :cap], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1, :a2 => :g1))
    params = (FF = Dict(:lab => 10.0, :cap => 5.0),)
    block = JCGEBlocks.FactorMarketClearingBlock(:factor_mkt, Symbol[], Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.CompositeMarketClearingBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1, :a2], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1, :a2 => :g2))
    block = JCGEBlocks.CompositeMarketClearingBlock(:comp_mkt, Symbol[], Symbol[])
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

@testset "JCGEBlocks.PriceEqualityBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    block = JCGEBlocks.PriceEqualityBlock(:price_eq, Symbol[])
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.ExchangeRateLinkBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    block = JCGEBlocks.ExchangeRateLinkBlock(:xr_link, Symbol[])
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

@testset "JCGEBlocks.GovernmentBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        tau_d = 0.1,
        tau_z = Dict(:g1 => 0.05, :g2 => 0.05),
        tau_m = Dict(:g1 => 0.02, :g2 => 0.02),
        mu = Dict(:g1 => 0.6, :g2 => 0.4),
        ssg = 0.2,
    )
    block = JCGEBlocks.GovernmentBlock(:gov, Symbol[], Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.PrivateSavingBlock" begin
    sets = JCGECore.Sets([:g1], [:a1], [:lab, :cap], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        ssp = 0.2,
        FF = Dict(:lab => 10.0, :cap => 5.0),
    )
    block = JCGEBlocks.PrivateSavingBlock(:sp, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.InvestmentBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        lambda = Dict(:g1 => 0.6, :g2 => 0.4),
        Sf = 1.0,
    )
    block = JCGEBlocks.InvestmentBlock(:inv, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.ArmingtonCESBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        gamma = Dict(:g1 => 1.0, :g2 => 1.0),
        delta_m = Dict(:g1 => 0.5, :g2 => 0.5),
        delta_d = Dict(:g1 => 0.5, :g2 => 0.5),
        eta = Dict(:g1 => 0.5, :g2 => 0.5),
        tau_m = Dict(:g1 => 0.1, :g2 => 0.1),
    )
    block = JCGEBlocks.ArmingtonCESBlock(:arm, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.TransformationCETBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        theta = Dict(:g1 => 1.0, :g2 => 1.0),
        xie = Dict(:g1 => 0.5, :g2 => 0.5),
        xid = Dict(:g1 => 0.5, :g2 => 0.5),
        phi = Dict(:g1 => 0.5, :g2 => 0.5),
        tau_z = Dict(:g1 => 0.1, :g2 => 0.1),
    )
    block = JCGEBlocks.TransformationCETBlock(:cet, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.ClosureBlock" begin
    sets = JCGECore.Sets([:g1], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        fixed = Dict(:epsilon => 1.0),
        equalities = [(Symbol(:pz_g1), Symbol(:pq_g1))],
    )
    block = JCGEBlocks.ClosureBlock(:closure, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.UtilityBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (alpha = Dict((:g1, :hh1) => 0.6, (:g2, :hh1) => 0.4),)
    block = JCGEBlocks.UtilityBlock(:util, [:hh1], [:g1, :g2], :cd, :Xp, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.UtilityCDBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (alpha = Dict(:g1 => 0.6, :g2 => 0.4),)
    block = JCGEBlocks.UtilityBlock(:util_cd, Symbol[], Symbol[], :cd, :X, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.UtilityCDXpBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (alpha = Dict(:g1 => 0.6, :g2 => 0.4),)
    block = JCGEBlocks.UtilityBlock(:util_xp, Symbol[], Symbol[], :cd, :Xp, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.ExternalBalanceBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        pWe = Dict(:g1 => 1.0, :g2 => 1.0),
        pWm = Dict(:g1 => 1.0, :g2 => 1.0),
        Sf = 1.0,
    )
    block = JCGEBlocks.ExternalBalanceBlock(:bop, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.ExternalBalanceVarPriceBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (Sf = 1.0,)
    block = JCGEBlocks.ExternalBalanceVarPriceBlock(:bop_var, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.ForeignTradeBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        E0 = Dict(:g1 => 1.0, :g2 => 2.0),
        M0 = Dict(:g1 => 1.0, :g2 => 2.0),
        pWe0 = Dict(:g1 => 1.0, :g2 => 1.0),
        pWm0 = Dict(:g1 => 1.0, :g2 => 1.0),
        sigma = Dict(:g1 => 2.0, :g2 => 2.0),
        psi = Dict(:g1 => 2.0, :g2 => 2.0),
    )
    block = JCGEBlocks.ForeignTradeBlock(:foreign, Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.PriceAggregationBlock" begin
    sets = JCGECore.Sets([:g1, :g2], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        ay = Dict(:a1 => 1.0),
        ax = Dict((:g1, :a1) => 0.0, (:g2, :a1) => 0.0),
    )
    block = JCGEBlocks.PriceAggregationBlock(:price_agg, Symbol[], Symbol[], params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end

@testset "JCGEBlocks.InitialValuesBlock" begin
    sets = JCGECore.Sets([:g1], [:a1], [:lab], [:hh1])
    mappings = JCGECore.Mappings(Dict(:a1 => :g1))
    params = (
        start = Dict(:X_g1 => 1.0),
        lower = Dict(:X_g1 => 0.01),
    )
    block = JCGEBlocks.InitialValuesBlock(:init, params)
    ms = JCGECore.ModelSpec(Any[block], sets, mappings)
    spec = JCGECore.RunSpec("BlocksTest", ms, JCGECore.ClosureSpec(:W), JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}()))
    ctx = JCGEKernel.KernelContext()
    JCGECore.build!(block, ctx, spec)
    @test !isempty(ctx.variables)
    @test !isempty(ctx.equations)
end
