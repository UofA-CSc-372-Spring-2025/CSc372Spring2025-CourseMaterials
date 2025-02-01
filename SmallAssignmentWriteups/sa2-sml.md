# SA2 SML programming assignment

CSc 372 Spring 2025 Assignment

* [Overview](#overview)

* [Getting Started](#start)

* [What we expect from your submission](#expect)

* [Programming in ML Warmup](#prog)

* [What and how to submit](#submit)


**Due Wednesday, January 29, 2025 at 11:59PM**

You can work with anyone on this assignment.  Each student does need
to submit an assignment.


# Overview
<a name="overview"/></a>

The purpose of this assignment is to help you to learn to program in 
Standard ML.  The first large assignment will be a compiler between a 
text language specifying shapes and lines to SVG, and it will be written
in SML.

~You will be expected to do at least two pushes of your intermediate progress
into GitHub.  For this assignment, we will be able to check that GitHub commits
and pushes are being done.~
Since the github repositories are all public.  You do NOT have to do commits
and pushes to your github repository.  I apologize for the inconvenience of
the public repositories.

You will be submitting your assignment to Gradescope.

# Getting Started
<a name="start"/></a>

## GitHub Setup

Accept the github assignment at [https://classroom.github.com/a/P5LRyqxv](https://classroom.github.com/a/P5LRyqxv)
and do a git clone of your repository.  Make sure to `git commit -a` and
`git push` frequently!  The initial github repository will include the 
following files:
 * sa2.sml
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
devuser@3de3a6e8c94f:/workspace$ poly --script sa2.sml
The only internal Unit test passed.
```

or use the interpreter.
```
$ poly
Poly/ML 5.7.1 Release
> use "sa2.sml";
structure Unit:
  sig
    (* elided many lines describing the types in the Unit module *)
end
val it = (): unit
The only internal Unit test passed.
val mynull = fn: 'a list -> bool
val it = (): unit
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
Please note who you collaborate with and if you use an LLM at the top
of the `sa2.sml` file in the comment header.
  
## Unit testing
<a name="unit"/></a>


Regrettably, standard ML does not have check-expect and friends built in. Unit 
tests can be simulated by using higher-order functions, but it's a pain.
Here are some examples of tests written with Dr. Ramsey's Unit module:
```
val () =
    Unit.checkExpectWith Int.toString "2 means the third"
    (fn () => List.nth ([1, 2, 3], 2)) 
    3

val () =      (* this test fails *)
    Unit.checkExpectWith Bool.toString "2 is false"
    (fn () => List.nth ([true, false, true], 2)) 
    false

val () = Unit.reportWhenFailures ()
```

You’ll use `Unit.checkExpectWith` to write your own unit tests. You'll also use 
`Unit.checkAssert` and `Unit.checkExnWith`. The details are in
[Learning Standard ML](https://www.cs.tufts.edu/comp/105-2019s/readings/ml.html#unit-testing).

Each call to `Unit.checkExpectWith` needs to receive a string-conversion 
function. These functions are written using the string-conversion builders in 
the `Unit` module. Here are some examples of code you can use:
```
val checkExpectInt     = Unit.checkExpectWith Unit.intString
val checkExpectIntList = Unit.checkExpectWith (Unit.listString Unit.intString)
val checkExpectStringList = Unit.checkExpectWith (Unit.listString Unit.stringString)
val checkExpectISList =
  Unit.checkExpectWith (Unit.listString
                        (Unit.pairString Unit.intString Unit.stringString))
val checkExpectIntListList = 
  Unit.checkExpectWith (Unit.listString (Unit.listString Unit.intString))
```

## Things you need to review before starting
Read Chapters 2 up through 2.6 and Chapter 3 up through 3.2 in 
[ML for the Working Programmer](https://www.cl.cam.ac.uk/~lp15/MLbook/pub-details.html) 
about programming in ML and consider
using the [SML Syntax Cheatsheet](https://smlhelp.github.io/book/docs/start/syntax/)
as a reference.

<!--Dr. Ramsey provides a guide to
(Learning Standard ML)[https://www.cs.tufts.edu/comp/105-2019s/readings/ml.pdf].  
*Learning Standard ML* will guide you to other reading.  It is only 12 pages long.
Ignore the parts about MLton as we are using poly.-->

The fourth section in
[Lessons in Program Design](https://www.cs.tufts.edu/comp/105-2019s/design/lessons.pdf)
explains how to apply a nine-step design process with types and pattern 
matching. This lesson includes the key code excerpts needed to design and 
program with standard type constructors `list`, `option bool`, `int`, `string`, 
and `order`, as well as the tree constructor that will be on next week's 
homework. Immediately following the lesson, you will find a one-page 
summary of ML syntax.


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

While not everybody can learn good style quickly, everybody can learn to 
avoid the worst faults. In ML, you must avoid these functions and idioms:

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

All of your solutions will go into a single file: `sa2.sml`.

At the start of each problem, please keep the labels with short comments, like
```
(***** Problem A *****)
```

To receive credit, your `sa2.sml` file must execute with poly in the docker container you set up for SA1. For example, we must be able to interpret your code without warnings or 
errors. The following command should test all of your code:
```
% poly --script sa2.sml
```

Please remember to **put your name, the time you spent, 
and who you collaborated with including AIs in the
comment header at the top of the 
`sa2.sml` file**.  We will be surprised if you don't
collaborate with anyone including an AI.  Thus, if you
don't list any collaborators, we will probably contact
you directly to here about how you did the assignment.


## Defining functions using clauses and patterns

**A.** Define a function `mynull : 'a list -> bool`, which when applied to a 
list tells whether the list is empty. Avoid using `if`, and make sure the 
function takes constant time. Do not use any functions from the Standard Basis. 
Make sure your function has the same type as the `null` in the Standard Basis.

<hr>

**B.** Define a function `firstVowel : char list -> bool` that takes a list of 
lower-case letters and returns `true` if the first character is a vowel (aeiou) 
and `false` if the first character is not a vowel or if the list is empty. Use 
the wildcard symbol `_` whenever possible, and avoid using `if`.

Here is an example `char list`:
```sml
val chars = [#"a", #"b", #"c"];
```

## Using fold

**C.** Define `reverse : 'a list -> 'a list` using `foldl`.
Read about `foldl` at a [Lecture on Folding](https://www.cs.cornell.edu/courses/cs312/2008sp/recitations/rec05.html).
(In ML, the reverse function is in the initial basis as rev.)

When you are testing `reverse`, you may get a warning message about "value 
polymorphism." This message is explained in [Learning Standard  ML](https://www.cs.tufts.edu/comp/105-2019s/readings/ml.html#unit-testing) 
(Type pitfall II).  You can fix it by specifying the 
type of the empty list you pass into `reverse`:
`> val empty = rev [] : int list;`.


## Using Exceptions

**D.** Implement `minlist : int list -> int`, which returns the smallest element of 
a *nonempty* list of integers.  Use `foldl` and NOT recursion to implement `minlist`.  

If given an empty list of integers, your solution must fail 
by throwing an exception (e.g., by `raise 
Match`).

Your solution should work regardless of the representation of integers: it 
should not matter how many bits are used to represent a value of type `int`. 
You may find a use for function `Int.min`, which is part of the initial basis 
of Standard ML.


## More list manipulation
**E.** Define a function `zip: 'a list * 'b list -> ('a * 'b) list` that takes a 
pair of lists (of equal length) and returns the equivalent list of pairs. If the 
lengths don't match, raise the exception `Mismatch`, which you must define. Do 
not use any functions from the Standard Basis Library.
Do not use `if`.

<hr>

**F.** Define a function

```sml
val concat : 'a list list -> 'a list
```
that takes a list of lists of `'a` and produces a single list of `'a` containing 
all the elements in the correct order. For example,

```sml
> concat [[1], [2, 3, 4], [], [5, 6]];
val it = [1, 2, 3, 4, 5, 6] : int list
```

Do not use `if`. You may use functions from the Standard Basis Library, except 
for `List.concat`—code that uses `List.concat` will earn No Credit.

## Helper functions for the upcoming LA1

**G.** Define a function `isDigit : char -> bool` that takes 
a single character and returns true if the character is 
a digit ('0' to '9') and false otherwise. You must use 
pattern matching in your solution and avoid using if statements. Additionally, do not use functions from 
the Standard Basis Library.

Here are some example calls to isDigit:
```sml
> isDigit #"5";
val it = true : bool

> isDigit #"a";
val it = false : bool
```
<hr>

**H.** Define a `function isAlpha : char -> bool` that 
takes a single character and returns true if the 
character is an alphabetical letter 
('a' to 'z' or 'A' to 'Z') and false otherwise. 
You must use `Char.ord` to determine if the character 
falls within the appropriate ranges for uppercase 
and lowercase letters. Do not use any other functions 
from the Standard Basis Library.
Here are some example calls to `isAlpha`:
```sml
> isAlpha #"5";
val it = false : bool

> isAlpha #"a";
val it = true : bool
```

**I.** Define a function `svgCircle : int * int * int * string -> string` 
that takes a tuple of four values:
 1.	An integer for the x-coordinate of the circle’s center (cx).
 2.	An integer for the y-coordinate of the circle’s center (cy).
 3.	An integer for the circle’s radius (r).
 4.	A string for the circle’s fill color (fill).

The function should return a properly formatted SVG string representing a 
circle element. The output should match the following format:
```svg
<circle cx="..." cy="..." r="..." fill="..." />
```

Here are some examples calls to svgCircle:
```sml
> svgCircle (120, 150, 60, "white");
val it = "<circle cx=\"120\" cy=\"150\" r=\"60\" fill=\"white\" />" : string

svgCircle (200, 300, 100, "red");
val it = "<circle cx=\"200\" cy=\"300\" r=\"100\" fill=\"red\" />" : string
```

**J.** Define a function `partition : ('a -> bool) -> 'a list -> 'a list * 'a list` 
that takes a predicate function and a list, and splits 
the list into two lists:
 1.	The first list contains elements that satisfy the predicate.
 2.	The second list contains elements that do not satisfy the predicate.

You must write your own implementation of partition and may not use any 
functions from the Standard Basis Library (including the existing List.partition function). 
Use recursion and pattern matching in your solution.

Here are some example calls to partition:
```sml
> partition (fn x => x mod 2 = 0) [1, 2, 3, 4, 5];
val it = ([2, 4], [1, 3, 5]) : int list * int list

> partition Char.isAlpha [#"a", #"1", #"b", #"2", #"c"];
val it = ([#"a", #"b", #"c"], [#"1", #"2"]) : char list * char list

> partition (fn x => x > 0) [~3, ~2, 0, 1, 2];
val it = ([1, 2], [~3, ~2, 0]) : int list * int list
```
Your implementation should work for lists of any type 'a, 
provided the predicate function can be applied to elements of that type. 
Ensure that your function processes the list in order and returns 
results in the same relative order as the original list.

# What and how to submit
<a name="submit"/></a>

Please submit one file to Gradescope:
* `sa2.sml`

As soon as you have the files listed above, submit preliminary versions of your 
work to gradescope. Keep submitting until your work is complete; we keep the
grade from the last submission before the deadline.
<!-- Each time you submit 
you have to submit ALL the files in gradescope.  In other words, you can't just submit
one file at a time.-->

# How your work will be evaluated

Your submission will be evaluated with automated correctness tests
and with some manual reviewing of your code.  Please follow all of the
above instructions.
