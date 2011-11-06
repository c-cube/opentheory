(* ========================================================================= *)
(* OBJECT STORE                                                              *)
(* Copyright (c) 2011 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

signature ObjectStore =
sig

(* ------------------------------------------------------------------------- *)
(* A type of object stores.                                                  *)
(* ------------------------------------------------------------------------- *)

type store

(* ------------------------------------------------------------------------- *)
(* Constructors and destructors.                                             *)
(* ------------------------------------------------------------------------- *)

val new : {filter : ObjectData.data -> bool} -> store

(* ------------------------------------------------------------------------- *)
(* Looking up objects.                                                       *)
(* ------------------------------------------------------------------------- *)

val peek : store -> ObjectData.data -> Object.object option

(* ------------------------------------------------------------------------- *)
(* Adding objects.                                                           *)
(* ------------------------------------------------------------------------- *)

val add : store -> Object.object -> store

end
