# Project

JCGE is a multi-package Julia ecosystem for computable general equilibrium (CGE)
modeling. It favors small, focused packages with clear responsibilities over a
single monolith. This repo provides the cross-cutting narrative: how the ecosystem
fits together, how to model with it, and where to find the right package for a task.

## Goals

- Make CGE model structure explicit and composable.
- Separate calibration, modeling, runtime, and reporting concerns.
- Provide reusable building blocks that scale from simple to large models.
- Keep the ecosystem approachable for applied economists and data teams.

## Scope of this documentation website

- Framework architecture and workflows (see the [Guides](guides/modeling.md))
- Cross-package guides and examples (start with [Getting Started](getting-started.md))
- High-level package responsibilities (see [Packages](packages.md))

## Ecosystem map

The JCGE ecosystem is built as a set of focused packages that connect through shared
data structures and explicit interfaces:

- Core abstractions and schemas live in `JCGECore`.
- Reusable modeling blocks are defined in `JCGEBlocks`.
- Model execution and solver orchestration run through `JCGERuntime`.
- Calibration workflows live in `JCGECalibrate`.
- Reporting and export live in `JCGEOutput`.
- Reference models and end-to-end examples live in `JCGEExamples`.
- Data ingestion is handled by `JCGEImportData` and `JCGEImportMPSGE`.

## Design principles

- Modularity over monoliths.
- Explicit data schemas and traceable transformations.
- Separation between model structure, calibration, runtime, and reporting.
- Reproducible workflows that scale from small to large models.
- Clear boundaries between packages with stable interfaces.

## Workflow overview

1. Define model structure and blocks ([Modeling](guides/modeling.md)).
2. Calibrate parameters and data to the canonical schema ([Calibration](guides/calibration.md)).
3. Run models through the runtime and solver integration ([Running](guides/running.md)).
4. Generate outputs, reports, and exports ([Output](guides/output.md)).

See the [Guides](guides/modeling.md) section for detailed steps across each stage.

## How this approach differs

Many CGE systems are delivered as closed or tightly coupled toolchains. JCGE takes a
different path: open, composable, and inspectable building blocks that can be reused
across models and institutions.

- Open source and fully inspectable from data ingest to solver interface.
- Reusable blocks that can be recomposed instead of copied between models.
- Free and open access documentation with modern tooling.
- Scientific rigor through explicit data schemas and reproducible workflows.
- Performance-oriented Julia implementation for fast iteration.
- Accessible workflows, including integration with AI-assisted tooling.

## Who this is for

- Applied economists and policy modeling teams.
- Research groups that need transparent, inspectable models.
- Organizations that want reusable components instead of single-use scripts.
- Students and educators building modern CGE workflows.

## Status and roadmap

JCGE is fully working and fully developed to support professional and research CGE
work. As an open source project it will continue to improve and expand. The next
focus is deeper data integration in the `JCGEImportData` package.
