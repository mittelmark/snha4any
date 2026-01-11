# snha4any

SNHA algorithm implented in various programming languages.

We will use the check following language transpilers to create code for
several programming languages from one code base:

- [Haxe](https://labs.perplexity.ai/) - using Haxe programming language it
  should create code for C++, C-sharp, the Haxe interpreter, Java, Lua,
  Python and Neko
- [Py2many](https://labs.perplexity.ai/) - using the Python programming
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


The following features will be implemented:

- Data structures
    - Data frame with row and colnames features
    - Matrix with rownames and colnames features
    - Graph structure with degree and harmonic centrality measures
- Graph generation for regular, random and explicit graph types
- Generate data with a normal distribution
- Data generation for graphs using Monte Carlo simulation
- Command line support for generating graphs and data
- Reading data from CSV files
- SNHA algorithm implementation
- Quality measures for predicting graphs if the real structure is known


Here is the process diagram:

![](https://kroki.io/plantuml/svg/eNqFUcFuwjAMvfMVUc-FDbRbVKSqlXratAunwiElXpsRkioNA4T49zlJGWUIIbVS7Gc_Pz9zURvWNqQmpxEhRGkOZdewFpJKH-LOHiUkX0JK4PFecNsk08lb3ICoG4vP19hhay21SbrNsZI7WFHH40nLqg6QdOWYOq4cVkzJeE6KWRnYhfoRXegqpoPZklUgk6hwTC85s2ypClBgmBVaRQ80MLnVKkyZPeBaqk8DXKztMxYkcUQnYpjaYHILFBVS8rGTkpKUkhw_1EXo-b5uhlhLyQL_jBJfkJa9jJR_T5bqnVkjDlH8p9LLzi9FuTCwtsBxa6c68mh2QTNtzJXDY4v2Arr9EFyM-07vbf4fznt4sHhUoR0wdCX0uo3LWw-HpwgbgJSi7fD-wbZ0PMeRdyfOW3f8vAe4trhizIzR-wYYT5RWcJ3pSlNCA5_vI4HEv9H6EOED48wHwQmHZyUXJqnYejOcjC7dpkNx-kTQefQLK_AAXg==)
