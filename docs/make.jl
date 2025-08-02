using VASPseudopotentials
using Documenter

DocMeta.setdocmeta!(VASPseudopotentials, :DocTestSetup, :(using VASPseudopotentials); recursive=true)

makedocs(;
    modules=[VASPseudopotentials],
    authors="singularitti <singularitti@outlook.com> and contributors",
    sitename="VASPseudopotentials.jl",
    format=Documenter.HTML(;
        canonical="https://singularitti.github.io/VASPseudopotentials.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => [
            "Installation Guide" => "man/installation.md",
            "Troubleshooting" => "man/troubleshooting.md",
        ],
        "Reference" => Any[
            "Public API" => "lib/public.md",
            "Internals" => map(
                s -> "lib/internals/$(s)",
                sort(readdir(joinpath(@__DIR__, "src/lib/internals")))
            ),
        ],
        "Developer Docs" => [
            "Contributing" => "developers/contributing.md",
            "Style Guide" => "developers/style-guide.md",
            "Design Principles" => "developers/design-principles.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/singularitti/VASPseudopotentials.jl",
    devbranch="main",
)
