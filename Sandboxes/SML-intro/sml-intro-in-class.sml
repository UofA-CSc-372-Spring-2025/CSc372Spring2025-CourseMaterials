(* Starting point for SML-intro sandbox *)

(* indicate planning to use the Unit testing module *)
(* use "Unit.sml"; *)

(* Example function definition *)

fun mynull []       = true
  | mynull (_::_)   = false

(* Example call to unit checker *)
val () =
    Unit.checkExpectWith Bool.toString "mynull [] should be true"
    (fn () => mynull [])
    true


(* Unit testing reporting *)

val () = Unit.report()
val () = Unit.reportWhenFailures ()  (* put me at the _end_ *)