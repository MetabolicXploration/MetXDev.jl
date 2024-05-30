# Assumes repos are at dev
function push_devrepos(dev = Pkg.devdir(), reg = METX_PKGS_REGISTRY)
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
                    cmd = Cmd(`git push`; ignorestatus = true)
                    println(read(cmd, String))
                end
            end
            break
        end
    end
end

# Assumes repos are at dev
# git pull att dev/pkg
function pull_devrepos(dev = Pkg.devdir(), reg = METX_PKGS_REGISTRY)
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
                    cmd = Cmd(`git pull`; ignorestatus = true)
                    println(read(cmd, String))
                end
            end
            break
        end
    end
end

function _pull_clone(
        name, url, 
        pkgdir = joinpath(Pkg.devdir(), name);
        force = false # force clone
    )
    force && rm(pkgdir; force = true, recursive = true)
    if isdir(pkgdir)
        cd(pkgdir) do
            @show pkgdir
            cmd = Cmd(`git pull`; ignorestatus = true)
            println(read(cmd, String))
        end
    else
        mkpath(pkgdir)
        cd(pkgdir) do
            cmd = ["git", "clone", url, "."]
            cmd = Cmd(Cmd(cmd); ignorestatus = true)
            println(read(cmd, String))
        end
    end
end
