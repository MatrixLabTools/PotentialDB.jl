module PotentialDB

using Reexport

@reexport using PotentialCalculation


export CASnumber, PotentialRegistry,
       addpotential!, defaultregistry, list, loadpotential, saveregistry



include("potentialregistry.jl")


using .potentialregistry



end # module
