@enum Direction begin
    cause = 0
    effect = 1
    bidirectional = 2
end

function order(direction::Direction, mechanism, purview)
    if direction == cause
        return purview, mechanism
    elseif direction == effect
        return mechanism, purview
    end

    validate_direction(direction)
end
