  proc foo(out x: real, out y: [] real) {
    x = 1.2;  // OK: local copy is modified
    y = [3.4,3.4,3.4];  // OK: local copy is modified
  }

  var r: real,
      A: [1..3] real;

  foo(r, A);

  writeln((r, A));  // writes (1.2, [3.4, 3.4, 3.4])
