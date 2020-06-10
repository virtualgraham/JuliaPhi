function validate_direction(direction::Direction, allow_bi=false)
    if direction != cause && direction != effect && !(allow_bi && direction == bidirectional)
        error("invalid direction")
    end

    return true
end

function validate_tpm()
    # TODO: implement
end