# Blocks

Blocks are reusable building blocks that emit equation ASTs and model variables.
A model is assembled by selecting and configuring blocks, then organizing them
into sections (production, households, markets, etc.). Each block has a clear
responsibility and declares which sets and parameters it requires.

## Forms

Many blocks accept a `form` parameter to choose the functional form (for
example Cobb-Douglas or CES). Use a global form for all items or provide a
per-entity mapping where supported.

Typical forms include:

- Cobb-Douglas for smooth substitution.
- CES for flexible elasticities.
- Leontief for fixed proportions.

## Typical block categories

Most models mix a small set of block categories:

- Production blocks that map inputs to outputs.
- Market clearing blocks for goods and factors.
- Income and demand blocks for institutions.
- Closure and numeraire blocks.

Organize blocks into sections so the model structure is readable and easy to
diagnose.

## Parameterization

Blocks take parameters from calibrated data. Keep parameter names consistent
across blocks so calibration outputs can be reused. Prefer explicit mappings
over implicit defaults when building large models.

## Extending blocks

Custom blocks can be created by following the same interface as the built-ins:
declare required sets, map parameters, and emit equation ASTs. This makes new
components fully compatible with the runtime and output tooling.

## Guidelines

- Blocks should be reusable and model-agnostic.
- Avoid hard-coded sector/factor counts; always work with sets.
- All equations are registered with block and tag metadata to enable rendering
  and reporting.

See the `JCGEBlocks` documentation at <https://Blocks.JCGE.org> for the full block
catalog and parameters.
