module MetXDev


    import Pkg
    import Pkg: RegistrySpec
    import Pkg: PackageSpec

    #! include .
    include("gitcmds.jl")
    include("juliadev.jl")
    include("registries.jl")
    include("repos.jl")
    include("utils.jl")

end
