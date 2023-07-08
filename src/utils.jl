_isa(x, T::DataType) = isa(x, T)
_isa(x, T) = isa(x, typeof(T))


function _ignore_err(f::Function; except = [InterruptException])
    try
        return f()
    catch e
        any(_isa.([e], except)) && rethrow(e)
        showerror(stdout, e)
    end
    return nothing
end

import Pkg.activate
function Pkg.activate(f::Function, proj::String; kwargs...)
    proj0 = Base.active_project()
    try
        isempty(proj) || Pkg.activate(proj; kwargs...)
        f()
    finally
        proj = Base.active_project()
        proj != proj0 && Pkg.activate(proj0)
    end
end
