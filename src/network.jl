using JSON

mutable struct Network
    tpm
    tpm_hash
    cm
    cm_hash
    node_indices
    node_labels
    purview_cache


    function Network(tpm; cm=nothing, node_labels=nothing, purview_cache=nothing)
        _tpm, _tpm_hash = build_tpm(tpm)
        _cm, _cm_hash = build_cm(cm)
        _node_indices = tupple(1:last(size(network.tpm)...))
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


function build_tpm(tpm::AbstractArray)
    
end


Base.length(network::Network) = last(size(network.tpm))

Base.hash(network::Network) = hash((network.tpm_hash, network.cm_hash))

Base.show(io::IO, network::Network) = println(io, "Network($(network.tpm), cm=$(network.cm))")

Base.:(==)(a::Network, b::Network) = a.tpm == b.tpm && a.cm == b.cm

JSON.lower(network::Network) = Dict(
    "tpm" => network.tpm,
    "cm" => network.cm,
    "size" => network.size,
    "node_labels" => network.node_labels,
)
