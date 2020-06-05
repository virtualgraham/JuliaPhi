module JuliaPhi

include("utils.jl")

include("connectivity.jl")
include("convert.jl")
include("cache.jl")
include("labels.jl")
include("validate.jl")

include("network.jl")

export get_inputs_from_cm

end # module