mutable struct Subsystem
    network::Network
    state
    nodes
    cut
    mice_cache
    repertoire_cache
    single_node_repertoire_cache
    _external_indices

    function MaximallyIrreducibleCauseOrEffect(
        network,
        state,
        nodes=nothing,
        cut=nothing,
        mice_cache=nothing,
        repertoire_cache=nothing,
        single_node_repertoire_cache=nothing,
        _external_indices=nothing,
    )
        new(
            network,
            state,
            nodes,
            cut,
            mice_cache,
            repertoire_cache,
            single_node_repertoire_cache,
            _external_indices
        )
    end
end
