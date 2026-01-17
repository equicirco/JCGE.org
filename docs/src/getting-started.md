# Getting Started

This quick start shows the minimal steps to install the core JCGE packages and run a
reference model. For full workflows and modeling guidance, see the Guides section.

## Install

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

## Solver note

For MCP models, PATHSolver is required. See the Imports guide for license setup.
