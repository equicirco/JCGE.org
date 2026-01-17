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

## Scope

- Framework architecture and workflows
- Cross-package guides and examples
- High-level package responsibilities

## Out of scope

- Detailed package APIs (see each package documentation site)
- Solver implementation details
- Package-level release notes

## Roadmap (short)

- Stabilize package interfaces and shared data schema.
- Expand reference models and validation coverage.
- Improve onboarding material for new modelers.
