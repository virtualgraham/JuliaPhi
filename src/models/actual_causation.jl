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
    self,
    alpha,
    state,
    direction,
    mechanism,
    purview,
    partition,
    probability,
    partitioned_probability,
    node_labels

    function AcRepertoireIrreducibilityAnalysis(
        self,
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
        self,
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

get_unorderable_unless_eq(x::AcRepertoireIrreducibilityAnalysis) = [:direction]

function order_by(x::AcRepertoireIrreducibilityAnalysis)
    
end

function Base.:(==)(a::AcRepertoireIrreducibilityAnalysis, b::Orderable) 