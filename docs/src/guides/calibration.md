# Calibration

`JCGECalibrate` converts SAM and IO data into calibrated parameters and starting
values. The calibration process is model-agnostic but assumes a canonical input
schema. The goal is a consistent benchmark where accounting identities and
zero-profit conditions hold.

## Inputs

- `sam.csv`: square SAM matrix with labeled rows/columns
- `sets.csv`: canonical lists of goods, activities, factors, and institutions
- Optional: `subsets.csv`, `labels.csv`, `mappings.csv`, `params.csv`

The [Imports guide](imports.md) describes the canonical schema and how to build
these files from raw sources.

## Outputs

Calibration produces:

- Parameter tables for production, demand, and tax structures.
- Starting values for levels and prices.
- Consistent mappings that align data with model sets.

## Typical workflow

```julia
using JCGECalibrate
sam = load_sam_table("path/to/sam.csv"; goods=..., factors=...)
start = compute_starting_values(sam)
params = compute_calibration_params(sam, start)
```

Calibration is deterministic and should produce a consistent benchmark that
satisfies model accounting identities.

## Validating calibration

Before building the model, check that:

- All accounts balance.
- Mappings cover all required sets.
- Calibration outputs match the expected model inputs.

If a balance check fails, fix the SAM or mappings before proceeding.

## Common pitfalls

- Misaligned labels between `sam.csv` and `sets.csv`.
- Missing or duplicated accounts in the SAM.
- Implicit zeros that should be explicit.

## Next steps

- [Modeling guide](modeling.md) to connect parameters to blocks.
- [Imports guide](imports.md) for schema details and data ingestion.
