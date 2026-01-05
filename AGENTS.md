# JCGE.jl — Repository Development Contracts (AGENTS)

## Purpose
JCGE.jl is a monorepo containing multiple Julia packages for building CGE models. The repo must maintain:
- clear dependency direction,
- reproducible minimal examples,
- per-package unit tests, and
- basic integration tests.

## Monorepo layout
- packages/JCGECore
- packages/JCGECalibrate
- packages/JCGEKernel
- packages/JCGEBlocks
- packages/JCGECircular
- packages/JCGELibrary
- examples/ (end-to-end usage and integration tests)
- docs/ (optional documentation sources)
- scripts/ (developer utilities)
- data/ (tiny toy data only)

## Dependency direction (must not be violated)
JCGECore
  -> JCGECalibrate
    -> JCGEKernel
      -> JCGEBlocks
        -> JCGECircular
          -> JCGELibrary

Rules:
- Core packages must never depend on extensions or the library.
- JCGELibrary is always “top”; nothing depends on it.

## Public API stability
- Until v0.1: breakages allowed, but must be deliberate and reflected in tests and docs.
- After v0.1: follow semver; document breaking changes.

## Development approach (near-term)
- Use a known JuMP CGE model ported into `JCGELibrary` as a concrete target.
- Fill missing framework capabilities only as demanded by that model (model-driven development).

## Contracts (minimum interface)
### Run specification
JCGECore defines the canonical specs:
- ModelSpec: blocks + nests + mappings assumptions
- ClosureSpec: closure choices (numeraire, macro closure, adjusting variables)
- ScenarioSpec: shock definitions (deltas)
- RunSpec: metadata + data references + ModelSpec + ClosureSpec + ScenarioSpec

### Block interface
Every block type must implement (or explicitly declare as not applicable):
- calibrate!(block, data, benchmark, params) -> updated params/benchmark
- build!(block, ctx, spec) -> modifies kernel context (variables/equations)
- report(block, solution) -> structured outputs

### Kernel responsibilities
JCGEKernel provides:
- variable registry (symbolic name -> internal handle)
- equation registry with tags (block, market, agent)
- closure application hooks
- diagnostics hooks (Walras, budgets), at least as placeholders initially

## Testing requirements
- Each package must have unit tests in packages/<Pkg>/test/runtests.jl
- Repo must have at least one integration test under examples/integration/
- CI must run package tests and the integration test script(s)

## Data policy
- Only tiny redistributable toy data may be committed.
- Anything large/licensed must be referenced by instructions, not stored.

## Library organization
- In `JCGELibrary`, each model owns its full subtree under `models/<ModelName>/`.
- All model code, data, and docs live under that model directory; avoid top-level `data/` or `docs/`.

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

## RunSpec contract (v0.1)

### Required fields
- `RunSpec.name::String`
- `RunSpec.model::ModelSpec`
- `RunSpec.closure::ClosureSpec`
- `RunSpec.scenario::ScenarioSpec`

### ModelSpec required fields
- `ModelSpec.sets::Sets`
- `ModelSpec.mappings::Mappings`
- `ModelSpec.blocks::Vector{<:AbstractBlock}` (may be temporarily `Vector{Any}` during early refactors)

### Optional fields (explicitly NOT required for v0.1)
- data references (SAM paths, satellite accounts, concordances)
- units/currency/base year metadata
- solver configuration
- output/report configuration


## Scenario delta rules (v0.1)
- `ScenarioSpec` is a **delta** relative to the baseline model configuration.
- `ScenarioSpec.shocks` must not duplicate baseline content; it only records changes.
- Shock keys must be **namespaced** to avoid collisions, e.g.:
  - `:tax.vat.new`
  - `:subsidy.repair`
  - `:sigma.use_appliances`


## Block protocol rules (v0.1)
- `build!(block, ctx, spec)` must be **purely additive**:
  - register variables and equations in `ctx`
  - must not solve the model
- Blocks must not read files directly; they consume inputs from `spec` (and `data` when introduced).
- Every equation added by a block must be registered with at least:
  - `block` tag (`Symbol`)
  - `tag` (`Symbol`)
- No “hidden equations”: all model-defining constraints must go through the registry.
