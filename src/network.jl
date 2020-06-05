using JSON

mutable struct Network
    tpm::AbstractArray{Float64}
    tpm_hash::UInt
    cm::AbstractMatrix{Bool}
    cm_hash::UInt
    node_indices
    node_labels
    purview_cache


    function Network(tpm; cm=nothing, node_labels=nothing, purview_cache=nothing)
        _tpm, _tpm_hash = build_tpm(tpm)
        size = last(size(_tpm))
        _cm, _cm_hash = build_cm(cm, size)
        _node_indices = tuple(1:size...)
        _node_labels = NodeLabels(node_labels, _node_indices)
        _purview_cache = if purview_cache !== nothing purview_cache else PurviewCache() end

        new(
            _tpm,
            _tpm_hash,
            _cm,
            _cm_hash,
            _node_indices,
            _node_labels,
            _purview_cache
        )
    end

end


function build_tpm(tpm::AbstractArray{Float64})
    validate_tpm(tpm)

    if is_state_by_state(tpm) 
        tpm = state_by_state2state_by_node(tpm)
    else
        tpm = to_multidimensional(tpm)
    end

    # np_immutable(tpm)

    return (tpm, hash(tpm))
end


function build_cm(cm::Union{Nothing, AbstractMatrix{Bool}}, size::Integer)
    if cm === nothing
        cm = ones(size, size)
    end

    # np_immutable(cm)

    return (cm, hash(cm))
end


Base.length(network::Network) = last(size(network.tpm))

Base.size(network::Network) = length(network)

Base.hash(network::Network) = hash((network.tpm_hash, network.cm_hash))

Base.show(io::IO, network::Network) = println(io, "Network($(network.tpm), cm=$(network.cm))")

Base.:(==)(a::Network, b::Network) = a.tpm == b.tpm && a.cm == b.cm

JSON.lower(network::Network) = Dict(
    "tpm" => network.tpm,
    "cm" => network.cm,
    "size" => size(network),
    "node_labels" => network.node_labels,
)
