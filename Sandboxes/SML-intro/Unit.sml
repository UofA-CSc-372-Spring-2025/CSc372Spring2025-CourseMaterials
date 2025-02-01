structure Unit = struct

val ran = ref 0
val passed = ref 0

fun eprint   s = TextIO.output (TextIO.stdErr, s)
fun eprintln s = (eprint s; eprint "\n")

fun passTest () = (ran := !ran + 1; passed := !passed + 1)
fun failTest msgs = (ran := !ran + 1; app eprint msgs; eprint "\n")

fun checkExpectWith show name thunk a =
  let val a' = thunk ()
  in  if a' = a then
        passTest ()
      else
        failTest ["In test '", name, "', expected value ", show a, " but got ", show a']
  end handle e =>
    failTest ["In test '", name, "', expected value ", show a, " but got exception ", exnName e]

fun checkAssert name thunk =
  let val a' = thunk ()
  in  if a' then
        passTest ()
      else
        failTest ["In test '", name, "', the assertion was not satisfied"]
  end handle e =>
    failTest ["In test '", name, "', the assertion raised exception ", exnName e]

fun checkExnSatisfiesWith show name thunk (ename, pred) =
  let val a' = thunk ()
  in  failTest ["In test '", name, "', expected exception ", ename,
                " but got value ", show a']
  end handle e =>
    if pred e then
      passTest ()
    else
      failTest ["In test '", name, "', expected exception ", ename,
                " but got some other exception named ", exnName e]

fun checkExnWith show name thunk =
  checkExnSatisfiesWith show name thunk ("any exception", fn _ => true)


fun reportTestResultsOf what (npassed, nthings) =
  case (npassed, nthings)
    of (_, 0) => ()  (* no report *)
     | (0, 1) => eprintln ("The only " ^ what ^ " failed.")
     | (1, 1) => eprintln ("The only " ^ what ^ " passed.")
     | (0, 2) => eprintln ("Both " ^ what ^ "s failed.")
     | (1, 2) => eprintln ("One of two " ^ what ^ "s passed.")
     | (2, 2) => eprintln ("Both " ^ what ^ "s passed.")
     | _ => if npassed = nthings then
               app eprint ["All ", Int.toString nthings, " " ^ what ^ "s passed.\n"]
            else if npassed = 0 then
               app eprint ["All ", Int.toString nthings, " " ^ what ^ "s failed.\n"]
            else
               app eprint [Int.toString npassed, " of ", Int.toString nthings,
                          " " ^ what ^ "s passed.\n"]

fun report () = reportTestResultsOf "internal Unit test" (!passed, !ran)

fun reportWhenFailures () =
  if !passed <> !ran then
    reportTestResultsOf "internal Unit test" (!passed, !ran)
  else
    ()



fun listString _ [] = "[]"
  | listString show (x::xs) =
      concat ("[" :: show x :: foldr (fn (y, tail) => ", " :: show y :: tail) ["]"] xs)

fun optionString show NONE = "NONE"
  | optionString show (SOME x) = "SOME (" ^ show x ^ ")"

fun pairString showa showb (a, b) = "(" ^ showa a ^ ", " ^ showb b ^ ")"

fun showNothing _ = "a value"

val intString = Int.toString
val stringString = fn s => "\"" ^ String.toCString s ^ "\""
val boolString = Bool.toString

end;