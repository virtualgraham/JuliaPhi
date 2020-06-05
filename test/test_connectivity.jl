@testset "TestConnectivity" begin
    
    @testset "test_get_inputs_from_cm" begin
        cm = BitArray([0 1 0; 
              1 1 1; 
              0 0 0])

        @test get_inputs_from_cm(1, cm) == (2,)
        @test get_inputs_from_cm(2, cm) == (1,2)
        @test get_inputs_from_cm(3, cm) == (2,)
    end

end