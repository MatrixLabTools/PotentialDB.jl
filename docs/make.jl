using Documenter, PotentialDB

makedocs(sitename="PotentialDB",
         pages=["Home"=>"index.md",
                "Usage"=>"usage.md"])


deploydocs(
      repo = "github.com/MatrixLabTools/PotentialDB.jl.git"
)
