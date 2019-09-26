# Usage

Package has two modes default registry and custom registries.

## Using default registry

Default registry can be loaded with

```@example 1
using PotentialDB
d = defaultregistry()
```

You can list potentials stored in the default registry with
`listpotentials`-command

```@example 1
listpotentials(d)
```

To list more detals of a selected potential you can call it with key

```@example 1
d["1"]
```

To load a wanted potential call with `loadpotential` and key

```@example 1
p=loadpotential(d,"1")
```


## Custom registries

Registries are defined by a TOML-file that holds information on where the potential
file is saved and some details on the potential it self. Example default registry
has entry:

```
[1]
CAS = ["64-18-6", "7440-37-1"]
method = "CCSD(T)-F12/RI"
hash = "23284650a0739cbda33e82f4f16ca962e833fa6c320c492525033e492d1e2b87"
keywords = ["formic acid", "argon"]
file = "potential-1.jld"
basis = "cc-pVDZ-F12 cc-pVDZ-F12-CABS cc-pVTZ/C"
authors = ["Teemu Järvinen"]
description = "cis-formic acid - argon potential. Max 20000 cm⁻¹"
```

Some of keywords are mandatory some are not. There can be as many keywords
than you want to add. To see which of the keywords are mandatory you can call
`requiredkeys`-function:

```@example 1
requiredkeys()
```

### Purpose of mandatory keywords

- authors - Identify persons who made the potential.
- basis - Basis functions used in calculaton.
- CAS  - CAS numbers of molecules in the potential. Needed for identification.
- description - Short desciption of potential.
- file - location of potentialfile relative to location registry file.
- keywords - Used to do search on potentials.
- method - Method used to calculate potential.

Additionally `hash`-keyword is optional. It contains SHA256 sum of potential file
and if present is used to check integrity of potential upon loading.

To load custom potential registry use `PotentialRegistry("Registry.toml")`.
If file `"Registry.toml"`-excists this call loads it and checks, if it has correct
form, if not it will throw an error. If file does not excist it creates a new registry.

```@example 2
using PotentialDB # hide
r = PotentialRegistry("example.toml")
```

You can use `addpotential!`-function to add potentials to this file.
As and example lets add a potential from default registry.

Let first load potential from default registry

```@example 2
d = defaultregistry()

p = loadpotential(d, "2")
```

To add potential you must create a `Dict`-that holds mandatory keywords need from
registry entry. In a case of this example we can load this data from defaultregistry.

```@example 2
k = d["2"]
```

We can now add potential to our example registry

```@example 2
addpotential!(r, p, k)
```

New potential is added and registry file is saved. To confirm we added new potential
correctly we can do:

```@repl 2
rc = PotentialRegistry("example.toml")
listpotentials(rc)
rc["1"]
loadpotential(rc, "1")
```

## Add potentials to default registry

Default registry is just standard registy file located in data-directory of the
package. While you can add entries there by had it is recommended to use
`addpotential!`-function. You can then submit a pull request to [PotentialDB.jl](https://github.com/MatrixLabTools/PotentialDB.jl)
to have your potential to added for everyones use.
