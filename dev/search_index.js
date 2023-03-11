var documenterSearchIndex = {"docs":
[{"location":"usage/#Usage","page":"Usage","title":"Usage","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"Package has two modes default registry and custom registries.","category":"page"},{"location":"usage/#Using-default-registry","page":"Usage","title":"Using default registry","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"Default registry can be loaded with","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"using PotentialDB\nd = defaultregistry()","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"You can list potentials stored in the default registry with listpotentials-command","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"listpotentials(d)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"To list more details of the selected potential, you can call it with its key","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"d[\"1\"]","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"To load a wanted potential, call with loadpotential and key","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"p=loadpotential(d,\"1\")","category":"page"},{"location":"usage/#Custom-registries","page":"Usage","title":"Custom registries","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"Registries are defined by a TOML-file that holds information on where the file holding potential energy data is saved and some details on the potential itself. Example default registry has entry:","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"[1]\nCAS = [\"64-18-6\", \"7440-37-1\"]\nmethod = \"CCSD(T)-F12/RI\"\nhash = \"23284650a0739cbda33e82f4f16ca962e833fa6c320c492525033e492d1e2b87\"\nkeywords = [\"formic acid\", \"argon\"]\nfile = \"potential-1.jld\"\nbasis = \"cc-pVDZ-F12 cc-pVDZ-F12-CABS cc-pVTZ/C\"\nauthors = [\"Teemu Järvinen\"]\ndescription = \"cis-formic acid - argon potential. Max 20000 cm⁻¹\"","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"Some of keywords are mandatory, some are not. Also there can be as many keywords as you want to add.","category":"page"},{"location":"usage/#List-of-mandatory-keywords","page":"Usage","title":"List of mandatory keywords","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"authors - Identify persons who made the potential.\nbasis - Basis functions used in calculaton.\nCAS  - CAS numbers of molecules in the potential. Needed for identification.\ndescription - Short desciption of potential.\nfile - location of potentialfile relative to location registry file.\nkeywords - Used to do search on potentials.\nmethod - Method used to calculate potential.","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"Additionally hash-keyword is optional. It contains SHA256 sum of potential file and, if present, is used to check integrity of potential upon loading.","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"To load custom potential registry, use PotentialRegistry(\"Registry.toml\"). If file \"Registry.toml\" exists, this call loads it and checks, if it has correct form, if not it will throw an error. If file does not exist, it creates a new registry.","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"using PotentialDB # hide\nr = PotentialRegistry(\"example.toml\")","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"You can use addpotential!-function to add potentials to this file. As and example, lets add a potential from default registry.","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"Lets first load potential from default registry","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"d = defaultregistry()\n\np = loadpotential(d, \"2\")","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"To add potential, you must create a Dict-that holds mandatory keywords needed for a registry entry. In the case of this example, we can load this data from the default registry.","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"k = d[\"2\"]","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"We can now add potential to our example registry","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"addpotential!(r, p, k)","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"New potential was added and registry file was saved. To confirm, that we added a new potential correctly, we can do:","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"rc = PotentialRegistry(\"example.toml\")\nlistpotentials(rc)\nrc[\"1\"]\nloadpotential(rc, \"1\")","category":"page"},{"location":"usage/#Add-potentials-to-default-registry","page":"Usage","title":"Add potentials to default registry","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"Default registry is just standard registy file located in data-directory of the package. While you can add entries there by had, it is recommended to use addpotential!-function. You can then submit a pull request to PotentialDB.jl, to have your potential to added for everyone's use.","category":"page"},{"location":"#PotentialDB.jl","page":"Home","title":"PotentialDB.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Used to store potential energy surfaces calculated with PotentialCalculation.","category":"page"},{"location":"#Package-Features","page":"Home","title":"Package Features","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Implements routines to store calculated potential energy surfaces\nGeneral registry and database for calculated potentials\nImplement own registries and databases for potentials","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To install it is recommended that you first install custom package registy and then install trough standard methodology.","category":"page"},{"location":"","page":"Home","title":"Home","text":"pkg> registry add https://github.com/MatrixLabTools/PackageRegistry\npkg> add PotentialDB","category":"page"}]
}
