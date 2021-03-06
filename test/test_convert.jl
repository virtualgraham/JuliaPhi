@testset "TestConvert" begin
    
    @testset "test_le_index2state" begin
        @test le_index2state(7, 8) == [1, 1, 1, 0, 0, 0, 0, 0]
        @test le_index2state(1, 3) == [1, 0, 0]
        @test le_index2state(8, 4) == [0, 0, 0, 1]
    end

    @testset "test_be_index2state" begin
        @test be_index2state(7, 8) == [0, 0, 0, 0, 0, 1, 1, 1]
        @test be_index2state(1, 3) == [0, 0, 1]
        @test be_index2state(8, 4) == [1, 0, 0, 0]
    end


    state_by_node = [
        0 0 0;
        0 1 1;
        1 0 1;
        1 1 0;
        1 1 0;
        1 0 1;
        0 1 1;
        0 0 0;
    ]

    state_by_state = [
        1 0 0 0 0 0 0 0;
        0 0 0 0 0 0 1 0;
        0 0 0 0 0 1 0 0;
        0 0 0 1 0 0 0 0;
        0 0 0 1 0 0 0 0;
        0 0 0 0 0 1 0 0;
        0 0 0 0 0 0 1 0;
        1 0 0 0 0 0 0 0;
    ]

    state_by_node_nondet = [
        0.0 0.0;
        0.5 0.5;
        0.5 0.5;
        1.0 1.0;
    ]

    state_by_state_nondet = [
        1.00 0.00 0.00 0.00;
        0.25 0.25 0.25 0.25;
        0.25 0.25 0.25 0.25;
        0.00 0.00 0.00 1.00;
    ]

    nd_state_by_node = Array{Float64}(undef, 2,2,2,2,4)
    nd_state_by_node[1,1,1,:,:] = [
        1 0 0 1
        1 0 1 1
    ]
    nd_state_by_node[1,1,2,:,:] = [
        0 0 0 0
        0 1 1 0
    ]
    nd_state_by_node[1,2,1,:,:] = [
        0 0 1 0
        0 0 0 0
    ]
    nd_state_by_node[1,2,2,:,:] = [
        0 0 1 1
        0 1 0 1
    ]
    nd_state_by_node[2,1,1,:,:] = [
        1 0 1 1
        1 1 0 1
    ]
    nd_state_by_node[2,1,2,:,:] = [
        0 1 1 0
        0 1 0 0
    ]
    nd_state_by_node[2,2,1,:,:] = [
        0 0 0 0
        0 1 1 0
    ]
    nd_state_by_node[2,2,2,:,:] = [
        0 1 0 1
        0 1 1 1
    ]

    twod_state_by_node = [
        1 0 0 1
        1 0 1 1
        0 0 1 0
        0 0 0 0
        0 0 0 0
        0 1 1 0
        0 0 1 1
        0 1 0 1
        1 0 1 1
        1 1 0 1
        0 0 0 0
        0 1 1 0
        0 1 1 0
        0 1 0 0
        0 1 0 1
        0 1 1 1
    ]

    nonsquare_deterministic_1 = [
        1 0 0
        0 1 1
        1 1 0
        0 0 1
    ]

    nonsquare_deterministic_2 = [
        0 0
        0 1
        1 0
        1 1
        0 0 
        0 1
        1 1
        1 0
    ]

    nonsquare_nondeterministic_1 = [
        0.8 0.1 0.3
        0.9 0.5 0.3
        0.2 0.8 0.9
        0.3 0.4 0.1
    ]

    nonsquare_nondeterministic_2 = [
        0.0 0.0
        0.9 0.1
        0.3 0.8
        0.3 0.1
        0.6 0.3
        0.5 0.6
        0.9 0.2
        0.8 0.1
    ]


    @testset "test_to_multidimensional" begin
        @test to_multidimensional(nd_state_by_node) == nd_state_by_node

        for tpm in [
            state_by_node,
            twod_state_by_node,
            nonsquare_deterministic_1,
            nonsquare_deterministic_2,
            nonsquare_nondeterministic_1,
            nonsquare_nondeterministic_2,
        ]
            S = size(tpm)[1]
            N = Integer(floor(log2(S)))
            result = to_multidimensional(tpm)
            for i in 1:S
                state = le_index2state(i-1, N) .+ 1
                @test result[state...,:] == tpm[i, :]
            end
        end
    end

    @testset "test_to_2dimensional" begin
        @test to_2dimensional(state_by_node) == state_by_node

        for tpm in [
            state_by_node,
            state_by_node_nondet,
            twod_state_by_node,
            nonsquare_deterministic_1,
            nonsquare_deterministic_2,
            nonsquare_nondeterministic_1,
            nonsquare_nondeterministic_2,
        ]
            nd = to_multidimensional(tpm)
            @test to_2dimensional(nd) == tpm
        end
    end

    @testset "test_state_by_state2state_by_node" begin
        result = state_by_state2state_by_node(state_by_state)
        expected = to_multidimensional(state_by_node)
        @test result == expected
    end

    @testset "test_state_by_node2state_by_state" begin
        sbn_tpm = [
            0 0
            1 0
            0 1
            1 1
        ]
        expected = [
            1 0 0 0
            0 1 0 0
            0 0 1 0
            0 0 0 1
        ]

        result = state_by_node2state_by_state(sbn_tpm)
        @test result == expected
    end

    @testset "test_nondet_state_by_node2state_by_state" begin
        result = state_by_node2state_by_state(state_by_node_nondet)
        expected = state_by_state_nondet
        @test result == expected
    end

    @testset "test_nondet_state_by_state2state_by_node" begin
        result = state_by_state2state_by_node(state_by_state_nondet)
        expected = to_multidimensional(state_by_node_nondet)
        @test result == expected
    end

    @testset "test_2_d_state_by_node2state_by_state" begin
        result = state_by_node2state_by_state(state_by_node)
        expected = state_by_state
        @test result == expected
    end

    @testset "test_n_d_state_by_node2state_by_state" begin
        sbn = to_multidimensional(state_by_node)
        result = state_by_node2state_by_state(sbn)
        expected = state_by_state
        @test result == expected
    end

    @testset "test_nonsquare_deterministic_1_state_by_node2state_by_state" begin
        result = state_by_node2state_by_state(nonsquare_deterministic_1)
        answer = [
            0 1 0 0 0 0 0 0
            0 0 0 0 0 0 1 0
            0 0 0 1 0 0 0 0
            0 0 0 0 1 0 0 0
        ]
        @test result == answer
    end

    @testset "test_nonsquare_deterministic_2_state_by_node2state_by_state" begin
        result = state_by_node2state_by_state(nonsquare_deterministic_2)
        answer = [
            1 0 0 0
            0 0 1 0
            0 1 0 0
            0 0 0 1
            1 0 0 0
            0 0 1 0
            0 0 0 1
            0 1 0 0
        ]
        @test result == answer
    end

    @testset "test_nonsquare_nondeterministic_1_state_by_node2state_by_state" begin
        result = round.(state_by_node2state_by_state(nonsquare_nondeterministic_1); digits=3)
        answer = [
            0.126 0.504 0.014 0.056 0.054 0.216 0.006 0.024
            0.035 0.315 0.035 0.315 0.015 0.135 0.015 0.135
            0.016 0.004 0.064 0.016 0.144 0.036 0.576 0.144
            0.378 0.162 0.252 0.108 0.042 0.018 0.028 0.012
        ]
        @test result == answer
    end

    @testset "test_nonsquare_nondeterministic_2_state_by_node2state_by_state" begin
        result = round.(state_by_node2state_by_state(nonsquare_nondeterministic_2); digits=3)
        answer = [
            1.   0.   0.   0.  
            0.09 0.81 0.01 0.09
            0.14 0.06 0.56 0.24
            0.63 0.27 0.07 0.03
            0.28 0.42 0.12 0.18
            0.2  0.2  0.3  0.3 
            0.08 0.72 0.02 0.18
            0.18 0.72 0.02 0.08
        ]
        @test result == answer
    end

end
