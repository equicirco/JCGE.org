# JCGEBlocks

Standard CGE blocks built on the JCGE interfaces.

## Responsibilities
- Production blocks (nested production functions)
- Trade blocks (Armington/CET as needed)
- Institution blocks (households, government)
- Market clearing blocks

## Dependencies
- Depends on JCGECore, JCGEKernel

## Naming and functional forms
Block names are composed as `Domain + Role + FunctionalForm` when relevant.
Examples: `ProductionCDBlock`, `UtilityCESBlock`, `TransformationCETBlock`.

For extensibility, blocks that support multiple forms also expose a `form` field
and can be constructed via a generic wrapper (e.g., `ProductionBlock(form=:cd)`).
This keeps the API stable while making the functional form explicit.

## Block catalog (planned)
- Production: `ProductionCDBlock`, `ProductionCESBlock`, `ProductionLeontiefBlock` (with `ProductionBlock(form=...)`)
- Factor supply/endowment: fixed factor availability (labor/capital) and shocks
- Government: `GovernmentBudgetBlock` (taxes, spending, saving)
- Investment: `InvestmentDemandBlock`, savings-investment identity
- Household: `HouseholdDemandBlock`, `UtilityCDBlock`/`UtilityCESBlock`, private saving
- Trade/Armington: `ArmingtonCESBlock`
- Transformation/CET: `TransformationCETBlock`
- Prices: `WorldPriceLinkBlock`, `ExchangeRateLinkBlock`
- External balance: balance of payments (foreign savings)
- Market clearing: `GoodsMarketClearingBlock`, `CompositeMarketClearingBlock`, `FactorMarketClearingBlock`
- Closure: numeraire + macro closure choices
