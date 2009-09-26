(* ========================================================================= *)
(* THEOREMS CONTAINED IN A SET OF OBJECTS                                    *)
(* Copyright (c) 2004 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

signature ObjectThms =
sig

(* ------------------------------------------------------------------------- *)
(* A type of object set theorems.                                            *)
(* ------------------------------------------------------------------------- *)

type thms

val empty : thms

val size : thms -> {objs : int, thms : int}

val objects : thms -> ObjectProvSet.set

val symbol : thms -> Symbol.symbol

val add : thms -> ObjectProv.object -> thms

val addList : thms -> ObjectProv.object list -> thms

val addSet : thms -> ObjectProvSet.set -> thms

val search : thms -> Sequent.sequent -> (Thm.thm * ObjectProv.object) option

val toThmSet : thms -> ThmSet.set

end
