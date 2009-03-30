(* ========================================================================= *)
(* OPENTHEORY COMMANDS                                                       *)
(* Copyright (c) 2004-2009 Joe Hurd, distributed under the GNU GPL version 2 *)
(* ========================================================================= *)

structure Command :> Command =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* Helper functions.                                                         *)
(* ------------------------------------------------------------------------- *)

fun natFromString err s =
    case Int.fromString s of
      SOME i => i
    | NONE => raise Error err;

(* ------------------------------------------------------------------------- *)
(* A type of commands.                                                       *)
(* ------------------------------------------------------------------------- *)

datatype command =
    Num of int
  | Name of Name.name
  | Error
  | Nil
  | Cons
  | TypeVar
  | TypeOp
  | Var
  | Const
  | Comb
  | Abs
  | Thm
  | Call
  | Return
  | Def
  | Ref
  | Remove
  | Pop
  | Dup
  | Save;

(* ------------------------------------------------------------------------- *)
(* Pretty printing.                                                          *)
(* ------------------------------------------------------------------------- *)

fun pp cmd =
    case cmd of
      Num i => Print.ppInt i
    | Name n => Name.ppQuoted n
    | Error => Print.ppString "error"
    | Nil => Print.ppString "nil"
    | Cons => Print.ppString "nil"
    | TypeVar => Print.ppString "type_var"
    | TypeOp => Print.ppString "type_op"
    | Var => Print.ppString "var"
    | Const => Print.ppString "const"
    | Comb => Print.ppString "comb"
    | Abs => Print.ppString "abs"
    | Thm => Print.ppString "thm"
    | Call => Print.ppString "call"
    | Return => Print.ppString "return"
    | Def => Print.ppString "def"
    | Ref => Print.ppString "ref"
    | Remove => Print.ppString "remove"
    | Pop => Print.ppString "pop"
    | Dup => Print.ppString "dup"
    | Save => Print.ppString "save";

val toString = Print.toString pp;

(* ------------------------------------------------------------------------- *)
(* Parsing.                                                                  *)
(* ------------------------------------------------------------------------- *)

local
  infixr 9 >>++
  infixr 8 ++
  infixr 7 >>
  infixr 6 ||

  open Parse;

  val space = many (some Char.isSpace) >> K ();

  val numParser =
      atLeastOne (some Char.isDigit) >>
      (natFromString "bad number" o implode);

  val nameParser = Name.quotedParser;

  fun commandParser s c = exactList (explode s) >> K c;
in
  val parser =
      numParser >> Num ||
      nameParser >> Name ||
      commandParser "error" Error ||
      commandParser "nil" Nil ||
      commandParser "cons" Cons ||
      commandParser "type_var" TypeVar ||
      commandParser "type_op" TypeOp ||
      commandParser "var" Var ||
      commandParser "const" Const ||
      commandParser "comb" Comb ||
      commandParser "abs" Abs ||
      commandParser "thm" Thm ||
      commandParser "call" Call ||
      commandParser "return" Return ||
      commandParser "def" Def ||
      commandParser "ref" Ref ||
      commandParser "remove" Remove ||
      commandParser "pop" Pop ||
      commandParser "dup" Dup ||
      commandParser "save" Save;

  val spacedParser = (space ++ parser ++ space) >> (fn ((),(t,())) => [t]);
end;

end