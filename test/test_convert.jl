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
                state = le_index2state(i, N)
                @test result[state] == tpm[i]
            end
        end
    end

    @testset "test_to_2dimensional" begin

    end

    @testset "test_state_by_state2state_by_node" begin

    end

    @testset "test_nondet_state_by_node2state_by_state" begin

    end

    @testset "test_nondet_state_by_state2state_by_node" begin

    end

    @testset "test_2_d_state_by_node2state_by_state" begin

    end

    @testset "test_n_d_state_by_node2state_by_state" begin

    end

    @testset "test_nonsquare_deterministic_1_state_by_node2state_by_state" begin

    end

    @testset "test_nonsquare_deterministic_2_state_by_node2state_by_state" begin

    end

    @testset "test_nonsquare_nondeterministic_1_state_by_node2state_by_state" begin

    end

    @testset "test_nonsquare_nondeterministic_2_state_by_node2state_by_state" begin

    end

end
