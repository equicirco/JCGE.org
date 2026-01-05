# JCGELibrary

A package that bundles **model definitions** (as submodules) for the JCGE ecosystem.

## What belongs here
- Named model modules (e.g. `StandardCGE`, `CircularToy`, `NO2019_Circular`, etc.) implemented as Julia submodules.
- Model constructors returning a **spec** or **builder object** (recommended: `RunSpec`/`ModelSpec` + optional default scenarios).
- Small toy datasets that are safe to ship in-repo (optional), under `data/<ModelName>/`.

## What does NOT belong here
- Core framework code (data model, calibration, kernel, generic blocks): those stay in `JCGECore`, `JCGECalibrate`, `JCGEKernel`, `JCGEBlocks`, `JCGECircular`.
- Large, licensed, or country SAM datasets unless distribution rights are clear.
- Solver-specific configuration that is not part of the model definition.

## Expected user-facing usage
Typical usage should look like:

- `using JCGELibrary`
- `using JCGELibrary.StandardCGE`
- `spec = StandardCGE.model()` (returns a spec/object that the framework can build/run)

## Folder layout
- `src/`: package module entrypoint
- `models/`: one `.jl` file per model submodule
- `data/`: optional small benchmark inputs per model
- `docs/`: optional model notes and documentation per model
