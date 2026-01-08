# JCGECore

Canonical internal data model and interfaces for JCGE.

## Responsibilities
- Core types for sets, mappings, benchmark containers, and RunSpec (run specification)
- Block interfaces and validation hooks
- Standard RunSpec builder and section/template helpers
- No JuMP dependency

## RunSpec builder (sections + templates)
JCGECore provides a lightweight builder to standardize RunSpec assembly:
- `SectionSpec` groups blocks by semantic section (e.g., `:production`, `:trade`).
- `RunSpecTemplate` declares required sections for a model family.
- `build_spec` assembles a `RunSpec` with required-section validation, optional
  allowed-section checks, and required-nonempty sections.

## Non-goals
- Solving, model construction, or calibration implementations
