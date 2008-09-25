(* ========================================================================= *)
(* NAMES                                                                     *)
(* Copyright (c) 2004-2008 Joe Hurd, distributed under the GNU GPL version 2 *)
(* ========================================================================= *)

structure Name :> Name =
struct

open Useful;

infixr ==

val op== = Portable.pointerEqual;

(* ------------------------------------------------------------------------- *)
(* A type of names.                                                          *)
(* ------------------------------------------------------------------------- *)

datatype name = Name of Namespace.namespace * string;

val mk = Name;

fun dest (Name n) = n;

fun mkGlobal s = Name (Namespace.global,s);

fun destGlobal (Name (n,s)) =
    if Namespace.isGlobal n then s
    else raise Error "Name.destGlobal";

val isGlobal = can destGlobal;

(* ------------------------------------------------------------------------- *)
(* A total ordering.                                                         *)
(* ------------------------------------------------------------------------- *)

fun compare (Name n1, Name n2) =
    prodCompare Namespace.compare String.compare (n1,n2);

fun equal (Name (ns1,n1)) (Name (ns2,n2)) =
    n1 = n2 andalso Namespace.equal ns1 ns2;

(* ------------------------------------------------------------------------- *)
(* Rewriting names.                                                          *)
(* ------------------------------------------------------------------------- *)

fun rewrite x_y (name as Name (ns,n)) =
    let
      val ns' = Namespace.rewrite x_y ns
    in
      if ns' == ns then name else Name (ns',n)
    end;

fun replace (x,y) n : name = if equal n x then y else n;

(* ------------------------------------------------------------------------- *)
(* Parsing and pretty printing.                                              *)
(* ------------------------------------------------------------------------- *)

fun toString (Name ns_n) = Namespace.toString (Namespace.mkNested ns_n);

val pp = Print.ppMap toString Print.ppString;

fun quotedToString (Name ns_n) =
    Namespace.quotedToString (Namespace.mkNested ns_n);

val ppQuoted = Print.ppMap quotedToString Print.ppString;

local
  infixr 9 >>++
  infixr 8 ++
  infixr 7 >>
  infixr 6 ||

  open Parse;

  fun process ns =
      if Namespace.isGlobal ns then raise NoParse
      else Name (Namespace.destNested ns);
in
  val quotedParser = Namespace.quotedParser >> process;
end;

end

structure NameOrdered =
struct type t = Name.name val compare = Name.compare end

structure NameSet =
struct

  local
    structure S = ElementSet (NameOrdered);
  in
    open S;
  end;

  val pp =
      Print.ppMap
        toList
        (Print.ppBracket "{" "}" (Print.ppOpList "," Name.pp));

end

structure NameMap = KeyMap (NameOrdered)
