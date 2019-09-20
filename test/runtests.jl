using Test
using PotentialDB

@testset "CASnumber" begin
    a = CASnumber(1,2,3)
    b = CASnumber("3-2-1")
    c = CASnumber("CAS: 1-2-3")
    @test a != b
    @test isequal(a,c)
end

@testset "Registry" begin
    d = defaultregistry()
    show(d)
    keys(d)
    values(d)
    d[1]
    file = tempname()
    r = PotentialRegistry(file)

    t = loadpotential(d,1)
    addpotential!(r, t, d[1])
    t = loadpotential(d,2)
    addpotential!(r, t, d[2])

    t2 = loadpotential(r,2)

    @test t["Energy"] == t2["Energy"]

    r2 = PotentialRegistry(file)

    @test r.cas == r2.cas
    @test r.keywords == r2.keywords
end
