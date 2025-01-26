# LA1 Shapes to MiniSVG Parsing, an SML programming assignment

CSc 372 Spring 2025 Assignment

* [Overview](#overview)

* [Getting Started](#start)

* [What we expect from your submission](#expect)

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
You will be compiling a declarative shape language into the SVG
file format.  You can view any image specified in the SVG file 
format in a web broswer.
You should be able to use some of the functions you wrote for
the SA2-SML assignment.

You will be expected to do at least two pushes of your intermediate progress
into GitHub.  For this assignment, we will be able to check that GitHub commits
and pushes are being done.

You will be submitting your assignment to Gradescope.

# Getting Started
<a name="start"/></a>

## GitHub Setup

Accept the github assignment at [https://classroom.github.com/a/P5LRyqxv](https://classroom.github.com/a/P5LRyqxv)
and do a git clone of your repository.  Make sure to `git commit -a` and
`git push` frequently!  The initial github repository will include the 
following files:
 * la1-shape2svg.sml
 * face.svg
 * min-grammar.svg
 * Unit.sml
 * README.md

Startup the docker container you made for SA1:
```
cd sa2-sml-githubid/
docker run -it -v $(pwd):/workspace chapel_sml_prolog
devuser@3de3a6e8c94f:~$ cd /workspace
devuser@3de3a6e8c94f:/workspace$ 
```

To run the code in `sa2.sml` from the commandline, 
you can do the following:
```
devuser@3de3a6e8c94f:/workspace$ poly --script la1-parse.sml
```


## The initial basis

As in the hofs assignment, we expect you to use the initial basis, which is 
properly known as the 
[Standard ML Basis Library](http://www.sml-family.org/Basis/). 
By the standards of popular languages, the basis is quite small, but it is still 
much more than you can learn in a week. Fortunately, you only have to learn a 
few key parts:

* Type constructors list, 
  [`option`](http://sml-family.org/Basis/option.html#SIG:OPTION.option:TY), 
  `bool`, `int`, `string`, and 
  [order](http://sml-family.org/Basis/general.html#SIG:GENERAL.order:TY)

* Modules [`List`](http://sml-family.org/Basis/list.html#List:STR:SPEC) and 
  [`Option`](http://sml-family.org/Basis/option.html#Option:STR:SPEC)

* Other module functions `Int.toString`, `Int.compare`, and `String.compare`

* Ramsey's `Unit` module, which is not part of the Basis Library but is 
  described in Dr. Ramsey's guide [Learning Standard  ML](https://www.cs.tufts.edu/comp/105-2019s/readings/ml.html#unit-testing).

The most convienient resource is to search on the internet for SML examples
and ask LLMs for examples and explanations of how to use
certain functionality.  You can also
collaborate with others who are in the class or folks not in the class.

Please remember to **put your name, the time you spent, 
and who you collaborated with including AIs in the
comment header at the top of the 
`la1-parse.sml` file**.  We will be surprised if you don't
collaborate with anyone including an AI.  Thus, if you
don't list any collaborators, we will probably contact
you directly to here about how you did the assignment.
  

# What we expect from your submission
<a name="expect"/></a>

We expect you will submit code that compiles, has the types given in the 
assignment, is acceptably styled 
(see [Style 
Guide for Standard ML Programmers](https://www.cs.tufts.edu/comp/105-2019s/handouts/mlstyle.pdf)), is tested, and 
avoids forbidden functions and constructs. Code that does not compile, that has 
the wrong types, or that uses forbidden functions or constructs will earn **No 
Credit**. 

## We expect you to avoid forbidden functions and constructs

In SML, you must avoid these functions and idioms:

* Standard ML provides a `length` function in the initial basis. 
  It is banned. The entire assignment must be solved without using length.

  **Solutions that use `length` will earn No Credit.**

* Use function definition by pattern matching. Do not use the functions `null`, 
  `mynull`, `hd`, and `tl`; use patterns instead.

  **Solutions that use `hd` or `tl` will earn No Credit.**



## We expect the right types
As always, your code is assessed in part through automated testing. To be 
testable, each function must not only have the correct *name*; it must also 
have the correct type. Your type definitions must also match the 
type definitions given in the assignment.

## We expect wise, well-formatted unit tests
Grading will focus on your code; your unit tests won't 
be graded. But we still expect the following:

* Use unit tests wisely. If a function is simple, do take a minute to 
  validate it with a unit test. If a function is not so simple, develop
  one unit test per case in the code.

* If you need debugging help during office hours, we expect that your code will 
  be accompanied by failing unit tests. (If you cannot get your code to 
  typecheck, we will help you do this without unit tests. But if you need help 
  getting code to produce right answers, we will want to see your unit tests.)

# Programming Problems
<a name="prog"/></a>

Both your lexer and your parser will go into a single file: `la1-parse.sml`.

To receive credit, your `sa2.sml` file must execute with poly in the docker container you set up for SA1. For example, we must be able to interpret your code without warnings or 
errors. The following command should test all of your code:
```sml
% poly --script la1-parse.sml
```

## Compiler for shape language

You will be writing a compiler consisting of a `lexer`,
`parser`, abstract syntax tree, and a `codegen` routine
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
  red, blue, green, yellow, black, purple

NUMBER can be any integer starting with a digit 1 through 9.

WHITESPACE is '\n', '\r\n', or `\r` or ' ' or '\t'

EOF stands for end of file.
```

Example inputs and outputs can be found in
`face.txt`, `face.svg`, `min-grammar.txt`, 
and `min-grammar.svg`.

## Lexer

You can create a datatype with whatever tokens you would
like.  I recommend having a token for each all caps
word in the grammar and a token for whitespace.

EOF is a token I recommend you have the lexer put at the
end of all the other tokens from the file.  Keep in mind
that these files are small enough that you can just read
the whole file into a string.  That string won't include
and end-of-file character.  The parser will work better
if there is an EOF token.

The finite state machine you will be implementing could
be the following:
  * States: start, state_keyword, state_whitespace, state_number
  * start
    * `\n`, `\r`, ` `, or `\t`, goto state_whitespace
    * isAlpha, goto state_keyword
    * '0', throw an exception
    * isDigit, goto state_number
    * otherwise, throw an exception "Unexpected character"

  * state_whitespace
    * `\n`, `\r`, ` `, or `\t`, consume character and goto state_whitespace
    * else, add a WHITESPACE token to token list and goto start

  * state_keyword
    * TODO: what should you do in this state per input char?

  * state_number
    * TODO: what should you do in this state per input char?






## Parser and the Abstract Syntax Tree


## Traversing the AST and Generating Output



# What and how to submit
<a name="submit"/></a>

Please submit one file to Gradescope:
* `la1-shape2svg.sml`
* `lexer.sml`
* `mypic.txt`
* `mypic.svg`

As soon as you have the files listed above, submit preliminary versions of your 
work to gradescope. Keep submitting until your work is complete; we keep the
grade from the last submission before the deadline.
<!-- Each time you submit 
you have to submit ALL the files in gradescope.  In other words, you can't just submit
one file at a time.-->

# How your work will be evaluated

Your submission will be evaluated with automated correctness tests
and with some manual reviewing of your code.
We also want to see an example input file called `mypic.txt`
and the `mypic.svg` that your compiler creates.
Please follow all of the
above instructions.
