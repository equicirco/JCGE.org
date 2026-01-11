<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/src/assets/jcge_runtime_logo_dark.png">
  <source media="(prefers-color-scheme: light)" srcset="docs/src/assets/jcge_runtime_logo_light.png">
  <img alt="JCGE Runtime logo" src="docs/src/assets/jcge_runtime_logo_light.png" height="150">
</picture>

# JCGERuntime

## What is a CGE?
A Computable General Equilibrium (CGE) model is a quantitative economic model that represents an economy as interconnected markets for goods and services, factors of production, institutions, and the rest of the world. It is calibrated with data (typically a Social Accounting Matrix) and solved numerically as a system of nonlinear equations until equilibrium conditions (zero-profit, market-clearing, and income-balance) hold within tolerance.

## What is JCGE?
JCGE is a block-based CGE modeling and execution framework in Julia. It defines a shared RunSpec structure and reusable blocks so models can be assembled, validated, solved, and compared consistently across packages.

## What is this package?
JuMP-facing runtime for building and solving models.

## Responsibilities
- Variable and constraint registries, naming, equation tagging
- Closure mechanisms and numerics (initialization, scaling hooks)
- Diagnostics and standardized result extraction

## Dependencies
- Should depend on JCGECore (and optionally JCGECalibrate for helpers)

## Warm starts and scenario chaining
To emulate GAMS-style “solve, tweak, solve”, capture the solved state and reuse it
as starting values (optionally carrying over bounds and fixed vars).

```julia
result = JCGERuntime.run!(spec; optimizer=Ipopt.Optimizer)
state = JCGERuntime.snapshot_state(result)

spec2 = JCGEBlocks.apply_start(spec2, state.start;
    lower=state.lower, upper=state.upper, fixed=state.fixed)
result2 = JCGERuntime.run!(spec2; optimizer=Ipopt.Optimizer)
```

You can also use the shortcut:
```julia
result2 = JCGEBlocks.rerun!(spec2; from=result, optimizer=Ipopt.Optimizer)
```

## Validation
Optional runtime checks are available once a model is built or solved:
```julia
result = JCGERuntime.run!(spec; optimizer=Ipopt.Optimizer)
report = JCGERuntime.validate_model(result.context; level=:basic)
report.ok || println(report.categories)
```
