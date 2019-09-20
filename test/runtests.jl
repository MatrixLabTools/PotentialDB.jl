using Test
using PotentialDB

@testset "CASnumber" begin
    a = CASnumber(1,2,3)
    b = CASnumber("3-2-1")
    @test a != b
end
