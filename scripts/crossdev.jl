## -.. -.-.- ----.. -..- .-..- --...-. -. -. .-... -
let
    import Pkg
    import MetXDev
    import MetXDev: _pull_clone, _ignore_err
    import TOML
end

## -.. -.-.- ----.. -..- .-..- --...-. -. -. .-... -
# TODO: move to package
_REGISTRY = [
    # MetX
    ("MetXDev", "https://github.com/MetabolicXploration/MetXDev.jl", "main"),
    ("MetXBase", "https://github.com/MetabolicXploration/MetXBase.jl", "main"),
    ("MetXGEMs", "https://github.com/MetabolicXploration/MetXGEMs.jl", "main"),
    ("MetXOptim", "https://github.com/MetabolicXploration/MetXOptim.jl", "main"),
    ("MetXNetHub", "https://github.com/MetabolicXploration/MetXNetHub.jl", "main"),
    ("MetXEP", "https://github.com/MetabolicXploration/MetXEP.jl", "main"),
    
    # # ("MetXGrids", "https://github.com/MetabolicXploration/MetXGrids.jl", "main"),
    # # ("MetXPlots", "https://github.com/MetabolicXploration/MetXPlots.jl", "main"),
    ("MetXMC", "https://github.com/MetabolicXploration/MetXMC.jl", "main"),
    ("MetXCultureHub", "https://github.com/MetabolicXploration/MetXCultureHub.jl", "main"),
    ("MetX", "https://github.com/MetabolicXploration/MetX.jl", "main"),
    
    # External Tools
    ("RunTestsEnv", "https://github.com/MetabolicXploration/RunTestsEnv.jl", "main"),
    ("DataFileNames", "https://github.com/josePereiro/DataFileNames.jl", "main"),
    ("FilesTreeTools", "https://github.com/josePereiro/FilesTreeTools.jl", "main"),
    ("SimpleLockFiles", "https://github.com/josePereiro/SimpleLockFiles.jl", "main"),
    ("BlobBatches", "https://github.com/josePereiro/BlobBatches.jl", "main"),
    ("ContextDBs", "https://github.com/josePereiro/ContextDBs.jl", "main"),
    ("ImgTools", "https://github.com/josePereiro/ImgTools.jl", "main"),
    ("ProjFlows", "https://github.com/MetabolicXploration/ProjFlows.jl", "main"),
    ("NDHistograms", "https://github.com/josePereiro/NDHistograms.jl", "main"),
    
]

## -.. -.-.- ----.. -..- .-..- --...-. -. -. .-... -
# 1. pull repos to dev
# 2. delete dev repos Manifest.toml
# 3. backup dev repos Project.toml
# 4. add/dev all deps depending is they are at dev folder or not

## -.. -.-.- ----.. -..- .-..- --...-. -. -. .-... -
# function _pullclone()

## -.. -.-.- ----.. -..- .-..- --...-. -. -. .-... -
# # reset dev
# let
#     juldir = joinpath(homedir(), ".julia")
#     dev = joinpath(juldir, "dev")
#     for (name, url, rev) in _REGISTRY
#         name == "MetXDev" && continue
#         pkgdir = joinpath(dev, name)
#         isdir(pkgdir) || continue
#         @show name
#         rm(pkgdir; force = true, recursive = true)
#     end
#     # compiled = joinpath(juldir, ".compiled")
#     # rm(compiled; force = true, recursive = true)
# end

## -.. -.-.- ----.. -..- .-..- --...-. -. -. .-... -
let
    dev = Pkg.devdir()
    
    # 1. pull repos to dev
    for (name, url, rev) in _REGISTRY
        name == "MetXDev" && continue
        println("="^30)
        @show name
        pkgdir = joinpath(dev, name)
        _pull_clone(name, url, pkgdir; force = false)
    end
    
    # # 2. delete dev repos Manifest.toml
    # for (name, url, rev) in _REGISTRY
    #     name == "MetXDev" && continue
    #     pkgdir = joinpath(dev, name)
    #     manfile = joinpath(pkgdir, "Manifest.toml")
    #     rm(manfile; force = true)
    # end

    # 3. backup dev repos Project.toml
    # 4. add/dev all deps depending is they are at dev folder or not
    ENV["JULIA_PKG_PRECOMPILE_AUTO"] = 0
    while true
        _ERROR = false
        for (name, url, rev) in _REGISTRY
            name == "MetXDev" && continue
            println("="^30)
            @show name
            pkgdir = joinpath(dev, name)
            projfile = joinpath(pkgdir, "Project.toml")
            toml = TOML.parsefile(projfile)
            deps = get(toml, "deps", Dict())
            
            Pkg.activate(pkgdir) do
                for (pkg, uuid) in deps
                    devpath = joinpath(dev, pkg)
                    println("-"^20)
                    @show pkg
                    try
                        isdir(devpath) ? Pkg.develop(;path=devpath) : Pkg.add(pkg)
                    catch e
                        _ERROR = true
                        e isa InterruptException && rethrow(e)
                        showerror(stdout, e)
                    end
                end
            end
        end # for (name, url, rev) 
        !_ERROR && break
    end # while true

    # 5. precompile
    for (name, url, rev) in _REGISTRY
        name == "MetXDev" && continue
        println("="^30)
        @show name
        pkgdir = joinpath(dev, name)
        Pkg.activate(pkgdir) do
            _ignore_err() do
                Pkg.precompile()
            end
        end
    end
end

## -.. -.-.- ----.. -..- .-..- --...-. -. -. .-... -
