# dev all repos (urls) on the registry
function dev_juliadev(proj::String = "", reg = METX_PKGS_REGISTRY)
    Pkg.activate(proj) do
        for (name, (url, rev)) in reg
            _ignore_err() do
                println("."^40)
                Pkg.develop(url)
            end
        end
    end
end