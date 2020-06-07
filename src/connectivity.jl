import LightGraphs


function apply_boundary_conditions_to_cm(external_indices, cm)
    cm = copy(cm)
    cm[external_indices, :] .= 0
    cm[:, external_indices] .= 0
    return cm
end


function get_inputs_from_cm(index, cm)
    [(i for i in 1:size(cm)[1] if cm[i, index])...]
end


function get_outputs_from_cm(index, cm)
    [(i for i in 1:size(cm)[1] if cm[index, i])...]
end


function causally_significant_nodes(cm)
    inputs = sum(cm, dims=1)'
    outputs = sum(cm, dims=2)
    nodes_with_inputs_and_outputs = vec((inputs .> 0) .& (outputs .> 0))
    findall(!iszero, nodes_with_inputs_and_outputs)
end


function relevant_connections(n, _from, to)
    cm = falses(n,n)
    cm[_from, to] .= true
    return cm
end


function block_cm(cm)
    if any(sum(cm; dims=2) .== 0) || all(sum(cm; dims=2) .== 1)
        return true
    end

    outputs = collect(1:size(cm)[2])

    function outputs_of(nodes)
        getindex.(findall(!iszero, sum(cm[nodes, :], dims=1)), 2)
    end

    function inputs_to(nodes)
        getindex.(findall(!iszero, sum(cm[:, nodes], dims=2)), 1)
    end

    sources = [argmax(sum(cm, dims=2))[1]]
    sinks = outputs_of(sources)
    sink_inputs = inputs_to(sinks)

    while true
        if sink_inputs == sources
            return true
        end

        sources = sink_inputs
        sinks = outputs_of(sources)
        sink_inputs = inputs_to(sinks)

        if sinks == outputs
            return false
        end
    end
end


function block_reducible(cm, nodes1, nodes2)
    if nodes1 === nothing || nodes2 === nothing
        return true
    end

    cm = cm[nodes1, nodes2]

    if !all(x->x>0, sum(cm, dims=1)) || !all(x->x>0, sum(cm, dims=2))
        return true
    end

    if length(nodes1) > 1 && length(nodes2) > 1
        return block_cm(cm)
    end

    return false
end


function is_strong(cm, nodes=nothing)
    if nodes !== nothing
        cm = cm[nodes, nodes]
    end
    return LightGraphs.is_strongly_connected(LightGraphs.SimpleDiGraph(cm))
end


function is_weak(cm, nodes=nothing)
    if nodes !== nothing
        cm = cm[nodes, nodes]
    end
    return LightGraphs.is_weakly_connected(LightGraphs.SimpleDiGraph(cm))
end


function is_full(cm, nodes1, nodes2)
    if isempty(nodes1) || isempty(nodes2)
        return true
    end

    cm = cm[nodes1, nodes2]

    return all(x->x>0, sum(cm, dims=1)) && all(x->x>0, sum(cm, dims=2))
end