# snha4any

SNHA algorithm implented in various programming languages.

We will use the check following language transpilers to create code for
several programming languages from one code base:

- [Fusion](https://github.com/fusionlanguage/fut) - Fusion programming
  language, it should create code for C, Cpp, C#, D, Java, Javascript,
  Python, Swift, Typescript and OpenCL C
- [Haxe](https://haxe.org/) - Haxe programming language it
  should create code for C++, C-sharp, the Haxe interpreter, Java, Lua,
  Python and Neko
- [Temper](https://temperlang.dev/) - Temper programming language transpiles to
  C-Sharp, Java, Javascript, Typescript, Lua, Python and Rust (C++)
- [Py2many](https://github.com/py2many/py2many) - using the Python programming
  language it should create code for C, C++, D, Dart, Go, Julia, Kotlin, Nim,
  Rust and V - where C++ and Rust are currently considered production ready, however not ready to be used yet
- [Nim](https://nim-lang.org/) - Nim programming language compiles to C, C++ and Javascript, C code seems hard to use
- [V](https://vlang.io/) - V programming language compiles to C and can import C
- [Dafny](https://github.com/dafny-lang/dafny) - Dafny programming language compiles to C#, Go, Python, Java or Javascript

Further the following direct implementations in other programming languages which seems not to have a high level programming language transpiler
will be placed here:

- [julia](https://julialang.org/)
- [octave](https://octave.org/)

Using generated C code, for instance create by Fusion, we might then use the [Swig](https://www.swig.org) interface 
generator to add support for more languages, here an example for that workflow:

![](https://kroki.io/plantuml/svg/eNqFkk1vgzAMhu_9FVF6LKsYl02asgtonSakorY3xCGAC1Fdgvhoh6b99xGgk1kPyyV-Xr-2nI9UZZUsc5axrwXr10DhVaVNLp5tOxrEShanVFWC-zv-YpRCpxDWuSxBAKIqa7DqpkMQR4UIqTXWP64dKweV5Y2w10-WySUadSXqUxdjC5Hp9dbWShfs4ZVxd7XiMyXomlwXTq9NUYgyBhQjRTOv57CevZuFezz6030Zm-7DfjO5yzvXfIIPeZH7pFJlM5MPXQn1vby_quNc2ZZQuD4zo7mTI-tjs01DcYoepY2mqU2rEGjajEbQbyltXXlGykkjL0CEACqaD94DSsP9EmFH4zbuCB4S_D3x9CV4rD85fW6J5_G5TNE_pu_FDwyfwkc=)

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
