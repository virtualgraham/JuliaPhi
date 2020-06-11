function validate_direction(direction::Direction, allow_bi=false)
    if direction != cause && direction != effect && !(allow_bi && direction == bidirectional)
        error("invalid direction")
    end

    return true
end


function validate_tpm(tpm::AbstractArray, check_independence=true)
    N = last(size(tpm))

    if ndims(tpm) == 2
        if (size(tpm)[1] == 2^N && size(tpm)[2] == N) || (size(tpm)[1] == size(tpm)[2])
            error("""
                Invalid shape for 2-D TPM: $(size(tpm))
                For a state-by-node TPM, there must be  2^N rows and N columns, 
                where N is the number of nodes. State-by-state TPM must be square. 
            """)
        end
        if size(tpm)[1] == size(tpm)[2] && check_independence
            validate_conditionally_independent(tpm)
        end
    elseif ndims(tpm) == N + 1
        if size(tpm) != push!(repeat([2], N), N)
            error("""
                Invalid shape for multidimensional state-by-node TPM ($size(tpm))
                The shape should be $(push!(repeat([2], N), N)) for $N nodes.
            """)
        end
    else 
        error("""
            Invalid TPM: Must be either 2-dimensional or multidimensional.
        """)
    end

    return true
end


function validate_conditionally_independent(tpm::AbstractArray)
    if is_stat_by_state(tpm)
        there_and_back_agian = state_by_node2state_by_state(state_by_state2state_by_node(tpm))
    else
        there_and_back_agian = state_by_state2state_by_node(state_by_node2state_by_state(tpm))
    end

    if !all(x->x<1e-08, tpm .- there_and_back_agian)
        error("""
            TPM is not conditionally independent.
            See the conditional independence example in the documentation for more info.
        """)
    end

    return true
end