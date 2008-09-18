(* ========================================================================= *)
(* ARTICLES OF PROOFS IN HIGHER ORDER LOGIC                                  *)
(* Copyright (c) 2004-2008 Joe Hurd, distributed under the GNU GPL version 2 *)
(* ========================================================================= *)

signature Article =
sig

(* ------------------------------------------------------------------------- *)
(* A type of proof articles.                                                 *)
(* ------------------------------------------------------------------------- *)

type article

val empty : article

val append : article -> article -> article

val saved : article -> ThmSet.set

val summarize : article -> Summary.summary

val prove : article -> Sequent.sequent -> Thm.thm option

(* ------------------------------------------------------------------------- *)
(* Input/Output.                                                             *)
(* ------------------------------------------------------------------------- *)

val fromTextFile :
    {known : ThmSet.set,
     interpretation : Interpretation.interpretation,
     filename : string} ->
    article

val toTextFile : {filename : string} -> article -> unit

end
