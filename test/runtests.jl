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
    tt = deepcopy(d[1])
    tt["file"] = tempname() * ".jld2"
    addpotential!(r, t, tt)

    t = loadpotential(d,2)
    ttt = deepcopy(d[2])
    ttt["file"] = tempname() * ".jld2"
    addpotential!(r, t, ttt)

    t2 = loadpotential(r,2)

    @test t["Energy"] == t2["Energy"]

    r2 = PotentialRegistry(file)

    @test r.cas == r2.cas
    @test r.keywords == r2.keywords
    listpotentials(r)
end
