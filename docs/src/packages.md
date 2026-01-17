# Packages

This project is organized as a set of focused Julia packages. The table below
summarizes responsibilities and typical usage.

| Package | Purpose | Typical Use |
|---|---|---|
| `JCGECore` | RunSpec, sections, sets/mappings, scenarios, validation | Define model structure and constraints |
| `JCGEBlocks` | Reusable CGE blocks | Assemble production/household/market systems |
| `JCGERuntime` | Compilation and solver execution | Solve a RunSpec with Ipopt/PATH |
| `JCGECalibrate` | SAM loading and calibration | Derive parameters and starting values |
| `JCGEOutput` | Rendering and results containers | Export equations, tidy results, DualSignals |
| `JCGEExamples` | Reference models | Canonical model ports and tests |
| `JCGEImportData` | Canonical IO/SAM schema | Convert external data to CSV inputs |
| `JCGEImportMPSGE` | MPSGE.jl importer | Translate MPSGE objects to RunSpecs |
| `JCGEAgentInterface` | MCP-compatible interface for agents | Tooling for AI integrations |

Each package has its own documentation site and API reference. This repository
keeps the ecosystem narrative consistent, but package-specific details belong in
those package docs.

## Resources

- JCGECore: code https://github.com/equicirco/JCGECore.jl, docs https://equicirco.github.io/JCGECore.jl
- JCGEBlocks: code https://github.com/equicirco/JCGEBlocks.jl, docs https://equicirco.github.io/JCGEBlocks.jl
- JCGERuntime: code https://github.com/equicirco/JCGERuntime.jl, docs https://equicirco.github.io/JCGERuntime.jl
- JCGECalibrate: code https://github.com/equicirco/JCGECalibrate.jl, docs https://equicirco.github.io/JCGECalibrate.jl
- JCGEOutput: code https://github.com/equicirco/JCGEOutput.jl, docs https://equicirco.github.io/JCGEOutput.jl
- JCGEExamples: code https://github.com/equicirco/JCGEExamples.jl, docs https://equicirco.github.io/JCGEExamples.jl
- JCGEImportData: code https://github.com/equicirco/JCGEImportData.jl, docs https://equicirco.github.io/JCGEImportData.jl
- JCGEImportMPSGE: code https://github.com/equicirco/JCGEImportMPSGE.jl, docs https://equicirco.github.io/JCGEImportMPSGE.jl
- JCGEAgentInterface: code https://github.com/equicirco/JCGEAgentInterface.jl, docs https://equicirco.github.io/JCGEAgentInterface.jl
