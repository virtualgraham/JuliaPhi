@testset "TestConnectivity" begin
    
    @testset "test_get_inputs_from_cm" begin
        cm = BitArray([
            0 1 0; 
            1 1 1; 
            0 0 0;
        ])

        @test get_inputs_from_cm(1, cm) == [2]
        @test get_inputs_from_cm(2, cm) == [1,2]
        @test get_inputs_from_cm(3, cm) == [2]
    end


    @testset "test_get_outputs_from_cm" begin
        cm = BitArray([
            0 1 0; 
            1 1 1; 
            0 0 0;
        ])

        @test get_outputs_from_cm(1, cm) == [2]
        @test get_outputs_from_cm(2, cm) == [1,2,3]
        @test get_outputs_from_cm(3, cm) == []
    end


    @testset "test_causally_significant_nodes" begin
        cm = BitArray([
            0 0; 
            1 0;
        ])

        @test causally_significant_nodes(cm) == []

        cm = BitArray([
            0 1; 
            1 0;
        ])

        @test causally_significant_nodes(cm) == [1,2]

        cm = BitArray([
            0 1 0; 
            0 0 1;
            0 1 1;
        ])

        @test causally_significant_nodes(cm) == [2,3]
    end


    @testset "test_relevant_connections" begin
        cm = relevant_connections(2, [1,2], [2,2])

        answer = BitArray([
            0 1; 
            0 1;
        ])

        @test cm == answer

        cm = relevant_connections(3, [1,2], [1,3])

        answer = BitArray([
            1 0 1; 
            1 0 1;
            0 0 0;
        ])

        @test cm == answer
    end


    @testset "test_block_cm" begin
        cm1 = BitArray([
            1 0 0 1 1 0; 
            1 0 1 0 0 1; 
            0 0 0 1 0 0; 
            0 1 0 0 0 0; 
            1 1 0 0 0 1;
        ])
        cm2 = BitArray([
            1 0 0;
            0 1 1;
            0 1 1;
        ])
        cm3 = BitArray([
            1 1 0 0 0;
            0 0 1 1 1;
        ])
        cm4 = BitArray([
            1 1 0 0 0;
            0 1 1 0 0;
            0 0 1 1 0;
            0 0 0 1 1;
            1 0 0 0 0;
        ])
        cm5 = BitArray([
            1 1;
            0 1;
        ])

        @test !block_cm(cm1)
        @test block_cm(cm2)
        @test block_cm(cm3)
        @test !block_cm(cm4)
        @test !block_cm(cm5)
    end

    @testset "test_block_reducible" begin
        cm1 = BitArray([
            1 0 0 1 1 0; 
            1 0 1 0 0 1; 
            0 0 0 1 0 0; 
            1 1 0 0 0 1; 
            0 0 0 0 0 0;
        ])
        cm2 = BitArray([
            1 0 0;
            0 1 1;
            0 1 1;
        ])
        cm3 = BitArray([
            1 1 0 0 0;
            0 0 1 1 1;
        ])
        cm4 = BitArray([
            0 1 1;
            1 0 1;
            1 1 0;
        ])

        @test !block_reducible(cm1, collect(1:(size(cm1)[1]-1)), collect(1:(size(cm1)[2])))
        @test block_reducible(cm2, [1,2,3], [1,2,3])
        @test block_reducible(cm3, [1,2], [1,2,3,4,5])
        @test !block_reducible(cm4, [1,2], [2,3])
    end

    @testset "test_is_strong" begin
        cm = BitArray([
            0 1 0;
            0 0 1;
            1 0 0;
        ])

        @test is_strong(cm)

        cm = BitArray([
            0 0 1;
            0 1 0;
            1 0 0;
        ])

        @test !is_strong(cm)

        cm = BitArray([
            0 1 0;
            0 0 1;
            0 1 0;
        ])

        @test !is_strong(cm)

        cm = BitArray([
            0 1 0;
            1 0 0;
            0 0 0;
        ])

        @test is_strong(cm, [1,2])
    end

    @testset "test_is_full" begin
        cm = BitArray([
            0 0 1;
            1 0 1;
            1 1 0;
        ])

        @test !is_full(cm, [1], [1,2,3])
        @test !is_full(cm, [3], [3])
        @test !is_full(cm, [1,2], [2,3])
        @test is_full(cm, [], [1,2,3])
        @test is_full(cm, [1], [])
        @test is_full(cm, [1,2], [1,3])
        @test is_full(cm, [2,3], [2,3])
        @test is_full(cm, [1,2,3], [1,2,3])
    end


    @testset "test_apply_boundary_conditions" begin
        cm = BitArray([
            0 0 1;
            1 0 1;
            1 1 0;
        ])
        
        answer = BitArray([
            0 0 1;
            0 0 0;
            1 0 0;
        ])
        
        @test apply_boundary_conditions_to_cm([2], cm) == answer
    end
end