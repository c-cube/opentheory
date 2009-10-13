(* ========================================================================= *)
(* HIGHER ORDER LOGIC THEORY INSTANCES                                       *)
(* Copyright (c) 2009 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

structure Instance :> Instance =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* A type of theory instances.                                               *)
(* ------------------------------------------------------------------------- *)

type id = int;

datatype instance =
    Instance of
      {id : id,
       instance : instance'}

and instance' =
    Instance' of
      {package : Package.name option,
       interpretation : Interpretation.interpretation,
       import : instance list,
       theory : instance Theory.theory};

(* ------------------------------------------------------------------------- *)
(* Instance IDs.                                                             *)
(* ------------------------------------------------------------------------- *)

val newId : unit -> id =
    let
      val counter = ref 0
    in
      fn () =>
         let
           val ref count = counter
           val () = counter := count + 1
         in
           count
         end
    end;

fun id (Instance {id = x, ...}) = x;

fun equalId i inst = i = id inst;

fun compare (Instance {id = i1, ...}, Instance {id = i2, ...}) =
    Int.compare (i1,i2);

(* ------------------------------------------------------------------------- *)
(* Constructors and destructors.                                             *)
(* ------------------------------------------------------------------------- *)

fun mk inst' =
    let
      val id = newId ()
    in
      Instance
        {id = id,
         instance = inst'}
    end;

fun dest (Instance {instance = x, ...}) = x;

fun package inst =
    let
      val Instance' {package = x, ...} = dest inst
    in
      x
    end;

fun interpretation inst =
    let
      val Instance' {interpretation = x, ...} = dest inst
    in
      x
    end;

fun import inst =
    let
      val Instance' {import = x, ...} = dest inst
    in
      x
    end;

fun theory inst =
    let
      val Instance' {theory = x, ...} = dest inst
    in
      x
    end;

end
