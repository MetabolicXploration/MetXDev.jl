METX_PKGS_REGISTRY = Dict(
    # MetX
    "MetX" => ("https://github.com/MetabolicXploration/MetX.jl", "main"),
    "MetXBase" => ("https://github.com/MetabolicXploration/MetXBase.jl", "main"),
    "MetXEP" => ("https://github.com/MetabolicXploration/MetXEP.jl", "main"),
    "MetXGEMs" => ("https://github.com/MetabolicXploration/MetXGEMs.jl", "main"),
    "MetXGrids" => ("https://github.com/MetabolicXploration/MetXGrids.jl", "main"),
    "MetXMC" => ("https://github.com/MetabolicXploration/MetXMC.jl", "main"),
    "MetXOptim" => ("https://github.com/MetabolicXploration/MetXOptim.jl", "main"),
    "MetXPlots" => ("https://github.com/MetabolicXploration/MetXPlots.jl", "main"),
    "ProjFlows" => ("https://github.com/MetabolicXploration/ProjFlows.jl", "main"),

    # External Tools
    "DataFileNames" => ("https://github.com/josePereiro/DataFileNames.jl", "main"),
    "FilesTreeTools" => ("https://github.com/josePereiro/FilesTreeTools.jl", "main"),
    "SimpleLockFiles" => ("https://github.com/josePereiro/SimpleLockFiles.jl", "main"),
)

function add_repos(proj::String = ""; rm = false)
    Pkg.activate(proj) do
        for (name, (url, rev)) in METX_PKGS_REGISTRY
            println("."^40)
            rm && _ignore_err(() -> Pkg.rm(name))
            _ignore_err(() -> Pkg.add(;url, rev))
        end
    end
end


function dev_repos(proj::String = ""; rm = false)
    Pkg.activate(proj) do
        for (_, (url, _)) in METX_PKGS_REGISTRY
            println("."^40)
            rm && _ignore_err(() -> Pkg.rm(name))
            _ignore_err(() -> Pkg.develop(;url))
        end
    end
end

