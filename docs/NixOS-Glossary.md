# Glossary

### Nix

At its core, Nix is a package manager - similar to other package managers, in that it handles installation of apps and tools provided in a specified package format. However, Nix is often used for other tasks as well.

Nix itself is composed of the Nix expression language and a suite of CLI tools.

### Nix Expression Language

Nix is a functional programming language featuring lazy evaluation.

Contains constructs specific to the language for managing and defining packages. A feature of the language is that all values are immutable, and side-effects are prohibited by the language itself. Everything is considered 'pure' (think Haskell).

Equivalent terms: **Nix Language**.

### Nix Expression

An expression within the Nix language.

As opposed to statements in languages like Python, or definitions in C, expressions are the top-level language construct in Nix.

A `.nix` file can be thought of as a self-contained Nix expression. 

We refer to `.nix` files by the language construct used to incorporate them into another Nix expression, the `import` function. Thus, `.nix` files are considered imports, we *import* a `.nix` module.

### Attribute Set

Similar to dictionary in Python or object in JS, an attribute set is a set of key-value pairs. 

```nix
{ name = "Scott"; age = 40; }
```

### Derivation

A build step expressed as a special type of value in the Nix language.

Subtype of an attribute set, and generated via the `derivation` function (although wrappers exist for making this process easier).

Derivations take in a set of inputs and produces some set of outputs. As it is lazily evaluated, it is only built when an output is evaluated by the Nix language. Packages depend on one another via derivations.

A common workflow when packaging for Nix is to have a derivation produce a single output, `out` (also the default), which is then used as an installation prefix for the tool or application being packages. Thus, binaries would result in `$out/bin` as an example.

Derivations can be used for more than just building packages, but for things like config files as well.

The concept of a `derivation` is the driving force behind Nix.

### Builder (Derivation)

Builders, which can be as simple as a shell script, is a required input for producing the outputs.

Example:
```nix

derivation {
    name = "my-simple-derivation";
    system = "x86_64-linux";
    outputs = [ "out" ];
    builder = "${pkgs.bash}/bin/bash";
    args = [ "-c" "echo 'My Simple Derivation.' > $out" ];
}
```

### Fixed-output derivation

A type of derivation in which the output, via a content hash, is known in advance.

Often times when packaging you are required to download the source of whatever you are trying to package. In nix, this is often achieved by functions like `fetchGit` and `fetchurl`.

When downloading from a URL, verification is critical as the contents may change which breaks the immutability of Nix. Also, verification provides a layer of security. Nix achieves this through the use of a content hash, or the `fixed-output`. An example might look like:

```nix
pkgs.fetchurl {
    url = "https://<some-url>";
    sha256 = "<sha256-value>";
}
```

