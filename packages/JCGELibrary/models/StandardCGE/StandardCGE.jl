module StandardCGE

using JCGEBlocks
using JCGECalibrate
using JCGECore

export model, baseline, scenario, datadir

"""
    model(; sam_table, sam_path, kwargs...) -> RunSpec

Return a RunSpec for the StandardCGE model port.
"""
function model(; sam_table::Union{Nothing,JCGECalibrate.SAMTable} = nothing,
    sam_path::Union{Nothing,AbstractString} = nothing,
    goods::Vector{String} = ["BRD", "MLK"],
    factors::Vector{String} = ["CAP", "LAB"],
    numeraire_factor_label::String = "LAB",
    indirectTax_label::String = "IDT",
    tariff_label::String = "TRF",
    households_label::String = "HOH",
    government_label::String = "GOV",
    investment_label::String = "INV",
    restOfTheWorld_label::String = "EXT")
    if sam_table === nothing
        sam_path === nothing && error("Provide sam_table or sam_path to StandardCGE.model()")
        sam_table = JCGECalibrate.load_sam_table(sam_path;
            goods = goods,
            factors = factors,
            numeraire_factor_label = numeraire_factor_label,
            indirectTax_label = indirectTax_label,
            tariff_label = tariff_label,
            households_label = households_label,
            government_label = government_label,
            investment_label = investment_label,
            restOfTheWorld_label = restOfTheWorld_label,
        )
    end
    start = JCGECalibrate.compute_starting_values(sam_table)
    params = JCGECalibrate.compute_calibration_params(sam_table, start)
    commodities = sam_table.goods
    activities = sam_table.goods
    factors_sym = sam_table.factors
    institutions = [
        sam_table.households_label,
        sam_table.government_label,
        sam_table.investment_label,
        sam_table.restOfTheWorld_label,
    ]
    sets = JCGECore.Sets(commodities, activities, factors_sym, institutions)
    mappings = JCGECore.Mappings(Dict(a => a for a in activities))
    prod_params = (b = params.b, beta = params.beta, ay = params.ay, ax = params.ax)
    prod_block = JCGEBlocks.ProductionBlock(:prod, activities, factors_sym, commodities, prod_params)

    factor_block = JCGEBlocks.FactorSupplyBlock(:factor_supply, factors_sym, (FF = start.FF,))

    hh = sam_table.households_label
    hh_params = (
        FF = Dict((h, hh) => start.FF[h] for h in factors_sym),
        ssp = Dict(hh => params.ssp),
        tau_d = Dict(hh => params.tau_d),
        alpha = Dict((i, hh) => params.alpha[i] for i in commodities),
    )
    household_block = JCGEBlocks.HouseholdDemandBlock(:household, [hh], commodities, factors_sym, hh_params)

    market_block = JCGEBlocks.MarketClearingBlock(:market, commodities, factors_sym)

    price_params = (pWe = start.pWe, pWm = start.pWm)
    price_block = JCGEBlocks.PriceLinkBlock(:prices, commodities, price_params)
    numeraire_block = JCGEBlocks.NumeraireBlock(:numeraire, :factor, sam_table.numeraire_factor_label, 1.0)

    blocks = Any[
        prod_block,
        factor_block,
        household_block,
        market_block,
        price_block,
        numeraire_block,
    ]
    ms = JCGECore.ModelSpec(blocks, sets, mappings)
    closure = JCGECore.ClosureSpec(sam_table.numeraire_factor_label)
    scenario = JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}())
    spec = JCGECore.RunSpec("StandardCGE", ms, closure, scenario)
    JCGECore.validate(spec)
    return spec
end

baseline() = model()

function scenario(name::Symbol)
    return JCGECore.ScenarioSpec(name, Dict{Symbol,Any}())
end

datadir() = joinpath(@__DIR__, "data")

end # module
