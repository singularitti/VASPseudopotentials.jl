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
    ],
)

deploydocs(;
    repo="github.com/singularitti/VASPseudopotentials.jl",
    devbranch="main",
)
