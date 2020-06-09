mutable struct CauseEffectStructure <: Orderable
    concepts
    subsystem
    time

    function CauseEffectStructure(
        concepts=(),
        subsystem=nothing,
        time=nothing,
    )
        new(
            concepts,
            subsystem,
            time
        )
    end
end


mutable struct SystemIrreducibilityAnalysis <: Orderable
    phi
    ces
    partitioned_ces
    subsystem
    cut_subsystem
    time

    function SystemIrreducibilityAnalysis(
        phi=nothing,
        ces=nothing,
        partitioned_ces=nothing,
        subsystem=nothing,
        cut_subsystem=nothing,
        time=nothing,
    )
        new(
            phi,
            ces,
            partitioned_ces,
            subsystem,
            cut_subsystem,
            time
        )
    end
end


function null_ces(subsystem)
    return CauseEffectStructure(
        (),
        subsystem
    )
end

function null_sia(subsystem, phi=0.0)
    return SystemIrreducibilityAnalysis(
        phi,
        null_ces(subsystem),
        null_ces(subsystem),
        subsystem,
        subsystem,
    )
end