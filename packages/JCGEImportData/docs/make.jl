using Documenter
using JCGEImportData

makedocs(
    sitename = "JCGEImportData",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        assets = ["assets/logo-theme.js", "assets/jcge_importdata_logo_light.png", "assets/jcge_importdata_logo_dark.png"],
        logo = "assets/jcge_importdata_logo_light.png",
        logo_dark = "assets/jcge_importdata_logo_dark.png",
    ),
    pages = [
        "Home" => "index.md",
        "Usage" => "usage.md",
        "API" => "api.md",
    ],
)


deploydocs(
    repo = "github.com/equicirco/JCGEImportData.jl",
    versions = ["stable" => "v^", "v#.#", "dev" => "dev"],
)
