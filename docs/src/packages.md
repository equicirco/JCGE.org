# Packages

This project is organized as a set of focused Julia packages. The table below
summarizes responsibilities and typical usage.

| Package | Purpose | Typical Use |
|---|---|---|
| `JCGECore` | RunSpec, sections, sets/mappings, scenarios, validation, and closure-condition roles | Define model structure and closure choices |
| `JCGEBlocks` | Reusable CGE blocks, auxiliary-quantity equations, and stable equation-condition keys | Assemble production/household/market systems, make supplementary quantities endogenous, and declare accounting checks |
| `JCGERuntime` | Role-aware compilation, solver execution, residual diagnostics, and experiment workflows | Solve a RunSpec and run parameter/policy batches |
| `JCGECalibrate` | SAM loading and calibration | Derive parameters and starting values |
| `JCGEOutput` | Equation rendering, results containers, accounting-check reporting, and satellite quantities | Export equations, tidy results, physical-flow projections, balance checks, and DualSignals |
| `JCGEExamples` | Reference models | Canonical model ports and tests |
| `JCGEImportData` | Canonical IO/SAM schema | Convert external data to CSV inputs |
| `JCGEImportMPSGE` | MPSGE.jl importer | Translate MPSGE objects to RunSpecs |
| `JCGEAgentInterface` | MCP-compatible interface for agents | AI-assisted discovery and guidance, plus controlled model calibration, studies, reporting, and provenance through a separate MCP host |

Each package has its own documentation site and API reference. This repository
keeps the ecosystem narrative consistent, but package-specific details belong in
those package docs.

## Resources

| Package | Source Code | Documentation |
|---|---|---|
| `JCGECore` | <https://github.com/equicirco/JCGECore.jl> | <https://Core.JCGE.org> |
| `JCGEBlocks` | <https://github.com/equicirco/JCGEBlocks.jl> | <https://Blocks.JCGE.org> |
| `JCGERuntime` | <https://github.com/equicirco/JCGERuntime.jl> | <https://Runtime.JCGE.org> |
| `JCGECalibrate` | <https://github.com/equicirco/JCGECalibrate.jl> | <https://Calibrate.JCGE.org> |
| `JCGEOutput` | <https://github.com/equicirco/JCGEOutput.jl> | <https://Output.JCGE.org> |
| `JCGEExamples` | <https://github.com/equicirco/JCGEExamples.jl> | <https://Examples.JCGE.org> |
| `JCGEImportData` | <https://github.com/equicirco/JCGEImportData.jl> | <https://ImportData.JCGE.org> |
| `JCGEImportMPSGE` | <https://github.com/equicirco/JCGEImportMPSGE.jl> | <https://ImportMPSGE.JCGE.org> |
| `JCGEAgentInterface` | <https://github.com/equicirco/JCGEAgentInterface.jl> | <https://AgentInterface.JCGE.org> |

For agent-based use, see the [AI Agent Interface guide](guides/agents.md). The
released MCP server is registered as `io.github.equicirco/JCGEAgentInterface.jl`
and the container image is published as
`ghcr.io/equicirco/jcge-agentinterface-mcp:<release-version>`.

For solver conditions, retained accounting identities, and their reporting,
see [Closures & Checks](guides/closures.md).
