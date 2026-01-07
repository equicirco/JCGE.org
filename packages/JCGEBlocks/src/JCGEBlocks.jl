module JCGEBlocks

using JCGECore
using JCGEKernel
using JuMP
import MathOptInterface as MOI

export DummyBlock
export ProductionBlock
export ProductionCDBlock
export ProductionCDLeontiefBlock
export ProductionCDLeontiefSectorPFBlock
export ProductionMultilaborCDBlock
export FactorSupplyBlock
export HouseholdDemandBlock
export HouseholdDemandCDBlock
export HouseholdDemandCDXpBlock
export HouseholdDemandCDHHBlock
export HouseholdDemandCDXpRegionalBlock
export HouseholdDemandIncomeBlock
export MarketClearingBlock
export GoodsMarketClearingBlock
export FactorMarketClearingBlock
export CompositeMarketClearingBlock
export LaborMarketClearingBlock
export PriceLinkBlock
export ExchangeRateLinkBlock
export ExchangeRateLinkRegionBlock
export PriceEqualityBlock
export NumeraireBlock
export GovernmentBlock
export GovernmentRegionalBlock
export GovernmentBudgetBalanceBlock
export PrivateSavingBlock
export PrivateSavingRegionalBlock
export PrivateSavingIncomeBlock
export InvestmentBlock
export InvestmentRegionalBlock
export ArmingtonCESBlock
export TransformationCETBlock
export MonopolyRentBlock
export ImportQuotaBlock
export MobileFactorMarketBlock
export CapitalStockReturnBlock
export CompositeInvestmentBlock
export InvestmentAllocationBlock
export CompositeConsumptionBlock
export PriceLevelBlock
export ClosureBlock
export UtilityBlock
export UtilityCDBlock
export UtilityCDXpBlock
export UtilityCDHHBlock
export UtilityCDRegionalBlock
export ExternalBalanceBlock
export ExternalBalanceVarPriceBlock
export ForeignTradeBlock
export PriceAggregationBlock
export InternationalMarketBlock
export ActivityPriceIOBlock
export CapitalPriceCompositionBlock
export TradePriceLinkBlock
export AbsorptionSalesBlock
export ArmingtonMXxdBlock
export CETXXDEBlock
export ExportDemandBlock
export NontradedSupplyBlock
export HouseholdShareDemandBlock
export GovernmentShareDemandBlock
export InventoryDemandBlock
export GovernmentFinanceBlock
export GDPIncomeBlock
export SavingsInvestmentBlock
export FinalDemandClearingBlock
export ConsumptionObjectiveBlock
export InitialValuesBlock
export apply_start
export rerun!
export production
export production_sector_pf
export production_multilabor_cd

function mcp_enabled(params)
    return hasproperty(params, :mcp) && params.mcp === true
end

function mcp_constraint(model::JuMP.Model, expr, var)
    return @constraint(model, [expr, var] in MOI.Complements(1))
end
export factor_supply
export household_demand
export household_demand_regional
export household_demand_income
export market_clearing
export goods_market_clearing
export factor_market_clearing
export composite_market_clearing
export labor_market_clearing
export price_link
export exchange_rate_link
export exchange_rate_link_region
export price_equality
export numeraire
export government
export government_regional
export government_budget_balance
export private_saving
export private_saving_regional
export private_saving_income
export investment
export investment_regional
export armington
export transformation
export monopoly_rent
export import_quota
export mobile_factor_market
export capital_stock_return
export composite_investment
export investment_allocation
export composite_consumption
export price_level
export closure
export utility
export utility_regional
export external_balance
export external_balance_var_price
export foreign_trade
export price_aggregation
export international_market
export activity_price_io
export capital_price_composition
export trade_price_link
export absorption_sales
export armington_m_xxd
export cet_xxd_e
export export_demand
export nontraded_supply
export household_share_demand
export government_share_demand
export inventory_demand
export government_finance
export gdp_income
export savings_investment
export final_demand_clearing
export consumption_objective
export initial_values

"Minimal example block used to validate end-to-end wiring."
struct DummyBlock <: JCGECore.AbstractBlock
    name::Symbol
end

function JCGECore.build!(block::DummyBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    JCGEKernel.register_variable!(ctx, Symbol(block.name, :_x), 1.0)
    JCGEKernel.register_equation!(ctx; tag=:dummy_eq, block=block.name, payload="x==1 (placeholder)")
    return nothing
end

production(name::Symbol, activities::Vector{Symbol}, factors::Vector{Symbol}, commodities::Vector{Symbol};
    form::Union{Symbol,Dict{Symbol,Symbol}}=:cd, params::NamedTuple) =
    ProductionBlock(
        name,
        activities,
        factors,
        commodities,
        form isa Symbol ? Dict(a => form for a in activities) : form,
        params,
    )

production_sector_pf(name::Symbol, activities::Vector{Symbol}, factors::Vector{Symbol}, commodities::Vector{Symbol};
    params::NamedTuple) =
    ProductionCDLeontiefSectorPFBlock(name, activities, factors, commodities, params)

production_multilabor_cd(name::Symbol, activities::Vector{Symbol}, labor::Vector{Symbol}; params::NamedTuple) =
    ProductionMultilaborCDBlock(name, activities, labor, params)

factor_supply(name::Symbol, factors::Vector{Symbol}, params::NamedTuple) =
    FactorSupplyBlock(name, factors, params)

household_demand(name::Symbol, households::Vector{Symbol}, commodities::Vector{Symbol}, factors::Vector{Symbol};
    form::Symbol=:cd, consumption_var::Symbol=:Xp, params::NamedTuple) =
    HouseholdDemandBlock(name, households, commodities, factors, form, consumption_var, params)

household_demand_regional(name::Symbol, commodities::Vector{Symbol}, factors::Vector{Symbol}, region::Symbol;
    params::NamedTuple) =
    HouseholdDemandCDXpRegionalBlock(name, commodities, factors, region, params)

household_demand_income(name::Symbol, commodities::Vector{Symbol}, factors::Vector{Symbol}, activities::Vector{Symbol};
    params::NamedTuple) =
    HouseholdDemandIncomeBlock(name, commodities, factors, activities, params)

market_clearing(name::Symbol, commodities::Vector{Symbol}, factors::Vector{Symbol}) =
    MarketClearingBlock(name, commodities, factors)

goods_market_clearing(name::Symbol, commodities::Vector{Symbol}) =
    GoodsMarketClearingBlock(name, commodities)

factor_market_clearing(name::Symbol, activities::Vector{Symbol}, factors::Vector{Symbol}; params::NamedTuple=(;)) =
    FactorMarketClearingBlock(name, activities, factors, params)

composite_market_clearing(name::Symbol, commodities::Vector{Symbol}, activities::Vector{Symbol}) =
    CompositeMarketClearingBlock(name, commodities, activities)

labor_market_clearing(name::Symbol, labor::Vector{Symbol}, activities::Vector{Symbol}; params::NamedTuple) =
    LaborMarketClearingBlock(name, labor, activities, params)

price_link(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    PriceLinkBlock(name, commodities, params)

exchange_rate_link(name::Symbol, commodities::Vector{Symbol}) =
    ExchangeRateLinkBlock(name, commodities)

exchange_rate_link_region(name::Symbol, commodities::Vector{Symbol}, region::Symbol) =
    ExchangeRateLinkRegionBlock(name, commodities, region)

price_equality(name::Symbol, commodities::Vector{Symbol}) =
    PriceEqualityBlock(name, commodities)

numeraire(name::Symbol, kind::Symbol, label::Symbol, value::Real) =
    NumeraireBlock(name, kind, label, value)

government(name::Symbol, commodities::Vector{Symbol}, factors::Vector{Symbol}, params::NamedTuple) =
    GovernmentBlock(name, commodities, factors, params)

government_regional(name::Symbol, commodities::Vector{Symbol}, factors::Vector{Symbol}, region::Symbol, params::NamedTuple) =
    GovernmentRegionalBlock(name, commodities, factors, region, params)

government_budget_balance(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    GovernmentBudgetBalanceBlock(name, commodities, params)

private_saving(name::Symbol, factors::Vector{Symbol}, params::NamedTuple) =
    PrivateSavingBlock(name, factors, params)

private_saving_regional(name::Symbol, factors::Vector{Symbol}, region::Symbol, params::NamedTuple) =
    PrivateSavingRegionalBlock(name, factors, region, params)

private_saving_income(name::Symbol, factors::Vector{Symbol}, activities::Vector{Symbol}, params::NamedTuple) =
    PrivateSavingIncomeBlock(name, factors, activities, params)

investment(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    InvestmentBlock(name, commodities, params)

investment_regional(name::Symbol, commodities::Vector{Symbol}, region::Symbol, params::NamedTuple) =
    InvestmentRegionalBlock(name, commodities, region, params)

armington(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    ArmingtonCESBlock(name, commodities, params)

transformation(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    TransformationCETBlock(name, commodities, params)

monopoly_rent(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    MonopolyRentBlock(name, commodities, params)

import_quota(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    ImportQuotaBlock(name, commodities, params)

mobile_factor_market(name::Symbol, factors::Vector{Symbol}, activities::Vector{Symbol}) =
    MobileFactorMarketBlock(name, factors, activities)

capital_stock_return(name::Symbol, factor::Symbol, activities::Vector{Symbol}, params::NamedTuple) =
    CapitalStockReturnBlock(name, factor, activities, params)

composite_investment(name::Symbol, commodities::Vector{Symbol}, activities::Vector{Symbol}, params::NamedTuple) =
    CompositeInvestmentBlock(name, commodities, activities, params)

investment_allocation(name::Symbol, factor::Symbol, activities::Vector{Symbol}, params::NamedTuple) =
    InvestmentAllocationBlock(name, factor, activities, params)

composite_consumption(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    CompositeConsumptionBlock(name, commodities, params)

price_level(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    PriceLevelBlock(name, commodities, params)

closure(name::Symbol, params::NamedTuple) =
    ClosureBlock(name, params)

utility(name::Symbol, households::Vector{Symbol}, commodities::Vector{Symbol};
    form::Symbol=:cd, consumption_var::Symbol=:Xp, params::NamedTuple) =
    UtilityBlock(name, households, commodities, form, consumption_var, params)

utility_regional(name::Symbol, goods_by_region::Dict{Symbol,Vector{Symbol}}, params::NamedTuple) =
    UtilityCDRegionalBlock(name, goods_by_region, params)

external_balance(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    ExternalBalanceBlock(name, commodities, params)

external_balance_var_price(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    ExternalBalanceVarPriceBlock(name, commodities, params)

foreign_trade(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    ForeignTradeBlock(name, commodities, params)

price_aggregation(name::Symbol, commodities::Vector{Symbol}, activities::Vector{Symbol}, params::NamedTuple) =
    PriceAggregationBlock(name, commodities, activities, params)

international_market(name::Symbol, goods::Vector{Symbol}, regions::Vector{Symbol},
    mapping::Dict{Tuple{Symbol,Symbol},Symbol}) =
    InternationalMarketBlock(name, goods, regions, mapping)

activity_price_io(name::Symbol, activities::Vector{Symbol}, commodities::Vector{Symbol}, params::NamedTuple) =
    ActivityPriceIOBlock(name, activities, commodities, params)

capital_price_composition(name::Symbol, activities::Vector{Symbol}, commodities::Vector{Symbol}, params::NamedTuple) =
    CapitalPriceCompositionBlock(name, activities, commodities, params)

trade_price_link(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    TradePriceLinkBlock(name, commodities, params)

absorption_sales(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    AbsorptionSalesBlock(name, commodities, params)

armington_m_xxd(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    ArmingtonMXxdBlock(name, commodities, params)

cet_xxd_e(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    CETXXDEBlock(name, commodities, params)

export_demand(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    ExportDemandBlock(name, commodities, params)

nontraded_supply(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    NontradedSupplyBlock(name, commodities, params)

household_share_demand(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    HouseholdShareDemandBlock(name, commodities, params)

government_share_demand(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    GovernmentShareDemandBlock(name, commodities, params)

inventory_demand(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    InventoryDemandBlock(name, commodities, params)

government_finance(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    GovernmentFinanceBlock(name, commodities, params)

gdp_income(name::Symbol, activities::Vector{Symbol}, params::NamedTuple) =
    GDPIncomeBlock(name, activities, params)

savings_investment(name::Symbol, activities::Vector{Symbol}, commodities::Vector{Symbol}, params::NamedTuple) =
    SavingsInvestmentBlock(name, activities, commodities, params)

final_demand_clearing(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    FinalDemandClearingBlock(name, commodities, params)

consumption_objective(name::Symbol, commodities::Vector{Symbol}, params::NamedTuple) =
    ConsumptionObjectiveBlock(name, commodities, params)

initial_values(name::Symbol, params::NamedTuple) =
    InitialValuesBlock(name, params)

struct ProductionBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    commodities::Vector{Symbol}
    form::Union{Symbol,Dict{Symbol,Symbol}}
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

struct ProductionCDLeontiefSectorPFBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    factors::Vector{Symbol}
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ProductionMultilaborCDBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    labor::Vector{Symbol}
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

struct HouseholdDemandCDXpRegionalBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    region::Symbol
    params::NamedTuple
end

struct HouseholdDemandIncomeBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    activities::Vector{Symbol}
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

struct LaborMarketClearingBlock <: JCGECore.AbstractBlock
    name::Symbol
    labor::Vector{Symbol}
    activities::Vector{Symbol}
    params::NamedTuple
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

struct ExchangeRateLinkRegionBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    region::Symbol
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

struct GovernmentRegionalBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    factors::Vector{Symbol}
    region::Symbol
    params::NamedTuple
end

struct GovernmentBudgetBalanceBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct PrivateSavingBlock <: JCGECore.AbstractBlock
    name::Symbol
    factors::Vector{Symbol}
    params::NamedTuple
end

struct PrivateSavingRegionalBlock <: JCGECore.AbstractBlock
    name::Symbol
    factors::Vector{Symbol}
    region::Symbol
    params::NamedTuple
end

struct PrivateSavingIncomeBlock <: JCGECore.AbstractBlock
    name::Symbol
    factors::Vector{Symbol}
    activities::Vector{Symbol}
    params::NamedTuple
end

struct InvestmentBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct InvestmentRegionalBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    region::Symbol
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

struct MonopolyRentBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ImportQuotaBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct MobileFactorMarketBlock <: JCGECore.AbstractBlock
    name::Symbol
    factors::Vector{Symbol}
    activities::Vector{Symbol}
end

struct CapitalStockReturnBlock <: JCGECore.AbstractBlock
    name::Symbol
    factor::Symbol
    activities::Vector{Symbol}
    params::NamedTuple
end

struct CompositeInvestmentBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    activities::Vector{Symbol}
    params::NamedTuple
end

struct InvestmentAllocationBlock <: JCGECore.AbstractBlock
    name::Symbol
    factor::Symbol
    activities::Vector{Symbol}
    params::NamedTuple
end

struct CompositeConsumptionBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct PriceLevelBlock <: JCGECore.AbstractBlock
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

struct UtilityCDRegionalBlock <: JCGECore.AbstractBlock
    name::Symbol
    goods_by_region::Dict{Symbol,Vector{Symbol}}
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

struct InternationalMarketBlock <: JCGECore.AbstractBlock
    name::Symbol
    goods::Vector{Symbol}
    regions::Vector{Symbol}
    mapping::Dict{Tuple{Symbol,Symbol},Symbol}
end

struct ActivityPriceIOBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct CapitalPriceCompositionBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct TradePriceLinkBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct AbsorptionSalesBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ArmingtonMXxdBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct CETXXDEBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ExportDemandBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct NontradedSupplyBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct HouseholdShareDemandBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct GovernmentShareDemandBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct InventoryDemandBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct GovernmentFinanceBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct GDPIncomeBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    params::NamedTuple
end

struct SavingsInvestmentBlock <: JCGECore.AbstractBlock
    name::Symbol
    activities::Vector{Symbol}
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct FinalDemandClearingBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
    params::NamedTuple
end

struct ConsumptionObjectiveBlock <: JCGECore.AbstractBlock
    name::Symbol
    commodities::Vector{Symbol}
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

function register_eq!(ctx::JCGEKernel.KernelContext, block::HouseholdDemandCDXpRegionalBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::HouseholdDemandIncomeBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::HouseholdDemandIncomeBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
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

function register_eq!(ctx::JCGEKernel.KernelContext, block::ExchangeRateLinkRegionBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
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

function register_eq!(ctx::JCGEKernel.KernelContext, block::GovernmentRegionalBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::GovernmentBudgetBalanceBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::GovernmentBudgetBalanceBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PrivateSavingBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PrivateSavingRegionalBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::PrivateSavingIncomeBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PrivateSavingIncomeBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
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

function register_eq!(ctx::JCGEKernel.KernelContext, block::InvestmentRegionalBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
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

function var_name(block::MonopolyRentBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::MonopolyRentBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::ImportQuotaBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ImportQuotaBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::MobileFactorMarketBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::MobileFactorMarketBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::CapitalStockReturnBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::CapitalStockReturnBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::CompositeInvestmentBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::CompositeInvestmentBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::InvestmentAllocationBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::InvestmentAllocationBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::CompositeConsumptionBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::CompositeConsumptionBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
    JCGEKernel.register_equation!(ctx; tag=tag, block=block.name, payload=(indices=idxs, info=info, constraint=constraint))
    return nothing
end

function var_name(block::PriceLevelBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::PriceLevelBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
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

function register_eq!(ctx::JCGEKernel.KernelContext, block::UtilityCDRegionalBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
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

function register_eq!(ctx::JCGEKernel.KernelContext, block::InternationalMarketBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
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

function var_name(block::ProductionCDLeontiefSectorPFBlock, base::Symbol, idxs::Symbol...)
    return global_var(base, idxs...)
end

function register_eq!(ctx::JCGEKernel.KernelContext, block::ProductionCDLeontiefSectorPFBlock, tag::Symbol, idxs::Symbol...; info=nothing, constraint=nothing)
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

        fc_term = hasproperty(block.params, :FC) ? JCGECore.getparam(block.params, :FC, i) / Z[i] : 0.0
        constraint = model isa JuMP.Model ? @NLconstraint(
            model,
            pz[i] == ay_i * py[i] + sum(ax_vals[j] * pq[j] for j in commodities) + fc_term
        ) : nothing
        register_eq!(ctx, block, :eqpzs, i; info="pz[i] == ay[i]*py[i] + sum(ax[j,i]*pq[j]) + FC[i]/Z[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::ProductionCDLeontiefSectorPFBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities

    model = ctx.model
    Y = Dict{Symbol,Any}()
    Z = Dict{Symbol,Any}()
    py = Dict{Symbol,Any}()
    pz = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Tuple{Symbol,Symbol},Any}()
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

    for h in factors, i in activities
        pf[(h, i)] = ensure_var!(ctx, model, var_name(block, :pf, h, i))
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
            constraint = model isa JuMP.Model ? @NLconstraint(model, F[(h, i)] == beta_vals[h] * py[i] * Y[i] / pf[(h, i)]) : nothing
            register_eq!(ctx, block, :eqF, h, i; info="F[h,i] == beta[h,i] * py[i] * Y[i] / pf[h,i]", constraint=constraint)
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
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    form_map = block.form isa Symbol ? Dict(a => block.form for a in activities) : block.form
    if !(form_map isa Dict{Symbol,Symbol})
        error("ProductionBlock.form must be Symbol or Dict{Symbol,Symbol}")
    end
    for a in activities
        haskey(form_map, a) || error("Missing production form for activity $(a)")
        form = form_map[a]
        if form == :cd
            inner = ProductionCDBlock(block.name, [a], block.factors, block.params)
            JCGECore.build!(inner, ctx, spec)
        elseif form == :cd_leontief
            inner = ProductionCDLeontiefBlock(block.name, [a], block.factors, block.commodities, block.params)
            JCGECore.build!(inner, ctx, spec)
        else
            error("Unsupported production form: $(form)")
        end
    end
    return nothing
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
    RT = Dict{Symbol,Any}()
    include_rent = hasproperty(block.params, :include_rent) && getproperty(block.params, :include_rent)
    include_fc = hasproperty(block.params, :include_fc) && getproperty(block.params, :include_fc)
    include_fc = hasproperty(block.params, :include_fc) && getproperty(block.params, :include_fc)

    for i in commodities
        Xp[i] = ensure_var!(ctx, model, global_var(:Xp, i))
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
        if include_rent
            RT[i] = ensure_var!(ctx, model, global_var(:RT, i))
        end
    end
    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
    end

    ff_vals = Dict(h => JCGECore.getparam(block.params, :FF, h) for h in factors)
    for i in commodities
        alpha_i = JCGECore.getparam(block.params, :alpha, i)
        rent_term = include_rent ? sum(RT[j] for j in commodities) : 0.0
        fc_term = include_fc ? sum(JCGECore.getparam(block.params, :FC, j) for j in commodities) : 0.0
        constraint = model isa JuMP.Model ? @NLconstraint(
            model,
            Xp[i] == alpha_i * (sum(pf[h] * ff_vals[h] for h in factors) - Sp - Td + rent_term + fc_term) / pq[i]
        ) : nothing
        register_eq!(ctx, block, :eqXp, i; info="Xp[i] == alpha[i] * (sum(pf[h]*FF[h]) - Sp - Td + sum(RT) + sum(FC)) / pq[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::HouseholdDemandCDXpRegionalBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Xp = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    Sp = ensure_var!(ctx, model, global_var(:Sp, block.region))
    Td = ensure_var!(ctx, model, global_var(:Td, block.region))

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

function JCGECore.build!(block::HouseholdDemandIncomeBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model

    Xp = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Tuple{Symbol,Symbol},Any}()
    F = Dict{Tuple{Symbol,Symbol},Any}()
    Sp = ensure_var!(ctx, model, global_var(:Sp))
    Td = ensure_var!(ctx, model, global_var(:Td))

    for i in commodities
        Xp[i] = ensure_var!(ctx, model, global_var(:Xp, i))
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
    end
    for h in factors, j in activities
        pf[(h, j)] = ensure_var!(ctx, model, global_var(:pf, h, j))
        F[(h, j)] = ensure_var!(ctx, model, global_var(:F, h, j))
    end

    income = sum(pf[(h, j)] * F[(h, j)] for h in factors for j in activities)
    for i in commodities
        alpha_i = JCGECore.getparam(block.params, :alpha, i)
        constraint = model isa JuMP.Model ? @NLconstraint(
            model,
            Xp[i] == alpha_i * (income - Sp - Td) / pq[i]
        ) : nothing
        register_eq!(ctx, block, :eqXp, i; info="Xp[i] == alpha[i] * (income - Sp - Td) / pq[i]", constraint=constraint)
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

function JCGECore.build!(block::ExchangeRateLinkRegionBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    epsilon = ensure_var!(ctx, model, global_var(:epsilon, block.region))
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
        register_eq!(ctx, block, :eqpe, i, block.region; info="pe[i] == epsilon[r] * pWe[i]", constraint=constraint)
        constraint = model isa JuMP.Model ? @constraint(model, pm[i] == epsilon * pWm[i]) : nothing
        register_eq!(ctx, block, :eqpm, i, block.region; info="pm[i] == epsilon[r] * pWm[i]", constraint=constraint)
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
    include_rent = hasproperty(block.params, :include_rent) && getproperty(block.params, :include_rent)
    include_fc = hasproperty(block.params, :include_fc) && getproperty(block.params, :include_fc)
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
    RT = Dict{Symbol,Any}()

    for i in commodities
        Tz[i] = ensure_var!(ctx, model, global_var(:Tz, i))
        Tm[i] = ensure_var!(ctx, model, global_var(:Tm, i))
        Xg[i] = ensure_var!(ctx, model, global_var(:Xg, i))
        pz[i] = ensure_var!(ctx, model, global_var(:pz, i))
        pm[i] = ensure_var!(ctx, model, global_var(:pm, i))
        Z[i] = ensure_var!(ctx, model, global_var(:Z, i))
        M[i] = ensure_var!(ctx, model, global_var(:M, i))
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
        if include_rent
            RT[i] = ensure_var!(ctx, model, global_var(:RT, i))
        end
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
    rent_term = include_rent ? sum(RT[i] for i in commodities) : 0.0
    fc_term = include_fc ? sum(JCGECore.getparam(block.params, :FC, i) for i in commodities) : 0.0
    constraint = model isa JuMP.Model ? @constraint(
        model,
        Td == tau_d * (sum(pf[h] * ff_vals[h] for h in factors) + rent_term + fc_term)
    ) : nothing
    register_eq!(ctx, block, :eqTd; info="Td == tau_d * (sum(pf[h] * FF[h]) + sum(RT) + sum(FC))", constraint=constraint)

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

function JCGECore.build!(block::GovernmentRegionalBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Td = ensure_var!(ctx, model, global_var(:Td, block.region))
    Sg = ensure_var!(ctx, model, global_var(:Sg, block.region))
    Tz = Dict{Symbol,Any}()
    Tm = Dict{Symbol,Any}()
    Xg = Dict{Symbol,Any}()
    pz = Dict{Symbol,Any}()
    pm = Dict{Symbol,Any}()
    Z = Dict{Symbol,Any}()
    M = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    pf = Dict{Symbol,Any}()
    ff_vals = Dict{Symbol,Any}()

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

    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
        ff_vals[h] = JCGECore.getparam(block.params, :FF, h)
    end

    tau_d = JCGECore.getparam(block.params, :tau_d)
    constraint = model isa JuMP.Model ? @constraint(model, Td == tau_d * sum(pf[h] * ff_vals[h] for h in factors)) : nothing
    register_eq!(ctx, block, :eqTd, block.region; info="Td[r] == tau_d[r] * sum(pf[h,r] * FF[h,r])", constraint=constraint)

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
    register_eq!(ctx, block, :eqSg, block.region; info="Sg[r] == ssg[r] * (Td + sum(Tz) + sum(Tm))", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::GovernmentBudgetBalanceBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    Td = ensure_var!(ctx, model, global_var(:Td))
    Tz = Dict{Symbol,Any}()
    Tm = Dict{Symbol,Any}()
    Xg = Dict{Symbol,Any}()
    pz = Dict{Symbol,Any}()
    pm = Dict{Symbol,Any}()
    Z = Dict{Symbol,Any}()
    M = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()

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

    for i in commodities
        tau_z_i = JCGECore.getparam(block.params, :tauz, i)
        tau_m_i = JCGECore.getparam(block.params, :taum, i)
        constraint = model isa JuMP.Model ? @constraint(model, Tz[i] == tau_z_i * pz[i] * Z[i]) : nothing
        register_eq!(ctx, block, :eqTz, i; info="Tz[i] == tauz[i] * pz[i] * Z[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, Tm[i] == tau_m_i * pm[i] * M[i]) : nothing
        register_eq!(ctx, block, :eqTm, i; info="Tm[i] == taum[i] * pm[i] * M[i]", constraint=constraint)
    end

    constraint = model isa JuMP.Model ? @constraint(
        model,
        Td == sum(pq[i] * Xg[i] for i in commodities) - sum(Tz[i] + Tm[i] for i in commodities)
    ) : nothing
    register_eq!(ctx, block, :eqTd; info="Td == sum(pq[i]*Xg[i]) - sum(Tz[i] + Tm[i])", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::PrivateSavingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Sp = ensure_var!(ctx, model, global_var(:Sp))
    pf = Dict{Symbol,Any}()
    RT = Dict{Symbol,Any}()
    include_rent = hasproperty(block.params, :include_rent) && getproperty(block.params, :include_rent)
    include_fc = hasproperty(block.params, :include_fc) && getproperty(block.params, :include_fc)
    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
    end

    ssp = JCGECore.getparam(block.params, :ssp)
    ff_vals = Dict(h => JCGECore.getparam(block.params, :FF, h) for h in factors)
    if include_rent
        for i in spec.model.sets.commodities
            RT[i] = ensure_var!(ctx, model, global_var(:RT, i))
        end
    end
    rent_term = include_rent ? sum(RT[i] for i in spec.model.sets.commodities) : 0.0
    fc_term = include_fc ? sum(JCGECore.getparam(block.params, :FC, i) for i in spec.model.sets.commodities) : 0.0
    constraint = model isa JuMP.Model ? @constraint(
        model,
        Sp == ssp * (sum(pf[h] * ff_vals[h] for h in factors) + rent_term + fc_term)
    ) : nothing
    register_eq!(ctx, block, :eqSp; info="Sp == ssp * (sum(pf[h] * FF[h]) + sum(RT) + sum(FC))", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::PrivateSavingRegionalBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    model = ctx.model

    Sp = ensure_var!(ctx, model, global_var(:Sp, block.region))
    pf = Dict{Symbol,Any}()
    for h in factors
        pf[h] = ensure_var!(ctx, model, global_var(:pf, h))
    end

    ssp = JCGECore.getparam(block.params, :ssp)
    ff_vals = Dict(h => JCGECore.getparam(block.params, :FF, h) for h in factors)
    constraint = model isa JuMP.Model ? @constraint(model, Sp == ssp * sum(pf[h] * ff_vals[h] for h in factors)) : nothing
    register_eq!(ctx, block, :eqSp, block.region; info="Sp[r] == ssp[r] * sum(pf[h,r] * FF[h,r])", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::PrivateSavingIncomeBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model

    Sp = ensure_var!(ctx, model, global_var(:Sp))
    Td = ensure_var!(ctx, model, global_var(:Td))
    pf = Dict{Tuple{Symbol,Symbol},Any}()
    F = Dict{Tuple{Symbol,Symbol},Any}()

    for h in factors, j in activities
        pf[(h, j)] = ensure_var!(ctx, model, global_var(:pf, h, j))
        F[(h, j)] = ensure_var!(ctx, model, global_var(:F, h, j))
    end

    ssp = JCGECore.getparam(block.params, :ssp)
    income = sum(pf[(h, j)] * F[(h, j)] for h in factors for j in activities)
    constraint = model isa JuMP.Model ? @constraint(model, Sp == ssp * (income - Td)) : nothing
    register_eq!(ctx, block, :eqSp; info="Sp == ssp * (sum(pf[h,j]*F[h,j]) - Td)", constraint=constraint)

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

function JCGECore.build!(block::InvestmentRegionalBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    Sp = ensure_var!(ctx, model, global_var(:Sp, block.region))
    Sg = ensure_var!(ctx, model, global_var(:Sg, block.region))
    Xv = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    epsilon = ensure_var!(ctx, model, global_var(:epsilon, block.region))

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
        pd_scale_i = hasproperty(block.params, :pd_scale) ? JCGECore.getparam(block.params, :pd_scale, i) : 1.0
        include_chi = hasproperty(block.params, :include_chi) && getproperty(block.params, :include_chi)
        chi_i = include_chi ? ensure_var!(ctx, model, global_var(:chi, i)) : 0.0

        constraint = model isa JuMP.Model ? @NLconstraint(model, Q[i] == gamma_i *
            (delta_m_i * M[i] ^ eta_i + delta_d_i * D[i] ^ eta_i) ^ (1 / eta_i)) : nothing
        register_eq!(ctx, block, :eqQ, i; info="Q[i] == gamma[i]*(delta_m*M^eta + delta_d*D^eta)^(1/eta)", constraint=constraint)

        constraint = model isa JuMP.Model ? @NLconstraint(model, M[i] ==
            (gamma_i ^ eta_i * delta_m_i * pq[i] / ((1 + chi_i + tau_m_i) * pm[i])) ^ (1 / (1 - eta_i)) * Q[i]) : nothing
        register_eq!(ctx, block, :eqM, i; info="M[i] == (...) * Q[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @NLconstraint(model, D[i] ==
            (gamma_i ^ eta_i * delta_d_i * pq[i] / (pd_scale_i * pd[i])) ^ (1 / (1 - eta_i)) * Q[i]) : nothing
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

function JCGECore.build!(block::MonopolyRentBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    RT = Dict{Symbol,Any}()
    pd = Dict{Symbol,Any}()
    D = Dict{Symbol,Any}()

    for i in commodities
        RT[i] = ensure_var!(ctx, model, global_var(:RT, i))
        pd[i] = ensure_var!(ctx, model, global_var(:pd, i))
        D[i] = ensure_var!(ctx, model, global_var(:D, i))
    end

    for i in commodities
        eta_i = JCGECore.getparam(block.params, :eta, i)
        constraint = model isa JuMP.Model ? @NLconstraint(model, RT[i] == ((1 - eta_i) / eta_i) * pd[i] * D[i]) : nothing
        register_eq!(ctx, block, :eqRT, i; info="RT[i] == (1-eta[i])/eta[i] * pd[i] * D[i]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::ImportQuotaBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    chi = Dict{Symbol,Any}()
    RT = Dict{Symbol,Any}()
    pm = Dict{Symbol,Any}()
    M = Dict{Symbol,Any}()

    for i in commodities
        chi[i] = ensure_var!(ctx, model, global_var(:chi, i))
        RT[i] = ensure_var!(ctx, model, global_var(:RT, i))
        pm[i] = ensure_var!(ctx, model, global_var(:pm, i))
        M[i] = ensure_var!(ctx, model, global_var(:M, i))
    end

    for i in commodities
        Mquota_i = JCGECore.getparam(block.params, :Mquota, i)
        constraint = model isa JuMP.Model ? @NLconstraint(model, RT[i] == chi[i] * pm[i] * M[i]) : nothing
        register_eq!(ctx, block, :eqRT, i; info="RT[i] == chi[i] * pm[i] * M[i]", constraint=constraint)

        constraint = model isa JuMP.Model ? @NLconstraint(model, chi[i] * (Mquota_i - M[i]) == 0) : nothing
        register_eq!(ctx, block, :eqchi1, i; info="chi[i] * (Mquota[i] - M[i]) == 0", constraint=constraint)

        constraint = model isa JuMP.Model ? @constraint(model, Mquota_i - M[i] >= 0) : nothing
        register_eq!(ctx, block, :eqchi2, i; info="Mquota[i] - M[i] >= 0", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::MobileFactorMarketBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    factors = isempty(block.factors) ? spec.model.sets.factors : block.factors
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model

    F = Dict{Tuple{Symbol,Symbol},Any}()
    pf = Dict{Tuple{Symbol,Symbol},Any}()
    FF = Dict{Symbol,Any}()

    for h in factors
        FF[h] = ensure_var!(ctx, model, global_var(:FF, h))
        for j in activities
            F[(h, j)] = ensure_var!(ctx, model, global_var(:F, h, j))
            pf[(h, j)] = ensure_var!(ctx, model, global_var(:pf, h, j))
        end
    end

    for h in factors
        constraint = model isa JuMP.Model ? @constraint(model, sum(F[(h, j)] for j in activities) == FF[h]) : nothing
        register_eq!(ctx, block, :eqpf1, h; info="sum(F[h,j]) == FF[h]", constraint=constraint)

        if length(activities) > 1
            ref = activities[1]
            for j in activities[2:end]
                constraint = model isa JuMP.Model ? @constraint(model, pf[(h, j)] == pf[(h, ref)]) : nothing
                register_eq!(ctx, block, :eqpf2, h, j; info="pf[h,j] == pf[h,ref]", constraint=constraint)
            end
        end
    end

    return nothing
end

function JCGECore.build!(block::CapitalStockReturnBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model

    F = Dict{Tuple{Symbol,Symbol},Any}()
    KK = Dict{Symbol,Any}()
    for j in activities
        F[(block.factor, j)] = ensure_var!(ctx, model, global_var(:F, block.factor, j))
        KK[j] = ensure_var!(ctx, model, global_var(:KK, j))
    end

    ror = JCGECore.getparam(block.params, :ror)
    for j in activities
        constraint = model isa JuMP.Model ? @constraint(model, F[(block.factor, j)] == ror * KK[j]) : nothing
        register_eq!(ctx, block, :eqpf3, j; info="F[factor,j] == ror * KK[j]", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::CompositeInvestmentBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model

    Xv = Dict{Symbol,Any}()
    pq = Dict{Symbol,Any}()
    II = Dict{Symbol,Any}()
    pk = ensure_var!(ctx, model, global_var(:pk))
    III = ensure_var!(ctx, model, global_var(:III))

    for i in commodities
        Xv[i] = ensure_var!(ctx, model, global_var(:Xv, i))
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
    end
    for j in activities
        II[j] = ensure_var!(ctx, model, global_var(:II, j))
    end

    sum_ii = sum(II[j] for j in activities)
    for i in commodities
        lambda_i = JCGECore.getparam(block.params, :lambda, i)
        constraint = model isa JuMP.Model ? @NLconstraint(model, Xv[i] == lambda_i * pk * sum_ii / pq[i]) : nothing
        register_eq!(ctx, block, :eqXv, i; info="Xv[i] == lambda[i] * pk * sum(II) / pq[i]", constraint=constraint)
    end

    iota = JCGECore.getparam(block.params, :iota)
    if model isa JuMP.Model
        lambda_vals = Dict(i => JCGECore.getparam(block.params, :lambda, i) for i in commodities)
        constraint = @NLconstraint(model, III == iota * prod(Xv[i] ^ lambda_vals[i] for i in commodities))
        register_eq!(ctx, block, :eqIII; info="III == iota * prod(Xv[i]^lambda[i])", constraint=constraint)
    else
        register_eq!(ctx, block, :eqIII; info="III == iota * prod(Xv[i]^lambda[i])", constraint=nothing)
    end

    constraint = model isa JuMP.Model ? @constraint(model, sum_ii == III) : nothing
    register_eq!(ctx, block, :eqpk; info="sum(II) == III", constraint=constraint)

    return nothing
end

function JCGECore.build!(block::InvestmentAllocationBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model

    pf = Dict{Tuple{Symbol,Symbol},Any}()
    F = Dict{Tuple{Symbol,Symbol},Any}()
    II = Dict{Symbol,Any}()
    pk = ensure_var!(ctx, model, global_var(:pk))
    Sp = ensure_var!(ctx, model, global_var(:Sp))
    Sf = ensure_var!(ctx, model, global_var(:Sf))
    epsilon = ensure_var!(ctx, model, global_var(:epsilon))

    for j in activities
        pf[(block.factor, j)] = ensure_var!(ctx, model, global_var(:pf, block.factor, j))
        F[(block.factor, j)] = ensure_var!(ctx, model, global_var(:F, block.factor, j))
        II[j] = ensure_var!(ctx, model, global_var(:II, j))
    end

    zeta = JCGECore.getparam(block.params, :zeta)
    denom = sum(pf[(block.factor, j)] ^ zeta * F[(block.factor, j)] for j in activities)
    for j in activities
        constraint = model isa JuMP.Model ? @NLconstraint(
            model,
            pk * II[j] == pf[(block.factor, j)] ^ zeta * F[(block.factor, j)] / denom * (Sp + epsilon * Sf)
        ) : nothing
        register_eq!(ctx, block, :eqII, j; info="pk*II[j] == pf^zeta*F/denom*(Sp+epsilon*Sf)", constraint=constraint)
    end

    return nothing
end

function JCGECore.build!(block::CompositeConsumptionBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    CC = ensure_var!(ctx, model, global_var(:CC))
    Xp = Dict{Symbol,Any}()
    for i in commodities
        Xp[i] = ensure_var!(ctx, model, global_var(:Xp, i))
    end

    if model isa JuMP.Model
        alpha_vals = Dict(i => JCGECore.getparam(block.params, :alpha, i) for i in commodities)
        scale = JCGECore.getparam(block.params, :a)
        @NLconstraint(model, CC == scale * prod(Xp[i] ^ alpha_vals[i] for i in commodities))
        @NLobjective(model, Max, CC)
    end
    register_eq!(ctx, block, :eqCC; info="CC == a * prod(Xp[i]^alpha[i])", constraint=nothing)
    register_eq!(ctx, block, :objective; info="maximize CC", constraint=nothing)
    return nothing
end

function JCGECore.build!(block::PriceLevelBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model

    PRICE = ensure_var!(ctx, model, global_var(:PRICE))
    pq = Dict{Symbol,Any}()
    for i in commodities
        pq[i] = ensure_var!(ctx, model, global_var(:pq, i))
    end

    weights = Dict(i => JCGECore.getparam(block.params, :w, i) for i in commodities)
    constraint = model isa JuMP.Model ? @constraint(model, PRICE == sum(pq[i] * weights[i] for i in commodities)) : nothing
    register_eq!(ctx, block, :eqPRICE; info="PRICE == sum(pq[i]*w[i])", constraint=constraint)
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

function JCGECore.build!(block::UtilityCDRegionalBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    model = ctx.model
    goods_by_region = block.goods_by_region
    regions = collect(keys(goods_by_region))
    UU = Dict{Symbol,Any}()

    for r in regions
        UU[r] = ensure_var!(ctx, model, global_var(:UU, r))
        goods = goods_by_region[r]
        Xp = Dict{Symbol,Any}()
        for i in goods
            Xp[i] = ensure_var!(ctx, model, global_var(:Xp, i))
        end
        if model isa JuMP.Model
            alpha_vals = Dict(i => JCGECore.getparam(block.params, :alpha, i) for i in goods)
            @NLconstraint(model, UU[r] == prod(Xp[i] ^ alpha_vals[i] for i in goods))
        end
        register_eq!(ctx, block, :eqUU, r; info="UU[r] == prod(Xp[i]^alpha[i])", constraint=nothing)
    end

    if model isa JuMP.Model
        @NLobjective(model, Max, sum(UU[r] for r in regions))
    end
    register_eq!(ctx, block, :objective; info="maximize social welfare", constraint=nothing)
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
    mcp = mcp_enabled(block.params)

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
    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @expression(
                model,
                sum(pWe[i] * E[i] for i in commodities) + Sf - sum(pWm[i] * M[i] for i in commodities)
            )
            constraint = mcp_constraint(model, expr, ensure_var!(ctx, model, global_var(:er)))
        else
            constraint = @constraint(model,
                sum(pWe[i] * E[i] for i in commodities) + Sf ==
                sum(pWm[i] * M[i] for i in commodities)
            )
        end
    end
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

function JCGECore.build!(block::InternationalMarketBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    model = ctx.model
    goods = block.goods
    regions = block.regions
    mapping = block.mapping

    for i in goods
        for r in regions, rr in regions
            r == rr && continue
            key_r = (i, r)
            key_rr = (i, rr)
            haskey(mapping, key_r) || error("Missing mapping for $(key_r)")
            haskey(mapping, key_rr) || error("Missing mapping for $(key_rr)")
            sym_r = mapping[key_r]
            sym_rr = mapping[key_rr]
            pWe = ensure_var!(ctx, model, global_var(:pWe, sym_r))
            pWm = ensure_var!(ctx, model, global_var(:pWm, sym_rr))
            E = ensure_var!(ctx, model, global_var(:E, sym_r))
            M = ensure_var!(ctx, model, global_var(:M, sym_rr))
            constraint = model isa JuMP.Model ? @constraint(model, pWe == pWm) : nothing
            register_eq!(ctx, block, :eqpw, i, r, rr; info="pWe[i,r] == pWm[i,rr]", constraint=constraint)
            constraint = model isa JuMP.Model ? @constraint(model, E == M) : nothing
            register_eq!(ctx, block, :eqw, i, r, rr; info="E[i,r] == M[i,rr]", constraint=constraint)
        end
    end

    return nothing
end

function JCGECore.build!(block::ProductionMultilaborCDBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    labor = isempty(block.labor) ? spec.model.sets.factors : block.labor
    model = ctx.model
    mcp = mcp_enabled(block.params)

    xd = Dict{Symbol,Any}()
    pva = Dict{Symbol,Any}()
    k = Dict{Symbol,Any}()
    l = Dict{Tuple{Symbol,Symbol},Any}()
    wa = Dict{Symbol,Any}()

    for i in activities
        xd[i] = ensure_var!(ctx, model, global_var(:xd, i))
        pva[i] = ensure_var!(ctx, model, global_var(:pva, i))
        k[i] = ensure_var!(ctx, model, global_var(:k, i))
    end

    for lc in labor
        wa[lc] = ensure_var!(ctx, model, global_var(:wa, lc))
    end

    for i in activities, lc in labor
        l[(i, lc)] = ensure_var!(ctx, model, global_var(:l, i, lc))
    end

    for i in activities
        ad_i = JCGECore.getparam(block.params, :ad, i)
        wdist_vals = Dict(lc => JCGECore.getparam(block.params, :wdist, i, lc) for lc in labor)
        alphl_vals = Dict(lc => JCGECore.getparam(block.params, :alphl, lc, i) for lc in labor)
        active_labor = [lc for lc in labor if wdist_vals[lc] > 0.0]
        labor_share = sum(alphl_vals[lc] for lc in labor)

        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(
                    model,
                    xd[i] - ad_i * prod(l[(i, lc)] ^ alphl_vals[lc] for lc in active_labor) *
                              k[i] ^ (1.0 - labor_share)
                )
                constraint = mcp_constraint(model, expr, pva[i])
            else
                constraint = @NLconstraint(
                    model,
                    xd[i] == ad_i * prod(l[(i, lc)] ^ alphl_vals[lc] for lc in active_labor) *
                             k[i] ^ (1.0 - labor_share)
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:activity, block=block.name,
            payload=(indices=(i,), info="xd[i] = ad[i]*prod(l^alphl)*k^(1-sum(alphl))", constraint=constraint))

        for lc in active_labor
            wdist_i = wdist_vals[lc]
            alpha_i = alphl_vals[lc]
            constraint = nothing
            if model isa JuMP.Model
                if mcp
                    expr = @NLexpression(model, wa[lc] * wdist_i * l[(i, lc)] - xd[i] * pva[i] * alpha_i)
                    constraint = mcp_constraint(model, expr, l[(i, lc)])
                else
                    constraint = @NLconstraint(
                        model,
                        wa[lc] * wdist_i * l[(i, lc)] == xd[i] * pva[i] * alpha_i
                    )
                end
            end
            JCGEKernel.register_equation!(ctx; tag=:profitmax, block=block.name,
                payload=(indices=(i, lc), info="wa*wdist*l = xd*pva*alphl", constraint=constraint))
        end
    end

    return nothing
end

function JCGECore.build!(block::LaborMarketClearingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    labor = isempty(block.labor) ? spec.model.sets.factors : block.labor
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    for lc in labor
        ls = ensure_var!(ctx, model, global_var(:ls, lc))
        l = Dict(i => ensure_var!(ctx, model, global_var(:l, i, lc)) for i in activities)
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @expression(model, ls - sum(l[i] for i in activities))
                constraint = mcp_constraint(model, expr, wa[lc])
            else
                constraint = @constraint(model, sum(l[i] for i in activities) == ls)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:lmequil, block=block.name,
            payload=(indices=(lc,), info="sum_i l[i,lc] = ls[lc]", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::ActivityPriceIOBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    for i in activities
        px = ensure_var!(ctx, model, global_var(:px, i))
        pva = ensure_var!(ctx, model, global_var(:pva, i))
        xd = ensure_var!(ctx, model, global_var(:xd, i))
        int = ensure_var!(ctx, model, global_var(:int, i))
        p = Dict(j => ensure_var!(ctx, model, global_var(:p, j)) for j in commodities)
        itax_i = JCGECore.getparam(block.params, :itax, i)
        io_vals = Dict(j => JCGECore.getparam(block.params, :io, j, i) for j in commodities)

        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @expression(model, px * (1.0 - itax_i) - pva - sum(io_vals[j] * p[j] for j in commodities))
                constraint = mcp_constraint(model, expr, xd)
            else
                constraint = @constraint(
                    model,
                    px * (1.0 - itax_i) == pva + sum(io_vals[j] * p[j] for j in commodities)
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:actp, block=block.name,
            payload=(indices=(i,), info="px*(1-itax) = pva + sum(io*p)", constraint=constraint))

        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @expression(
                    model,
                    int - sum(JCGECore.getparam(block.params, :io, i, j) * ensure_var!(ctx, model, global_var(:xd, j)) for j in activities)
                )
                constraint = mcp_constraint(model, expr, int)
            else
                constraint = @constraint(
                    model,
                    int == sum(JCGECore.getparam(block.params, :io, i, j) * ensure_var!(ctx, model, global_var(:xd, j)) for j in activities)
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:inteq, block=block.name,
            payload=(indices=(i,), info="int[i] = sum(io[i,j]*xd[j])", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::CapitalPriceCompositionBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    for i in activities
        pk = ensure_var!(ctx, model, global_var(:pk, i))
        p = Dict(j => ensure_var!(ctx, model, global_var(:p, j)) for j in commodities)
        imat_vals = Dict(j => JCGECore.getparam(block.params, :imat, j, i) for j in commodities)
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @expression(model, pk - sum(p[j] * imat_vals[j] for j in commodities))
                constraint = mcp_constraint(model, expr, pk)
            else
                constraint = @constraint(
                    model,
                    pk == sum(p[j] * imat_vals[j] for j in commodities)
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:pkdef, block=block.name,
            payload=(indices=(i,), info="pk[i] = sum(p[j]*imat[j,i])", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::TradePriceLinkBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    traded = hasproperty(block.params, :traded) ? block.params.traded : commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)
    er = ensure_var!(ctx, model, global_var(:er))

    for i in traded
        pm = ensure_var!(ctx, model, global_var(:pm, i))
        pwm = ensure_var!(ctx, model, global_var(:pwm, i))
        tm = ensure_var!(ctx, model, global_var(:tm, i))
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(model, pm - pwm * er * (1.0 + tm))
                constraint = mcp_constraint(model, expr, pm)
            else
                constraint = @NLconstraint(model, pm == pwm * er * (1.0 + tm))
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:pmdef, block=block.name,
            payload=(indices=(i,), info="pm = pwm*er*(1+tm)", constraint=constraint))

        pe = ensure_var!(ctx, model, global_var(:pe, i))
        pwe = ensure_var!(ctx, model, global_var(:pwe, i))
        te_i = JCGECore.getparam(block.params, :te, i)
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(model, pe * (1.0 + te_i) - pwe * er)
                constraint = mcp_constraint(model, expr, pe)
            else
                constraint = @NLconstraint(model, pe * (1.0 + te_i) == pwe * er)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:pedef, block=block.name,
            payload=(indices=(i,), info="pe*(1+te) = pwe*er", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::AbsorptionSalesBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    traded = hasproperty(block.params, :traded) ? block.params.traded : commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    for i in commodities
        p = ensure_var!(ctx, model, global_var(:p, i))
        x = ensure_var!(ctx, model, global_var(:x, i))
        pd = ensure_var!(ctx, model, global_var(:pd, i))
        xxd = ensure_var!(ctx, model, global_var(:xxd, i))
        pm = ensure_var!(ctx, model, global_var(:pm, i))
        m = ensure_var!(ctx, model, global_var(:m, i))
        term_m = i in traded ? pm * m : 0.0
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(model, p * x - pd * xxd - term_m)
                constraint = mcp_constraint(model, expr, x)
            else
                constraint = @NLconstraint(model, p * x == pd * xxd + term_m)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:absorption, block=block.name,
            payload=(indices=(i,), info="p*x = pd*xxd + pm*m", constraint=constraint))

        px = ensure_var!(ctx, model, global_var(:px, i))
        xd = ensure_var!(ctx, model, global_var(:xd, i))
        pe = ensure_var!(ctx, model, global_var(:pe, i))
        e = ensure_var!(ctx, model, global_var(:e, i))
        term_e = i in traded ? pe * e : 0.0
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(model, px * xd - pd * xxd - term_e)
                constraint = mcp_constraint(model, expr, xxd)
            else
                constraint = @NLconstraint(model, px * xd == pd * xxd + term_e)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:sales, block=block.name,
            payload=(indices=(i,), info="px*xd = pd*xxd + pe*e", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::ArmingtonMXxdBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    traded = hasproperty(block.params, :traded) ? block.params.traded : commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    for i in traded
        x = ensure_var!(ctx, model, global_var(:x, i))
        m = ensure_var!(ctx, model, global_var(:m, i))
        xxd = ensure_var!(ctx, model, global_var(:xxd, i))
        pd = ensure_var!(ctx, model, global_var(:pd, i))
        pm = ensure_var!(ctx, model, global_var(:pm, i))
        ac_i = JCGECore.getparam(block.params, :ac, i)
        delta_i = JCGECore.getparam(block.params, :delta, i)
        rhoc_i = JCGECore.getparam(block.params, :rhoc, i)

        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(
                    model,
                    x - ac_i * (delta_i * m ^ (-rhoc_i) + (1.0 - delta_i) * xxd ^ (-rhoc_i)) ^ (-1.0 / rhoc_i)
                )
                constraint = mcp_constraint(model, expr, pd)
            else
                constraint = @NLconstraint(
                    model,
                    x == ac_i * (delta_i * m ^ (-rhoc_i) + (1.0 - delta_i) * xxd ^ (-rhoc_i)) ^ (-1.0 / rhoc_i)
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:armington, block=block.name,
            payload=(indices=(i,), info="x = ac*(delta*m^-rhoc + (1-delta)*xxd^-rhoc)^(-1/rhoc)", constraint=constraint))

        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(
                    model,
                    m / xxd - (pd / pm * delta_i / (1.0 - delta_i)) ^ (1.0 / (1.0 + rhoc_i))
                )
                constraint = mcp_constraint(model, expr, m)
            else
                constraint = @NLconstraint(
                    model,
                    m / xxd == (pd / pm * delta_i / (1.0 - delta_i)) ^ (1.0 / (1.0 + rhoc_i))
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:costmin, block=block.name,
            payload=(indices=(i,), info="m/xxd = (pd/pm*delta/(1-delta))^(1/(1+rhoc))", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::CETXXDEBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    traded = hasproperty(block.params, :traded) ? block.params.traded : commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    for i in traded
        xd = ensure_var!(ctx, model, global_var(:xd, i))
        e = ensure_var!(ctx, model, global_var(:e, i))
        xxd = ensure_var!(ctx, model, global_var(:xxd, i))
        pe = ensure_var!(ctx, model, global_var(:pe, i))
        pd = ensure_var!(ctx, model, global_var(:pd, i))
        at_i = JCGECore.getparam(block.params, :at, i)
        gamma_i = JCGECore.getparam(block.params, :gamma, i)
        rhot_i = JCGECore.getparam(block.params, :rhot, i)

        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(
                    model,
                    xd - at_i * (gamma_i * e ^ rhot_i + (1.0 - gamma_i) * xxd ^ rhot_i) ^ (1.0 / rhot_i)
                )
                constraint = mcp_constraint(model, expr, px)
            else
                constraint = @NLconstraint(
                    model,
                    xd == at_i * (gamma_i * e ^ rhot_i + (1.0 - gamma_i) * xxd ^ rhot_i) ^ (1.0 / rhot_i)
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:cet, block=block.name,
            payload=(indices=(i,), info="xd = at*(gamma*e^rhot + (1-gamma)*xxd^rhot)^(1/rhot)", constraint=constraint))

        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(
                    model,
                    e / xxd - (pe / pd * (1.0 - gamma_i) / gamma_i) ^ (1.0 / (rhot_i - 1.0))
                )
                constraint = mcp_constraint(model, expr, e)
            else
                constraint = @NLconstraint(
                    model,
                    e / xxd == (pe / pd * (1.0 - gamma_i) / gamma_i) ^ (1.0 / (rhot_i - 1.0))
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:esupply, block=block.name,
            payload=(indices=(i,), info="e/xxd = (pe/pd*(1-gamma)/gamma)^(1/(rhot-1))", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::ExportDemandBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    traded = hasproperty(block.params, :traded) ? block.params.traded : commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    for i in traded
        e = ensure_var!(ctx, model, global_var(:e, i))
        pwe = ensure_var!(ctx, model, global_var(:pwe, i))
        e0_i = JCGECore.getparam(block.params, :e0, i)
        pwe0_i = JCGECore.getparam(block.params, :pwe0, i)
        eta_i = JCGECore.getparam(block.params, :eta, i)
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(model, e / e0_i - (pwe0_i / pwe) ^ eta_i)
                constraint = mcp_constraint(model, expr, pwe)
            else
                constraint = @NLconstraint(model, e / e0_i == (pwe0_i / pwe) ^ eta_i)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:edemand, block=block.name,
            payload=(indices=(i,), info="e/e0 = (pwe0/pwe)^eta", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::NontradedSupplyBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    nontraded = hasproperty(block.params, :nontraded) ? block.params.nontraded : Symbol[]
    model = ctx.model
    for i in nontraded
        xxd = ensure_var!(ctx, model, global_var(:xxd, i))
        xd = ensure_var!(ctx, model, global_var(:xd, i))
        x = ensure_var!(ctx, model, global_var(:x, i))
        constraint = model isa JuMP.Model ? @constraint(model, xxd == xd) : nothing
        JCGEKernel.register_equation!(ctx; tag=:xxdsn, block=block.name,
            payload=(indices=(i,), info="xxd = xd (nontraded)", constraint=constraint))
        constraint = model isa JuMP.Model ? @constraint(model, x == xxd) : nothing
        JCGEKernel.register_equation!(ctx; tag=:xsn, block=block.name,
            payload=(indices=(i,), info="x = xxd (nontraded)", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::HouseholdShareDemandBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    y = ensure_var!(ctx, model, global_var(:y))
    mps = ensure_var!(ctx, model, global_var(:mps))
    for i in commodities
        p = ensure_var!(ctx, model, global_var(:p, i))
        cd = ensure_var!(ctx, model, global_var(:cd, i))
        cles_i = JCGECore.getparam(block.params, :cles, i)
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(model, p * cd - cles_i * (1.0 - mps) * y)
                constraint = mcp_constraint(model, expr, cd)
            else
                constraint = @NLconstraint(model, p * cd == cles_i * (1.0 - mps) * y)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:cdeq, block=block.name,
            payload=(indices=(i,), info="p*cd = cles*(1-mps)*y", constraint=constraint))
    end

    hhsav = ensure_var!(ctx, model, global_var(:hhsav))
    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @NLexpression(model, hhsav - mps * y)
            constraint = mcp_constraint(model, expr, hhsav)
        else
            constraint = @NLconstraint(model, hhsav == mps * y)
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:hhsaveq, block=block.name,
        payload=(indices=(), info="hhsav = mps*y", constraint=constraint))
    return nothing
end

function JCGECore.build!(block::GovernmentShareDemandBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)
    gdtot = ensure_var!(ctx, model, global_var(:gdtot))
    for i in commodities
        gd = ensure_var!(ctx, model, global_var(:gd, i))
        gles_i = JCGECore.getparam(block.params, :gles, i)
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @expression(model, gd - gles_i * gdtot)
                constraint = mcp_constraint(model, expr, gd)
            else
                constraint = @constraint(model, gd == gles_i * gdtot)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:gdeq, block=block.name,
            payload=(indices=(i,), info="gd = gles*gdtot", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::InventoryDemandBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)
    for i in commodities
        dst = ensure_var!(ctx, model, global_var(:dst, i))
        xd = ensure_var!(ctx, model, global_var(:xd, i))
        dstr_i = JCGECore.getparam(block.params, :dstr, i)
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @expression(model, dst - dstr_i * xd)
                constraint = mcp_constraint(model, expr, dst)
            else
                constraint = @constraint(model, dst == dstr_i * xd)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:dsteq, block=block.name,
            payload=(indices=(i,), info="dst = dstr*xd", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::GovernmentFinanceBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    traded = hasproperty(block.params, :traded) ? block.params.traded : commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    er = ensure_var!(ctx, model, global_var(:er))
    gr = ensure_var!(ctx, model, global_var(:gr))
    tariff = ensure_var!(ctx, model, global_var(:tariff))
    indtax = ensure_var!(ctx, model, global_var(:indtax))
    duty = ensure_var!(ctx, model, global_var(:duty))
    govsav = ensure_var!(ctx, model, global_var(:govsav))
    itax_vals = Dict(i => JCGECore.getparam(block.params, :itax, i) for i in commodities)
    te_vals = Dict(i => JCGECore.getparam(block.params, :te, i) for i in traded)

    tm_vars = Dict(i => ensure_var!(ctx, model, global_var(:tm, i)) for i in traded)
    m_vars = Dict(i => ensure_var!(ctx, model, global_var(:m, i)) for i in traded)
    pwm_vars = Dict(i => ensure_var!(ctx, model, global_var(:pwm, i)) for i in traded)
    px_vars = Dict(i => ensure_var!(ctx, model, global_var(:px, i)) for i in commodities)
    xd_vars = Dict(i => ensure_var!(ctx, model, global_var(:xd, i)) for i in commodities)
    e_vars = Dict(i => ensure_var!(ctx, model, global_var(:e, i)) for i in traded)
    pe_vars = Dict(i => ensure_var!(ctx, model, global_var(:pe, i)) for i in traded)
    p_vars = Dict(i => ensure_var!(ctx, model, global_var(:p, i)) for i in commodities)
    gd_vars = Dict(i => ensure_var!(ctx, model, global_var(:gd, i)) for i in commodities)

    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @NLexpression(model, tariff - sum(tm_vars[i] * m_vars[i] * pwm_vars[i] for i in traded) * er)
            constraint = mcp_constraint(model, expr, tariff)
        else
            constraint = @NLconstraint(
                model,
                tariff == sum(tm_vars[i] * m_vars[i] * pwm_vars[i] for i in traded) * er
            )
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:tariffdef, block=block.name,
        payload=(indices=(), info="tariff = sum(tm*m*pwm)*er", constraint=constraint))

    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @NLexpression(model, indtax - sum(itax_vals[i] * px_vars[i] * xd_vars[i] for i in commodities))
            constraint = mcp_constraint(model, expr, indtax)
        else
            constraint = @NLconstraint(model, indtax == sum(itax_vals[i] * px_vars[i] * xd_vars[i] for i in commodities))
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:indtaxdef, block=block.name,
        payload=(indices=(), info="indtax = sum(itax*px*xd)", constraint=constraint))

    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @NLexpression(model, duty - sum(te_vals[i] * e_vars[i] * pe_vars[i] for i in traded))
            constraint = mcp_constraint(model, expr, duty)
        else
            constraint = @NLconstraint(model, duty == sum(te_vals[i] * e_vars[i] * pe_vars[i] for i in traded))
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:dutydef, block=block.name,
        payload=(indices=(), info="duty = sum(te*e*pe)", constraint=constraint))

    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @expression(model, gr - tariff - duty - indtax)
            constraint = mcp_constraint(model, expr, gr)
        else
            constraint = @constraint(model, gr == tariff + duty + indtax)
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:greq, block=block.name,
        payload=(indices=(), info="gr = tariff + duty + indtax", constraint=constraint))

    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @NLexpression(model, gr - sum(p_vars[i] * gd_vars[i] for i in commodities) - govsav)
            constraint = mcp_constraint(model, expr, govsav)
        else
            constraint = @NLconstraint(model, gr == sum(p_vars[i] * gd_vars[i] for i in commodities) + govsav)
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:gruse, block=block.name,
        payload=(indices=(), info="gr = sum(p*gd) + govsav", constraint=constraint))

    return nothing
end

function JCGECore.build!(block::GDPIncomeBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    model = ctx.model
    mcp = mcp_enabled(block.params)
    y = ensure_var!(ctx, model, global_var(:y))
    deprecia = ensure_var!(ctx, model, global_var(:deprecia))
    pva_vars = Dict(i => ensure_var!(ctx, model, global_var(:pva, i)) for i in activities)
    xd_vars = Dict(i => ensure_var!(ctx, model, global_var(:xd, i)) for i in activities)
    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @NLexpression(model, y - sum(pva_vars[i] * xd_vars[i] for i in activities) + deprecia)
            constraint = mcp_constraint(model, expr, y)
        else
            constraint = @NLconstraint(model,
                y == sum(pva_vars[i] * xd_vars[i] for i in activities) - deprecia
            )
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:gdp, block=block.name,
        payload=(indices=(), info="y = sum(pva*xd) - deprecia", constraint=constraint))
    return nothing
end

function JCGECore.build!(block::SavingsInvestmentBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    activities = isempty(block.activities) ? spec.model.sets.activities : block.activities
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)

    deprecia = ensure_var!(ctx, model, global_var(:deprecia))
    savings = ensure_var!(ctx, model, global_var(:savings))
    hhsav = ensure_var!(ctx, model, global_var(:hhsav))
    govsav = ensure_var!(ctx, model, global_var(:govsav))
    fsav = ensure_var!(ctx, model, global_var(:fsav))
    er = ensure_var!(ctx, model, global_var(:er))
    depr_vals = Dict(i => JCGECore.getparam(block.params, :depr, i) for i in activities)
    pk_vars = Dict(i => ensure_var!(ctx, model, global_var(:pk, i)) for i in activities)
    k_vars = Dict(i => ensure_var!(ctx, model, global_var(:k, i)) for i in activities)
    dk_vars = Dict(i => ensure_var!(ctx, model, global_var(:dk, i)) for i in activities)
    dst_vars = Dict(j => ensure_var!(ctx, model, global_var(:dst, j)) for j in commodities)
    p_vars = Dict(j => ensure_var!(ctx, model, global_var(:p, j)) for j in commodities)

    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @NLexpression(model, deprecia - sum(depr_vals[i] * pk_vars[i] * k_vars[i] for i in activities))
            constraint = mcp_constraint(model, expr, deprecia)
        else
            constraint = @NLconstraint(model,
                deprecia == sum(depr_vals[i] * pk_vars[i] * k_vars[i] for i in activities)
            )
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:depreq, block=block.name,
        payload=(indices=(), info="deprecia = sum(depr*pk*k)", constraint=constraint))

    constraint = nothing
    if model isa JuMP.Model
        if mcp
            expr = @NLexpression(model, savings - (hhsav + govsav + deprecia + fsav * er))
            constraint = mcp_constraint(model, expr, savings)
        else
            constraint = @NLconstraint(model, savings == hhsav + govsav + deprecia + fsav * er)
        end
    end
    JCGEKernel.register_equation!(ctx; tag=:totsav, block=block.name,
        payload=(indices=(), info="savings = hhsav + govsav + deprecia + fsav*er", constraint=constraint))

    for i in activities
        kio_i = JCGECore.getparam(block.params, :kio, i)
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @NLexpression(
                    model,
                    pk_vars[i] * dk_vars[i] - (kio_i * savings - kio_i * sum(dst_vars[j] * p_vars[j] for j in commodities))
                )
                constraint = mcp_constraint(model, expr, dk_vars[i])
            else
                constraint = @NLconstraint(
                    model,
                    pk_vars[i] * dk_vars[i] == kio_i * savings - kio_i * sum(dst_vars[j] * p_vars[j] for j in commodities)
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:prodinv, block=block.name,
            payload=(indices=(i,), info="pk*dk = kio*savings - kio*sum(dst*p)", constraint=constraint))
    end

    for i in activities
        id = ensure_var!(ctx, model, global_var(:id, i))
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @expression(
                    model,
                    id - sum(JCGECore.getparam(block.params, :imat, i, j) * dk_vars[j] for j in activities)
                )
                constraint = mcp_constraint(model, expr, id)
            else
                constraint = @constraint(
                    model,
                    id == sum(JCGECore.getparam(block.params, :imat, i, j) * dk_vars[j] for j in activities)
                )
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:ieq, block=block.name,
            payload=(indices=(i,), info="id[i] = sum(imat[i,j]*dk[j])", constraint=constraint))
    end

    return nothing
end

function JCGECore.build!(block::FinalDemandClearingBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model
    mcp = mcp_enabled(block.params)
    for i in commodities
        x = ensure_var!(ctx, model, global_var(:x, i))
        int = ensure_var!(ctx, model, global_var(:int, i))
        cd = ensure_var!(ctx, model, global_var(:cd, i))
        gd = ensure_var!(ctx, model, global_var(:gd, i))
        id = ensure_var!(ctx, model, global_var(:id, i))
        dst = ensure_var!(ctx, model, global_var(:dst, i))
        constraint = nothing
        if model isa JuMP.Model
            if mcp
                expr = @expression(model, x - int - cd - gd - id - dst)
                constraint = mcp_constraint(model, expr, ensure_var!(ctx, model, global_var(:p, i)))
            else
                constraint = @constraint(model, x == int + cd + gd + id + dst)
            end
        end
        JCGEKernel.register_equation!(ctx; tag=:equil, block=block.name,
            payload=(indices=(i,), info="x = int + cd + gd + id + dst", constraint=constraint))
    end
    return nothing
end

function JCGECore.build!(block::ConsumptionObjectiveBlock, ctx::JCGEKernel.KernelContext, spec::JCGECore.RunSpec)
    commodities = isempty(block.commodities) ? spec.model.sets.commodities : block.commodities
    model = ctx.model
    omega = ensure_var!(ctx, model, global_var(:omega))
    cd = Dict(i => ensure_var!(ctx, model, global_var(:cd, i)) for i in commodities)
    if model isa JuMP.Model
        alpha_vals = Dict(i => JCGECore.getparam(block.params, :alpha, i) for i in commodities)
        active = [i for i in commodities if alpha_vals[i] > 0.0]
        @NLconstraint(model, omega == prod(cd[i] ^ alpha_vals[i] for i in active))
        @NLobjective(model, Max, omega)
    end
    JCGEKernel.register_equation!(ctx; tag=:objective, block=block.name,
        payload=(indices=(), info="omega = prod(cd^alpha)", constraint=nothing))
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
