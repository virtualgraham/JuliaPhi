const _acria_attributes = [
    "alpha",
    "state",
    "direction",
    "mechanism",
    "purview",
    "partition",
    "probability",
    "partitioned_probability",
]


const _acria_attributes_for_eq = [
    "alpha",
    "state",
    "direction",
    "mechanism",
    "purview",
    "probability",
]


greater_than_zero(alpha) = alpha > 0 && !approxeq(alpha, 0)


mutable struct AcRepertoireIrreducibilityAnalysis <: Orderable
    alpha
    state
    direction
    mechanism
    purview
    partition
    probability
    partitioned_probability
    node_labels

    function AcRepertoireIrreducibilityAnalysis(
        alpha,
        state,
        direction,
        mechanism,
        purview,
        partition,
        probability,
        partitioned_probability,
        node_labels=nothing,
    )
        new(
            alpha,
            state,
            direction,
            mechanism,
            purview,
            partition,
            probability,
            partitioned_probability,
            node_labels
        )
    end
end


get_unorderable_unless_eq(x::AcRepertoireIrreducibilityAnalysis) = [:direction]


function order_by(x::AcRepertoireIrreducibilityAnalysis)
    if configuration.PICK_SMALLEST_PURVIEW
        return [x.alpha, length(x.mechanism), -length(x.purview)]
    end
    return [x.alpha, length(x.mechanism), length(x.purview)]
end


(==)(a::AcRepertoireIrreducibilityAnalysis, b::Orderable) = general_eq(a, b, _acria_attributes_for_eq)


phi(a::AcRepertoireIrreducibilityAnalysis) = a.alpha


function null_ac_ria(state, direction, mechanism, purview, partition=nothing)
    return AcRepertoireIrreducibilityAnalysis(
        0.0,
        state,
        direction,
        mechanism,
        purview,
        partition,
        nothing,
        nothing
    )
end


mutable struct CausalLink <: Orderable
    ria
    extended_purview

    function CausalLink(
        ria,
        extended_purview=nothing
    )
        new(
            ria,
            extended_purview
        )
    end
end


mutable struct Event
    actual_cause
    actual_effect
end


mutable struct Account <: Orderable
    causal_links

    function Account(
        causal_links
    )
        new(
            causal_links
        )
    end
end


# DirectedAccount

_ac_sia_attributes = [
    "alpha",
    "direction",
    "account",
    "partitioned_account",
    "transition",
    "cut",
]


mutable struct AcSystemIrreducibilityAnalysis <: Orderable
    alpha
    direction
    account
    partitioned_account
    transition
    cut

    function AcSystemIrreducibilityAnalysis(
        alpha=nothing,
        direction=nothing,
        account=nothing,
        partitioned_account=nothing,
        transition=nothing,
        cut=nothing,
    )
        new(
            alpha,
            direction,
            account,
            partitioned_account,
            transition,
            cut
        )
    end
end

get_unorderable_unless_eq(x::AcSystemIrreducibilityAnalysis) = [:direction]

function order_by(x::AcSystemIrreducibilityAnalysis)
    return [x.alpha, length(x.transition)]
end


(==)(a::AcSystemIrreducibilityAnalysis, b::Orderable) = general_eq(a, b, _ac_sia_attributes)

function null_ac_sia(transition, direction, alpha=0.0)
    return AcSystemIrreducibilityAnalysis(
        alpha,
        direction,
        (),
        (),
        transition
    )
end