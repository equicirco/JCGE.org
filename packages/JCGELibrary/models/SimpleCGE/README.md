# SimpleCGE

Simple CGE model from Chapter 5 of:
Hosoe, N, Gasawa, K, and Hashimoto, H.
Handbook of Computable General Equilibrium Modeling.
University of Tokyo Press, Tokyo, Japan, 2004.

This model is intended for testing and development, using the SAM in `data/sam_2_2.csv`.

## Block usage (form-aware)
The simple model uses the form-aware wrappers for production, household demand, and utility:
```julia
prod = JCGEBlocks.ProductionBlock(:prod, goods, factors, Symbol[], :cd, params)
hh = JCGEBlocks.HouseholdDemandBlock(:household, Symbol[], goods, factors, :cd, :X, params)
util = JCGEBlocks.UtilityBlock(:utility, Symbol[], goods, :cd, :X, (alpha=alpha,))
```
