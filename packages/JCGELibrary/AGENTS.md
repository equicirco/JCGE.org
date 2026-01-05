# JCGELibrary — Development Guide (AGENTS)

## Purpose
JCGELibrary collects *concrete model definitions* (as submodules) built on top of the JCGE framework packages.

This package is the place to store:
- reference models used for development/regression,
- reusable “named models” for users,
- optional toy benchmark datasets (when legally distributable).

## Core rule: framework vs model separation
- Framework packages define *capabilities* (blocks, kernel, calibration).
- JCGELibrary defines *instances* (specific model structures, closures, default scenarios).

Do not move generic framework logic into JCGELibrary.

## Model directory rule
- Each model lives under `models/<ModelName>/`.
- All model-related assets (code, data, docs) must live under that model directory.
- Do not add parallel top-level `data/` or `docs/` folders in JCGELibrary.

## Model module contract (required)
Each model submodule (e.g. `<ModelName>`) must:
1) live in `models/<ModelName>/<ModelName>.jl`
2) define `module <ModelName> ... end`
3) export at least:
   - `model()` returning a JCGE-compatible spec/builder (prefer `RunSpec` or `ModelSpec`)
4) optionally export:
   - `baseline()` (alias of `model()`)
   - `scenario(name::Symbol)` returning a scenario delta
   - `datadir()` if shipping small data inside this package

## Data policy
- Only commit datasets that are small and redistributable.
- For non-redistributable data, include only:
  - schema/expected filenames
  - provenance notes
  - instructions for the user to place files locally

## Versioning
- Keep JCGELibrary compatible with the current JCGE framework versions used in the monorepo.
- Once published, changes to a model module API should be deliberate and documented.

## Development approach (near-term)
- Port a known JuMP CGE model into this package as the first real target model.
- Use that model to drive missing framework features across JCGECore/Kernel/Blocks.
