@testset "TestDirection" begin
    
    @testset "test_direction_order" begin
        mechanism = (0,)
        purview = (1,2)
        @test order(JuliaPhi.cause, mechanism, purview) == (purview, mechanism)
        @test order(JuliaPhi.effect, mechanism, purview) == (mechanism, purview)

        @test_throws ErrorException order(JuliaPhi.bidirectional, mechanism, purview)
    end

end