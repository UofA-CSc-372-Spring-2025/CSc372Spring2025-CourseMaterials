# SA1 Docker, GitHub, Gradescope, SML, Prolog, and Chapel

CSc 372 Spring 2025 Assignment

* [Overview](#overview)

* [Getting Started](#start)

* [What we expect from your submission](#expect)

* [What and how to submit](#submit)



**Due Wednesday, January 22, 2025 at 11:59PM**

You can work with anyone on this assignment.  Each student does need
to submit an assignment.


# Overview
<a name="overview"/></a>

The purpose of this assignment is for you to edit and execute (1) an SML program, (2) a prolog program, and (3) a Chapel program.
These are the three programming languages you will be learning this semester.

You will be doing this by creating and running a docker container that has all of the programs you need to interpret SML and Prolog and compile and run Chapel.  You will also edit each of the source files to add a line of code that produces some output.

You will be expected to do at least two pushes of your intermediate progress into GitHub.

The assignment will be graded when you submit it to Gradescope.

# Getting Started
<a name="start"/></a>

## GitHub Setup

Accept the github assignment at https://classroom.github.com/a/5CPJbvxS
and do a git clone of your repository.  Make sure to `git commit -a` and
`git push` frequently!  The initial github repository will include the 
following files:
 * Dockerfile
 * hello.chpl
 * hello.pl
 * hello.sml

If you are new to GitHub, you might want to accept the GitHub fundamentals
assignment at https://classroom.github.com/a/KgmpZG-y and work through
the material there first.

## Create a docker container

1. Download Docker Desktop and run it.

2. Create the docker container
```
cd sa1-docker-<github-id>/
docker build -t chapel_sml_prolog .
```
Note that the build might take about 5 minutes or so.  It will output status information.
If you get a strange `buildx` error, you might have forgotten the `.` at the end of the build command.

3. Check that the container was built
```
docker images
```
Should list your image.

4. Run the container

```
docker pull docker.io/chapel/chapel:2.3.0
cd sa1-docker-<github-id>/
docker run -it -v $(pwd):/workspace chapel_sml_prolog
devuser@3de3a6e8c94f:~$ cd /workspace
devuser@3de3a6e8c94f:/workspace$ 
devuser@3de3a6e8c94f:/workspace$ ls
Dockerfile  hello.chpl  hello.pl  hello.sml REAMDE.md
```

Reference for the above steps: ChatGPT answer to "How do I build a docker container once I have a docker file?  Describe how to do it on the command line and in Docker desktop."


Possible issues
* If you do the above in docker desktop, you may have to type your absolute directory path instead of using `$(pwd)` in the `docker run` command.

* Docker on the Mac can’t handle when `pwd` has spaces in it.  So I moved to `/Users/mstrout/MyGitHub/Temp372/` before cloning the my `sa1-docker-<github-id>` GitHub repository.

* If you run into other issues or errors, I recommend asking a free LLM like ChatGPT or Claude, or the copilot provided by the university, to get ideas for fixing the problems.  You can always ask on Piazza as well.

## Edit and Execute each of the programs

The docker container doesn't have any editors.  However, it mounted the 
directory you started it in on your machine `sa1-docker-<github-id>/` into `/workspace/`.
That is why in the docker container you can do an `ls` and see those files.  
Thus, you can edit those files on your machine in `sa1-docker-<github-id>/`
with any editor you prefer.  I recommend vscode.

### SML
1. Edit the `hello.sml` file and add the below line with the print.
```
val () = print "Hello World!\n";
```

2. In the container, run the `hello.sml` program using the following command line:
```
poly --script hello.sml
```

Ask an LLM what the `val ()` above is all about.

### Prolog
1. Edit the `hello.pl` file and add the below code.
```
:- initialization(proc1).

proc1 :-
    write('Hello'), tab(4), write('World!\n'),    
    halt.
```
2. In the container, run the `hello.sml` program using the following command line:
```
swipl -q -f hello.pl
```

Consider asking an LLM or copilot what `initialization` and `halt` do.

### Chapel
1. Edit the `hello.chpl` file and add the below code.
```
writeln("Hello World!");
```
2. In the container, run the `hello.chpl` program by compiling it and then running the executable:

```
chpl hello.chpl
./hello
```

What is the difference between the Chapel code and the other codes in terms 
of the newline character?  Consider asking an LLM or looking up the Chapel
documentation at chapel-lang.org to understand the semantics of `writeln`.

# What we expect from your submission
<a name="expect"/></a>

All three versions of Hello World should run and print out the string `Hello World!`.

From within your container, your output should look like the following:
```
devuser@c71a3c5bae8f:/workspace$ poly --script hello.sml
Hello World!
devuser@c71a3c5bae8f:/workspace$ swipl -q -f hello.pl
Hello    World!
devuser@c71a3c5bae8f:/workspace$ chpl hello.chpl
devuser@c71a3c5bae8f:/workspace$ ./hello
Hello World!
devuser@c71a3c5bae8f:/workspace$ 
```

# What and how to submit
<a name="submit"/></a>

Please submit three files to Gradescope:
* hello.chpl
* hello.pl
* hello.sml

As soon as you have the files listed above, submit preliminary versions of your 
work to gradescope. Keep submitting until your work is complete; we keep the
grade from the last submission before the deadline.  Each time you submit 
you have to submit ALL the files in gradescope.  In other words, you can't just submit
one file at a time.

# How your work will be evaluated

This is a participation programming assignment.  As long as you followed
the instructions, you should receive full credit.
