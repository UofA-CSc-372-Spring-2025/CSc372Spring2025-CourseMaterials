# LA1 Shapes to MiniSVG Parsing, an SML programming assignment

CSc 372 Spring 2025 Assignment

* [Overview](#overview)

* [Getting Started](#start)

* [Lexing and Parsing in SML](#prog)

* [What and how to submit](#submit)


**Due Friday, February 14, 2025 at 11:59PM**

You can work with anyone on this assignment.  Each student needs
to submit their own assignment.  Make sure you understand how
everything you submit works.


# Overview
<a name="overview"/></a>

The purpose of this assignment is to satisfy the learning objective
from the syllabus that states
"write a lexer and recursive descent parser for a simple language".
It will also give you more experience writing SML code and understanding the SML code of others.

You will be compiling a declarative "shapes" language into the SVG
file format.  You can view any image specified in the SVG file 
format in a web broswer.
You should be able to use some of the functions you wrote for
the SA2-SML assignment.

You will be expected to do at least two pushes of your intermediate progress
into GitHub.  For this assignment, we will be able to check that GitHub commits
and pushes are being done.  To do this we will need your github id.
If you haven't provided that yet, please [fill out this form](https://docs.google.com/forms/d/e/1FAIpQLSd6AcisGSxCnco7e8REqmNy3pZHRAepzshIWWlv0sNXfcD-MQ/viewform).

You will be submitting your assignment to Gradescope.
* 30 of the 40 points will be autograded.
* 10 of the 40 points will be for
  * having at least two github commits,
  * having unit test cases in a separate file `la1-tests.sml` that test `lexer`, `parser`, `svgGen`, and other function,
  * commenting your functions to explain what they do,
  * no warnings from `poly`,
  * and providing information about how long the assignment took you and who/what you collaborated with in the comment header.

Code that does not compile will receive 0 out of 40 points.

# Getting Started
<a name="start"/></a>

## GitHub Setup

Accept the github assignment at [https://classroom.github.com/a/-JfdvKDM](https://classroom.github.com/a/-JfdvKDM)
and do a git clone of your repository.  Make sure to `git commit -a` and
`git push` frequently!  The initial github repository will include the 
following files:
 * la1-parse.sml
 * la1-tests.sml
 * shapes2svg.sml
 * face.svg
 * face.shapes
 * min-grammar.svg
 * min-grammar.shapes
 * Unit.sml
 * README.md

Below are some videos to help you with setting up SSH for Github, cloning, commiting, and pushing:
 * SSH Setup and Cloning:  https://youtu.be/snCP3c7wXw0?si=1ju86TiRn1LIodKL&t=75
 * Committing and Pushing:  https://www.youtube.com/watch?v=9DHjfDuXMGA
    * You shouldn't need to use the git bash terminal, the same commands shown in this video should work on any other terminal where git can be used.
    * When first committing, you may be asked to do the following commands, which are necessary to associate you with your commits:
      * `git config --global user.email "<your Github email>"`
      * `git config --global user.name "<your Github username>"`

Startup the docker container you made for SA1:
```
cd la1-parse-githubid/
docker run -it -v $(pwd):/workspace chapel_sml_prolog
devuser@3de3a6e8c94f:~$ cd /workspace
devuser@3de3a6e8c94f:/workspace$ 
```

To run the code in `shapes2svg.sml` from the commandline, 
you can do the following:
```
devuser@3de3a6e8c94f:/workspace$ cat la1-parse.sml shapes2svg.sml > compiler.sml; poly --script compiler.sml < face.shapes > face-out.svg
```
`face-out.svg` should be identical to `face.svg`.  Do a `diff` to see if that is true.


## Other information

The most convenient resource is to search on the internet for SML examples
and ask LLMs for examples and explanations of how to use
certain functionality.  You can also
collaborate with others who are in the class or folks not in the class.

Please remember to **put your name, the time you spent, 
and who you collaborated with including AIs in the
comment header at the top of the 
`la1-parse.sml` file**.  We will be surprised if you don't
collaborate with anyone including an AI.  Thus, if you
don't list any collaborators, we will probably contact
you directly to learn more details about how you did the assignment.
  

We recommend you use the [Style 
Guide for Standard ML Programmers](https://www.cs.tufts.edu/comp/105-2019s/handouts/mlstyle.pdf)).  However, we will not be grading you on style.


## We expect wise, well-formatted unit tests
We will be grading unit tests for LA1.  They should be added
to the la1-tests.sml file.
See the Overview at the top of this file for
what functions need tested.

* Use unit tests wisely. If a function is simple, do take a minute to 
  validate it with a unit test. If a function is not so simple, develop
  one unit test per case in the code.

* If you need debugging help during office hours, we expect that your code will 
  be accompanied by failing unit tests. (If you cannot get your code to 
  typecheck, we will help you do this without unit tests. But if you need help 
  getting code to produce right answers, we will want to see your unit tests.)

# Lexing and Parsing in SML
<a name="prog"/></a>

Both your lexer and your parser will go into a single file: `la1-parse.sml`.
The provided `la1-parse.sml` is already pre-populated with stubs (or implementations) for
all of the functions you have to write and some recommended ones.

To receive credit, your `la1-parse.sml` file must execute with poly in the docker container you set up for SA1. For example, we must be able to interpret your code without warnings or 
errors. The following commands should test all of your code:
```
cat la1-parse.sml la1-tests.sml > cat.sml
poly --script cat.sml
```

## Compiler for shape language

You will be writing a compiler consisting of a `lexer`,
`parser`, abstract syntax tree, and a `svgGen` routine
for reading in a shape language and writing out
SVG (scalar vector graphics) format.

Here is the context free grammar for the shape language.
```
program ::=  
        stmts EOF

stmts   ::= 
        stmt stmts
    |   epsilon

stmt    ::= 
        CIRCLE NUMBER NUMBER NUMBER COLOR
    |   LINE NUMBER NUMBER NUMBER NUMBER COLOR
    |   RECTANGLE NUMBER NUMBER NUMBER NUMBER COLOR

COLOR can be the following strings:
  red, blue, green, yellow, black, white

NUMBER can be 0 or any integer starting with a digit 1 through 9.

WHITESPACE is '\n', '\r\n', or `\r` or ' ' or '\t'

EOF stands for end of file.
```

Example inputs and outputs can be found in
`face.shapes`, `face.svg`, `min-grammar.shapes`, 
and `min-grammar.svg`.

## Lexer

The lexer for this assignment is relatively simple although you do need to deal with numbers like `042` or `00` being an error.
It takes as input the string for the full input file.
It needs to generate a list of tokens that are in that string
and then append the `TokenEOF` at the end of the list.
See the provided `la1-parse.sml` for hints.

## Parser and the Abstract Syntax Tree

The parser function will take as input a list of tokens
and generate an abstract syntax tree.
See the course notes from Feb 4 and 6th classes for approaches
to implement a recursive descent parser.

## Traversing the AST and Generating Output

The function `svgGen` will traverse the `ast` generated by 
the `parser` function and create a string that is the 
contents of an SVG file.  See the example svg files for the formatting.
The formatting needs to match the given files identically to enable testing.

# What and how to submit
<a name="submit"/></a>

Please submit the following files to Gradescope:
* `la1-parse.sml`
* `la1-tests.sml`
* `mypic.shapes`
* `mypic.svg`

As soon as you have the files listed above, submit preliminary versions of your 
work to gradescope. Keep submitting until your work is complete; we keep the
grade from the last submission before the deadline.
Each time you submit 
you have to submit ALL the files in gradescope.  In other words, you can't just submit
one file at a time.

# How your work will be evaluated

Your submission will be evaluated with automated correctness tests
and with some manual reviewing of your code.
See the Overview at the top of this file for how it will be graded.

We also want to see an example input file called `mypic.shapes`
and the `mypic.svg` that your compiler creates.
