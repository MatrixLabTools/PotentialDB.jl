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
