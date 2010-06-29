(* ========================================================================= *)
(* THEOREMS AND THEIR SYMBOLS                                                *)
(* Copyright (c) 2009 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

signature Thms =
sig

(* ------------------------------------------------------------------------- *)
(* A type of theorems and their symbols.                                     *)
(* ------------------------------------------------------------------------- *)

type thms

val empty : thms

val size : thms -> int

val thms : thms -> ThmSet.set

val symbol : thms -> Symbol.symbol

(* ------------------------------------------------------------------------- *)
(* Adding theorems.                                                          *)
(* ------------------------------------------------------------------------- *)

val add : thms -> Thm.thm -> thms

val addList : thms -> Thm.thm list -> thms

val addSet : thms -> ThmSet.set -> thms

val singleton : Thm.thm -> thms

val fromList : Thm.thm list -> thms

val fromSet : ThmSet.set -> thms

(* ------------------------------------------------------------------------- *)
(* Merging.                                                                  *)
(* ------------------------------------------------------------------------- *)

val union : thms -> thms -> thms

val unionList : thms list -> thms

(* ------------------------------------------------------------------------- *)
(* Searching for theorems.                                                   *)
(* ------------------------------------------------------------------------- *)

val search : thms -> Sequent.sequent -> Thm.thm option

end
