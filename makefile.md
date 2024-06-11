# Lexical and Syntax Analysis Project

This project demonstrates the use of Flex and Bison for lexical and syntax analysis. It includes source files for both lexical and syntax analysis, relevant scripts, and resources.

## Project Structure

### Folder 1: Lexical Analysis (1. Lex)

- `a.out`: Executable file generated from the C source files.
- `compiler.l`: Flex source file for lexical analysis.
- `Execution Help.txt`: Instructions on how to execute the project.
- `fort500test1.f`: Fortran source file for testing.
- `lex.yy.c`: Generated C source file from Flex.
- `tokens.h`: Header file containing token definitions.
- `JFLAP7.1.jar`: JFLAP tool for visualizing automata and grammars.
- `Transition Diagram.jff`: JFLAP file containing the transition diagram.
- `Transition Diagram.jff.png`: PNG image of the transition diagram.

### Folder 2: Syntax Analysis (2. Bison)

- `a.out`: Executable file generated from the C source files.
- `compiler.l`: Flex source file for lexical analysis.
- `lex.yy.c`: Generated C source file from Flex.
- `Makefile`: Makefile to build the project.
- `Run comands`: File containing commands to run the project.
- `syntax.output`: Bison output file.
- `syntax.tab.c`: Generated C source file from Bison.
- `syntax.tab.h`: Generated header file from Bison.
- `syntax.y`: Bison source file for syntax analysis.
- `hashtbl.h`: Header file for hash table implementation.
- `hashtbl.c`: C source file for hash table implementation.
- `fort500test1.f`: Fortran source file for testing.
- `fort500test2.f`: Additional Fortran source file for testing.
- `tokens.h`: Header file containing token definitions.

## Setup

### Prerequisites

- Flex
- Bison
- GCC
- JFLAP (for viewing .jff files)

### Installation

1. **Build the project using the Makefile:**

   ```
   cd "2. Bison"
   make
   ```

## Usage

### Lexical Analysis

1. **Navigate to the Lex directory:**

   ```
   cd "1. Lex"
   ```

2. **Execute the lexical analysis:**

   ```
   flex compiler.l
   gcc lex.yy.c -lfl -lm
   ./a.out fort500test1.f
   ```

### Syntax Analysis

1. **Navigate to the Bison directory:**

   ```
   cd "../2. Bison"
   ```

2. **Execute the syntax analysis:**

   ```
   bison -d syntax.y
   gcc syntax.tab.c -o syntax_analysis
   ./syntax_analysis fort500test1.f
   ```

3. **Run additional commands:**

   Refer to the `Run comands` and `Execution Help.txt` for more details on execution commands.

## Directory Structure

The expected directory structure is:

```
project-directory/
├── README.md
├── 1. Lex/
│   ├── a.out
│   ├── compiler.l
│   ├── Execution Help.txt
│   ├── fort500test1.f
│   ├── lex.yy.c
│   ├── tokens.h
│   ├── JFLAP7.1.jar
│   ├── Transition Diagram.jff
│   └── Transition Diagram.jff.png
└── 2. Bison/
    ├── a.out
    ├── compiler.l
    ├── lex.yy.c
    ├── Makefile
    ├── Run comands
    ├── syntax.output
    ├── syntax.tab.c
    ├── syntax.tab.h
    ├── syntax.y
    ├── hashtbl.h
    ├── hashtbl.c
    ├── fort500test1.f
    ├── fort500test2.f
    └── tokens.h
```

## Contributing

Feel free to fork this repository and make improvements. Pull requests are welcome.

## License

This project is licensed under the MIT License.