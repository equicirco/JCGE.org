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

## Model module contract (required)
Each model submodule (e.g. `StandardCGE`) must:
1) live in `models/<ModelName>.jl`
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

## Next steps (initial)
- [ ] Add first model: `models/StandardCGE.jl`
- [ ] Wire it into `src/JCGELibrary.jl` with `include` and `export`
- [ ] Add one minimal integration test that loads the module and calls `model()`
