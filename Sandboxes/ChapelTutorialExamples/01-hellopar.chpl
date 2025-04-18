// hellopar.chpl

/*
   This is a shorter version of hello6-taskpar-dist.chpl.  It has fewer 
   comments and uses fewer string operations.

   usage:
     chpl hellopar.chpl
     ./hellopar -nl 2

     # something else to try
     ./hellopar -nl 4 --tasksPerLocale=3

*/


// The number of tasks to use per locale.  Specify on command line with 
// --tasksPerLocal=n, where n is some number.
config const tasksPerLocale = here.maxTaskPar;

// Creates a task per locale
coforall loc in Locales do on loc {
  coforall tid in 0..#tasksPerLocale {

    writeln("Hello world! (from task ", tid, " of ", tasksPerLocale,
            " on locale ", here.id, " of ", numLocales, ")");
  }
}

writeln();
writeln("Output from forall loop follows:");
var numTasks = Locales.size*tasksPerLocale;
forall i in 0..#numTasks {
    writeln("Hello world! (from iter ", i, " of ", numTasks,
            " on locale ", here.id, " of ", numLocales, ")");
}
