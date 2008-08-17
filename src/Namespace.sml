(* ========================================================================= *)
(* OPENTHEORY NAMESPACES                                                     *)
(* Copyright (c) 2004-2008 Joe Hurd, distributed under the GNU GPL version 2 *)
(* ========================================================================= *)

structure Namespace :> Namespace =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* A type of namespaces.                                                     *)
(* ------------------------------------------------------------------------- *)

datatype namespace = Namespace of string list;

(* ------------------------------------------------------------------------- *)
(* The top level namespace.                                                  *)
(* ------------------------------------------------------------------------- *)

val global = Namespace [];

fun isGlobal (Namespace n) = null n;

val globalString = ".";

(* ------------------------------------------------------------------------- *)
(* Nested namespaces (i.e., everything except the top level).                *)
(* ------------------------------------------------------------------------- *)

fun mkNested (Namespace ns, n) = Namespace (ns @ [n]);

fun destNested (Namespace ns) =
    case rev ns of
      [] => raise Error "Namespace.destNested"
    | n :: ns => (Namespace (rev ns), n);

val isNested = can destNested;

(* ------------------------------------------------------------------------- *)
(* A total ordering.                                                         *)
(* ------------------------------------------------------------------------- *)

fun compare (Namespace n1, Namespace n2) = lexCompare String.compare (n1,n2);

(* ------------------------------------------------------------------------- *)
(* Rewriting namespaces.                                                     *)
(* ------------------------------------------------------------------------- *)

local
  fun stripPrefix [] ys = SOME ys
    | stripPrefix (x :: xs) ys =
      case ys of
        [] => NONE
      | y :: ys => if x = y then stripPrefix xs ys else NONE;
in
  fun rewrite (Namespace xs, Namespace ys) (n as Namespace ns) =
      case stripPrefix xs ns of
        NONE => n
      | SOME ns => Namespace (ys @ ns);
end;

(* ------------------------------------------------------------------------- *)
(* Parsing and pretty printing.                                              *)
(* ------------------------------------------------------------------------- *)

local
  fun dotify ns = join "." ns;
in
  fun toString (n as Namespace ns) =
      if isGlobal n then globalString else dotify ns;
end;

local
  infixr 9 >>++
  infixr 8 ++
  infixr 7 >>
  infixr 6 ||

  open Parser;

  val globalChars = explode globalString;

  val isSpecialChar = C mem (explode "\"\\.");

  val escapeParser =
      some isSpecialChar ||
      (exact #"n" >> K #"\n") ||
      (exact #"t" >> K #"\t") ||
      (any >> (fn c => raise Error ("bad escaped char: \\" ^ str c)));

  val componentCharParser =
      (exact #"\n" >> (fn _ => raise Error "newline in quote")) ||
      ((exact #"\\" ++ escapeParser) >> snd) ||
      some (not o isSpecialChar);

  val componentParser = many componentCharParser >> implode;

  val dotComponentParser = (exact #"." ++ componentParser) >> snd;
in
  val parser =
      (exactList globalChars >> K global) ||
      (componentParser ++ many dotComponentParser) >> (Namespace o op::);
end;

end