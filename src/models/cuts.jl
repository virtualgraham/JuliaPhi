abstract type AbtractCut end


mutable struct NullCut <: AbtractCut
    indices
    node_labels
end


mutable struct Cut <: AbtractCut
    from_nodes
    to_nodes
    node_labels
end


# abstract type AbtractActual end


mutable struct KCut <: AbtractCut
    direction
    partition
    node_labels
end


struct Part
    mechanism
    purview
end


struct KPartition
    parts
    node_labels
end


# abstract type Bipartition end


# abstract type Tripartition end



