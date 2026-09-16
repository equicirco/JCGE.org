# AI Agent Interface

`JCGEAgentInterface` is the JCGE entry point for AI assistants and other
Model Context Protocol (MCP) clients. It exposes a standard stdio MCP server
over JCGE services, so agents can discover the active JCGE environment, inspect
available modeling components, guide model development, and work with explicitly
exposed model workflows. These workflows can include calibration, named
scenarios or experiments, solving, validation, reporting, and study provenance.

The package-level documentation is available at <https://AgentInterface.JCGE.org>.

## What the Agent Interface Provides

The interface is designed around JCGE's model-as-code approach. It helps users
work with explicit Julia models rather than replacing the economic modeling
decision.

It currently provides services for:

- discovering installed JCGE package versions and capabilities;
- listing and describing reusable `JCGEBlocks` components;
- guiding model development, formulation choice, solver choice, calibration, and
  reporting;
- updating released JCGE packages in the active Julia environment when requested;
- checking registered-model readiness and compatible JCGE package versions;
- running model-defined calibration checks, scenarios, experiments, and reports;
- solving registered `RunSpec` models through `JCGERuntime`, validating solved
  model contexts, and rendering equations and output artifacts through
  `JCGEOutput`;
- returning session-scoped, structured provenance for model studies.

The interface does not automatically create a complete CGE model, choose the
right closure, fetch arbitrary external data, or decide the economic theory for
the user. Those choices remain part of the model source.

## Choose How to Use the Server

For JCGE discovery and development guidance, configure the released MCP server
in an MCP client. The package need not be installed by, imported by, or added
as a dependency of a JCGE model package.

To run a model through MCP, use a **separate MCP host environment**. That host
depends on both `JCGEAgentInterface` and the model package, imports them, and
registers only the model operations that should be available to an agent. The
model package remains an ordinary, MCP-independent Julia package.

Install the interface in that separate host environment:

```julia
import Pkg
Pkg.add("JCGEAgentInterface")
```

The host starts the server with a context containing its selected model
registrations:

```julia
using JCGEAgentInterface

ctx = AgentContext()
# The host registers selected model constructors or ModelAdapter workflows here.
serve(transport = :mcp_stdio; ctx = ctx)
```

The MCP client connects to that host process; it does not import Julia packages
itself. In particular, the server does not search arbitrary folders or execute
arbitrary Julia provided by the client.

For a guidance-only MCP client configuration, the released package can be
launched directly from a Julia environment containing the interface:

```sh
julia --project=/path/to/mcp-host -e 'using JCGEAgentInterface; serve(transport=:mcp_stdio)'
```

The plain server starts with no application models. It can solve only models
registered in its running `AgentContext`; model-specific calibration, studies,
and reporters additionally require a declared `ModelAdapter` in the separate
host.

## Use the Registered MCP Server

The release workflow publishes a versioned container image to GitHub Container
Registry and registers the server in the
[official MCP Registry](https://registry.modelcontextprotocol.io/?q=io.github.equicirco%2FJCGEAgentInterface.jl)
under:

```text
io.github.equicirco/JCGEAgentInterface.jl
```

The container image has the form:

```text
ghcr.io/equicirco/jcge-agentinterface-mcp:<release-version>
```

MCP clients that support registry discovery can use the registered server name.
The container can also be run directly as a stdio server:

```sh
docker run --rm -i ghcr.io/equicirco/jcge-agentinterface-mcp:<release-version>
```

The plain container is useful for discovery and guidance tools. Running a
project-specific model requires a separate host that imports the model and
registers its selected public workflows with the server. This does not require
the model package itself to depend on the agent interface.

## Main Tools

The MCP tool surface includes:

| Tool | Purpose |
|:---|:---|
| `jcge_capabilities` | Discover JCGE package capabilities and versions. |
| `jcge_list_blocks` | List reusable block helpers grouped by model component. |
| `jcge_describe_block` | Describe one block helper or block type. |
| `jcge_modeling_guide` | Guide the JCGE model-development workflow. |
| `jcge_formulation_guide` | Guide equality, inequality, MCP/complementarity, and optimization-style formulations. |
| `jcge_solver_guide` | Guide solver choice and diagnostics. |
| `jcge_calibration_guide` | Guide currently available calibration workflows. |
| `jcge_reporting_guide` | Guide generated equation and results reporting. |
| `jcge_package_status` | Report installed and loaded JCGE package versions. |
| `jcge_update_packages` | Dry-run or apply updates for released JCGE packages. |
| `jcge_list_models` | List registered models. |
| `jcge_load_model` | Load a registered model by name. |
| `jcge_model_status` | Inspect model compatibility, lifecycle state, and safe next actions without running it. |
| `jcge_calibrate_model` | Run a registered model's declared calibration workflow with structured inputs. |
| `jcge_check_calibration` | Run the model-defined diagnostic for the current calibration artifact. |
| `jcge_run_scenario` | Run one declared model scenario with checked parameters. |
| `jcge_run_experiment` | Run one declared model experiment with checked parameters. |
| `jcge_solve` | Solve a loaded or named model. |
| `jcge_validate_model` | Validate the last solved context. |
| `jcge_run_reporter` | Return a declared, model-specific report from a solve or workflow result. |
| `jcge_render_model` | Render equations, blocks, or symbols. |
| `jcge_export_results` | Return tidy results from the last solve. |
| `jcge_provenance` | Return ordered, session-scoped study provenance records. |

See the package documentation for the complete action API and current limits:
<https://AgentInterface.JCGE.org>.
