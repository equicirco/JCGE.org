# Imports

JCGE provides two import paths: data ingestion and MPSGE model conversion. The
goal is to make external data and legacy model structures reusable within the
JCGE ecosystem.

## Data import (IO/SAM)

`JCGEImportData` defines a canonical CSV schema and helpers to build a SAM
from IO tables. It is designed for adapters that extract data from external
sources like Eurostat or GTAP.

Key outputs:
- `sam.csv`
- `sets.csv`
- optional labels, subsets, mappings, and parameters

### Recommended workflow

1. Extract raw IO/SAM data from a source dataset.
2. Map accounts into the canonical schema.
3. Generate `sets.csv` and `sam.csv`.
4. Validate that labels and mappings align.

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
