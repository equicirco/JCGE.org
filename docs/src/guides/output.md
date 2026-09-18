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

Use `show_condition_roles=true` to label solver-enforced equations and
post-solution accounting checks in the listing:

```julia
text = render_equations(result;
    format=:markdown,
    show_condition_roles=true,
)
```

Use this to:

- Audit model structure.
- Compare variants of the same model.
- Generate human-readable documentation.

For a compact equation inventory, `render_equation_report` can render exact
equation families or explicitly declared indexed forms. The model author
supplies any index mappings, reference mappings, and direct-term enumerations;
they are validated for coverage and change only the report, never the model
equations. LaTeX output wraps long relations and sum/product domains for
document layouts. See the [JCGEOutput documentation](https://Output.JCGE.org)
for the package API and formatting options.

## Results containers

Results are stored in a canonical `Results` object with primals/duals and
metadata. Export helpers include JSON, CSV, Arrow/Parquet, and a tidy
long-table form for analysis.

Post-solution accounting residuals are available as
`results.accounting_checks`. They are included in tidy exports with
`kind = :accounting_check` and as zero-dual constraints in DualSignals output.

Typical workflows include:

- Exporting sector-level tables for reports.
- Writing tidy outputs for dashboards or notebooks.
- Archiving scenario runs for reproducibility.

## Physical satellite quantities

Satellite reporting links solved model-volume drivers to calibrated quantities
outside the monetary CGE accounts, such as physical flows, energy use,
emissions, stocks, or technical indicators. An anchor records a stable
identifier, a declared unit, an observed baseline quantity, its model driver,
and the corresponding calibration driver. The anchors are model data, not
hard-coded reporting values.

```julia
using JCGEOutput

anchors = calibration.physical_anchors
reference = satellite_reference(baseline_result, anchors)

baseline_quantities = satellite_projection(baseline_result, anchors;
    reference=reference)
scenario_quantities = satellite_projection(scenario_result, anchors;
    reference=reference)

calibration_differences = satellite_calibration_report(reference, anchors)
checks = satellite_balances(scenario_quantities, calibration.physical_balances)
```

`satellite_reference` stores the solved zero-policy value of every driver.
Using that reference makes the baseline projection reproduce its observed
physical quantities exactly and gives every scenario the same denominator.
`satellite_calibration_report` makes any difference between monetary
calibration inputs and solved driver values visible rather than silently
absorbing it. `satellite_balances` evaluates signed post-solution identities;
all terms in a balance must share a declared unit.

Satellite reporting does not add an equation or constraint to the equilibrium
model. If a quantity must alter production, demand, capacity, or a market
identity, define it structurally with the generic auxiliary-quantity blocks in
`JCGEBlocks` instead.

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
- [Closures & Checks](closures.md) for the corresponding model and runtime setup.
