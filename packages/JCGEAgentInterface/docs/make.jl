using Documenter
using JCGEAgentInterface

makedocs(
    sitename = "JCGEAgentInterface",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        assets = ["assets/logo-theme.js", "assets/jcge_agentinterface_logo_light.png", "assets/jcge_agentinterface_logo_dark.png"],
        logo = "assets/jcge_agentinterface_logo_light.png",
        logo_dark = "assets/jcge_agentinterface_logo_dark.png",
    ),
    pages = [
        "Home" => "index.md",
        "Usage" => "usage.md",
        "API" => "api.md",
    ],
)


deploydocs(
    repo = "github.com/equicirco/JCGEAgentInterface.jl",
    versions = ["stable" => "v^", "v#.#", "dev" => "dev"],
)
