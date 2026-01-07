module CamMCP

using JCGEBlocks
using JCGECore
using JCGEKernel
using PATHSolver

export model, baseline, scenario, solve

const SECTOR_LABELS = [
    "ag-subsist",
    "ag-exp+ind",
    "sylvicult",
    "ind-alim",
    "biens-cons",
    "biens-int",
    "cim-int",
    "biens-cap",
    "construct",
    "services",
    "publiques",
]

const LABOR_LABELS = [
    "rural",
    "urban-unsk",
    "urban-skil",
]

function _vecdict(keys::Vector{Symbol}, values::Vector{Float64})
    return Dict(keys[i] => values[i] for i in eachindex(keys))
end

function _matdict(rows::Vector{Symbol}, cols::Vector{Symbol}, data::Matrix{Float64})
    out = Dict{Tuple{Symbol,Symbol},Float64}()
    for (i, r) in enumerate(rows), (j, c) in enumerate(cols)
        out[(r, c)] = data[i, j]
    end
    return out
end

function _build_data()
    sectors = Symbol.(SECTOR_LABELS)
    labor = Symbol.(LABOR_LABELS)

    io_data = [
        0.03046 0.0 0.0 0.30266 0.00206 0.0 0.0 0.0 0.0 0.0412 0.0;
        0.0 0.01518 0.0 0.02043 0.01123 0.00669 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.00243 0.0 0.02106 0.0 0.0 0.0 0.0 0.0;
        0.00341 0.00629 0.0 0.03241 0.01234 0.00503 0.0 0.0 0.0 0.00092 0.01532;
        0.0 0.0 0.0 0.00105 0.05385 0.00435 0.0 0.0 0.0 0.00103 0.00338;
        0.00676 0.12385 0.02095 0.03794 0.08309 0.23461 0.18289 0.01567 0.14665 0.00929 0.08466;
        0.00002 0.00025 0.00017 0.11238 0.05095 0.05593 0.27608 0.11722 0.18643 0.00018 0.0;
        0.00041 0.00971 0.02427 0.00931 0.01229 0.05259 0.02053 0.05013 0.02622 0.00389 0.0;
        0.00472 0.00113 0.00318 0.10456 0.01831 0.05302 0.00172 0.00031 0.01457 0.00385 0.00394;
        0.00375 0.30649 0.26666 0.101 0.26072 0.23006 0.11793 0.09922 0.13692 0.13728 0.24145;
        0.00022 0.00293 0.00327 0.00536 0.00539 0.00957 0.00486 0.00081 0.00447 0.00219 0.0;
    ]

    imat_data = [
        0.23637 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.5953 0.60608 0.63876 0.60608 0.78723 0.63876 0.63876 0.60608 0.71728 0.1761 0.1761;
        0.16833 0.39392 0.36124 0.39392 0.21277 0.36124 0.36124 0.39392 0.28272 0.8239 0.8239;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    ]

    wdist_data = [
        1.0189 0.71491 0.0;
        0.49556 0.34774 0.29222;
        3.2628 2.289 1.9232;
        1.4571 1.0223 0.85902;
        1.1335 0.79531 0.66829;
        3.1074 2.1806 1.8323;
        6.3224 4.4364 3.7277;
        2.5035 1.7552 1.4758;
        2.9204 2.0492 1.722;
        1.4039 0.98502 0.82776;
        0.0 1.3263 1.1146;
    ]

    xle_data = [
        1654.43 162.89 0.0;
        399.93 45.508 5.057;
        7.662 1.789 0.597;
        12.989 9.434 2.358;
        28.344 37.462 12.488;
        18.331 16.553 8.3;
        1.458 1.317 0.66;
        3.112 2.82 1.208;
        22.584 28.462 7.116;
        121.2 125.8 61.96;
        0.0 83.029 32.771;
    ]

    io = _matdict(sectors, sectors, io_data)
    imat = _matdict(sectors, sectors, imat_data)
    wdist = _matdict(sectors, labor, wdist_data)
    xle = _matdict(sectors, labor, xle_data)

    m0 = _vecdict(sectors, [2.461, 8.039, 0.023, 17.961, 37.062, 138.57, 49.616, 134.72, 0.0, 74.439, 0.0])
    e0 = _vecdict(sectors, [4.594, 125.07, 22.337, 23.451, 5.864, 101.33, 10.501, 3.838, 0.0, 81.626, 0.0])
    xd0 = _vecdict(sectors, [330.48, 131.45, 29.503, 72.024, 118.43, 284.38, 34.169, 10.298, 174.12, 615.79, 163.98])
    k0 = _vecdict(sectors, [495.73, 170.89, 73.76, 140.0, 236.87, 853.13, 102.51, 20.6, 435.29, 769.73, 180.36])
    id0 = _vecdict(sectors, [6.71, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 113.36, 138.13, 0.0, 0.0])
    dst0 = _vecdict(sectors, [4.033, 3.509, 1.025, 3.19, 7.101, 3.494, 0.0, 0.433, 0.0, 0.0, 0.0])

    depr = _vecdict(sectors, [0.0246, 0.0472, 0.0244, 0.0144, 0.0212, 0.0335, 0.0335, 0.0111, 0.0232, 0.0637, 0.0637])
    rhoc_raw = _vecdict(sectors, [1.5, 0.9, 0.4, 1.25, 1.25, 0.5, 0.75, 0.4, 0.4, 0.4, 0.4])
    rhot_raw = _vecdict(sectors, [1.5, 0.9, 0.4, 1.25, 1.25, 0.5, 0.75, 0.4, 0.4, 0.4, 0.4])
    eta = _vecdict(sectors, [1.0, 1.0, 1.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0])
    pd0 = _vecdict(sectors, fill(1.0, length(sectors)))
    tm0 = _vecdict(sectors, [0.2205, 0.233, 0.278, 0.3534, 0.3826, 0.1768, 0.2633, 0.268, 0.0, 0.0, 0.0])
    itax = _vecdict(sectors, [0.002, 0.191, 0.057, 0.038, 0.096, 0.026, 0.014, 0.029, 0.034, 0.076, 0.0])
    cles = _vecdict(sectors, [0.2744, 0.00445, 0.0, 0.05599, 0.14099, 0.17738, 0.0, 0.0, 0.004, 0.31921, 0.02358])
    gles = _vecdict(sectors, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0])
    kio = _vecdict(sectors, [0.11, 0.09, 0.06, 0.01, 0.04, 0.14, 0.02, 0.01, 0.08, 0.34, 0.1])
    dstr = _vecdict(sectors, [0.012203, 0.026694, 0.034742, 0.044291, 0.059958, 0.012287, 0.0, 0.042047, 0.0, 0.0, 0.0])

    wa0 = _vecdict(labor, [0.11, 0.15678, 1.8657])
    er = 0.21
    gr0 = 179.0
    gdtot0 = 135.03
    cdtot0 = 947.98
    fsav0 = 36.841

    rhoc = Dict(i => (1.0 / rhoc_raw[i]) - 1.0 for i in sectors)
    rhot = Dict(i => (1.0 / rhot_raw[i]) + 1.0 for i in sectors)
    te = Dict(i => 0.0 for i in sectors)

    xllb = Dict{Tuple{Symbol,Symbol},Float64}()
    for i in sectors, lc in labor
        val = xle[(i, lc)]
        xllb[(i, lc)] = val + (1.0 - sign(val))
    end

    traded = [i for i in sectors if m0[i] > 0.0]
    nontraded = [i for i in sectors if m0[i] <= 0.0]

    xxd0 = Dict(i => xd0[i] - e0[i] for i in sectors)
    pm0 = pd0
    pe0 = pd0
    pwm0 = Dict(i => pm0[i] / ((1.0 + tm0[i]) * er) for i in sectors)
    pwe0 = Dict(i => pe0[i] / ((1.0 + te[i]) * er) for i in sectors)

    pva0 = Dict(i => pd0[i] - sum(io[(j, i)] * pd0[j] for j in sectors) - itax[i] for i in sectors)

    int0 = Dict(i => sum(io[(i, j)] * xd0[j] for j in sectors) for i in sectors)

    delta = Dict{Symbol,Float64}()
    ac = Dict{Symbol,Float64}()
    x0 = Dict(i => pd0[i] * xxd0[i] + (pm0[i] * m0[i]) * (i in traded ? 1.0 : 0.0) for i in sectors)
    for i in sectors
        if i in traded
            delta_val = pm0[i] / pd0[i] * (m0[i] / xxd0[i]) ^ (1.0 + rhoc[i])
            delta_val = delta_val / (1.0 + delta_val)
            delta[i] = delta_val
            ac[i] = x0[i] / (delta_val * m0[i] ^ (-rhoc[i]) + (1.0 - delta_val) * xxd0[i] ^ (-rhoc[i])) ^ (-1.0 / rhoc[i])
        else
            delta[i] = 0.0
            ac[i] = 0.0
        end
    end

    gamma = Dict{Symbol,Float64}()
    for i in sectors
        if i in traded
            gamma[i] = 1.0 / (1.0 + pd0[i] / pe0[i] * (e0[i] / xxd0[i]) ^ (rhot[i] - 1.0))
        else
            gamma[i] = 0.0
        end
    end

    alphl = Dict{Tuple{Symbol,Symbol},Float64}()
    for i in sectors, lc in labor
        w = wdist[(i, lc)]
        val = (w == 0.0 || xle[(i, lc)] == 0.0) ? 0.0 : (w * wa0[lc] * xle[(i, lc)]) / (pva0[i] * xd0[i])
        alphl[(lc, i)] = val
    end

    qd = Dict{Symbol,Float64}()
    for i in sectors
        labor_term = prod(xllb[(i, lc)] ^ alphl[(lc, i)] for lc in labor)
        qd[i] = labor_term * k0[i] ^ (1.0 - sum(alphl[(lc, i)] for lc in labor))
    end

    ad = Dict(i => xd0[i] / qd[i] for i in sectors)

    at = Dict{Symbol,Float64}()
    for i in sectors
        if i in traded
            at[i] = xd0[i] / (gamma[i] * e0[i] ^ rhot[i] + (1.0 - gamma[i]) * xxd0[i] ^ rhot[i]) ^ (1.0 / rhot[i])
        else
            at[i] = 0.0
        end
    end

    ls0 = Dict(lc => sum(xle[(i, lc)] for i in sectors) for lc in labor)

    return (
        sectors=sectors,
        labor=labor,
        traded=traded,
        nontraded=nontraded,
        io=io,
        imat=imat,
        wdist=wdist,
        xle=xle,
        m0=m0,
        e0=e0,
        xd0=xd0,
        k0=k0,
        id0=id0,
        dst0=dst0,
        int0=int0,
        xxd0=xxd0,
        x0=x0,
        pd0=pd0,
        pm0=pm0,
        pe0=pe0,
        pva0=pva0,
        pwm0=pwm0,
        pwe0=pwe0,
        delta=delta,
        ac=ac,
        rhoc=rhoc,
        rhot=rhot,
        at=at,
        gamma=gamma,
        eta=eta,
        ad=ad,
        cles=cles,
        gles=gles,
        depr=depr,
        dstr=dstr,
        kio=kio,
        tm0=tm0,
        te=te,
        itax=itax,
        alphl=alphl,
        wa0=wa0,
        ls0=ls0,
        er=er,
        gr0=gr0,
        gdtot0=gdtot0,
        cdtot0=cdtot0,
        fsav0=fsav0,
        mps0=0.09305,
    )
end

"""
    model() -> RunSpec

Return a RunSpec for the Cameroon CGE MCP port (block-based).
"""
function model()
    data = _build_data()
    sectors = data.sectors
    labor = data.labor

    sets = JCGECore.Sets(
        sectors,
        sectors,
        labor,
        [Symbol("households"), Symbol("government"), Symbol("foreign"), Symbol("investment")],
    )
    mappings = JCGECore.Mappings(Dict(i => i for i in sectors))

    trade_block = JCGEBlocks.trade_price_link(:trade_prices, sectors, (traded=data.traded, te=data.te, mcp=true))
    absorption_block = JCGEBlocks.absorption_sales(:absorption, sectors, (traded=data.traded, mcp=true))
    activity_price_block = JCGEBlocks.activity_price_io(:activity_price, sectors, sectors, (io=data.io, itax=data.itax, mcp=true))
    capital_price_block = JCGEBlocks.capital_price_composition(:capital_price, sectors, sectors, (imat=data.imat, mcp=true))
    production_block = JCGEBlocks.production_multilabor_cd(:production, sectors, labor; params=(ad=data.ad, alphl=data.alphl, wdist=data.wdist, mcp=true))
    labor_block = JCGEBlocks.labor_market_clearing(:labor_market, labor, sectors; params=(mcp=true,))
    cet_block = JCGEBlocks.cet_xxd_e(:cet, sectors, (traded=data.traded, at=data.at, gamma=data.gamma, rhot=data.rhot, mcp=true))
    export_block = JCGEBlocks.export_demand(:export, sectors, (traded=data.traded, eta=data.eta, e0=data.e0, pwe0=data.pwe0, mcp=true))
    armington_block = JCGEBlocks.armington_m_xxd(:armington, sectors, (traded=data.traded, delta=data.delta, ac=data.ac, rhoc=data.rhoc, mcp=true))
    nontraded_block = JCGEBlocks.nontraded_supply(:nontraded, sectors, (nontraded=data.nontraded,))
    inventory_block = JCGEBlocks.inventory_demand(:inventory, sectors, (dstr=data.dstr, mcp=true))
    household_block = JCGEBlocks.household_share_demand(:household, sectors, (cles=data.cles, mcp=true))
    government_demand_block = JCGEBlocks.government_share_demand(:government_demand, sectors, (gles=data.gles, mcp=true))
    government_finance_block = JCGEBlocks.government_finance(:government_finance, sectors, (traded=data.traded, itax=data.itax, te=data.te, mcp=true))
    gdp_block = JCGEBlocks.gdp_income(:gdp, sectors, (mcp=true,))
    savings_block = JCGEBlocks.savings_investment(:savings, sectors, sectors, (depr=data.depr, kio=data.kio, imat=data.imat, mcp=true))
    market_block = JCGEBlocks.final_demand_clearing(:market, sectors, (mcp=true,))
    bop_block = JCGEBlocks.external_balance_var_price(:bop, sectors, (Sf=data.fsav0, mcp=true))

    start_vals = Dict{Symbol,Float64}()
    lower_vals = Dict{Symbol,Float64}()
    fixed_vals = Dict{Symbol,Float64}()

    dk0 = Dict{Symbol,Float64}()
    for j in sectors
        dk0[j] = sum(data.id0[i] * data.imat[(i, j)] for i in sectors)
    end

    for i in sectors
        start_vals[JCGEBlocks.global_var(:x, i)] = data.x0[i]
        start_vals[JCGEBlocks.global_var(:xd, i)] = data.xd0[i]
        start_vals[JCGEBlocks.global_var(:xxd, i)] = data.xd0[i] - data.e0[i]
        start_vals[JCGEBlocks.global_var(:cd, i)] = data.cles[i] * data.cdtot0
        start_vals[JCGEBlocks.global_var(:gd, i)] = data.gles[i] * data.gdtot0
        start_vals[JCGEBlocks.global_var(:id, i)] = data.id0[i]
        start_vals[JCGEBlocks.global_var(:dk, i)] = dk0[i]
        start_vals[JCGEBlocks.global_var(:dst, i)] = data.dst0[i]
        start_vals[JCGEBlocks.global_var(:int, i)] = data.int0[i]
        start_vals[JCGEBlocks.global_var(:pd, i)] = data.pd0[i]
        start_vals[JCGEBlocks.global_var(:pm, i)] = data.pm0[i]
        start_vals[JCGEBlocks.global_var(:pe, i)] = data.pe0[i]
        start_vals[JCGEBlocks.global_var(:p, i)] = data.pd0[i]
        start_vals[JCGEBlocks.global_var(:px, i)] = data.pd0[i]
        start_vals[JCGEBlocks.global_var(:pk, i)] = data.pd0[i]
        start_vals[JCGEBlocks.global_var(:pva, i)] = data.pva0[i]
        start_vals[JCGEBlocks.global_var(:pwe, i)] = data.pwe0[i]
        start_vals[JCGEBlocks.global_var(:pwm, i)] = data.pwm0[i]
        start_vals[JCGEBlocks.global_var(:tm, i)] = data.tm0[i]

        lower_vals[JCGEBlocks.global_var(:x, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:xd, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:pd, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:p, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:px, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:pk, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:int, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:cd, i)] = 0.0
        lower_vals[JCGEBlocks.global_var(:gd, i)] = 0.0
        lower_vals[JCGEBlocks.global_var(:id, i)] = 0.0
        lower_vals[JCGEBlocks.global_var(:dst, i)] = 0.0
    end

    for i in data.traded
        start_vals[JCGEBlocks.global_var(:m, i)] = data.m0[i]
        start_vals[JCGEBlocks.global_var(:e, i)] = data.e0[i]
        lower_vals[JCGEBlocks.global_var(:pm, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:xxd, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:m, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:e, i)] = 0.01
        lower_vals[JCGEBlocks.global_var(:pwe, i)] = 0.01
    end

    for lc in labor
        start_vals[JCGEBlocks.global_var(:wa, lc)] = data.wa0[lc]
        start_vals[JCGEBlocks.global_var(:ls, lc)] = data.ls0[lc]
        lower_vals[JCGEBlocks.global_var(:wa, lc)] = 0.01
    end

    for i in sectors, lc in labor
        start_vals[JCGEBlocks.global_var(:l, i, lc)] = data.xle[(i, lc)]
        lower_vals[JCGEBlocks.global_var(:l, i, lc)] = 0.01
    end

    start_vals[:er] = data.er
    start_vals[:gr] = data.gr0
    start_vals[:fsav] = data.fsav0
    start_vals[:mps] = data.mps0
    start_vals[:gdtot] = data.gdtot0

    start_vals[:tariff] = 76.548
    start_vals[:indtax] = 102.45
    start_vals[:savings] = 280.98

    y0 = sum(data.pva0[i] * data.xd0[i] for i in sectors) - sum(data.depr[i] * data.k0[i] for i in sectors)
    start_vals[:y] = y0
    start_vals[:hhsav] = data.mps0 * y0
    start_vals[:deprecia] = sum(data.depr[i] * data.pd0[i] * data.k0[i] for i in sectors)
    start_vals[:govsav] = data.gr0 - data.gdtot0
    lower_vals[:y] = 0.01

    fixed_vals[:fsav] = data.fsav0
    fixed_vals[:mps] = data.mps0
    fixed_vals[:gdtot] = data.gdtot0

    for i in sectors
        fixed_vals[JCGEBlocks.global_var(:k, i)] = data.k0[i]
        fixed_vals[JCGEBlocks.global_var(:pwm, i)] = data.pwm0[i]
    end

    for lc in labor
        fixed_vals[JCGEBlocks.global_var(:ls, lc)] = data.ls0[lc]
    end

    for i in data.traded
        fixed_vals[JCGEBlocks.global_var(:tm, i)] = data.tm0[i]
    end

    for i in data.nontraded
        fixed_vals[JCGEBlocks.global_var(:m, i)] = 0.0
        fixed_vals[JCGEBlocks.global_var(:e, i)] = 0.0
    end

    fixed_vals[JCGEBlocks.global_var(:l, Symbol("publiques"), Symbol("rural"))] = 0.0
    fixed_vals[JCGEBlocks.global_var(:l, Symbol("ag-subsist"), Symbol("urban-skil"))] = 0.0

    fixed_vals[:y] = y0

    init_block = JCGEBlocks.initial_values(:init, (start=start_vals, lower=lower_vals, fixed=fixed_vals))

    blocks = Any[
        trade_block,
        absorption_block,
        activity_price_block,
        capital_price_block,
        production_block,
        labor_block,
        cet_block,
        export_block,
        armington_block,
        nontraded_block,
        inventory_block,
        household_block,
        government_demand_block,
        government_finance_block,
        gdp_block,
        savings_block,
        market_block,
        bop_block,
        init_block,
    ]

    ms = JCGECore.ModelSpec(blocks, sets, mappings)
    closure = JCGECore.ClosureSpec(:pwm)
    scenario = JCGECore.ScenarioSpec(:baseline, Dict{Symbol,Any}())
    spec = JCGECore.RunSpec("CamMCP", ms, closure, scenario)
    JCGECore.validate(spec)
    return spec
end

baseline() = model()

function solve(; optimizer=PATHSolver.Optimizer)
    return JCGEKernel.run!(model(); optimizer=optimizer)
end

function scenario(name::Symbol)
    return JCGECore.ScenarioSpec(name, Dict{Symbol,Any}())
end

end # module
