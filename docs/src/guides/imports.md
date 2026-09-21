# Imports

JCGE provides two import paths: data ingestion and MPSGE model conversion. The
goal is to make external data and legacy model structures reusable within the
JCGE ecosystem.

## Data import (IO/SAM)

`JCGEImportData` provides released source adapters for Eurostat FIGARO,
national supply--use tables and national accounts, selected Eurostat satellite
accounts, BEA Make/Use and national-accounts tables, and OECD ICIO archives.
It normalizes selected source accounts into SUT, IO, satellite, and canonical
data artefacts; it also provides balance diagnostics and a Model-D
SUT-to-industry-by-industry IO transformation.

Downloads retain the declared source selection, raw responses, retrieval
metadata, and SHA-256 checksums. The package deliberately does not infer a
model's aggregation, account mapping, SAM closure, or behavioural assumptions:
those remain explicit model-owned decisions.

Key outputs include normalized source tables, balance diagnostics, and the
canonical files (`sam.csv`, `sets.csv`, and optional labels, subsets, mappings,
and parameters) required by a model's calibration workflow.

### Recommended workflow

1. Select a published source release, accounts, valuation, and reference year.
2. Retrieve or read the declared source tables and retain the source manifest.
3. Normalize them to the relevant SUT, IO, national-account, or satellite form;
   apply Model D only when an industry-by-industry IO table is required.
4. Diagnose source-table balances.
5. Map accounts, aggregation, institutions, and closure explicitly in the model,
   then write `sets.csv` and `sam.csv` for calibration.

Use the [Calibration guide](calibration.md) once the canonical files are in place.

## MPSGE import

`JCGEImportMPSGE` converts an `MPSGE.jl` model object to a JCGE RunSpec.
This is a converter and conformance bridge, not a competing authoring format.

Typical flow:

```julia
using MPSGE, JCGEImportMPSGE
m = MPSGEModel()
# build MPSGE model...
run_spec = import_mpsge(m)
```

When the source model is complementarity-based, the importer emits MCP blocks
so the model can be solved with PATHSolver.

## Choosing an import path

- Use `JCGEImportData` when you are starting from data and building new models.
- Use `JCGEImportMPSGE` when you need to translate an existing MPSGE model.

## Next steps

- [Calibration guide](calibration.md) for canonical schema usage.
- [Modeling guide](modeling.md) for building RunSpecs from blocks.
