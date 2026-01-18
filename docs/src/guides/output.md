# Output & Reporting

`JCGEOutput` provides backend-agnostic rendering and results containers. It is
designed to support reporting across solvers and to keep outputs consistent
across scenarios.

## Equation rendering

```julia
using JCGEOutput
text = render_equations(result; format=:markdown)
```

Rendered equations are derived from the equation AST, not solver objects.

Use this to:

- Audit model structure.
- Compare variants of the same model.
- Generate human-readable documentation.

## Results containers

Results are stored in a canonical `Results` object with primals/duals and
metadata. Export helpers include JSON, CSV, Arrow/Parquet, and a tidy
long-table form for analysis.

Typical workflows include:

- Exporting sector-level tables for reports.
- Writing tidy outputs for dashboards or notebooks.
- Archiving scenario runs for reproducibility.

## SAM-style reporting

`sam_from_solution` can map model flows back to a SAM-like table. This is
optional and may be incomplete if the model does not track all flows.

## Scenario comparison

When running multiple scenarios, keep outputs in consistent formats so
differences can be computed directly. A common pattern is to export a tidy table
for each run and merge on keys.

## Next steps

- [Running guide](running.md) for scenario workflows.
- [Modeling guide](modeling.md) for block-level inspection.
