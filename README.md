# snha4any

SNHA algorithm implemented in various programming languages.

Already existing are implementations in:

- [R](https://github.com/mittelmark/snha) - by Detlef Groth
- [Python](https//github.com/thake93/snah4py) - Tim Hake
- [Julia](https://github.com/nono-zarazua/snha4jl) - Roberto Zarazua

## References

- Groth, D.; Scheffler, C.; Hermanussen, M. (2019): Body height in stunted Indonesian children depends directly on parental education and not via a nutrition mediated pathway - Evidence from tracing association chains by St. Nicolas House Analysis. In Anthropologischer Anzeiger. [DOI: 10.1127/anthranz/2019/1027](https://doi.org/10.1127/anthranz/2019/1027)
- Hermanussen, M., Aßmann, C., & Groth, D. (2021). Chain reversion for detecting associations in interacting variables—St. Nicolas House Analysis. International journal of environmental research and public health, 18(4), 1741. [DOI: 10.3390/ijerph18041741](https://doi.org/10.3390/ijerph18041741)

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

![](https://kroki.io/graphviz/svg/eNqFkk1vgzAMhu_9FVF6LKsYl02asgtonSakorY3xCGAC1Fdgvhoh6b99xGgk1kPyyV-Xr-2nI9UZZUsc5axrwXr10DhVaVNLp5tOxrEShanVFWC-zv-YpRCpxDWuSxBAKIqa7DqpkMQR4UIqTXWP64dKweV5Y2w10-WySUadSXqUxdjC5Hp9dbWShfs4ZVxd7XiMyXomlwXTq9NUYgyBhQjRTOv57CevZuFezz6030Zm-7DfjO5yzvXfIIPeZH7pFJlM5MPXQn1vby_quNc2ZZQuD4zo7mTI-tjs01DcYoepY2mqU2rEGjajEbQbyltXXlGykkjL0CEACqaD94DSsP9EmFH4zbuCB4S_D3x9CV4rD85fW6J5_G5TNE_pu_FDwyfwkc=)

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

![](https://kroki.io/graphviz/svg/eNqFks1OhDAURvfzFJU1YyIaY2K64GeA1TjRJZnFHdoRYuWSUoLE-O5SSussJrhqenLa-31p3yW0FcnI94YQASP2ijYcFE7bBhkvugpaTk_45Q81UxW9uw38To2C03MtBGe-XkoUKGkH4hOb43QyJEWLHfUC__7GOz5PJFrIgyPxQh4dSRby5Mic4GLAx3gSPdcTds4NFjd191mSuZmW5C6XJnPQ7ZZEBaslPaMcQDJfwIkL6oWHWYi0EK8IsRaSa0JuhEQLu2tC_OKZKpOQrgipFrIVIdNC_p8QFebdGCrF2dy-WLQ9H0xbC145iEz_DNPR4gQUmFKWxChNCQcqqJvO5LbsbZ-HJoclB8nZ3_25xWFZ9hLKUdPNzy_qBMRl)

## Progress

| Language   | Compiler / Interpreter | [Rand.fu](fusion/Rand.fu) | [Stats.fu](fusion/Stats.fu) | [Matrix.fu](fusion/Matrix.fu) | [Mgraph.fu](fusion/Mgraph.fu) | [Mcgraph.fu](fusion/Mcgraph.fu) |
|------------|------------------------|----------|----------|-----------|-----------|----------------------|
| C          | gcc 14-15              | [x]     | [x]      |   [?] transpose?  |   [x]     | [x]   | 
| C++        | g++ 14-15              | [x]     | [x]      |   [x]     |   [x]     | [x]   |
| C#         | dotnet 10              | [x]     | [x]      |   [x]     |   [x]     | [x]   |
| D          | ldc2 1.40 / dmd 2.112  | [x]     | [x]      |   [x]     |   [x]     | [x]   |
| Java       | javac 21-25            | [x]     | [x]      |   [x]     |   [x]     | [x]   |
| JavaScript | node 20-22             | [x]     | [x]      |   [x]     |   [x]     | [x]   |
| Python     | python 3.13            | [x]     | [x]      |   [x]     |   [x]     | [x]   |
| Swift      | swift 6.0-6.3          | [x]     | [x]      |   [x]     |   [x]     | [x]   |
| TypeScript | bun 1.3                | [x]     | [x]      |   [x]     |   [x]     | [x]   |


| Language   | [FileSystem.fu](fusion/FileSystem.fu) | [CSVParser.fu](fusion/CSVParser.fu) |
|------------|------------------------|----------------------------------------------------|
| C          | [x]                    | [x] |
| C++        | [x]                    | [x] |
| C#         | [x]                    | [x] |
| D          | [x]                    | [x] |
| Java       | [x]                    | [x] |
| JavaScript | [x]                    | [x] |
| Python     | [x]                    | [x] |
| Swift      | [x]                    | [x] |
| TypeScript | [x]                    | [x] |

## Class Diagram (WIP)

![](https://kroki.io/plantuml/svg/eNqVUc1OwzAMvvcpciyij4C4bEKaBAVREGfTeFu0xB6JCwXEu9MfGsrUHMgpzveTz3ZtIQR1D6TVZ6a6c64qRJ2fzYqS33LLtFPt9FpiK72GXSSuPILgI5kte7cGgXxrGUQ5Q4X6uUJbKEOiKIA7Wgx_tWUnBDuXNpMymJ2DZe0Yw3xgfm2CXAz8y9-kEd6QjIzOZMC_sqwemq8EJMTuN6GEZaurvn7gaHSK3yBQCtEmibFORL_1Gv0ydIfgA9OKvUcLYvjEvFDz8n02jENyTId0_gpfGqQa834BQcDLuAskHSnHLpKDf0eqGpf4U7rNgddrfDULdhPtaW_q_Qg9M9txs9_PHd_o)

## Authors

The following persons contribute to the project:

- Alba de Prada Hernandez (AP), University of Potsdam (graph and data generation modules)
- Christopher Olvera (CO), University of Potsdam (implementation of SNHA algorithm and accuracy metrics)
- Detlef Groth (DG), University of Potsdam (supervisor and random data generation)
- Harsini Praveen Kumar (HP), University of Potsdam (statistics module)
- Roberto Zarazua (RZ), University of Potsdam (Julia code, used for implementation)
