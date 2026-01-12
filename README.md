# snha4any

SNHA algorithm implented in various programming languages.

We will use the check following language transpilers to create code for
several programming languages from one code base:

- [Haxe](https://haxe.org/) - using Haxe programming language it
  should create code for C++, C-sharp, the Haxe interpreter, Java, Lua,
  Python and Neko
- [Py2many](https://github.com/py2many/py2many) - using the Python programming
  language it should create code for C, C++, D, Dart, Go, Julia, Kotlin, Nim,
  Rust and V - where C++ and Rust are currently considered production ready
- [Fusion](https://github.com/fusionlanguage/fut) - Fusion programming
  language, it should create code for C, Cpp, C#, D, Java, Javascript,
  Python, Swift, Typescript, Zig
- [Nim](https://nim-lang.org/) - Nim programming language compiles to C, C++ and Javascript
- [V](https://vlang.io/) - V programming language compiles to C
- [Dafny](https://github.com/dafny-lang/dafny) - Dafny programming language compiles to C#, Go, Python, Java or Javascript

Further the following direct implementations in other programming languages which seems not to have a high level programming language transpiler
will be placed here:

- [julia](https://julialang.org/)
- [octave](https://octave.org/)

Using generated C code, for instance of Nim, we can use [Swig](https://www.swig.org) interface generator to add support for more languages, here an example:

![](https://kroki.io/plantuml/svg/eNqFkLFOwzAQhvc-heWODVVgAQmZgVQqQggi2q3K4MRHfOoljhynJUK8O3HT4Ta82N_3353kM1h73VlRi5-FmM6FDmc0waqHNC0u0uv2aNAruX-Wj9G0zsCht7oDBUTY9ZD0YSRQX0gEJpn7b9d3iQWsbVDp-j6JWeXIedUfx5IGKOKsd2zEzZOQ2WolOTJ41Se9qzx2YXJZNLsz1tM7XnP1UnLccNo6Hm0HJOBxHM7wbeD0kemGOFdBn4CJHDzP85ec0xisa5n45O-hHBnuK5o_fF2rLN235CvT1Li2uHb8U_S7-ANaGInn)

The following features will be implemented:

- Data structures:
    - Data frame with row and colnames features.
    - Matrix with rownames and colnames features.
    - Graph structure with degree and harmonic centrality measures.
    - Reading data from CSV files into data frames.
- Graph and data generation:
    - Graph generation for regular, random and explicit graph types.
    - Generate data with a normal distribution.
    - Data generation for graphs using Monte Carlo simulation.
    - Command line support for generating graphs and data.
    - Generating of [GraphViz](https://www.graphviz.org) code for creating plots.
- Graph prediction:    
    - SNHA algorithm implementation.
    - Quality measures for graph prediction if the real structure is known.
    - Command line support for data reading and prediction

Here is the process diagram:

![](https://kroki.io/plantuml/svg/eNqFUcFuwjAMvfMVUc-FDbRbVKSqlXratAunwiElXpsRkioNA4T49zlJGWUIIbVS7Gc_Pz9zURvWNqQmpxEhRGkOZdewFpJKH-LOHiUkX0JK4PFecNsk08lb3ICoG4vP19hhay21SbrNsZI7WFHH40nLqg6QdOWYOq4cVkzJeE6KWRnYhfoRXegqpoPZklUgk6hwTC85s2ypClBgmBVaRQ80MLnVKkyZPeBaqk8DXKztMxYkcUQnYpjaYHILFBVS8rGTkpKUkhw_1EXo-b5uhlhLyQL_jBJfkJa9jJR_T5bqnVkjDlH8p9LLzi9FuTCwtsBxa6c68mh2QTNtzJXDY4v2Arr9EFyM-07vbf4fznt4sHhUoR0wdCX0uo3LWw-HpwgbgJSi7fD-wbZ0PMeRdyfOW3f8vAe4trhizIzR-wYYT5RWcJ3pSlNCA5_vI4HEv9H6EOED48wHwQmHZyUXJqnYejOcjC7dpkNx-kTQefQLK_AAXg==)
