

struct CASnumber
    num::Tuple{Int,Int,Int}
    CASnumber(i,j,k) = new( (i,j,k) )
    function CASnumber(s::AbstractString)
        if length(s) > 4 && s[1:4] == "CAS:"
            parts = parse.(Int,split(s[5:end],"-"))
        else
            parts = parse.(Int,split(s,"-"))
        end
        @assert length(parts) == 3
        CASnumber(parts...)
    end
end

Base.show(io::IO, c::CASnumber) = print(io, "CAS: ", c.num[1], "-", c.num[2], "-", c.num[3])
Base.isequal(c1::CASnumber, c2::CASnumber) = c1.num == c2.num

"""
requiredkeys()

Returns a list of keys required for PotentialRegistry entry.
"""
function requiredkeys()
    return ["file", "keywords", "method", "basis", "CAS", "authors", "description"]
end

"""
checkformat(d) -> Bool

Checks if dictionary has information needed to make PotentialRegistry entry.
"""
function checkformat(d; checkfile=true)
    for k in requiredkeys()
        ! checkfile && continue
        if ! haskey(d, k)
            return false
        end
    end
    try
        for x in d["CAS"]
            isa(x, CASnumber) && continue
            CASnumber(x)
        end
    catch e
        @error "CAS numbers cannot be parsed"
        return false
    end
    return true
end

mutable struct PotentialRegistry
    "Registry TOML file"
    fname::String
    data::Dict
    "Keywords descriping potential and keys for `data`"
    keywords::Dict
    "CAS numbers of molecules that are in potentials and their key for `data`"
    cas::Dict

    function PotentialRegistry(fname::String)
        if ! isfile(fname)
            touch(fname)
        end
        d = TOML.parsefile(fname)
        for (k,v) in d
            if ! checkformat(v)
                error("Error in PotentialRegistry entry $k")
            end
        end
        tmpkeys = Dict()
        for (k,v) in d
            for x in v["keywords"]
                if haskey(tmpkeys, x)
                    push!(tmpkeys[x], k)
                else
                    push!(tmpkeys, x=>[k])
                end
            end
        end
        cas = Dict()
        for (k,v) in d
            for x in v["CAS"]
                t = CASnumber(x)
                if haskey(cas, t)
                    push!(cas[t], k)
                else
                    push!(cas, t=>[k])
                end
            end
        end
        new(fname, d, tmpkeys, cas)
    end
end


Base.length(p::PotentialRegistry) = length(p.data)
Base.keys(p::PotentialRegistry) = keys(p.data)
Base.haskey(p::PotentialRegistry, key) = haskey(p.data, key)
Base.values(p::PotentialRegistry) = values(p.data)
Base.show(io::IO, p::PotentialRegistry) = print(io, "Potential registry $(length(p)) potentials")

Base.getindex(p::PotentialRegistry,i) = p.data[i]
Base.getindex(p::PotentialRegistry,i::Integer) = p["$i"]


"""
saveregistry(p::PotentialRegistry)

Saves potentila registry to file given by `p.fname`
"""
function saveregistry(p::PotentialRegistry)
    open(p.fname,"w") do f
        TOML.print(f, p.data)
    end
    @info "Potential registry saved to $(p.fname)"
    return p
end


"""
loadpotential(p::PotentialRegistry,key)

Load potential
"""
function loadpotential(p::PotentialRegistry,key)
    fname = joinpath(splitdir(p.fname)[1], p[key]["file"])
    if haskey(p[key], "hash")
        s = open(fname,"r") do f
           bytes2hex(sha2_256(f))
        end
        if s != p[key]["hash"]
            error("Potential file ", fname ," has hash: ", s, " while ", p[key]["hash"],
                  " was expected")
        end
    end
    load_jld_data(fname)
end



"""
    defaultregistry() -> `PotentialRegistry`

Loads default registry
"""
function defaultregistry()
    PotentialRegistry( normpath(joinpath( @__DIR__, "../data", "Potentials.toml")))
end

"""
addpotential!(registry::PotentialRegistry, potential::Dict, registryentry::Dict)

Add potential to registry. Potential is saved to file in same directory that
registry file is and given name after default naming scheme.
"""
function addpotential!(registry::PotentialRegistry, potential::Dict, registryentry::Dict)
    entry = deepcopy(registryentry)
    ! checkformat(entry, checkfile=false) && error("Registry entry does not have the needed information")
    tmpkeys = deepcopy(registry.keywords)
    tmpcas = deepcopy(registry.cas)
    l = length(registry) + 1
    #Check that l is not reserved already
    while true
        if haskey(registry, "$l")
            l += 1
        else
            break
        end
    end
    if haskey(entry,"file")
        pfile = joinpath(splitdir(registry.fname)[1], entry["file"])
    else
        pfile = joinpath(splitdir(registry.fname)[1], "potential-$l.jld")
        entry["file"] = "potential-$l.jld"
    end
    isfile(pfile) && error("File $(pfile) already exists")
    for x in entry["keywords"]
        if haskey(tmpkeys, x)
            push!(tmpkeys[x], "$l")
        else
            push!(tmpkeys, x=>["$l"])
        end
    end
    for x in entry["CAS"]
        t = CASnumber(x)
        if haskey(tmpcas, t)
            push!(tmpcas[t], "$l")
        else
            push!(tmpcas, t=>["$l"])
        end
    end
    registry.cas = tmpcas
    registry.keywords = tmpkeys
    save_jld_data(pfile, potential)
    s = open(pfile, "r") do f
       bytes2hex(sha2_256(f))
    end
    entry["number of points"] = length(potential["Energy"])
    push!(entry, "hash"=>s)
    push!(registry.data, "$l"=>entry)

    #TODO Check potential for content

    saveregistry(registry)
    @info "All done!"
    return registry
end


function listpotentials(r::PotentialRegistry)
    println("\n[key]  =>  Description\n")
    for k in keys(r)
        println("[$k]  =>  ", r[k]["description"])
    end
end

