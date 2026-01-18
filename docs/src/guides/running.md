# Running Models

This guide covers how to run models, configure solvers, and work with scenarios.
For structural modeling steps, see the [Modeling guide](modeling.md).

The `JCGEExamples` package provides reference models ported from the literature.
Each model exposes a `model`, `baseline`, and `solve` entry point.

```julia
using JCGEExamples

result = JCGEExamples.StandardCGE.solve()
```

## Build a spec and run it

You can also run a custom `RunSpec` directly once it is validated:

```julia
using JCGERuntime, Ipopt

report = validate_model(spec)
report.ok || error("Model validation failed")

result = run!(spec; optimizer=Ipopt.Optimizer)
```

## Solvers

- NLP models: Ipopt (`Ipopt.Optimizer`)
- MCP models: PATHSolver (`PATHSolver.Optimizer`)

PATHSolver requires a license for larger problems. You can provide the license
via environment variable:

```bash
export PATH_LICENSE_STRING="<LICENSE STRING>"
```

If the problem is small enough, PATHSolver can run without a license.

## Runtime options

Typical runtime controls include:

- Choice of optimizer and solver parameters.
- Output directories and report formats.
- Scenario labels for comparison workflows.

Exact options depend on the runtime package entry points you use.

## Scenarios and experiments

Run the same model under multiple parameter sets to compare outcomes. A common
workflow is to:

1. Define a baseline calibration.
2. Apply policy or shock parameters.
3. Solve and compare outputs.

Use consistent naming for scenarios to make reports reproducible.

## Troubleshooting

- Check validation reports before solving.
- Confirm that all calibration outputs map to block parameters.
- For PATHSolver issues, confirm the license string and solver availability.

## Next steps

- [Blocks guide](blocks.md) for reusable components.
- [Calibration guide](calibration.md) for data workflows and schema details.
- [Output guide](output.md) for reporting and exports.
