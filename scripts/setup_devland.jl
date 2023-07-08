import Pkg

## ------------------------------------------------------------------
include("metx_base.jl")

## ------------------------------------------------------------------
# add registries
let
    println("\n\n")
    println("="^60)
    println("ADDING REGISTRIES")

    try
    
        url = string(METX_ORG_URL, "/", "MetX_Registry_jl")
        Pkg.Registry.add(Pkg.RegistrySpec(;url))
        url = "https://github.com/FF-UH/CSC_Registry.jl"
        Pkg.Registry.add(Pkg.RegistrySpec(;url))
        
    catch e
        showerror(stdout, e)
    end
end

## ------------------------------------------------------------------
# try download to Pkg.pkgdir
let
    println("\n\n")
    println("="^60)
    println("DOWNLOADING")
    
    for pkgname in MET_X_PKG_NAMES
        
        try

            pkgdir = joinpath(Pkg.devdir(), pkgname)
            url = string(METX_ORG_URL, "/", pkgname, ".jl")
            
            println()
            println("."^60)
            println()
            @info("Doing", pkgname, url, pkgdir)
            println()
            
            if isdir(pkgdir) 
                @info("Package already downloaded")
                continue
            end

            # Download
            run(`git clone $(url) $(pkgdir)`)

        catch e
            showerror(stdout, e)
        end

    end # for pkgname in MET_X_PKG_NAMES
end

## ------------------------------------------------------------------
# try to pull
let
    
    println("\n\n")
    println("="^60)
    println("PULLING")

    for pkgname in MET_X_PKG_NAMES
        
        try
            pkgdir = joinpath(Pkg.devdir(), pkgname)
            url = joinpath(METX_ORG_URL, string(pkgname, ".jl"))
            
            println()
            println("."^60)
            println()
            @info("Doing", pkgname, url, pkgdir)
            println()
            
            mkpath(pkgdir)
            cd(pkgdir) do

                if !success(`git diff --quiet`)
                    @warn("Package repo is dirty")
                    println()
                    run(`git -C $(pkgdir) status`)
                    
                    println()
                    @info("Trying pull --ff-only")
                    println()

                    if success(`git -C $(pkgdir) pull --ff-only`)
                        println()
                        @info("pull --ff-only OK")
                    else
                        println()
                        @warn("pull --ff-only Failed")
                    end
                else
                    # Pull
                    if success(`git -C $(pkgdir) pull`)
                        println()
                        @info("pull OK")
                    else
                        println()
                        @info("pull Failed")
                    end
                end
            end

        catch e
            showerror(stdout, e)
        end

    end # for pkgname in MET_X_PKG_NAMES
end

## ------------------------------------------------------------------
# Dev in home pkg
let
    println("\n\n")
    println("="^60)
    println("DEV IN HOME")

    Pkg.activate()
    for pkgname in MET_X_PKG_NAMES

        try
            println()
            println("."^60)
            println()
            @info("Doing", pkgname)
            println()
            
            Pkg.develop(pkgname)
            
            println()

        catch e
            showerror(stdout, e)
        end

    end # for pkgname in MET_X_PKG_NAMES
end

## ------------------------------------------------------------------
# Dev cross-dependencies
function _get_deps(projtoml) 
    tomldict = Pkg.TOML.parsefile(projtoml)
    return get(tomldict, "deps", Dict()) |> keys |> collect
end

let
    println("\n\n")
    println("="^60)
    println("DEV CROSS DEPENDENCIES")

    Pkg.activate()
    for pkgname in MET_X_PKG_NAMES

        try

            pkgdir = joinpath(Pkg.devdir(), pkgname)
            projtoml = joinpath(pkgdir, "Project.toml")
            
            if !isfile(projtoml) 
                @warn("Project.Toml no found. Skipping", projtoml)
                continue
            end
            
            println()
            println("."^60)
            println()
            @info("Doing", pkgname, projtoml)
            println()
            
            Pkg.activate(projtoml)
            println()
            Pkg.status()
            println()

            deps = _get_deps(projtoml)

            for pkgname1 in MET_X_PKG_NAMES
                (pkgname1 == pkgname) && continue
                (pkgname1 in deps) || continue

                Pkg.develop(pkgname1)
                println()
            end

            # instantiate
            println()
            Pkg.instantiate()
            println()
        
        catch e
            showerror(stdout, e)
        end

    end # for pkgname in MET_X_PKG_NAMES

end

## ------------------------------------------------------------------
println("\n\n")
println("="^60)
println("DONE!!! ENJOY")
println("\n\n")


