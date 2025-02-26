# SA4 Prolog programming assignment

CSC 372 Spring 2025 Assignment

* [Overview](#overview)

* [Getting Started](#start)

* [Programming Problems](#problems)

* [What and how to submit](#submit)

**Due Wednesday, February 26, 2025 at 11:59PM**

You can work with anyone on this assignment.  Each student does need
to submit an assignment.

# Overview
<a name="overview"/></a>

The purpose of this assignment is to help you learn to program in Prolog. The 
second large assignment will be a type inference system for the SML type system, 
written in Prolog. The goal is to practice writing recursive and  logical 
queries using Prolog's declarative syntax and built-in mechanisms like 
backtracking and pattern matching.


You will be submitting your assignment to Gradescope.

---


# Getting Started
<a name="start"/></a>

## GitHub Setup

Accept the github assignment at [https://classroom.github.com/a/kq79ggv2](https://classroom.github.com/a/kq79ggv2)
and do a git clone of your repository.  Make sure to `git commit -a` and
`git push` frequently!  The initial github repository will include the 
following files:
- `sa4.pl` - the starter file for you to write in your solution predicates.
- `family.pl` - contains family facts for problems 1-4.R
- `friends.pl` - contains social network facts for problems 5-8.
- `test.pl` - file to run testcases for all the predicates at once.
- `README.md`

## Running Tests
You can use the docker container from SA1 to test your predicates. To use the 
container:
1. Navigate to the assignment repository (`sa4-prolog-<github ID>`) in your terminal.
2. Startup the docker container you made for SA1:
    ```
    docker run -it -v $(pwd):/workspace chapel_sml_prolog
    devuser@3de3a6e8c94f:~$ cd /workspace
    devuser@3de3a6e8c94f:/workspace$ 
    ```
Once in the container, you can use the swipl interpreter to manually test your predicates:
```
> swipl
Welcome to SWI-Prolog ...
?- <your predicate here>
```
Additionally, you can use `test.pl` to test all of your predicates at once. To 
do this, run the following command:
```
swipl -q -s test.pl
```



# Programming Problems
<a name="problems"></a>

All of your solutions will go into a single file: `sa4.pl`.

At the start of each problem, please keep the brief predicate descriptions labels. 

Please remember to **put your name, the time you spent, 
and who you collaborated, with including AIs, in the
comment header at the top of the 
`sa4.pl` file**.  We will be surprised if you don't
collaborate with anyone including an AI.  Thus, if you
don't list any collaborators, we will probably contact
you directly to hear about how you did the assignment.

## Problem 1 - Grandparent

### Task:

Write the predicate `grandparent(X, Y)` that succeeds if `X` is a grandparent of `Y`. `X` is grandparent of `Y` if `X` has a child who is a parent of `Y`.

### Sample Queries:
```prolog
?- grandparent(georgeI, georgeII).
true.

?- grandparent(dio, jotaro).
false.

?- grandparent(joseph,X).
X = jotaro.
```

---

## Problem 2 - Siblings

### Task:

Write the predicate `siblings(X, Y)` that succeeds if `X` and `Y` are siblings, meaning they share at least one common parent.

### Sample Queries:
```prolog
?- siblings(jonathan, dio).
true .

?- siblings(jonathan, giorno).
false.

?- siblings(josuke, X).   
X = holy ;
false.
```

---

## Problem 3 - Aunt or Uncle

### Task:

Write the predicate `auntOrUncle(X, Y)` that succeeds if `X` is either an aunt or uncle of `Y`. An aunt or uncle is a sibling of one of `Y`'s parents.

### Sample Queries:
```prolog
?- auntOrUncle(josuke, jotaro).
true .

?- auntOrUncle(erina, joseph).
false.

?- auntOrUncle(dio, Y).
Y = georgeII .
```

---

## Problem 4 - Ancestor

### Task:

Write the predicate `ancestor(X, Y)` that succeeds if `X` is an ancestor of `Y`. An ancestor is anyone in the line of descent of `Y` (parent, grandparent, etc.).

### Sample Queries:
```prolog
?- ancestor(georgeI, jolyne).
true.

?- ancestor(dio, jolyne).
false.

?- ancestor(X, joseph).
X = georgeII ;
X = elizabeth ;
X = jonathan ;
X = erina ;
X = georgeI ;
X = mary ;
false.
```

---

## Problem 5 - Friends

### Task:

Write the predicate `friends(X, Y)` that succeeds if `X` and `Y` are friends. The friendship is reciprocal, so if `X` is a friend of `Y`, then `Y` is a friend of `X`.

### Sample Queries:
```prolog
?- friends(bichuan, alan).
true.
```

---

## Problem 6 - Common Friend

### Task:

Write the predicate `commonFriend(X, Y, Z)` that succeeds if `Z` is a friend of both `X` and `Y`. Note that a person cannot be their own friend.

### Sample Queries:
```prolog
?- commonFriend(alan, elena, X).
X = bichuan ;
X = maria ;
false.

?- commonFriend(X, maria, alan).
X = bichuan ;
false.

?- commonFriend(X, Y, Z).
X = alan,
Y = elena,
Z = bichuan ;
X = alan,
Y = elena,
Z = maria ;
X = alan,
Y = zahra,
Z = maria
... (many more results possible)
```

---

## Problem 7 - Suggest Friend

### Task:

Write the predicate `suggestFriend(X, Y)` that suggests that `X` and `Y` become friends if they have a friend in common and are not already friends, or if they follow the same person and are not already friends.

### Sample Queries:
```prolog
?- suggestFriend(alan, X).
X = elena ;
X = elena ;
X = zahra ;
false.

?- suggestFriend(X,
deshawn).
X = zahra ;
X = zahra.

?- suggestFriend(X,Y).
X = alan,
Y = elena ;
X = alan,
Y = elena ;
X = alan,
Y = zahra ;
X = bichuan,
Y = maria
... (many more results possible)
```

---

## Problem 8 - Suggest Follow

### Task:

Write the predicate `suggestFollow(X, Y)` that suggests that `X` follow `Y` if:
- `X` follows someone who follows `Y` and `X` does not already follow `Y`,
- or `X` follows someone who is friends with `Y` and `X` does not already follow `Y`,
- or `X` is friends with someone who follows `Y` and `X` does not already follow `Y`.

### Sample Queries:
```prolog
?- suggestFollow(alan, X).
X = coco ;
X = lucas ;
X = deshawn ;
X = oliver ;
false.

?- suggestFollow(X, anna).
X = deshawn ;
X = bichuan ;
X = deshawn ;
X = maria ;
X = deshawn ;
false.
```

---

## Problem 9 - Fibonacci Number

### Task:

Write the predicate `fibonacci(N, F)` that succeeds if `F` is the Nth Fibonacci number.

### Sample Queries:
```prolog
?- fibonacci(0,F).
F = 0 .

?- fibonacci(1,F).
F = 1 .

?- fibonacci(5,F).
F = 5 ;
false.

?- fibonacci(7, F).
F = 13.

?- fibonacci(10, F).
F = 55.
```

---

## Problem 10 - Unique Set

### Task:

Write the predicate `isSet(X)` that succeeds if `X` is a list with unique elements.

### Sample Queries:
```prolog
?- isSet([1, 2, 3, 4]).
true.

?- isSet([1, 2, 2, 3]).
false.

?- isSet([a, b, c]).
true.
```

---

## Problem 11 - Duplicate List

### Task:

Write the predicate `dupList(X, Y)` that succeeds if `Y` is a list where each element in `X` is repeated once.

### Sample Queries:
```prolog
?- dupList([1, 2], Y).
Y = [1, 1, 2, 2] .

?- dupList(X,[a,a,b,b,c,c]).
X = [a, b, c] .
```

---

## Problem 12 - Remove Duplicates

### Task:

Write the predicate `removeDuplicates(X, Y)` that succeeds if `Y` is the list obtained by removing duplicate elements from `X`.

### Sample Queries:
```prolog
?- removeDuplicates([1,2,2,3,3,4], X).
X = [1, 2, 3, 4].

?- removeDuplicates([a,b,a,c,c], X).
X = [b, a, c].
```

---

## Problem 13 - Every Other Element

### Task:

Write the predicate `everyOtherOne(X, Y)` that succeeds if `Y` is a list that contains every other element from list `X`.

### Sample Queries:
```prolog
?- everyOtherOne([1,2,3,4,5,6], X).
X = [1, 3, 5].

?- everyOtherOne([a,b,c,d,e], X).
X = [a, c, e].
```

---

## Problem 14 - Set Equality

### Task:

Write the predicate `setEq(X, Y)` that succeeds if `X` and `Y` contain the same elements, regardless of order.

### Sample Queries:
```prolog
?- setEq([1,2,3], [2,3,1]).
true .

?- setEq([a,b,c], [c,a,b]).
true .
```

---

## Problem 15 - Maximum in List

### Task:

Write the predicate `maxList(L, Max)` that succeeds if `Max` is the largest element in the list `L`.

### Sample Queries:
```prolog
?- maxList([3,5,2,8,7], X).
X = 8.

?- maxList([10,20,30,25], X).
X = 30.
```


# What and how to submit
<a name="submit"/></a>

Please submit one file to Gradescope:
* `sa4.pl`

As soon as you have the files listed above, submit preliminary versions of your 
work to gradescope. Keep submitting until your work is complete; we keep the
grade from the last submission before the deadline.  Note that the grading test
cases are more thorough than the initial set of test cases provided.
You will want to add additional test cases.

# How your work will be evaluated

Your submission will be evaluated with automated correctness tests
and with some manual reviewing of your code.  Please follow all of the
above instructions.
