# JCGEBlocks

Standard CGE blocks built on the JCGE interfaces.

## Responsibilities
- Production blocks (nested production functions)
- Trade blocks (Armington/CET as needed)
- Institution blocks (households, government)
- Market clearing blocks

## Dependencies
- Depends on JCGECore, JCGEKernel

## Block catalog (planned)
- Production: Cobb-Douglas value-added, factor demand, Leontief intermediates, unit cost/zero-profit
- Factor supply/endowment: fixed factor availability (labor/capital) and shocks
- Government: direct tax, production tax, import tariff, government demand, government saving
- Investment: investment demand, savings-investment identity
- Household: household demand, private saving, direct tax link
- Trade/Armington: Armington composite, import demand, domestic demand
- Transformation/CET: output split between exports and domestic sales
- Prices: world price links + exchange rate
- External balance: balance of payments (foreign savings)
- Market clearing: composite goods clearing + factor market clearing
- Utility/objective: household utility (Cobb-Douglas over consumption)
- Closure: numeraire + macro closure choices
