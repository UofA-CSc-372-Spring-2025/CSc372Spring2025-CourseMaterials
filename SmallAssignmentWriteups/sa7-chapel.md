# SA7 Chapel programming assignment

CSc 372 Spring 2025 Assignment

* [Overview](#overview)

* [Getting Started](#start)

* [Programming Programming Problems to Solve in Chapel](#prog)

* [What and how to submit](#submit)


**Due Wednesday, April 9, 2025 at 11:59PM**

You can work with anyone on this assignment.  
I especially recommend asking questions on the Chapel
Discord, https://discord.com/invite/xu2xg45yqH, for this assignment.
Each student does need to submit an assignment for autograding.


# Overview
<a name="overview"/></a>

FIXME: Testing: sorted array of image sizes is correct hardcode for them and do in auto grader, result of edge detection same also hardcode, check something on mp4, maybe 2d and 1d histogram of image sizes and push sorting to la3

The purpose of this assignment is to help you to learn to program in 
Chapel.  The last large assignment (LA3) will be doing 
parallel image analysis in Chapel.  The theme for
SA7 and LA3 is processing images of different sizes using parallelism as much as possible.
For SA7, you will implement edge detection for images and create histograms of the image sizes.

You will be submitting your assignment to Gradescope.

# Getting Started
<a name="start"/></a>

## GitHub Setup

Accept the github assignment at FIXME[https://classroom.github.com/a/P5LRyqxv](https://classroom.github.com/a/P5LRyqxv)
and do a git clone of your repository.  Make sure to `git commit -a` and
`git push` frequently!  The initial github repository will include the 
following files:
 * sa7.chpl
 * sa7-student-tests.chpl, note that the autograder will use different tests
 * sa7-chapel.md
 * ImageDir/*.FIXME
 * README.md

Startup the chapel-gasnet docker container:
```
 docker pull docker.io/chapel/chapel-gasnet
 cd sa7-chapel/
 docker run --rm -it -v "$PWD":/workspace chapel/chapel-gasnet
 root@589405d07f6a:/opt/chapel# cd /workspace
```

Run the tests and see that they currently fail:
```
 root@xxxxxxxxx:/workspace# chpl sa7.chpl sa7-student-tests.chpl
 root@xxxxxxxxx:/workspace# ./sa7-student-tests
```

## VSCode setup

To ensure that Visual Studio Code recognizes `.chpl` files as Chapel files and uses the Chapel Language Server Protocol (LSP), follow these steps:

1. Install the Chapel Extension
* Open Visual Studio Code.
* Go to the Extensions view by clicking on the Extensions icon in the Activity Bar on the side of the window or by pressing Cmd+Shift+X (Mac).
* Search for "Chapel" in the Extensions Marketplace.
* Install the "Chapel Language" extension that has an author of "Chapel".

2. Associate .chpl Files with Chapel
If the .chpl files are still being recognized as JavaScript, you can manually associate them with Chapel:

* Open the Command Palette (Cmd+Shift+P on Mac).

* Search for and select Preferences: Open Settings (JSON).

* Add the following configuration to your settings.json file to associate .chpl files with Chapel:

3. Reload the Window
After making the changes, reload the VS Code window to apply the new settings.
Open the Command Palette (Cmd+Shift+P) and select Developer: Reload Window.

4. Verify the Language Mode
Open your .chpl file in VS Code.
Check the bottom-right corner of the status bar. It should display "Chapel" as the language mode.


## Background References

Both SA7 and LA3 are going to be about doing image processing in Chapel.
Here are some resources you might want to reference.

* Documentation for the Chapel Image package: https://chapel-lang.org/docs/main/modules/packages/Image.html



* Real world example in Chai, FIXME: https://github.com/Iainmon/ChAI/blob/b4df21b3ad4c45ce445842174f5c7270d35819bb/lib/Utilities.chpl
  * Figuring out an image type, https://github.com/Iainmon/ChAI/blob/b4df21b3ad4c45ce445842174f5c7270d35819bb/lib/Utilities.chpl#L321
* Demo FIXME: https://www.youtube.com/watch?v=5x3Lsn-yOD0
  * FIXME: where is life.chpl?
  * FIXME: link to Image module code, or tell them how to get there from Image.html
* Chapel con 24 tutorial session with the Image module: https://youtu.be/N2LWN3A9rck?si=rC6KOuXgrjJB6p9h&t=765


# Programming Problems to Solve in Chapel
<a name="prog"/></a>

All of your solutions will go into a single file: `sa7.chpl`.

At the start of each problem, please keep the labels with short comments, like
```
/***** Problem A *****/
```

To receive credit, your `sa7.chpl` file must compile and execute with the chpl installed in the chapel/chapel-gasnet container. For example, we must be able to compile your code without warnings or 
errors.

Please remember to **put your name, the time you spent, 
and who you collaborated with including AIs in the
comment header at the top of the 
`sa7.chpl` file**.


## Read in the images

**A.** Define a Chapel procedure that given the path to a
directory of files, returns an array of filenames.
Here is the procedure prototype.
```
proc getArrayOfFiles(dirPath: string): [] string;
```

Hints:
* See the 17-Chapel-Intro.pdf slides for relevant example code.

<hr>

**B.** Define a procedure that checks if a string ends in a
particular substring.
Here is the procedure prototype:
```
proc endsWith(s: string, suffix: string): bool;
```


**C.** Create a procedure that given the path to a directory
of image files, finds all of the `.png` files, reads them
in, and writes them out as `.bmp` files.
```
proc convertPngToBmpInDir(dirPath: string): void;
```



## Histogram of file sizes

**D.** Write a procedure that given an array of an image
returns the size of the image,
where an image size is `numRows*numCols` for each image.
Here is a prototype for the procedure:
```
proc imageSize(imageArray: [?d]): int where d.isRectangular() && d.rank == 2 {

}
```

Hints:
* You can get the domain for an array in Chapel using `arrayName.domain`.
* You can get the size of each dimension in a domain with 
`domainName.dim(0).size`, `domainName.dim(1).size`, etc.

**E.** Define a procedure that, given:
* the path to a directory of image files (dirPath),
* an image file extension as a string (e.g., "png", "bmp"),
* and the number of histogram buckets (numBuckets),

returns a 1D array representing a histogram of image sizes (where image size is width * height).

The histogram should be an array of length numBuckets. Each bucket represents a range of image sizes, from 0 up to the maximum size found. The range of each bucket is:
```
bucketSize = ceil(maxImageSize / numBuckets)
bucketRange = [i * bucketSize, (i+1) * bucketSize)
```

For each image of the given type in the directory:
* Compute its size (width × height) and save that to an array.

Then determine the max image size from that array.

Finally, for each size in the array:
* Determine which bucket it falls into,
* Increment that bucket’s count.

Here is the prototype for the procedure:
```
proc imageSizeHistogram(dirPath: string, fileExtension: string, numBuckets: int): [0..#numBuckets] int;
```

Hint:
* You might need to cast a real to an int.  Here is how you can do that in Chapel.
```
var x: real = 3.7;
var y = x:int;       // y = 3 (truncates toward zero)
```

## Edge Detection

You can read about edge detection in 
https://blog.roboflow.com/edge-detection/.
For this assignment you will be using Sobel
edge detection.

**F.** Write a procedure that given a color image array
returns a gray-scale image array using the following formula
to determine the grayscale value.
```
Y = 0.299 * R + 0.587 * G + 0.114 * B
```

Here is a reference on ways to convert to grayscale,
https://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale.

The prototype for the procedure is as follows:
```
proc rgbToGrayscale(rgbImage : [?d] int) : [d] int;
```

Hint:
* This example from the Chapel Image package might be especially relevant.
```
use Image;

var arr = readImage("input.png", imageType.png);
const fmt = (rgbColor.red, rgbColor.green, rgbColor.blue);
var colors = pixelToColor(arr, format=fmt);
[c in colors] c(1) = 0;
arr = colorToPixel(colors, format=fmt);
writeImage("output.jpg", imageType.jpg, arr);
```

**G.** Write a procedure that given a gray-scale image array 
returns a new array with the Sobel edge
detection results.
The prototype for the procedure is as follows:
```
proc sobelEdgeDetection(grayScale : [?d] int) : [d] int;
```

Below is most of the Sobel edge detection computation.
All you need to do is figure out how to determine what the
domain of the `edge` array should be.
```
// Sobel kernels
const Gx = [[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]];
const Gy = [[-1, -2, -1], [ 0,  0,  0], [ 1,  2,  1]];

var edge: [TODO] real;

forall i in TODO do
  forall j in TODO {
    var sumX = 0, sumY = 0;
    for di in -1..1 do
      for dj in -1..1 {
        const pixel = image[i+di, j+dj];
        sumX += pixel * Gx[di+1][dj+1];
        sumY += pixel * Gy[di+1][dj+1];
      }
    edge[i, j] = sqrt(sumX**2 + sumY**2) : int;
  }
```
Assume that your original image has `numRow` rows and `numCol` columns.
The resulting edge array is only going to have results for the inner 
`numRow-2` by `numCol-2` pixels.
Looking at the above code, why is that the case? (Make sure you know the
answer to this for the Final Exam.  Propose possible answers on piazza.)



# What and how to submit
<a name="submit"/></a>

Please submit one file to Gradescope:
* `sa7.chpl`

The provided test cases in `sa7-student-tests.chpl` are just examples.
There will be more thorough testing for grading.

NOTE: As of April 4th, the Gradescope assignment is not set up.  
It will get set up sometime before Monday night April 7th.

As soon as you have the file listed above, submit preliminary versions of your 
work to gradescope. Keep submitting until your work is complete; we keep the
grade from the last submission before the deadline.
<!-- Each time you submit 
you have to submit ALL the files in gradescope.  In other words, you can't just submit
one file at a time.-->

# How your work will be evaluated

Your submission will be evaluated with automated correctness tests
and with some manual reviewing of your code.  Please follow all of the
above instructions.
