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
(* Adding objects.                                                           *)
(* ------------------------------------------------------------------------- *)

val add : store -> Object.object -> store

(* ------------------------------------------------------------------------- *)
(* Looking up objects.                                                       *)
(* ------------------------------------------------------------------------- *)

val peek : store -> ObjectData.data -> Object.object option

val get : store -> ObjectData.data -> Object.object

(* ------------------------------------------------------------------------- *)
(* Using the store to construct objects.                                     *)
(* ------------------------------------------------------------------------- *)

val build : ObjectData.data -> store -> Object.object * store

end
