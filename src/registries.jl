METX_PKGS_REGISTRIES_REGISTRY = Dict(
    "MetX_Registry_jl" => ("https://github.com/MetabolicXploration/MetX_Registry_jl", "main"),
    "CSC_Registry" => ("https://github.com/FF-UH/CSC_Registry.jl", "main"),
)

function add_registries()
    for (_, (url, _)) in METX_PKGS_REGISTRIES_REGISTRY
        _ignore_err() do
            println("."^40)
            Pkg.Registry.add(RegistrySpec(url))
        end
    end
end