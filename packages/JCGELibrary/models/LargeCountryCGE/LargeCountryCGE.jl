module LargeCountryCGE

using JCGEBlocks
using JCGECalibrate
using JCGECore

export model, baseline, scenario, datadir

"""
    model(; sam_table, sam_path, kwargs...) -> RunSpec

Return a RunSpec for the large-country CGE model port.
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
        sam_path === nothing && (sam_path = joinpath(@__DIR__, "data", "sam_2_2.csv"))
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
    prod_block = JCGEBlocks.ProductionBlock(:prod, activities, factors_sym, commodities, :cd_leontief, prod_params)

    factor_market_block = JCGEBlocks.FactorMarketClearingBlock(:factor_market, activities, factors_sym, (FF = start.FF,))

    gov_params = (
        tau_d = params.tau_d,
        tau_z = start.tau_z,
        tau_m = start.tau_m,
        mu = params.mu,
        ssg = params.ssg,
        FF = start.FF,
    )
    gov_block = JCGEBlocks.GovernmentBlock(:government, commodities, factors_sym, gov_params)

    saving_block = JCGEBlocks.PrivateSavingBlock(:private_saving, factors_sym, (ssp = params.ssp, FF = start.FF))

    hh_params = (alpha = params.alpha, FF = start.FF)
    household_block = JCGEBlocks.HouseholdDemandBlock(:household, Symbol[], commodities, factors_sym, :cd, :Xp, hh_params)

    invest_block = JCGEBlocks.InvestmentBlock(:investment, commodities, (lambda = params.lambda, Sf = start.Sf))

    price_block = JCGEBlocks.ExchangeRateLinkBlock(:prices, commodities)

    bop_block = JCGEBlocks.ExternalBalanceVarPriceBlock(:bop, commodities, (Sf = start.Sf,))

    foreign_params = (
        E0 = start.E0,
        M0 = start.M0,
        pWe0 = start.pWe,
        pWm0 = start.pWm,
        sigma = params.sigma,
        psi = params.psi,
    )
    foreign_block = JCGEBlocks.ForeignTradeBlock(:foreign_trade, commodities, foreign_params)

    arm_params = (
        gamma = params.gamma,
        delta_m = params.delta_m,
        delta_d = params.delta_d,
        eta = params.eta,
        tau_m = start.tau_m,
    )
    arm_block = JCGEBlocks.ArmingtonCESBlock(:armington, commodities, arm_params)

    trans_params = (
        theta = params.theta,
        xie = params.xie,
        xid = params.xid,
        phi = params.phi,
        tau_z = start.tau_z,
    )
    trans_block = JCGEBlocks.TransformationCETBlock(:transformation, commodities, trans_params)

    market_block = JCGEBlocks.CompositeMarketClearingBlock(:market, commodities, activities)

    util_block = JCGEBlocks.UtilityBlock(:utility, Symbol[], commodities, :cd, :Xp, (alpha = params.alpha,))

    start_vals = Dict{Symbol,Float64}()
    lower_vals = Dict{Symbol,Float64}()
    for j in commodities
        start_vals[JCGEBlocks.global_var(:Y, j)] = start.Y0[j]
        start_vals[JCGEBlocks.global_var(:Z, j)] = start.Z0[j]
        start_vals[JCGEBlocks.global_var(:Xp, j)] = start.Xp0[j]
        start_vals[JCGEBlocks.global_var(:Xg, j)] = start.Xg0[j]
        start_vals[JCGEBlocks.global_var(:Xv, j)] = start.Xv0[j]
        start_vals[JCGEBlocks.global_var(:E, j)] = start.E0[j]
        start_vals[JCGEBlocks.global_var(:M, j)] = start.M0[j]
        start_vals[JCGEBlocks.global_var(:Q, j)] = start.Q0[j]
        start_vals[JCGEBlocks.global_var(:D, j)] = start.D0[j]
        start_vals[JCGEBlocks.global_var(:py, j)] = start.py0[j]
        start_vals[JCGEBlocks.global_var(:pz, j)] = start.pz0[j]
        start_vals[JCGEBlocks.global_var(:pq, j)] = start.pq0[j]
        start_vals[JCGEBlocks.global_var(:pe, j)] = start.pe0[j]
        start_vals[JCGEBlocks.global_var(:pm, j)] = start.pm0[j]
        start_vals[JCGEBlocks.global_var(:pd, j)] = start.pd0[j]
        start_vals[JCGEBlocks.global_var(:pWe, j)] = start.pWe[j]
        start_vals[JCGEBlocks.global_var(:pWm, j)] = start.pWm[j]
        start_vals[JCGEBlocks.global_var(:Tz, j)] = start.Tz0[j]
        start_vals[JCGEBlocks.global_var(:Tm, j)] = start.Tm0[j]
    end
    for h in factors_sym
        start_vals[JCGEBlocks.global_var(:pf, h)] = start.pf0[h]
    end
    for h in factors_sym, j in commodities
        start_vals[JCGEBlocks.global_var(:F, h, j)] = start.F0[h, j]
    end
    for i in commodities, j in commodities
        start_vals[JCGEBlocks.global_var(:X, i, j)] = start.X0[i, j]
    end
    start_vals[:epsilon] = start.epsilon0
    start_vals[:Sp] = start.Sp0
    start_vals[:Sg] = start.Sg0
    start_vals[:Td] = start.Td0

    for (name, value) in start_vals
        lower_vals[name] = 1.0e-5
    end
    for j in commodities
        lower_vals[JCGEBlocks.global_var(:Tz, j)] = 0.0
        lower_vals[JCGEBlocks.global_var(:Tm, j)] = 0.0
    end
    init_block = JCGEBlocks.InitialValuesBlock(:init, (start = start_vals, lower = lower_vals))

    numeraire_block = JCGEBlocks.NumeraireBlock(:numeraire, :factor, sam_table.numeraire_factor_label, 1.0)

    blocks = Any[
        prod_block,
        factor_market_block,
        gov_block,
        saving_block,
        household_block,
        invest_block,
        price_block,
        bop_block,
        foreign_block,
        arm_block,
        trans_block,
        market_block,
        util_block,
        init_block,
        numeraire_block,
    ]

    ms = JCGECore.ModelSpec(blocks, sets, mappings)
    closure = JCGECore.ClosureSpec(sam_table.numeraire_factor_label)
    scenario = JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}())
    spec = JCGECore.RunSpec("LargeCountryCGE", ms, closure, scenario)
    JCGECore.validate(spec)
    return spec
end

baseline() = model()

function scenario(name::Symbol)
    return JCGECore.ScenarioSpec(name, Dict{Symbol,Any}())
end

datadir() = joinpath(@__DIR__, "data")

end # module
