METX_PKGS_REGISTRY = Dict(
    # MetX
    "MetX" => ("https://github.com/MetabolicXploration/MetX.jl", "main"),
    "MetXBase" => ("https://github.com/MetabolicXploration/MetXBase.jl", "main"),
    "MetXEP" => ("https://github.com/MetabolicXploration/MetXEP.jl", "main"),
    "MetXGEMs" => ("https://github.com/MetabolicXploration/MetXGEMs.jl", "main"),
    # "MetXGrids" => ("https://github.com/MetabolicXploration/MetXGrids.jl", "main"),
    "MetXMC" => ("https://github.com/MetabolicXploration/MetXMC.jl", "main"),
    "MetXOptim" => ("https://github.com/MetabolicXploration/MetXOptim.jl", "main"),
    "MetXPlots" => ("https://github.com/MetabolicXploration/MetXPlots.jl", "main"),
    "ProjFlows" => ("https://github.com/MetabolicXploration/ProjFlows.jl", "main"),
    "MetXDev" => ("https://github.com/MetabolicXploration/MetXDev.jl", "main"),
    "RunTestsEnv" => ("https://github.com/MetabolicXploration/RunTestsEnv.jl", "main"),
    "MetXNetHub" => ("https://github.com/MetabolicXploration/MetXNetHub.jl", "main"),
    "MetXCultureHub" => ("https://github.com/MetabolicXploration/MetXCultureHub.jl", "main"),
    
    # External Tools
    "BlobBatches" => ("https://github.com/josePereiro/BlobBatches.jl", "main"),
    "DataFileNames" => ("https://github.com/josePereiro/DataFileNames.jl", "main"),
    "ContextDBs" => ("https://github.com/josePereiro/ContextDBs.jl", "main"),
    "ImgTools" => ("https://github.com/josePereiro/ImgTools.jl", "main"),
    "FilesTreeTools" => ("https://github.com/josePereiro/FilesTreeTools.jl", "main"),
    "SimpleLockFiles" => ("https://github.com/josePereiro/SimpleLockFiles.jl", "main"),
    "NDHistograms" => ("https://github.com/josePereiro/NDHistograms.jl", "main"),
    "Bloberias" => ("https://github.com/josePereiro/Bloberias.jl", "main"),
)

# just Pkg.add(;url)
function add_repos(proj::String = "", reg = METX_PKGS_REGISTRY; rm = false)
    activate(proj) do
        for (name, (url, rev)) in reg
            println("."^40)
            @show name
            rm && _ignore_err(() -> Pkg.rm(name))
            _ignore_err(() -> Pkg.add(;url, rev))
        end
    end
end

# the equivalent to git pull + dev(pkg)
function dev_repos(proj::String = "", reg = METX_PKGS_REGISTRY; rm = false, devlocal = true)
    activate(proj) do
        for (name, (url, _)) in reg
            println("."^40)
            @show name
            rm && _ignore_err(() -> Pkg.rm(name))
            # try pull first
            dir = joinpath(Pkg.devdir(), name)
            isdir(dir) || _ignore_err(() -> Pkg.develop(;url))
            # dev local path
            devlocal && _ignore_err(() -> Pkg.develop(;name))
        end
    end
end

# Assumes repos are at dev
# git status at dev/pkg
function gitst_devrepos(dev = Pkg.devdir(), reg = METX_PKGS_REGISTRY; dostep = false)
    for name in keys(reg)
        dirs = joinpath.([dev], [name, string(name, ".jl")])
        for dir in dirs
            println("."^40)
            @show dir
            if !isdir(dir) 
                @warn("Dir not found", dir)
                continue
            end
            _ignore_err() do
                cd(dir) do
                    cmd = Cmd(`git status`; ignorestatus = true)
                    println(read(cmd, String))
                end
            end
            break
        end
        dostep && readline()
    end
end

# Assumes repos are at dev
function resolve_devrepos(dev = Pkg.devdir(), reg = METX_PKGS_REGISTRY)
    for name in keys(reg)
        dirs = joinpath.([dev], [name, string(name, ".jl")])
        for dir in dirs
            println("."^40)
            @show dir
            if !isdir(dir) 
                @warn("Dir not found", dir)
                continue
            end
            activate(dir) do
                _ignore_err() do
                    Pkg.resolve()
                end
            end
            break
        end
    end
end

# Assumes repos are at dev
function instantiate_devrepos(dev = Pkg.devdir(), reg = METX_PKGS_REGISTRY)
    for name in keys(reg)
        dirs = joinpath.([dev], [name, string(name, ".jl")])
        for dir in dirs
            println("."^40)
            @show dir
            if !isdir(dir) 
                @warn("Dir not found", dir)
                continue
            end
            activate(dir) do
                _ignore_err() do
                    Pkg.instantiate()
                end
            end
            break
        end
    end
end

