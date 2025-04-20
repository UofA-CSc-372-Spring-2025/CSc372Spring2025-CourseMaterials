# LA3 Runtime Improvement Using Parallelism

CSc 372 Spring 2025 Assignment

* [Overview](#overview)

* [Requirements, Deliverables, and Evaluation](#requirements)

* [Getting Started](#start)

* [What and how to submit](#submit)


**Due Friday, April 25, 2025 at 11:59PM**

In this assignment, you will implement a Chapel program that does edge detection on a list of images
that are of various sizes and then improve the speed by parallelizing that program and dealing with
the load imbalance.

# Overview
<a name="overview"></a>

The Chapel programming language is a high-level programming language that provides ease of parallel
programming, high performance, and portability. 
For this assignment, you are given a serial version of the code (`la3_serial.chpl`) that does the
following:
1. For each image in subdirectory `InputDir`:
    * Converts the image into the grayscale version
    * Writes out the grayscale file into the subdirectory `SOutputDir`.
2. For each image in subdirectory `SOutputDir`:
    * Reads in the grayscale file
    * Does edge detection
    * Writes out the result.
3. Verifies that the answer is correct.

`la3_parallel.chpl` starts as a copy of `la3_serial.chpl`, and you will be modifying `la3_parallel.chpl` to improve
the performance of that program relative to `la3_serial.chpl`.

# Requirements, Deliverables, and Scoring
<a name="requirements"></a>

## Requirements
You are to improve the timing performance of `la3_parallel.chpl` by parallelizing the program execution.  
You can also optimize the code by optimizing it to further improve the timing performance.  The output
files from `la3_parallel.chpl` must be the same as those from `la3_serial.chpl`.

## Leaderboard and Extra Credit
There will be an anonymous-to-the-class leaderboard in Gradescope keeping track of who has the largest improvement.  It will also track
the best serial and parallel times out of curiosity, but we don't have any control
on which server the autograder runs on in Gradescope.
The top percentage improvement leaders will obtain some extra credit points that can go over and above the 40 limit for extra credit.
The amount will be between 5 to 10 extra credit points, and
they will be awarded to at least the top 3 leaders.

Another way to obtain extra credit is to use the UofA
HPC cluster and report your results in piazza.
Instructions on how to do this will be posted in piazza
sometime this weekend.

## Implementation Details
You are provided the following files:
 * `la3_serial.chpl` - This is the original code that performs the listed functionalities in a serial fashion.
 * `la3_parallel.chpl` - This is the starting code that you will edit to improve the performance of the code. The code starts out as a copy of `la3_serial.chpl`.
 * `la3_student_tests.chpl` - This is the code that will run the functions in both `la3_serial.chpl` and `la3_parallel.chpl`, calculate the timing performance improvement, and compare the output files to verify that they are the same.  Output files from `la3_parallel.chpl` will be stored in the subdirectory `POutputDir`.

Compile the code by typing:
```
  chpl --fast la3_student_tests.chpl
```

Execute the code by typing:
```
  ./la3_student_tests.chpl
```

The output will look like this (but with different timings for your machine):
```
runSerial execution time: 1.58586 seconds
runParallel execution time: 1.19322 seconds
Improvement = 32.9049%
PASS: SerialOutputDir/alligator_edge.png and ParallelOutputDir/alligator_edge.png are the same
PASS: SerialOutputDir/alligator_gray.png and ParallelOutputDir/alligator_gray.png are the same
PASS: SerialOutputDir/flower_edge.png and ParallelOutputDir/flower_edge.png are the same
...
All tests completed.
```

## Deliverable
You will be submitting the Chapel file (`la3_parallel.chpl`) implementing the optimized code and a brief description of how you optimized the code in the comment header.

## Evaluation Criteria
* Correctness (30 points): The code executes faster (at least 10%) than `la3_serial.chpl`, and all the output files are the same as those produced by `la3_serial.chpl`.
* Optimization description: (10 points): Your description of what optimizations you used and a manual inspection of your code will be used for these 10 points.
* Put your name, the time you spent, and who you collaborated with including AIs in the comment header at the top of the `la3_parallel.chpl` file


# Getting Started
<a name="start"></a>
- Familiarize yourself with Chapel<br>
- [https://chapel-lang.org/docs/main/primers/learnChapelInYMinutes.html](https://chapel-lang.org/docs/main/primers/learnChapelInYMinutes.html)
- [https://chapel-lang.org/docs/language/reference.html](https://chapel-lang.org/docs/language/reference.html)
- Review Lecture Notes and SA7.
- Debug incrementally using test cases.<br>

## GitHub Setup
Accept the github assignment at [https://classroom.github.com/a/l1LCdokX](https://classroom.github.com/a/l1LCdokX)
and do a git clone of your repository.  Make sure to `git commit -a` and
`git push` frequently!  The initial github repository will include the 
following files or directories:
- `la3_serial.chpl`
- `la3_parallel.chpl`
- `la3_student_tests.chpl`
- `InputDir`
- `SOutputDir`
- `POutputDir`
- `README.md`

Startup the docker container you made for SA1:
```
cd la3-par
docker pull docker.io/chapel/chapel-gasnet 
docker run --rm -it -v "$PWD":/workspace chapel/chapel-gasnet
root@589405d07f6a:/opt/chapel# cd /workspace
root@xxxxxxxxx:/myapp# chpl la3_serial.chpl la3_parallel.chpl la3_student_tests.chpl
root@xxxxxxxxx:/myapp# ./la3_student_tests -nl 1
```

## Other information

We will be going over possible ways to parallelize and optimize the code in class on Tuesday April 15th.
The slides will be posted as usual.

You can collaborate with others who are in the class or folks not in the class.

Please remember to **put your name, the time you spent, 
and who you collaborated with including AIs in the
comment header at the top of the `la3_parallel.chpl` file**.

**Also include a short description and list of changes you made to parallelize
and otherwise improve the performance.**


# What and how to submit
<a name="submit"></a>

In Gradescope submit the following files: `la3_parallel.chpl`.

As soon as you have the files listed above, submit preliminary versions of your 
work to gradescope. Keep submitting until your work is complete; we keep the
grade from the last submission before the deadline. Each time you submit 
you have to submit ALL the files in gradescope.  In other words, you can't just submit
one file at a time.

## How your work will be evaluated

Your submission will be evaluated with automated correctness tests, and with some manual reviewing of your code.
See the Evaluation Criteria above for how it will be graded.

