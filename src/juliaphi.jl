module JuliaPhi

include("utils.jl")

include("connectivity.jl")
include("convert.jl")
include("cache.jl")
include("labels.jl")
include("validate.jl")

include("network.jl")

export apply_boundary_conditions_to_cm, get_inputs_from_cm, get_outputs_from_cm,
causally_significant_nodes, relevant_connections, block_cm, block_reducible, is_strong, 
is_weak, is_full


end # module