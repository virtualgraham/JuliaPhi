

function apply_boundary_conditions_to_cm(external_indices::AbstractVector, cm::AbstractMatrix{Bool})
    _cm = copy(cm)
    _cm[external_indices, :] .= 0
    _cm[:, external_indices] .= 0
    return cm
end


function get_inputs_from_cm(index::Integer, cm::AbstractMatrix{Bool})
    tuple((i for i in 1:size(cm)[1] if cm[i, index])...)
end


function get_outputs_from_cm(index::Integer, cm::AbstractMatrix{Bool})
    tuple((i for i in 1:size(cm)[1] if cm[index, i])...)
end


function causally_significant_nodes(cm::AbstractMatrix{Bool})
    inputs = sum(cm, 1)
    outputs = sum(cm, 2)
    nodes_with_inputs_and_outputs = (inputs .> 0) .& (outputs .> 0)
    tuple(findall(x -> x > 0, nodes_with_inputs_and_outputs)...)
end


function relevant_connections(n, _from, to)
    cm = falses(n,n)
    cm[_from, to] .= true
    return cm
end