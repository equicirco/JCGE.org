module JCGECalibrate

using CSV
using DataFrames

export rho_from_sigma, sigma_from_rho
export calibrate_ces_share_scale
export LabeledVector, LabeledMatrix
export SAMTable, StartingValues, ModelParameters
export load_sam_table, compute_starting_values, compute_calibration_params

"Convert CES elasticity sigma to rho (rho = (sigma - 1)/sigma)."
rho_from_sigma(sigma::Real) = (sigma - 1) / sigma

"Convert CES rho back to sigma (sigma = 1/(1-rho))."
sigma_from_rho(rho::Real) = 1 / (1 - rho)

"""
Calibrate CES share/scale parameters (placeholder).
Return a NamedTuple so callers can evolve without breaking.
"""
function calibrate_ces_share_scale(; shares::AbstractVector, scale::Real=1.0)
    return (α = collect(shares), A = scale)
end

struct LabeledVector{T}
    data::Vector{T}
    labels::Vector{Symbol}
    index::Dict{Symbol,Int}
end

struct LabeledMatrix{T}
    data::Matrix{T}
    row_labels::Vector{Symbol}
    col_labels::Vector{Symbol}
    row_index::Dict{Symbol,Int}
    col_index::Dict{Symbol,Int}
end

LabeledVector(data::Vector{T}, labels::Vector{Symbol}) where {T} =
    LabeledVector{T}(data, labels, Dict(l => i for (i, l) in pairs(labels)))

LabeledMatrix(data::Matrix{T}, row_labels::Vector{Symbol}, col_labels::Vector{Symbol}) where {T} =
    LabeledMatrix{T}(
        data,
        row_labels,
        col_labels,
        Dict(l => i for (i, l) in pairs(row_labels)),
        Dict(l => i for (i, l) in pairs(col_labels)),
    )

Base.sum(v::LabeledVector) = sum(v.data)

Base.getindex(v::LabeledVector, label::Symbol) = v.data[v.index[label]]
Base.getindex(v::LabeledVector, labels::Vector{Symbol}) = v.data[[v.index[l] for l in labels]]

Base.getindex(m::LabeledMatrix, r::Symbol, c::Symbol) = m.data[m.row_index[r], m.col_index[c]]
Base.getindex(m::LabeledMatrix, rows::Vector{Symbol}, cols::Vector{Symbol}) =
    m.data[[m.row_index[r] for r in rows], [m.col_index[c] for c in cols]]
Base.getindex(m::LabeledMatrix, r::Symbol, cols::Vector{Symbol}) =
    vec(m.data[m.row_index[r], [m.col_index[c] for c in cols]])
Base.getindex(m::LabeledMatrix, rows::Vector{Symbol}, c::Symbol) =
    vec(m.data[[m.row_index[r] for r in rows], m.col_index[c]])

struct SAMTable
    goods::Vector{Symbol}
    factors::Vector{Symbol}
    numeraire_factor_label::Symbol
    indirectTax_label::Symbol
    tariff_label::Symbol
    households_label::Symbol
    government_label::Symbol
    investment_label::Symbol
    restOfTheWorld_label::Symbol
    sam::LabeledMatrix{Float64}
end

struct StartingValues
    Td0::Float64
    Tz0::LabeledVector{Float64}
    Tm0::LabeledVector{Float64}
    F0::LabeledMatrix{Float64}
    Y0::LabeledVector{Float64}
    X0::LabeledMatrix{Float64}
    Z0::LabeledVector{Float64}
    M0::LabeledVector{Float64}
    tau_z::LabeledVector{Float64}
    tau_m::LabeledVector{Float64}
    Xp0::LabeledVector{Float64}
    FF::LabeledVector{Float64}
    Xg0::LabeledVector{Float64}
    Xv0::LabeledVector{Float64}
    E0::LabeledVector{Float64}
    Q0::LabeledVector{Float64}
    D0::LabeledVector{Float64}
    Sp0::Float64
    Sg0::Float64
    Sf::Float64
    pWe::LabeledVector{Float64}
    pWm::LabeledVector{Float64}
    pf0::LabeledVector{Float64}
    py0::LabeledVector{Float64}
    pz0::LabeledVector{Float64}
    pq0::LabeledVector{Float64}
    pe0::LabeledVector{Float64}
    pm0::LabeledVector{Float64}
    pd0::LabeledVector{Float64}
    epsilon0::Float64
end

struct ModelParameters
    sigma::LabeledVector{Float64}
    psi::LabeledVector{Float64}
    eta::LabeledVector{Float64}
    phi::LabeledVector{Float64}
    alpha::LabeledVector{Float64}
    beta::LabeledMatrix{Float64}
    b::LabeledVector{Float64}
    ax::LabeledMatrix{Float64}
    ay::LabeledVector{Float64}
    mu::LabeledVector{Float64}
    lambda::LabeledVector{Float64}
    delta_m::LabeledVector{Float64}
    delta_d::LabeledVector{Float64}
    gamma::LabeledVector{Float64}
    xid::LabeledVector{Float64}
    xie::LabeledVector{Float64}
    theta::LabeledVector{Float64}
    ssp::Float64
    ssg::Float64
    tau_d::Float64
end

to_symbols(values::Vector) = Symbol.(values)

"""
    load_sam_table(file_path::AbstractString; kwargs...) -> SAMTable

Load a SAM CSV from `file_path` and return a `SAMTable`.
"""
function load_sam_table(file_path::AbstractString; goods::Vector{String} = ["BRD", "MLK"],
    factors::Vector{String} = ["CAP", "LAB"],
    numeraire_factor_label::String = "LAB",
    indirectTax_label::String = "IDT",
    tariff_label::String = "TRF",
    households_label::String = "HOH",
    government_label::String = "GOV",
    investment_label::String = "INV",
    restOfTheWorld_label::String = "EXT")
    df = DataFrame(CSV.File(file_path))
    for col in eachcol(df)
        replace!(col, missing => 0)
    end
    row_labels = Symbol.(df[:, "Column1"])
    col_labels = Symbol.(names(df)[2:end])
    sam = LabeledMatrix(Matrix(df[:, 2:end]), row_labels, col_labels)
    return SAMTable(
        to_symbols(goods),
        to_symbols(factors),
        Symbol(numeraire_factor_label),
        Symbol(indirectTax_label),
        Symbol(tariff_label),
        Symbol(households_label),
        Symbol(government_label),
        Symbol(investment_label),
        Symbol(restOfTheWorld_label),
        sam,
    )
end

"""
    load_sam_table(io::IO; kwargs...) -> SAMTable

Load a SAM CSV from an `IO` stream and return a `SAMTable`.
"""
function load_sam_table(io::IO; goods::Vector{String} = ["BRD", "MLK"],
    factors::Vector{String} = ["CAP", "LAB"],
    numeraire_factor_label::String = "LAB",
    indirectTax_label::String = "IDT",
    tariff_label::String = "TRF",
    households_label::String = "HOH",
    government_label::String = "GOV",
    investment_label::String = "INV",
    restOfTheWorld_label::String = "EXT")
    df = DataFrame(CSV.File(io))
    for col in eachcol(df)
        replace!(col, missing => 0)
    end
    row_labels = Symbol.(df[:, "Column1"])
    col_labels = Symbol.(names(df)[2:end])
    sam = LabeledMatrix(Matrix(df[:, 2:end]), row_labels, col_labels)
    return SAMTable(
        to_symbols(goods),
        to_symbols(factors),
        Symbol(numeraire_factor_label),
        Symbol(indirectTax_label),
        Symbol(tariff_label),
        Symbol(households_label),
        Symbol(government_label),
        Symbol(investment_label),
        Symbol(restOfTheWorld_label),
        sam,
    )
end

"""
    compute_starting_values(sam_table::SAMTable) -> StartingValues

Compute calibrated starting values from a `SAMTable`.
"""
function compute_starting_values(sam_table::SAMTable)
    sam = sam_table.sam
    goods = sam_table.goods
    factors = sam_table.factors
    Td0 = sam[sam_table.government_label, sam_table.households_label]
    Tz0 = sam[sam_table.indirectTax_label, goods]
    Tm0 = sam[sam_table.tariff_label, goods]
    F0 = sam[factors, goods]
    Y0 = vec(sum(F0, dims=1))
    X0 = sam[goods, goods]
    Z0 = vec(sum(X0, dims=1)) .+ Y0
    M0 = sam[sam_table.restOfTheWorld_label, goods]
    tau_z = Tz0 ./ Z0
    tau_m = Tm0 ./ M0
    Xp0 = sam[goods, sam_table.households_label]
    FF = sam[sam_table.households_label, factors]
    Xg0 = sam[goods, sam_table.government_label]
    Xv0 = sam[goods, sam_table.investment_label]
    E0 = sam[goods, sam_table.restOfTheWorld_label]
    Q0 = Xp0 .+ Xg0 .+ Xv0 .+ vec(sum(X0, dims=2))
    D0 = (1 .+ tau_z) .* Z0 .- E0
    Sp0 = sam[sam_table.investment_label, sam_table.households_label]
    Sg0 = sam[sam_table.investment_label, sam_table.government_label]
    Sf = sam[sam_table.investment_label, sam_table.restOfTheWorld_label]
    pWe = ones(length(goods))
    pWm = ones(length(goods))
    pf0 = ones(length(factors))
    py0 = ones(length(goods))
    pz0 = ones(length(goods))
    pq0 = ones(length(goods))
    pe0 = ones(length(goods))
    pm0 = ones(length(goods))
    pd0 = ones(length(goods))
    epsilon0 = 1.0
    return StartingValues(
        Td0,
        LabeledVector(Tz0, goods),
        LabeledVector(Tm0, goods),
        LabeledMatrix(F0, factors, goods),
        LabeledVector(Y0, goods),
        LabeledMatrix(X0, goods, goods),
        LabeledVector(Z0, goods),
        LabeledVector(M0, goods),
        LabeledVector(tau_z, goods),
        LabeledVector(tau_m, goods),
        LabeledVector(Xp0, goods),
        LabeledVector(FF, factors),
        LabeledVector(Xg0, goods),
        LabeledVector(Xv0, goods),
        LabeledVector(E0, goods),
        LabeledVector(Q0, goods),
        LabeledVector(D0, goods),
        Sp0,
        Sg0,
        Sf,
        LabeledVector(pWe, goods),
        LabeledVector(pWm, goods),
        LabeledVector(pf0, factors),
        LabeledVector(py0, goods),
        LabeledVector(pz0, goods),
        LabeledVector(pq0, goods),
        LabeledVector(pe0, goods),
        LabeledVector(pm0, goods),
        LabeledVector(pd0, goods),
        epsilon0,
    )
end

"""
    compute_calibration_params(sam_table::SAMTable, start::StartingValues) -> ModelParameters

Compute calibrated model parameters from a `SAMTable` and starting values.
"""
function compute_calibration_params(sam_table::SAMTable, start::StartingValues)
    goods = sam_table.goods
    factors = sam_table.factors
    sigma = fill(2.0, length(goods))
    psi = fill(2.0, length(goods))
    eta = (sigma .- 1.0) ./ sigma
    phi = (psi .+ 1.0) ./ psi
    alpha = start.Xp0.data ./ sum(start.Xp0.data)
    beta = start.F0.data ./ sum(start.F0.data, dims=1)
    b = start.Y0.data ./ vec(prod(start.F0.data .^ beta, dims=1))
    ax = start.X0.data ./ transpose(start.Z0.data)
    ay = start.Y0.data ./ start.Z0.data
    mu = start.Xg0.data ./ sum(start.Xg0.data)
    lambda = start.Xv0.data ./ (start.Sp0 + start.Sg0 + start.Sf)
    delta_m = (1 .+ start.tau_m.data) .* start.M0.data .^ (1 .- eta) ./
              ((1 .+ start.tau_m.data) .* start.M0.data .^ (1 .- eta) .+ start.D0.data .^ (1 .- eta))
    delta_d = start.D0.data .^ (1 .- eta) ./
              ((1 .+ start.tau_m.data) .* start.M0.data .^ (1 .- eta) .+ start.D0.data .^ (1 .- eta))
    gamma = start.Q0.data ./ (delta_m .* start.M0.data .^ eta .+ delta_d .* start.D0.data .^ eta) .^ (1 ./ eta)
    xie = start.E0.data .^ (1 .- phi) ./ (start.E0.data .^ (1 .- phi) .+ start.D0.data .^ (1 .- phi))
    xid = start.D0.data .^ (1 .- phi) ./ (start.E0.data .^ (1 .- phi) .+ start.D0.data .^ (1 .- phi))
    theta = start.Z0.data ./ (xie .* start.E0.data .^ phi .+ xid .* start.D0.data .^ phi) .^ (1 ./ phi)
    ssp = start.Sp0 / sum(start.FF.data)
    ssg = start.Sg0 / (start.Td0 + sum(start.Tz0.data) + sum(start.Tm0.data))
    tau_d = start.Td0 / sum(start.FF.data)
    return ModelParameters(
        LabeledVector(sigma, goods),
        LabeledVector(psi, goods),
        LabeledVector(eta, goods),
        LabeledVector(phi, goods),
        LabeledVector(alpha, goods),
        LabeledMatrix(beta, factors, goods),
        LabeledVector(b, goods),
        LabeledMatrix(ax, goods, goods),
        LabeledVector(ay, goods),
        LabeledVector(mu, goods),
        LabeledVector(lambda, goods),
        LabeledVector(delta_m, goods),
        LabeledVector(delta_d, goods),
        LabeledVector(gamma, goods),
        LabeledVector(xid, goods),
        LabeledVector(xie, goods),
        LabeledVector(theta, goods),
        ssp,
        ssg,
        tau_d,
    )
end

end # module
