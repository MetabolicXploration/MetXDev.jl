function dev_juliadev(proj::String = "")
    Pkg.activate(proj) do
        for (name, (url, rev)) in METX_PKGS_REGISTRY
            _ignore_err() do
                println("."^40)
                Pkg.develop(url)
            end
        end
    end
end