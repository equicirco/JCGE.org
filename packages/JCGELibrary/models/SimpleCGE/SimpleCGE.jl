module SimpleCGE

using JCGECore
using JCGEBlocks
using JCGECalibrate

export model, baseline, scenario, datadir

"""
Return a minimal RunSpec for quick testing and development.
"""
function model(; sam_path::Union{Nothing,AbstractString}=nothing)
    sam_path === nothing && (sam_path = joinpath(@__DIR__, "data", "sam_2_2.csv"))
    sam_table = JCGECalibrate.load_sam_table(sam_path;
        goods = ["BRD", "MLK"],
        factors = ["CAP", "LAB"],
        households_label = "HOH",
    )
    sam = sam_table.sam

    goods = [:BRD, :MLK]
    factors = [:CAP, :LAB]
    hh = :HOH

    X0 = Dict(i => sam[i, hh] for i in goods)
    F0 = Dict((h, j) => sam[h, j] for h in factors for j in goods)
    Z0 = Dict(j => sum(F0[(h, j)] for h in factors) for j in goods)
    FF = Dict(h => sam[hh, h] for h in factors)

    alpha = Dict(i => X0[i] / sum(values(X0)) for i in goods)
    beta = Dict((h, j) => F0[(h, j)] / sum(F0[(k, j)] for k in factors) for h in factors for j in goods)
    b = Dict(j => Z0[j] / prod(F0[(h, j)] ^ beta[(h, j)] for h in factors) for j in goods)

    prod_params = (
        b = b,
        beta = beta,
    )
    prod_block = JCGEBlocks.ProductionBlock(:prod, goods, factors, Symbol[], :cd, prod_params)

    hh_params = (
        FF = FF,
        alpha = alpha,
    )
    household_block = JCGEBlocks.HouseholdDemandBlock(:household, Symbol[], goods, factors, :cd, :X, hh_params)

    goods_market_block = JCGEBlocks.GoodsMarketClearingBlock(:goods_market, goods)

    factor_market_block = JCGEBlocks.FactorMarketClearingBlock(:factor_market, goods, factors, (FF = FF,))

    price_block = JCGEBlocks.PriceEqualityBlock(:price_link, goods)

    numeraire_block = JCGEBlocks.NumeraireBlock(:numeraire, :factor, :LAB, 1.0)

    util_block = JCGEBlocks.UtilityBlock(:utility, Symbol[], goods, :cd, :X, (alpha = alpha,))

    start_vals = Dict{Symbol,Float64}()
    lower_vals = Dict{Symbol,Float64}()
    for i in goods
        start_vals[JCGEBlocks.global_var(:X, i)] = X0[i]
        start_vals[JCGEBlocks.global_var(:Z, i)] = Z0[i]
        start_vals[JCGEBlocks.global_var(:px, i)] = 1.0
        start_vals[JCGEBlocks.global_var(:pz, i)] = 1.0
    end
    for h in factors, j in goods
        start_vals[JCGEBlocks.global_var(:F, h, j)] = F0[(h, j)]
    end
    for h in factors
        start_vals[JCGEBlocks.global_var(:pf, h)] = 1.0
    end
    for (name, value) in start_vals
        lower_vals[name] = 0.001
    end
    init_block = JCGEBlocks.InitialValuesBlock(:init, (start = start_vals, lower = lower_vals))

    blocks = Any[
        prod_block,
        household_block,
        goods_market_block,
        factor_market_block,
        price_block,
        init_block,
        numeraire_block,
        util_block,
    ]

    sets = JCGECore.Sets(goods, goods, factors, [hh])
    mappings = JCGECore.Mappings(Dict(j => j for j in goods))
    ms = JCGECore.ModelSpec(blocks, sets, mappings)
    closure = JCGECore.ClosureSpec(:LAB)
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
