// parfilekmer.chpl
/*
   usage:
     chpl parfilekmer.chpl
     ./parfilekmer -nl 2

   # can change the directory where infiles are read
     ./parfilekmer --nl --dir="DataDir"
 */

use Map, IO;
use FileSystem, BlockDist;

config const k = 4;             // kmer length to count
config const dir = "DataDir";   // subdirectory for all data

// find all the files in the given subdirectory and put them in a distributed array
var fList = findFiles(dir);
var filenames = blockDist.createArray(0..#fList.size,string);
filenames = fList;
writeln("fList = ", fList);
writeln();
writeln("filenames = ", filenames);

// per file kmer count
forall f in filenames {
  // read in the input sequence from the file infile and strip out newlines
  var sequence, line : string;
  var infile = open(f, ioMode.r).reader();
  while infile.readLine(line) {
    sequence += line.strip();
  }

  // declare a dictionary/map to store the count per kmer
  var nkmerCounts : map(string, int);

  // count up the number of times each kmer occurs
  for ind in 0..<(sequence.size-k) {
    nkmerCounts[sequence[ind..#k]] += 1;
  }

  writeln("Number of unique k-mers in ", f, " is ", nkmerCounts.size);
  writeln();
}


