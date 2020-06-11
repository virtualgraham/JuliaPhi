function state_by_state2state_by_node(tpm::AbstractArray)
    S = last(size(tpm))
    N = Integer(floor(log2(S)))

    sbn_tpm = zeros(push!(repeat([2], N), N)...)

    states = Dict(i => le_index2state(i, N) for i in 1:S)

    node_on = [[states[i][n] for i in 1:S] for n in 1:N]
    on_probabilities = [tpm * node_on[n] for n in 1:N]
    for (i, state) in states
        sbn_tpm[state] = [sum(on_probabilities[n][i]) for n in 1:N]
    end

    return sbn_tpm
end


function state_by_node2state_by_state(tpm::AbstractArray)
    # TODO: implement
end


function to_multidimensional(tpm::AbstractArray)
    # TODO: implement
end


function to_2dimensional(tpm::AbstractArray)
    S = prod(size(tpm)[1:end-1])
    N = last(size(tpm))
    return reshape(tpm, (S, N))
end


function le_index2state(i, number_of_nodes) 
    collect((i >> n) & 1 for n in 0:number_of_nodes-1)
end


function be_index2state(i, number_of_nodes) 
    reverse(le_index2state(i, number_of_nodes))
end



function state2le_index(state)
    parse(Int, join(string(n) for n in state[end:-1:1]); base=2)
end


function _deterministic_sbn2sbs(Sp, Sn, sbn_tpm)
    sbs_tpm = zeros(Sp, Sn)
    for previous_state_index in 1:Sp
        current_state_index = state2le_index(sbn_tpm[previous_state_index])
        sbs_tpm[previous_state_index, current_state_index] = 1
    end
    return sbs_tpm
end



function _nondeterministic_sbn2sbs(Nn, Sn, sbn_tpm)
    unfolded = [_unfold_nodewise_probabilities(Nn, Sn, row) for row in sbn_tpm]
end


function _unfold_nodewise_probabilities(Nn, Sn, sbn_row)
    combinations = [parse.(Int, reverse(split(string(i, base = 2, pad = Nn), ""))) for i in 1:Sn]
    row_replicates = repeat(sbn_row, outer=(Sn,1))
    return abs.(combinations .- row_replicates)
end