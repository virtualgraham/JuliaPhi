mutable struct RepertoireIrreducibilityAnalysis <: Orderable
    phi
    direction
    mechanism
    purview
    partition
    repertoire
    partitioned_repertoire
    node_labels

    function CausalLink(
        phi,
        direction,
        mechanism,
        purview,
        partition,
        repertoire,
        partitioned_repertoire,
        node_labels=nothing
    )
        new(
            phi,
            direction,
            mechanism,
            purview,
            partition,
            repertoire,
            partitioned_repertoire,
            node_labels
        )
    end
end

function null_ria(direction, mechanism, purview, repertoire=nothing, phi=0.0)
    return RepertoireIrreducibilityAnalysis(
        phi,
        direction,
        mechanism,
        purview,
        nothing,
        repertoire,
        nothing
    )
end


mutable struct MaximallyIrreducibleCauseOrEffect <: Orderable
    ria

    function MaximallyIrreducibleCauseOrEffect(
        ria
    )
        new(
            ria
        )
    end
end

# MaximallyIrreducibleCause <: MaximallyIrreducibleCauseOrEffect
# MaximallyIrreducibleEffect <: MaximallyIrreducibleCauseOrEffect

mutable struct Concept <: Orderable
    mechanism
    cause
    effect
    time
    subsystem
    node_labels
    
    function Concept(
        mechanism=nothing, 
        cause=nothing, 
        effect=nothing, 
        subsystem=nothing, 
        time=nothing
    )
        new(
            mechanism,
            cause,
            effect,
            time,
            subsystem,
            subsystem.node_labels
        )
    end
end