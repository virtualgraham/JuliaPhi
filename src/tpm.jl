function is_state_by_state(tpm::AbstractArray)
    return ndims(tpm) == 2 && size(tpm)[1] == size(tpm)[2]
end

function is_deterministic(tpm::AbstractArray)
    return all(x -> x == 1 || x == 0, tpm)
end