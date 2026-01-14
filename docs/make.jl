using Documenter

makedocs(
    sitename = "JCGE",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        assets = ["assets/custom.css", "assets/custom.js"],
        inventory_version = "dev",
    ),
    pages = [
        "Home" => "index.md",
        "Packages" => "packages.md",
        "Guides" => [
            "Modeling" => "guides/modeling.md",
            "Running Models" => "guides/running.md",
            "Blocks" => "guides/blocks.md",
            "Calibration" => "guides/calibration.md",
            "Output & Reporting" => "guides/output.md",
            "Imports" => "guides/imports.md",
        ],
    ],
)

deploydocs(
    repo = "github.com/equicirco/JCGE.jl.git",
    branch = "gh-pages",
    devbranch = "main",
)
