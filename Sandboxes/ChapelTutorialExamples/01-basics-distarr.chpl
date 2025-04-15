writeln("Hello from locale ", here.id);
config const up=2;

use BlockDist;
var D = blockDist.createDomain({1..up, 1..up});

var A: [D] real;

writeln("D = ");
writeln(D);
var B: [D] real;
B = A;
writeln("B = ");
writeln(B);
