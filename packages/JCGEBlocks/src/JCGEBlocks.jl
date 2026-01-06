module JCGEBlocks

using JCGECore
using JCGEKernel
using JuMP

export DummyBlock
export ProductionBlock
export ProductionCDBlock
export ProductionCDLeontiefBlock
export FactorSupplyBlock
export HouseholdDemandBlock
export HouseholdDemandCDBlock
export HouseholdDemandCDXpBlock
export HouseholdDemandCDHHBlock
export MarketClearingBlock
export GoodsMarketClearingBlock
export FactorMarketClearingBlock
export CompositeMarketClearingBlock
export PriceLinkBlock
export ExchangeRateLinkBlock
export PriceEqualityBlock
export NumeraireBlock
export GovernmentBlock
export PrivateSavingBlock
export InvestmentBlock
export ArmingtonCESBlock
export TransformationCETBlock
export ClosureBlock
export UtilityBlock
export UtilityCDBlock
export UtilityCDXpBlock
export UtilityCDHHBlock
export ExternalBalanceBlock
export ExternalBalanceVarPriceBlock
export ForeignTradeBlock
export PriceAggregationBlock
export InitialValuesBlock
export apply_start
export rerun!

"Minimal example block used to validate end-to-end wiring."
struct DummyBlock <: JCGECore.AbstractBlock
    name::Symbol
end

function JCGECore.build!(block::DummyBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    JCGEKernel.register_variable!(ctx, Symbol(block.name, :_x), 1.0)
    JCGEKernel.register_equation!(ctx; tag=:dummy_eq, block=block.name, payload="x==1 (placeholder)")
    return nothing
end

struct ProductionBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    commodities::Vector{Symbol}
    form::Symbol
    params::NamedTuple
end

struct ProductionCDBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    params::NamedTuple
end

struct ProductionCDLeontiefBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct FactorSupplyBlock <: JCGECore.AbstractBlock
    name::Symbol
    factors::Vector{Symbol}
    params::NamedTuple
end

struct HouseholdDemandBlock <: JCGECore.AbstractBlock
    name::Symbol
    households::Vector{Symbol}
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    form::Symbol
    consumption_var::Symbol
    params::NamedTuple
end

struct HouseholdDemandCDBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    params::NamedTuple
end

struct HouseholdDemandCDXpBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    params::NamedTuple
end

struct HouseholdDemandCDHHBlock <: JCGECore.AbstractBlock
    name::Symbol
    households::Vector{Symbol}
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    params::NamedTuple
end

struct MarketClearingBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
end

struct GoodsMarketClearingBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
end

struct FactorMarketClearingBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    params::NamedTuple
end

struct CompositeMarketClearingBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    activities::Vector{Symbol}
end

struct PriceLinkBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ExchangeRateLinkBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
end

struct PriceEqualityBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
end

struct NumeraireBlock <: JCGECore.AbstractBlock
    name::Symbol
    kind::Symbol
    label::Symbol
    value::Float64
end

struct GovernmentBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    params::NamedTuple
end

struct PrivateSavingBlock <: JCGECore.AbstractBlock
    name::Symbol
    factors::Vector{Symbol}
    params::NamedTuple
end

struct InvestmentBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ArmingtonCESBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct TransformationCETBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ClosureBlock <: JCGECore.AbstractBlock
    name::Symbol
    params::NamedTuple
end

struct UtilityBlock <: JCGECore.AbstractBlock
    name::Symbol
    households::Vector{Symbol}
    commodities::Vector{Symbol}
    form::Symbol
    consumption_var::Symbol
    params::NamedTuple
end

struct UtilityCDBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct UtilityCDXpBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct UtilityCDHHBlock <: JCGECore.AbstractBlock
    name::Symbol
    households::Vector{Symbol}
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ExternalBalanceBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ExternalBalanceVarPriceBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ForeignTradeBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct PriceAggregationBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    activities::Vector{Symbol}
    params::NamedTuple
end

struct InitialValuesBlock <: JCGECore.AbstractBlock
    name::Symbol
    params::NamedTuple
end

function global_var(base::Symbol, idxs::Symbol...)
    if isempty(idxs)
        return base
    end
    return Symbol(string(base), "_", join(string.(idxs), "_"))
end

function var_name(block::FactorSupplyBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::FactorSupplyBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::HouseholdDemandCDHHBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::HouseholdDemandCDHHBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::HouseholdDemandCDBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::HouseholdDemandCDXpBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::MarketClearingBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::MarketClearingBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::GoodsMarketClearingBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::FactorMarketClearingBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::CompositeMarketClearingBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::PriceLinkBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PriceLinkBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ExchangeRateLinkBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PriceEqualityBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::NumeraireBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::NumeraireBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::GovernmentBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::GovernmentBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PrivateSavingBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::InvestmentBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::InvestmentBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::ArmingtonCESBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ArmingtonCESBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::TransformationCETBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::TransformationCETBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::ClosureBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ClosureBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::UtilityBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::UtilityBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::UtilityCDBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::UtilityCDXpBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::UtilityCDHHBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::ExternalBalanceBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ExternalBalanceBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ExternalBalanceVarPriceBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ForeignTradeBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::PriceAggregationBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PriceAggregationBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::InitialValuesBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::ProductionCDLeontiefBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function ensure_var!(ctx::JCGEKernel.KernelContext, model, name::Symbol; lower=0.00001, start=nothing)
    if haskey(ctx.variables, name)
        return ctx.variables[name]
    end
    if model isa JuMP.Model
        if start === nothing
            v = @variable(model, lower_bound=lower, base_name=string(name))
        else
            v = @variable(model, lower_bound=lower, base_name=string(name), start=start)
        end
    else
        v = (name=name)
    end
    JCGEKernel.register_variable!(ctx, name, v)
    return v
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ProductionCDLeontiefBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ProductionCDBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function JCGECore.build!(block::ProductionCDLeontiefBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities

    model = ctx.model
    Y = Dict{Symbol,Any}()
    Z = Dict{Symbol,Any}()
    py = Dict{Symbol,Any}()
    pz = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    F = Dict{Tuple{Symbol,Symbol},Any}()
    X = Dict{Tuple{Symbol,Symbol},Any}()

    for i in activities
        Y[i] = ensure_var!(ctx, model, var_name(block, :Y, i))
        Z[i] = ensure_var!(ctx, model, var_name(block, :Z, i))
        py[i] = ensure_var!(ctx, model, var_name(block, :py, i))
        pz[i] = ensure_var!(ctx, model, var_name(block, :pz, i))
    end

    for j in commodities
        pq[j] = ensure_var!(ctx, model, var_name(block, :pq, j))
    end

    for h in factors
        pf[h] = ensure_var!(ctx, model, var_name(block, :pf, h))
    end

    for h in factors, i in activities
        F[(h, i)] = ensure_var!(ctx, model, var_name(block, :F, h, i))
    end

    for j in commodities, i in activities
        X[(j, i)] = ensure_var!(ctx, model, var_name(block, :X, j, i))
    end

    for i in activities
        b_i = JCGECore.getparam(block.params, :b, i)
        beta_vals = Dict(h => JCGECore.getparam(block.params, :beta, h, i) for h in factors)
        ay_i = JCGECore.getparam(block.params, :ay, i)
        ax_vals = Dict(j => JCGECore.getparam(block.params, :ax, j, i) for j in commodities)

        constraint = model isa JuMP.Model ? @NLconstraint(model, Y[i] == b_i * prod(F[(h, i)] ^ beta_vals[h] for h in factors)) : nothing
        register_eq!(ctx, block, :eqpy, i; info="Y[i] == b[i] * prod(F[h,i]^beta[h,i])", constraint=constraint)

        for h in factors
            constraint = model isa JuMP.Model ? @NLconstraint(model, F[(h, i)] == beta_vals[h] * py[i] * Y[i] / pf[h]) : nothing
            register_eq!(ctx, block, :eqF, h, i; info="F[h,i] == beta[h,i] * py[i] * Y[i] / pf[h]", constraint=constraint)
        end

        for j in commodities
            constraint = model isa JuMP.Model ? @constraint(model, X[(j, i)] == ax_vals[j] * Z[i]) : nothing
            register_eq!(ctx, block, :eqX, j, i; info="X[j,i] == ax[j,i] * Z[i]", constraint=constraint)
        end

        constraint = model isa JuMP.Model ? @constraint(model, Y[i] == ay_i * Z[i]) : nothing
        register_eq!(ctx, block, :eqY, i; info="Y[i] == ay[i] * Z[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, pz[i] == ay_i * py[i] + sum(ax_vals[j] * pq[j] for j in commodities)) : nothing
        register_eq!(ctx, block, :eqpzs, i; info="pz[i] == ay[i]*py[i] + sum(ax[j,i]*pq[j])", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::ProductionCDBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Z = Dict{Symbol,Any}()
    pz = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    F = Dict{Tuple{Symbol,Symbol},Any}()

    for j in activities
        Z[j] = ensure_var!(ctx, model, global_var(:Z, j))
        pz[j] = ensure_var!(ctx, model, global_var(:pz, j))
    end
    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
    end
    for h in factors, j in activities
        F[(h, j)] = ensure_var!(ctx, model, global_var(:F, h, j))
    end

    for j in activities
        b_j = JCGECore.getparam(block.params, :b, j)
        beta_vals = Dict(h => JCGECore.getparam(block.params, :beta, h, j) for h in factors)
        constraint = model isa JuMP.Model ? @NLconstraint(model, Z[j] == b_j * prod(F[(h, j)] ^ beta_vals[h] for h in factors)) : nothing
        register_eq!(ctx, block, :eqZ, j; info="Z[j] == b[j] * prod(F[h,j]^beta[h,j])", constraint=constraint)

        for h in factors
            constraint = model isa JuMP.Model ? @NLconstraint(model, F[(h, j)] == beta_vals[h] * pz[j] * Z[j] / pf[h]) : nothing
            register_eq!(ctx, block, :eqF, h, j; info="F[h,j] == beta[h,j] * pz[j] * Z[j] / pf[h]", constraint=constraint)
        end
    end

    return nothing
end

function JCGECore.build!(block::ProductionBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    if block.form == :cd
        inner = ProductionCDBlock(block.name, block.activities, block.factors, block.params)
        return JCGECore.build!(inner, ctx, spec)
    elseif block.form == :cd_leontief
        inner = ProductionCDLeontiefBlock(block.name, block.activities, block.factors, block.commodities, block.params)
        return JCGECore.build!(inner, ctx, spec)
    else
        error("Unsupported production form: $(block.form)")
    end
end

function JCGECore.build!(block::FactorSupplyBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    for h in factors
        var = ensure_var!(ctx, model, var_name(block, :FF, h))
    ff_h = JCGECore.getparam(block.params, :FF, h)
    constraint = model isa JuMP.Model ? @constraint(model, var == ff_h) : nothing
        register_eq!(ctx, block, :eqFF, h; info="FF[h] == endowment[h]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::HouseholdDemandCDHHBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    households = isempty(block.households) ? spec.model.sets.institutions : block.households
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Xp = Dict{Tuple{Symbol,Symbol},Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    Sp = Dict{Symbol,Any}()
    Td = Dict{Symbol,Any}()
    Y = Dict{Symbol,Any}()

    for i in commodities
        pq[i] = ensure_var!(ctx, model, var_name(block, :pq, i))
    end

    for h in factors
        pf[h] = ensure_var!(ctx, model, var_name(block, :pf, h))
    end

    for hh in households
        Sp[hh] = ensure_var!(ctx, model, var_name(block, :Sp, hh))
        Td[hh] = ensure_var!(ctx, model, var_name(block, :Td, hh))
        Y[hh] = ensure_var!(ctx, model, var_name(block, :Y, hh))
    end

    for i in commodities, hh in households
        Xp[(i, hh)] = ensure_var!(ctx, model, var_name(block, :Xp, i, hh))
    end

    for hh in households
        ff_vals = Dict(h => JCGECore.getparam(block.params, :FF, h, hh) for h in factors)
        ssp_hh = JCGECore.getparam(block.params, :ssp, hh)
        tau_d_hh = JCGECore.getparam(block.params, :tau_d, hh)
        alpha_vals = Dict(i => JCGECore.getparam(block.params, :alpha, i, hh) for i in commodities)

        constraint = model isa JuMP.Model ? @constraint(model, Y[hh] == sum(pf[h] * ff_vals[h] for h in factors)) : nothing
        register_eq!(ctx, block, :eqY, hh; info="Y[hh] == sum(pf[h] * FF[h,hh])", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, Sp[hh] == ssp_hh * Y[hh]) : nothing
        register_eq!(ctx, block, :eqSp, hh; info="Sp[hh] == ssp[hh] * Y[hh]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, Td[hh] == tau_d_hh * Y[hh]) : nothing
        register_eq!(ctx, block, :eqTd, hh; info="Td[hh] == tau_d[hh] * Y[hh]", constraint=constraint)

        for i in commodities
            constraint = model isa JuMP.Model ? @NLconstraint(model, Xp[(i, hh)] == alpha_vals[i] * (Y[hh] - Sp[hh] - Td[hh]) / pq[i]) : nothing
            register_eq!(ctx, block, :eqXp, i, hh; info="Xp[i,hh] == alpha[i,hh] * (Y - Sp - Td) / pq[i]", constraint=constraint)
        end
    end

    return nothing
end

function JCGECore.build!(block::HouseholdDemandCDBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    X = Dict{Symbol,Any}()
    px = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()

    for i in commodities
        X[i] = ensure_var!(ctx, model, global_var(:X, i))
        px[i] = ensure_var!(ctx, model, global_var(:px, i))
    end
    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
    end

    ff_vals = Dict(h => JCGECore.getparam(block.params, :FF, h) for h in factors)
    for i in commodities
        alpha_i = JCGECore.getparam(block.params, :alpha, i)
        constraint = model isa JuMP.Model ? @NLconstraint(model, X[i] == alpha_i * sum(pf[h] * ff_vals[h] for h in factors) / px[i]) : nothing
        register_eq!(ctx, block, :eqX, i; info="X[i] == alpha[i] * sum(pf[h]*FF[h]) / px[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::HouseholdDemandCDXpBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Xp = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    Sp = ensure_var!(ctx, model, global_var(:Sp))
    Td = ensure_var!(ctx, model, global_var(:Td))

    for i in commodities
        Xp[i] = ensure_var!(ctx, model, global_var(:Xp, i))
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
    end
    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
    end

    ff_vals = Dict(h => JCGECore.getparam(block.params, :FF, h) for h in factors)
    for i in commodities
        alpha_i = JCGECore.getparam(block.params, :alpha, i)
        constraint = model isa JuMP.Model ? @NLconstraint(
            model,
            Xp[i] == alpha_i * (sum(pf[h] * ff_vals[h] for h in factors) - Sp - Td) / pq[i]
        ) : nothing
        register_eq!(ctx, block, :eqXp, i; info="Xp[i] == alpha[i] * (sum(pf[h]*FF[h]) - Sp - Td) / pq[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::HouseholdDemandBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    if block.form != :cd
        error("Unsupported household demand form: $(block.form)")
    end
    if block.consumption_var == :X
        inner = HouseholdDemandCDBlock(block.name, block.commodities, block.factors, block.params)
        return JCGECore.build!(inner, ctx, spec)
    elseif block.consumption_var == :Xp
        if isempty(block.households)
            inner = HouseholdDemandCDXpBlock(block.name, block.commodities, block.factors, block.params)
            return JCGECore.build!(inner, ctx, spec)
        end
        inner = HouseholdDemandCDHHBlock(block.name, block.households, block.commodities, block.factors, block.params)
        return JCGECore.build!(inner, ctx, spec)
    else
        error("Unsupported consumption variable: $(block.consumption_var)")
    end
end

function JCGECore.build!(block::MarketClearingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Q = Dict{Symbol,Any}()
    Xp = Dict{Tuple{Symbol,Symbol},Any}()
    Xg = Dict{Symbol,Any}()
    Xv = Dict{Symbol,Any}()
    X = Dict{Tuple{Symbol,Symbol},Any}()
    F = Dict{Tuple{Symbol,Symbol},Any}()
    FF = Dict{Symbol,Any}()

    for i in commodities
        Q[i] = ensure_var!(ctx, model, var_name(block, :Q, i))
        Xg[i] = ensure_var!(ctx, model, var_name(block, :Xg, i))
        Xv[i] = ensure_var!(ctx, model, var_name(block, :Xv, i))
    end

    for h in factors
        FF[h] = ensure_var!(ctx, model, var_name(block, :FF, h))
    end

    for i in commodities, hh in spec.model.sets.institutions
        Xp[(i, hh)] = ensure_var!(ctx, model, var_name(block, :Xp, i, hh))
    end

    for j in commodities, i in spec.model.sets.activities
        X[(j, i)] = ensure_var!(ctx, model, var_name(block, :X, j, i))
    end

    for h in factors, i in spec.model.sets.activities
        F[(h, i)] = ensure_var!(ctx, model, var_name(block, :F, h, i))
    end

    for i in commodities
        constraint = model isa JuMP.Model ? @constraint(model, Q[i] == sum(Xp[(i, hh)] for hh in spec.model.sets.institutions) + Xg[i] + Xv[i] + sum(X[(i, j)] for j in spec.model.sets.activities)) : nothing
        register_eq!(ctx, block, :eqQ, i; info="Q[i] == sum(Xp[i,hh]) + Xg[i] + Xv[i] + sum(X[i,j])", constraint=constraint)
    end

    for h in factors
        constraint = model isa JuMP.Model ? @constraint(model, FF[h] == sum(F[(h, i)] for i in spec.model.sets.activities)) : nothing
        register_eq!(ctx, block, :eqF, h; info="FF[h] == sum(F[h,i])", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::GoodsMarketClearingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    for i in commodities
        X = ensure_var!(ctx, model, global_var(:X, i))
        Z = ensure_var!(ctx, model, global_var(:Z, i))
        constraint = model isa JuMP.Model ? @constraint(model, X == Z) : nothing
        register_eq!(ctx, block, :eqX, i; info="X[i] == Z[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::FactorMarketClearingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    F = Dict{Tuple{Symbol,Symbol},Any}()
    for h in factors, j in activities
        F[(h, j)] = ensure_var!(ctx, model, global_var(:F, h, j))
    end

    for h in factors
        ff_h = JCGECore.getparam(block.params, :FF, h)
        constraint = model isa JuMP.Model ? @constraint(model, sum(F[(h, j)] for j in activities) == ff_h) : nothing
        register_eq!(ctx, block, :eqF, h; info="sum(F[h,j]) == FF[h]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::CompositeMarketClearingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model

    Q = Dict{Symbol,Any}()
    Xp = Dict{Symbol,Any}()
    Xg = Dict{Symbol,Any}()
    Xv = Dict{Symbol,Any}()
    X = Dict{Tuple{Symbol,Symbol},Any}()

    for i in commodities
        Q[i] = ensure_var!(ctx, model, global_var(:Q, i))
        Xp[i] = ensure_var!(ctx, model, global_var(:Xp, i))
        Xg[i] = ensure_var!(ctx, model, global_var(:Xg, i))
        Xv[i] = ensure_var!(ctx, model, global_var(:Xv, i))
    end

    for i in commodities, j in activities
        X[(i, j)] = ensure_var!(ctx, model, global_var(:X, i, j))
    end

    for i in commodities
        constraint = model isa JuMP.Model ? @constraint(
            model,
            Q[i] == Xp[i] + Xg[i] + Xv[i] + sum(X[(i, j)] for j in activities)
        ) : nothing
        register_eq!(ctx, block, :eqQ, i; info="Q[i] == Xp[i] + Xg[i] + Xv[i] + sum(X[i,j])", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::PriceLinkBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    pe = Dict{Symbol,Any}()
    pm = Dict{Symbol,Any}()
    epsilon = ensure_var!(ctx, model, var_name(block, :epsilon))

    for i in commodities
        pe[i] = ensure_var!(ctx, model, var_name(block, :pe, i))
        pm[i] = ensure_var!(ctx, model, var_name(block, :pm, i))
    end

    for i in commodities
        pWe_i = JCGECore.getparam(block.params, :pWe, i)
        pWm_i = JCGECore.getparam(block.params, :pWm, i)
        constraint = model isa JuMP.Model ? @constraint(model, pe[i] == epsilon * pWe_i) : nothing
        register_eq!(ctx, block, :eqpe, i; info="pe[i] == epsilon * pWe[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, pm[i] == epsilon * pWm_i) : nothing
        register_eq!(ctx, block, :eqpm, i; info="pm[i] == epsilon * pWm[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::ExchangeRateLinkBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    epsilon = ensure_var!(ctx, model, global_var(:epsilon))
    pe = Dict{Symbol,Any}()
    pm = Dict{Symbol,Any}()
    pWe = Dict{Symbol,Any}()
    pWm = Dict{Symbol,Any}()

    for i in commodities
        pe[i] = ensure_var!(ctx, model, global_var(:pe, i))
        pm[i] = ensure_var!(ctx, model, global_var(:pm, i))
        pWe[i] = ensure_var!(ctx, model, global_var(:pWe, i))
        pWm[i] = ensure_var!(ctx, model, global_var(:pWm, i))
    end

    for i in commodities
        constraint = model isa JuMP.Model ? @constraint(model, pe[i] == epsilon * pWe[i]) : nothing
        register_eq!(ctx, block, :eqpe, i; info="pe[i] == epsilon * pWe[i]", constraint=constraint)
        constraint = model isa JuMP.Model ? @constraint(model, pm[i] == epsilon * pWm[i]) : nothing
        register_eq!(ctx, block, :eqpm, i; info="pm[i] == epsilon * pWm[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::PriceEqualityBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    for i in commodities
        px = ensure_var!(ctx, model, global_var(:px, i))
        pz = ensure_var!(ctx, model, global_var(:pz, i))
        constraint = model isa JuMP.Model ? @constraint(model, px == pz) : nothing
        register_eq!(ctx, block, :eqP, i; info="px[i] == pz[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::NumeraireBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    model = ctx.model
    if model isa JuMP.Model
        if block.kind == :factor
            pf = ensure_var!(ctx, model, var_name(block, :pf, block.label))
            JuMP.fix(pf, block.value; force=true)
        elseif block.kind == :commodity
            pq = ensure_var!(ctx, model, var_name(block, :pq, block.label))
            JuMP.fix(pq, block.value; force=true)
        elseif block.kind == :exchange
            epsilon = ensure_var!(ctx, model, var_name(block, :epsilon))
            JuMP.fix(epsilon, block.value; force=true)
        else
            error("Unknown numeraire kind: $(block.kind)")
        end
    end
    register_eq!(ctx, block, :numeraire; info="numeraire fixed", constraint=nothing)
    return nothing
end

function JCGECore.build!(block::GovernmentBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Td = ensure_var!(ctx, model, global_var(:Td))
    Sg = ensure_var!(ctx, model, global_var(:Sg))
    Tz = Dict{Symbol,Any}()
    Tm = Dict{Symbol,Any}()
    Xg = Dict{Symbol,Any}()
    pz = Dict{Symbol,Any}()
    pm = Dict{Symbol,Any}()
    Z = Dict{Symbol,Any}()
    M = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    FF = Dict{Symbol,Any}()

    for i in commodities
        Tz[i] = ensure_var!(ctx, model, global_var(:Tz, i))
        Tm[i] = ensure_var!(ctx, model, global_var(:Tm, i))
        Xg[i] = ensure_var!(ctx, model, global_var(:Xg, i))
        pz[i] = ensure_var!(ctx, model, global_var(:pz, i))
        pm[i] = ensure_var!(ctx, model, global_var(:pm, i))
        Z[i] = ensure_var!(ctx, model, global_var(:Z, i))
        M[i] = ensure_var!(ctx, model, global_var(:M, i))
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
    end

    use_ff_params = hasproperty(block.params, :FF)
    ff_vals = Dict{Symbol,Any}()
    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
        if use_ff_params
            ff_vals[h] = JCGECore.getparam(block.params, :FF, h)
        else
            FF[h] = ensure_var!(ctx, model, global_var(:FF, h))
        end
    end
    if !use_ff_params
        for h in factors
            ff_vals[h] = FF[h]
        end
    end

    tau_d = JCGECore.getparam(block.params, :tau_d)
    constraint = model isa JuMP.Model ? @constraint(model, Td == tau_d * sum(pf[h] * ff_vals[h] for h in factors)) : nothing
    register_eq!(ctx, block, :eqTd; info="Td == tau_d * sum(pf[h] * FF[h])", constraint=constraint)

    for i in commodities
        tau_z_i = JCGECore.getparam(block.params, :tau_z, i)
        tau_m_i = JCGECore.getparam(block.params, :tau_m, i)
        mu_i = JCGECore.getparam(block.params, :mu, i)
        constraint = model isa JuMP.Model ? @constraint(model, Tz[i] == tau_z_i * pz[i] * Z[i]) : nothing
        register_eq!(ctx, block, :eqTz, i; info="Tz[i] == tau_z[i] * pz[i] * Z[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, Tm[i] == tau_m_i * pm[i] * M[i]) : nothing
        register_eq!(ctx, block, :eqTm, i; info="Tm[i] == tau_m[i] * pm[i] * M[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @NLconstraint(model, Xg[i] == mu_i * (Td + sum(Tz[j] for j in commodities) + sum(Tm[j] for j in commodities) - Sg) / pq[i]) : nothing
        register_eq!(ctx, block, :eqXg, i; info="Xg[i] == mu[i] * (Td + sum(Tz)+sum(Tm) - Sg) / pq[i]", constraint=constraint)
    end

    ssg = JCGECore.getparam(block.params, :ssg)
    constraint = model isa JuMP.Model ? @constraint(model, Sg == ssg * (Td + sum(Tz[i] for i in commodities) + sum(Tm[i] for i in commodities))) : nothing
    register_eq!(ctx, block, :eqSg; info="Sg == ssg * (Td + sum(Tz) + sum(Tm))", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::PrivateSavingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Sp = ensure_var!(ctx, model, global_var(:Sp))
    pf = Dict{Symbol,Any}()
    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
    end

    ssp = JCGECore.getparam(block.params, :ssp)
    ff_vals = Dict(h => JCGECore.getparam(block.params, :FF, h) for h in factors)
    constraint = model isa JuMP.Model ? @constraint(model, Sp == ssp * sum(pf[h] * ff_vals[h] for h in factors)) : nothing
    register_eq!(ctx, block, :eqSp; info="Sp == ssp * sum(pf[h] * FF[h])", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::InvestmentBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    Sp = ensure_var!(ctx, model, global_var(:Sp))
    Sg = ensure_var!(ctx, model, global_var(:Sg))
    Xv = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    epsilon = ensure_var!(ctx, model, global_var(:epsilon))

    for i in commodities
        Xv[i] = ensure_var!(ctx, model, global_var(:Xv, i))
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
    end

    Sf = JCGECore.getparam(block.params, :Sf)
    for i in commodities
        lambda_i = JCGECore.getparam(block.params, :lambda, i)
        constraint = model isa JuMP.Model ? @NLconstraint(model, Xv[i] == lambda_i * (Sp + Sg + epsilon * Sf) / pq[i]) : nothing
        register_eq!(ctx, block, :eqXv, i; info="Xv[i] == lambda[i] * (Sp + Sg + epsilon*Sf) / pq[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::ArmingtonCESBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    Q = Dict{Symbol,Any}()
    M = Dict{Symbol,Any}()
    D = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pm = Dict{Symbol,Any}()
    pd = Dict{Symbol,Any}()

    for i in commodities
        Q[i] = ensure_var!(ctx, model, global_var(:Q, i))
        M[i] = ensure_var!(ctx, model, global_var(:M, i))
        D[i] = ensure_var!(ctx, model, global_var(:D, i))
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
        pm[i] = ensure_var!(ctx, model, global_var(:pm, i))
        pd[i] = ensure_var!(ctx, model, global_var(:pd, i))
    end

    for i in commodities
        gamma_i = JCGECore.getparam(block.params, :gamma, i)
        delta_m_i = JCGECore.getparam(block.params, :delta_m, i)
        delta_d_i = JCGECore.getparam(block.params, :delta_d, i)
        eta_i = JCGECore.getparam(block.params, :eta, i)
        tau_m_i = JCGECore.getparam(block.params, :tau_m, i)

        constraint = model isa JuMP.Model ? @NLconstraint(model, Q[i] == gamma_i *
            (delta_m_i * M[i] ^ eta_i + delta_d_i * D[i] ^ eta_i) ^ (1 / eta_i)) : nothing
        register_eq!(ctx, block, :eqQ, i; info="Q[i] == gamma[i]*(delta_m*M^eta + delta_d*D^eta)^(1/eta)", constraint=constraint)

        constraint = model isa JuMP.Model ? @NLconstraint(model, M[i] ==
            (gamma_i ^ eta_i * delta_m_i * pq[i] / ((1 + tau_m_i) * pm[i])) ^ (1 / (1 - eta_i)) * Q[i]) : nothing
        register_eq!(ctx, block, :eqM, i; info="M[i] == (...) * Q[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @NLconstraint(model, D[i] ==
            (gamma_i ^ eta_i * delta_d_i * pq[i] / pd[i]) ^ (1 / (1 - eta_i)) * Q[i]) : nothing
        register_eq!(ctx, block, :eqD, i; info="D[i] == (...) * Q[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::TransformationCETBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    Z = Dict{Symbol,Any}()
    E = Dict{Symbol,Any}()
    D = Dict{Symbol,Any}()
    pz = Dict{Symbol,Any}()
    pe = Dict{Symbol,Any}()
    pd = Dict{Symbol,Any}()

    for i in commodities
        Z[i] = ensure_var!(ctx, model, global_var(:Z, i))
        E[i] = ensure_var!(ctx, model, global_var(:E, i))
        D[i] = ensure_var!(ctx, model, global_var(:D, i))
        pz[i] = ensure_var!(ctx, model, global_var(:pz, i))
        pe[i] = ensure_var!(ctx, model, global_var(:pe, i))
        pd[i] = ensure_var!(ctx, model, global_var(:pd, i))
    end

    for i in commodities
        theta_i = JCGECore.getparam(block.params, :theta, i)
        xie_i = JCGECore.getparam(block.params, :xie, i)
        xid_i = JCGECore.getparam(block.params, :xid, i)
        phi_i = JCGECore.getparam(block.params, :phi, i)
        tau_z_i = JCGECore.getparam(block.params, :tau_z, i)

        constraint = model isa JuMP.Model ? @NLconstraint(model, Z[i] == theta_i *
            (xie_i * E[i] ^ phi_i + xid_i * D[i] ^ phi_i) ^ (1 / phi_i)) : nothing
        register_eq!(ctx, block, :eqZ, i; info="Z[i] == theta[i]*(xie*E^phi + xid*D^phi)^(1/phi)", constraint=constraint)

        constraint = model isa JuMP.Model ? @NLconstraint(model, E[i] ==
            (theta_i ^ phi_i * xie_i * (1 + tau_z_i) * pz[i] / pe[i]) ^ (1 / (1 - phi_i)) * Z[i]) : nothing
        register_eq!(ctx, block, :eqE, i; info="E[i] == (...) * Z[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @NLconstraint(model, D[i] ==
            (theta_i ^ phi_i * xid_i * (1 + tau_z_i) * pz[i] / pd[i]) ^ (1 / (1 - phi_i)) * Z[i]) : nothing
        register_eq!(ctx, block, :eqDs, i; info="D[i] == (...) * Z[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::ClosureBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    model = ctx.model

    if hasproperty(block.params, :fixed)
        fixed = block.params.fixed
        for (name, value) in fixed
            var = ensure_var!(ctx, model, global_var(Symbol(name)))
            if model isa JuMP.Model
                JuMP.fix(var, value; force=true)
            end
            register_eq!(ctx, block, :fix, name; info="fix $(name) == $(value)", constraint=nothing)
        end
    end

    if hasproperty(block.params, :equalities)
        eqs = block.params.equalities
        for (lhs, rhs) in eqs
            var_lhs = ensure_var!(ctx, model, global_var(Symbol(lhs)))
            var_rhs = ensure_var!(ctx, model, global_var(Symbol(rhs)))
            constraint = model isa JuMP.Model ? @constraint(model, var_lhs == var_rhs) : nothing
            register_eq!(ctx, block, :eq, lhs, rhs; info="fix $(lhs) == $(rhs)", constraint=constraint)
        end
    end

    return nothing
end

function JCGECore.build!(block::UtilityCDHHBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    households = isempty(block.households) ? spec.model.sets.institutions : block.households
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    Xp = Dict{Tuple{Symbol,Symbol},Any}()
    for i in commodities, hh in households
        Xp[(i, hh)] = ensure_var!(ctx, model, global_var(:Xp, i, hh))
    end

    if model isa JuMP.Model
        alpha_vals = Dict(hh => Dict(i => JCGECore.getparam(block.params, :alpha, i, hh) for i in commodities) for hh in households)
        if length(households) == 1
            hh = only(households)
            @NLobjective(model, Max, prod(Xp[(i, hh)] ^ alpha_vals[hh][i] for i in commodities))
        else
            @NLobjective(model, Max, sum(prod(Xp[(i, hh)] ^ alpha_vals[hh][i] for i in commodities) for hh in households))
        end
    end
    register_eq!(ctx, block, :objective; info="maximize household utility", constraint=nothing)
    return nothing
end

function JCGECore.build!(block::UtilityCDBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    X = Dict{Symbol,Any}()
    for i in commodities
        X[i] = ensure_var!(ctx, model, global_var(:X, i))
    end

    if model isa JuMP.Model
        alpha_vals = Dict(i => JCGECore.getparam(block.params, :alpha, i) for i in commodities)
        @NLobjective(model, Max, prod(X[i] ^ alpha_vals[i] for i in commodities))
    end
    register_eq!(ctx, block, :objective; info="maximize Cobb-Douglas utility", constraint=nothing)
    return nothing
end

function JCGECore.build!(block::UtilityCDXpBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    Xp = Dict{Symbol,Any}()
    for i in commodities
        Xp[i] = ensure_var!(ctx, model, global_var(:Xp, i))
    end

    if model isa JuMP.Model
        alpha_vals = Dict(i => JCGECore.getparam(block.params, :alpha, i) for i in commodities)
        @NLobjective(model, Max, prod(Xp[i] ^ alpha_vals[i] for i in commodities))
    end
    register_eq!(ctx, block, :objective; info="maximize Cobb-Douglas utility over Xp", constraint=nothing)
    return nothing
end

function JCGECore.build!(block::UtilityBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    if block.form != :cd
        error("Unsupported utility form: $(block.form)")
    end
    if block.consumption_var == :X
        inner = UtilityCDBlock(block.name, block.commodities, block.params)
        return JCGECore.build!(inner, ctx, spec)
    elseif block.consumption_var == :Xp
        if isempty(block.households)
            inner = UtilityCDXpBlock(block.name, block.commodities, block.params)
            return JCGECore.build!(inner, ctx, spec)
        end
        inner = UtilityCDHHBlock(block.name, block.households, block.commodities, block.params)
        return JCGECore.build!(inner, ctx, spec)
    else
        error("Unsupported consumption variable: $(block.consumption_var)")
    end
end

function JCGECore.build!(block::ExternalBalanceBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    E = Dict{Symbol,Any}()
    M = Dict{Symbol,Any}()
    for i in commodities
        E[i] = ensure_var!(ctx, model, global_var(:E, i))
        M[i] = ensure_var!(ctx, model, global_var(:M, i))
    end

    Sf = JCGECore.getparam(block.params, :Sf)
    pWe_vals = Dict(i => JCGECore.getparam(block.params, :pWe, i) for i in commodities)
    pWm_vals = Dict(i => JCGECore.getparam(block.params, :pWm, i) for i in commodities)
    constraint = model isa JuMP.Model ? @constraint(model,
        sum(pWe_vals[i] * E[i] for i in commodities) + Sf ==
        sum(pWm_vals[i] * M[i] for i in commodities)
    ) : nothing
    register_eq!(ctx, block, :eqBOP; info="sum(pWe[i]*E[i]) + Sf == sum(pWm[i]*M[i])", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::ExternalBalanceVarPriceBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    E = Dict{Symbol,Any}()
    M = Dict{Symbol,Any}()
    pWe = Dict{Symbol,Any}()
    pWm = Dict{Symbol,Any}()
    for i in commodities
        E[i] = ensure_var!(ctx, model, global_var(:E, i))
        M[i] = ensure_var!(ctx, model, global_var(:M, i))
        pWe[i] = ensure_var!(ctx, model, global_var(:pWe, i))
        pWm[i] = ensure_var!(ctx, model, global_var(:pWm, i))
    end

    Sf = JCGECore.getparam(block.params, :Sf)
    constraint = model isa JuMP.Model ? @constraint(model,
        sum(pWe[i] * E[i] for i in commodities) + Sf ==
        sum(pWm[i] * M[i] for i in commodities)
    ) : nothing
    register_eq!(ctx, block, :eqBOP; info="sum(pWe[i]*E[i]) + Sf == sum(pWm[i]*M[i])", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::ForeignTradeBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    E = Dict{Symbol,Any}()
    M = Dict{Symbol,Any}()
    pWe = Dict{Symbol,Any}()
    pWm = Dict{Symbol,Any}()
    for i in commodities
        E[i] = ensure_var!(ctx, model, global_var(:E, i))
        M[i] = ensure_var!(ctx, model, global_var(:M, i))
        pWe[i] = ensure_var!(ctx, model, global_var(:pWe, i))
        pWm[i] = ensure_var!(ctx, model, global_var(:pWm, i))
    end

    for i in commodities
        E0_i = JCGECore.getparam(block.params, :E0, i)
        M0_i = JCGECore.getparam(block.params, :M0, i)
        pWe0_i = JCGECore.getparam(block.params, :pWe0, i)
        pWm0_i = JCGECore.getparam(block.params, :pWm0, i)
        sigma_i = JCGECore.getparam(block.params, :sigma, i)
        psi_i = JCGECore.getparam(block.params, :psi, i)
        constraint = model isa JuMP.Model ? @NLconstraint(model, E[i] / E0_i == (pWe[i] / pWe0_i) ^ (-sigma_i)) : nothing
        register_eq!(ctx, block, :eqfe, i; info="E[i]/E0[i] == (pWe[i]/pWe0[i])^(-sigma[i])", constraint=constraint)
        constraint = model isa JuMP.Model ? @NLconstraint(model, M[i] / M0_i == (pWm[i] / pWm0_i) ^ (psi_i)) : nothing
        register_eq!(ctx, block, :eqfm, i; info="M[i]/M0[i] == (pWm[i]/pWm0[i])^(psi[i])", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::PriceAggregationBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model

    pz = Dict{Symbol,Any}()
    py = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    for i in activities
        pz[i] = ensure_var!(ctx, model, global_var(:pz, i))
        py[i] = ensure_var!(ctx, model, global_var(:py, i))
    end
    for j in commodities
        pq[j] = ensure_var!(ctx, model, global_var(:pq, j))
    end

    for i in activities
        ay_i = JCGECore.getparam(block.params, :ay, i)
        ax_vals = Dict(j => JCGECore.getparam(block.params, :ax, j, i) for j in commodities)
        constraint = model isa JuMP.Model ? @constraint(model, pz[i] == ay_i * py[i] + sum(ax_vals[j] * pq[j] for j in commodities)) : nothing
        register_eq!(ctx, block, :eqpzs, i; info="pz[i] == ay[i]*py[i] + sum(ax[j,i]*pq[j])", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::InitialValuesBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    model = ctx.model
    start = hasproperty(block.params, :start) ? block.params.start : Dict{Symbol,Float64}()
    lower = hasproperty(block.params, :lower) ? block.params.lower : Dict{Symbol,Float64}()
    upper = hasproperty(block.params, :upper) ? block.params.upper : Dict{Symbol,Float64}()
    fixed = hasproperty(block.params, :fixed) ? block.params.fixed : Dict{Symbol,Float64}()

    for (name, value) in start
        var = ensure_var!(ctx, model, global_var(Symbol(name)))
        if model isa JuMP.Model
            JuMP.set_start_value(var, value)
        end
        register_eq!(ctx, block, :start, name; info="start $(name) = $(value)", constraint=nothing)
    end

    for (name, value) in lower
        var = ensure_var!(ctx, model, global_var(Symbol(name)))
        if model isa JuMP.Model
            JuMP.set_lower_bound(var, value)
        end
        register_eq!(ctx, block, :lower, name; info="lower $(name) = $(value)", constraint=nothing)
    end

    for (name, value) in upper
        var = ensure_var!(ctx, model, global_var(Symbol(name)))
        if model isa JuMP.Model
            JuMP.set_upper_bound(var, value)
        end
        register_eq!(ctx, block, :upper, name; info="upper $(name) = $(value)", constraint=nothing)
    end

    for (name, value) in fixed
        var = ensure_var!(ctx, model, global_var(Symbol(name)))
        if model isa JuMP.Model
            JuMP.fix(var, value; force=true)
        end
        register_eq!(ctx, block, :fixed, name; info="fixed $(name) = $(value)", constraint=nothing)
    end

    return nothing
end

function apply_start(spec::JCGECore.RunSpec, start::Dict{Symbol,<:Real};
    lower::Union{Nothing,Dict{Symbol,<:Real}}=nothing,
    upper::Union{Nothing,Dict{Symbol,<:Real}}=nothing,
    fixed::Union{Nothing,Dict{Symbol,<:Real}}=nothing)
    blocks = copy(spec.model.blocks)
    start_vals = Dict{Symbol,Float64}()
    for (name, value) in start
        start_vals[name] = Float64(value)
    end
    lower_vals = Dict{Symbol,Float64}()
    if lower !== nothing
        for (name, value) in lower
            lower_vals[name] = Float64(value)
        end
    end
    upper_vals = Dict{Symbol,Float64}()
    if upper !== nothing
        for (name, value) in upper
            upper_vals[name] = Float64(value)
        end
    end
    fixed_vals = Dict{Symbol,Float64}()
    if fixed !== nothing
        for (name, value) in fixed
            fixed_vals[name] = Float64(value)
        end
    end
    init_block = InitialValuesBlock(:init, (start = start_vals, lower = lower_vals, upper = upper_vals, fixed = fixed_vals))
    replaced = false
    for i in eachindex(blocks)
        if blocks[i] isa InitialValuesBlock
            blocks[i] = init_block
            replaced = true
            break
        end
    end
    if !replaced
        push!(blocks, init_block)
    end
    ms = JCGECore.ModelSpec(blocks, spec.model.sets, spec.model.mappings)
    return JCGECore.RunSpec(spec.name, ms, spec.closure, spec.scenario)
end

function rerun!(spec::JCGECore.RunSpec; from, optimizer=nothing,
    dataset_id::String="jcge", tol::Real=1e-6, description::Union{String,Nothing}=nothing)
    state = JCGEKernel.snapshot_state(from)
    spec2 = apply_start(spec, state.start; lower=state.lower, upper=state.upper, fixed=state.fixed)
    return JCGEKernel.run!(spec2; optimizer=optimizer, dataset_id=dataset_id, tol=tol, description=description)
end

end # module
