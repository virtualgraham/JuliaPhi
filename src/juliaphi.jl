module JuliaPhi

include("utils.jl")

include("connectivity.jl")
include("convert.jl")
include("cache.jl")
include("labels.jl")
include("validate.jl")

include("network.jl")

const EPSILON = nothing
const FILESYSTEM = "fs"
const DATABASE = "db"
# const PICKLE_PROTOCOL = pickle.HIGHEST_PROTOCOL
const joblib_memory = nothing
const OFF = (0,)
const ON = (1,)

export apply_boundary_conditions_to_cm, get_inputs_from_cm, get_outputs_from_cm,
causally_significant_nodes, relevant_connections, block_cm, block_reducible, is_strong, 
is_weak, is_full,

approxeq


end # module