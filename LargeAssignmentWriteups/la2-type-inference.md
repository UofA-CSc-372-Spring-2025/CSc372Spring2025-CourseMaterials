# LA2 Type Inference in SML Using Prolog

CSc 372 Spring 2025 Assignment

* [Overview](#overview)

* [Requirements, Deliverables, and Evaluation](#requirements)

* [Getting Started](#start)

* [What and how to submit](#submit)


**Due Sunday, March 23, 2025 at 11:59PM**

In this assignment, you will implement a type inference system for a small subset of Standard 
ML (SML) using Prolog. The goal is to understand how type inference works in functional 
languages and to explore how logic programming can be used for type checking.

# Overview
<a name="overview"></a>

SML is a statically typed functional programming language with a strong type system. Type 
inference in SML follows the Damas-Milner algorithm, which allows the compiler to 
determine the types of expressions without explicit type annotations through unification of
types. Prolog, being a logic programming language whose execution model uses unification,
provides a natural way to express type inference rules as logical relations.

## Subset of SML to be Supported
For this assignment, your type inference system will handle a small subset of SML expressions:
1.	Variables (`x`, `y`, `z`)
2.	Integer constants (`1`, `2`, `42`)
3.	Boolean constants (`true`, `false`)
4.	Lambda expressions (`fn x => e`)
5.	Function application (`e1 e2`)
6.	Let bindings (`let val x = e1 in e2 end`)
7.	Conditional expressions (`if e1 then e2 else e3`)
The system should infer types such as `int`, `bool`, and function types (`t1 -> t2`).

# Requirements, Deliverables, and Scoring
<a name="requirements"></a>

## Requirements
Your implementation should:
1. Define type inference rules for the given subset in Prolog.
2. Implement a Prolog predicate `infer(Expression, Type)` that succeeds when `Expression` has the inferred `Type`.
3. Handle type variables and unification to support monomorphic type inference sufficient to satisfy the provided test cases.


## Implementation Details
1. Representation of Expressions in Prolog:
    *   Variables: `sml_var(x)`
      * You will need the builtin `var\1` to test if a term is a prolog variable.
    *   Integers: `int(42)`
    *   Booleans: `bool(true)`
    *   Conditionals: `if(E1, E2, E3)`
    *   Tuples: `tuple(E1,E2)`
    *   Lambda: `lambda(x, E)`
    *   Application: `apply(E1, E2)`
    *   Let binding: `let(x, E1, E2)`
 
2. Representation of Types:
    *   Integer type: `int`
    *   Boolean type: `bool`
    *   Tuple type: `tuple(T1,T2)`
    *   Function type: `arrow(T1, T2)`
    *   Type variables: will be represented by a fresh prolog variable

3. Type rules:
    *   Variables: Lookup type in an environment.
    *   Integers: `int(N) -> int`
    *   Booleans: `bool(B) -> bool`
    *   Conditionals: `if(E1, E2, E3) -> T` requires `E1` to be `bool` and `E2`, `E3` to have the same type as the if expression, which is `T`.
    *   tuples: `tuple(E1,E2)` has type `tuple(T1,T2)` where `T1` is the type of `E1` and `T2` is the type of `E2`.
    *   Lambda: `lambda(X, E) -> arrow(T1, T2)` assuming `X` has type `T1` and `E` has type `T2`.
    *   Application: `apply(E1, E2) -> T` assuming `E1` has type `arrow(T1, T)` and `E2` has type `T1`.
    *   Let bindings: `let(X, E1, E2)` infers `E1`'s type, extends the environment with the variable `X` being assigned the type for `E1`, and then infers the type for `E2` using the extended environment.


4. Environment Representation in Prolog:
    * The environment will be represented as a list of pairs, mapping variable names to types.
    * Prolog rules for handling an environment:
        * `lookup(Var, [(Var, Type) | _], Type).`
        * `lookup(Var, [_ | Rest], Type) :- lookup(Var, Rest, Type).`
        * `extend(Var, Type, Env, [(Var, Type) | Env]).`
    *  `lookup/3` searches for a variable's type in the environment.	
    * `extend/4` adds a new variable-type mapping to the environment.

## Examples
1. Example: Inferring Types for a Let Expression
    *   The let expression in SML: `let val x = 42 in x end`
    *   Prolog representation: `let(x, int(42), var(x))`
    *   Type inference query:<br>
        `infer(let(x, int(42), var(x)), Type).`
    *   The system should infer that x has type int and extend the environment:<br>
        `Type = int.`
    *   This demonstrates how `let` expressions introduce new variable bindings and allow subsequent 
        lookups in the environment.

2. Example: Inferring the Type of the Identity Function
    * The identity function in SML: `fn x => x`
    * Prolog representation: `lambda(x, sml_var(x))`
    * Type inference query:<br>
        `infer(lambda(x, sml_var(x)), Type).`
    * Since x has an unknown type, the system should introduce a fresh prolog variable to represent an SML type variable:<br>
        `Type = arrow(T,T),var(T).`
    * The definition of `infer` for lambda expressions is provided for you in the starting la2-infer.pl.

3. Example: Inferring Types for an Apply Expression
    *   The apply expression in SML: `(e1 e2)`
    *   Prolog representation: `apply(lambda(x, sml_var(x)), e2)`
    *   Type inference query:<br>
        `infer(apply(lambda(x, sml_var(x)), int(5)), Type).`
    *   The identity function in the lambda is being applied to an integer, 
    so the type of the apply expression is an integer:<br>
        `Type = int.`


## Deliverables
1.	A Prolog file (`la2-infer.pl`) implementing the inference system.
2.	An edited README.md file that includes the answers to the questions in the starter README.md.

## Evaluation Criteria
* Correctness (30 points): The inference system correctly assigns types.
    * The autograder is using the provided la2-test.pl for grading tests.  Thus, if any of those tests fail, the autograder will give 0 points.  Make sure all of the tests pass locally before submitting.
* README file contents (8 points)
* put your name, the time you spent, and who you collaborated with including AIs in the comment header at the top of the `la2-infer.pl` file


# Getting Started
<a name="start"></a>
- Familiarize yourself with Prolog’s unification and backtracking.<br>
- Review Hindley-Milner type inference principles.<br>
- Start with simple cases (constants, variables) before handling complex expressions.<br>
- Debug incrementally using test cases.<br>

## GitHub Setup

Accept the github assignment at [https://classroom.github.com/a/yetttbmD](https://classroom.github.com/a/yetttbmD)
and do a git clone of your repository.  Make sure to `git commit -a` and
`git push` frequently!  The initial github repository will include the 
following files:
- `la2-infer.pl`
- `README.md`
- `Dockerfile`

Startup the docker container you made for SA1:
```
cd la2-infer-githubid/
docker build -t prolog_sml .
docker run -it -v $(pwd):/workspace prolog_sml
devuser@3de3a6e8c94f:~$ cd /workspace
devuser@3de3a6e8c94f:/workspace$ 
```

Once in the container, you can use the swipl interpreter to manually test your predicates:
```
> swipl
Welcome to SWI-Prolog ...
?- <your predicate here>
```
Additionally, you can use `la2-test.pl` to test all of your predicates at once. To 
do this, run the following command:
```
swipl -q -s la2-test.pl
```

## Other information

You can collaborate with others who are in the class or folks not in the class.

Please remember to **put your name, the time you spent, 
and who you collaborated with including AIs in the
comment header at the top of the `la2-infer.pl` file**.


# What and how to submit
<a name="submit"></a>

In Gradescope submit the following files: `la2-infer.pl` and `README.md`.

As soon as you have the files listed above, submit preliminary versions of your 
work to gradescope. Keep submitting until your work is complete; we keep the
grade from the last submission before the deadline. Each time you submit 
you have to submit ALL the files in gradescope.  In other words, you can't just submit
one file at a time.

## How your work will be evaluated

Your submission will be evaluated with automated correctness tests, your answers to the questions in the README.md file, and with some manual reviewing of your code.
See the Evaluation Criteria above for how it will be graded.

