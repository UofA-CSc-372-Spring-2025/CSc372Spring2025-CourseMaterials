writeln("Hello from locale ", here.id);

var A: [1..2, 1..2] real;

use BlockDist;

var D = blockDist.createDomain({1..3, 1..3});
writeln("D = ");
writeln(D);
var B: [D] real;
B = A;
writeln("B = ");
writeln(B);
