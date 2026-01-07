# JCGE.jl Roadmap

## Scope
JCGE.jl is a modular, block-based framework for building and running computable general equilibrium (CGE) models in Julia.

## Monorepo structure
- `packages/`: independently testable Julia packages (Core, Calibrate, Kernel, Blocks, Circular)
- `JCGEExamples`: runnable reference models and scenarios
- `docs/`: documentation sources (optional)
- `scripts/`: developer utilities (optional)
- `data/`: tiny toy datasets only (no large or proprietary files)

## Near-term milestones
1. Establish a minimal internal data model and validation (JCGECore).
2. Implement calibration helpers for standard functional forms (JCGECalibrate).
3. Implement a JuMP kernel with variable/constraint registries and diagnostics (JCGEKernel).
4. Implement a minimal set of standard blocks (JCGEBlocks).
5. Add first circular-economy extension blocks (JCGECircular).
6. Provide a tiny end-to-end example in `JCGEExamples` using a toy SAM.
7. Port an existing JuMP CGE model into `JCGEExamples` as the first real model-driven development target.

## Definition of done (v0.1)
- One toy SAM example runs end-to-end and replicates the benchmark within tolerance.
- Basic validation and diagnostics are present (Walras check, budget balance residuals).
- Each package has tests and minimal documentation.
# Project Objective (Non-negotiable)
- This is a block-based CGE tool. Every model must be expressed as a composition of reusable blocks.
- No standalone model implementations outside the block system; library/examples only wire blocks.
