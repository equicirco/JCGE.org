using Documenter

makedocs(
    sitename = "JCGE",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        inventory_version = "dev",
        assets = [
            "assets/favicon.ico",
            "assets/logo-theme.js",
            "assets/logo.css",
            asset(
                "https://stats.bojafa.us/script.js",
                class = :js,
                attributes = Dict(
                    :defer => "",
                    Symbol("data-website-id") => "13e68d2a-ccad-4901-b409-ceff2a689a3a",
                ),
            ),
        ],
    ),
    pages = [
        "Home" => "index.md",
        "Project" => "project.md",
        "Getting Started" => "getting-started.md",
        "Packages" => "packages.md",
        "Guides" => [
            "Modeling" => "guides/modeling.md",
            "Running Models" => "guides/running.md",
            "Blocks" => "guides/blocks.md",
            "Calibration" => "guides/calibration.md",
            "Output & Reporting" => "guides/output.md",
            "Imports" => "guides/imports.md",
        ],
        "Contact & Citation" => "contact.md",
    ],
)

deploydocs(
    repo = "github.com/equicirco/JCGE.org.git",
    branch = "gh-pages",
    devbranch = "main",
    versions = nothing,
)
