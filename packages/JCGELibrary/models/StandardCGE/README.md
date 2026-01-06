# StandardCGE

Julia implementation of the standard CGE model from Hosoe, Gasawa, and Hashimoto (Chapter 6).

## Block usage (form-aware)
This model uses the form-aware wrappers for production, household demand, and utility:
```julia
prod = JCGEBlocks.ProductionBlock(:prod, activities, factors, commodities, :cd_leontief, params)
hh = JCGEBlocks.HouseholdDemandBlock(:household, Symbol[], commodities, factors, :cd, :Xp, params)
util = JCGEBlocks.UtilityBlock(:utility, Symbol[], commodities, :cd, :Xp, (alpha=params.alpha,))
```
