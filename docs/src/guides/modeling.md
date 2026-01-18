# Modeling

This guide outlines a typical modeling workflow in JCGE, from data-backed
calibration to a solved model and exported outputs. It focuses on the structural
steps and how the pieces fit together.

If you are new to the ecosystem, start with [Getting Started](../getting-started.md)
and then return here for a deeper walkthrough of model construction.

## 1. Start from data

Use `JCGECalibrate` to load a SAM and produce calibrated parameters and
starting values. The canonical input format is described in the
[Calibration](calibration.md) and [Imports](imports.md) guides.

Key ideas:

- Data should be mapped into the canonical schema before building blocks.
- Calibration outputs become model parameters and initial values.
- Keep data transformations explicit so the pipeline is reproducible.

## 2. Build a RunSpec

A RunSpec is the structural description of a model: sets, mappings, sections,
blocks, and closures. It is a readable definition of the economic structure
separate from any specific calibration dataset.

```julia
using JCGECore
using JCGEBlocks

sets = Sets(goods, activities, factors, institutions)
mappings = Mappings(Dict(a => a for a in activities))

prod = production(:prod, activities, factors, goods; form=:cd, params=prod_params)
market = composite_market_clearing(:market, goods, activities)
numeraire = numeraire(:numeraire, :factor, :LAB, 1.0)

sections = [
    section(:production, [prod]),
    section(:markets, [market]),
    section(:closure, [numeraire]),
]

spec = build_spec("MyModel", sets, mappings, sections)
```

### Common block types

JCGEBlocks provides a library of reusable economic blocks. Typical models mix:

- Production blocks (Cobb-Douglas, CES, Leontief).
- Market clearing blocks.
- Demand or institutional behavior blocks.
- Closure and numeraire blocks.

The [Blocks guide](blocks.md) gives concrete examples and parameterization details.

### Closures and normalization

Closures specify which variables are fixed and which adjust. A numeraire
normalizes the price level and avoids indeterminacy.

## 3. Validate

```julia
using JCGERuntime
report = validate_model(spec)
report.ok || error("Model validation failed")
```

Validation checks block consistency, coverage of sets, and structural integrity
before solving. It is a good place to catch missing mappings or parameters.

## 4. Solve

```julia
using JCGERuntime, Ipopt
result = run!(spec; optimizer=Ipopt.Optimizer)
```

Solver configuration depends on the model class. For MCP models, PATHSolver is
required. Use the [Running guide](running.md) for configuration patterns and runtime
options.

## 5. Inspect and export

Use `JCGEOutput` to render equations or export results.

Typical outputs include:

- Equation listings for verification.
- Report tables by sector or account.
- Scenario comparison exports.

## Tips for building models

- Start from a minimal model and expand iteratively.
- Keep data and structure separate so you can swap datasets.
- Prefer reusable blocks over copy-pasted equations.
- Make closures explicit and document them in the model description.

## Next steps

- [Blocks guide](blocks.md) for reusable components and parameterization.
- [Calibration guide](calibration.md) for data workflows and schema details.
- [Running guide](running.md) for solvers, scenarios, and batch execution.
