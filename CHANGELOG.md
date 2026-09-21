# JCGE Changelog
All notable changes to this project will be documented in this file.
Releases use semantic versioning as in 'MAJOR.MINOR.PATCH'.

## Change entries
Added: For new features that have been added.
Changed: For changes in existing functionality.
Deprecated: For once-stable features removed in upcoming releases.
Removed: For features removed in this release.
Fixed: For any bug fixes.
Security: For vulnerabilities.

## [B] - Unreleased
### Added
- Import-guide and package-catalogue coverage for `JCGEImportData` 0.2.0:
  released BEA, Eurostat, FIGARO, and OECD source support; normalized source
  tables; balance diagnostics; Model-D transformation; and retained source
  manifests with checksums.
- AI Agent Interface documentation for the `0.3.0` source-data guidance and
  installed-example discovery tools.
- AI Agent Interface documentation for the `0.2.0` model-lifecycle tools:
  readiness checks, controlled calibration, named studies, reporting, and
  session-scoped provenance.
- Cross-package guide for closure-condition roles and post-solution accounting
  checks, covering Core, Blocks, Runtime, and Output.
- Links and package-overview descriptions aligned with closure-aware modeling,
  solving, and reporting.
- Cross-package guidance for calibrated physical satellite quantities,
  baseline-referenced projections, and post-solution physical-balance checks.
- Documentation distinguishing reporting-only satellite quantities from
  auxiliary quantities that participate in the equilibrium system.
- Output guide coverage of validated indexed equation reports and automatic
  LaTeX layout for long relations and domains.

### Changed
- The AI Agent Interface guide now distinguishes the generic MCP server from a
  separate application host. JCGE model packages remain MCP-independent; an
  external host imports and registers only the model operations it exposes.

## [A] - 2026-01-17
### Added
- AI Agent Interface guide covering `JCGEAgentInterface`, MCP server use,
  registry naming, Docker image use, and the available service categories.
- Documentation site scaffolding with Documenter config and build setup.
- Landing page explaining JCGE scope, architecture, and ecosystem map.
- Getting Started guide covering installation and a reference model run.
- Guides for modeling, blocks, calibration, output, imports, and running workflows.
- Project overview, package listings, and contact information pages.
- Branding assets and custom theme styling for the docs site.
