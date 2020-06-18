module JuliaPhi


############
# Utils
############
include("utils.jl")



include("config.jl")


############
# Models
############
include("models/cmp.jl")
include("models/cuts.jl")
include("models/actual_causation.jl")
include("models/mechanism.jl")
include("models/subsystem.jl")

############
# 
############
include("direction.jl")
include("tpm.jl")
include("connectivity.jl")
include("convert.jl")
include("cache.jl")
include("labels.jl")
include("validate.jl")

############
# 
############
include("network.jl")


############
# 
############
const EPSILON = nothing
const FILESYSTEM = "fs"
const DATABASE = "db"
# const PICKLE_PROTOCOL = pickle.HIGHEST_PROTOCOL
const joblib_memory = nothing
const OFF = (0,)
const ON = (1,)



export 

# connectivity.jl
apply_boundary_conditions_to_cm, get_inputs_from_cm, get_outputs_from_cm,
causally_significant_nodes, relevant_connections, block_cm, block_reducible, is_strong, 
is_weak, is_full,

# utils.jl
approxeq,

# direction.jl
Direction, order,

# validate.jl
validate_direction, validate_tpm,

# tpm.jl"
is_state_by_state,

# convert.jl
to_2dimensional, le_index2state, be_index2state, state2le_index, to_multidimensional,
state_by_state2state_by_node, state_by_node2state_by_state

end # module