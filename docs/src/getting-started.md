# Getting Started

This quick start shows the minimal steps to install the core JCGE packages and run a
reference model. For full workflows and modeling guidance, see the
[Guides](guides/modeling.md).

## Prerequisites

- Julia 1.9+ installed and on your PATH.
- A clean project environment (recommended).

## Install

Create or activate a project before adding packages:

```julia
import Pkg
Pkg.activate(".")
```

Then add the core packages:

```julia
import Pkg
Pkg.add([
    "JCGECore",
    "JCGEBlocks",
    "JCGERuntime",
    "JCGECalibrate",
    "JCGEOutput",
])
```

## Run a reference model

```julia
using JCGEExamples
result = JCGEExamples.StandardCGE.solve()
```

## Inspect results

The returned `result` contains the solved model and output artifacts. Typical next
steps include inspecting reports and exporting tables via `JCGEOutput`.

## Solver note

For MCP models, PATHSolver is required. See the [Imports guide](guides/imports.md)
for license setup.

## Next steps

- Read the [Modeling guide](guides/modeling.md) to understand blocks and model structure.
- Follow the [Calibration](guides/calibration.md) and [Output](guides/output.md)
  guides for data workflows and reporting.
