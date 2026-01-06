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
        ay = Dict(j => 1.0 for j in goods),
        ax = Dict((i, j) => 0.0 for i in goods for j in goods),
    )
    prod_block = JCGEBlocks.ProductionBlock(:prod, goods, factors, goods, prod_params)

    factor_block = JCGEBlocks.FactorSupplyBlock(:factor_supply, factors, (FF = FF,))

    hh_params = (
        FF = Dict((h, hh) => FF[h] for h in factors),
        ssp = Dict(hh => 0.0),
        tau_d = Dict(hh => 0.0),
        alpha = Dict((i, hh) => alpha[i] for i in goods),
    )
    household_block = JCGEBlocks.HouseholdDemandBlock(:household, [hh], goods, factors, hh_params)

    market_block = JCGEBlocks.MarketClearingBlock(:market, goods, factors)

    numeraire_block = JCGEBlocks.NumeraireBlock(:numeraire, :factor, :LAB, 1.0)

    fixed = Dict{Symbol,Float64}()
    for i in goods
        fixed[Symbol("Xg_", i)] = 0.0
        fixed[Symbol("Xv_", i)] = 0.0
    end
    for i in goods, j in goods
        fixed[Symbol("X_", i, "_", j)] = 0.0
    end
    equalities = Tuple{Symbol,Symbol}[]
    append!(equalities, [(Symbol("Q_", i), Symbol("Z_", i)) for i in goods])
    append!(equalities, [(Symbol("pq_", i), Symbol("pz_", i)) for i in goods])
    closure_block = JCGEBlocks.ClosureBlock(:closure, (fixed=fixed, equalities=equalities))

    util_block = JCGEBlocks.UtilityBlock(:utility, [hh], goods, (alpha = Dict((i, hh) => alpha[i] for i in goods),))

    blocks = Any[
        prod_block,
        factor_block,
        household_block,
        market_block,
        numeraire_block,
        closure_block,
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
