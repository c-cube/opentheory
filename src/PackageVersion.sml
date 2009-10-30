(* ========================================================================= *)
(* PACKAGE VERSIONS                                                          *)
(* Copyright (c) 2009 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

structure PackageVersion :> PackageVersion =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* Constants.                                                                *)
(* ------------------------------------------------------------------------- *)

val separatorString = ".";

(* ------------------------------------------------------------------------- *)
(* A type of theory package versions.                                        *)
(* ------------------------------------------------------------------------- *)

datatype version = Version of int * int list;

(* ------------------------------------------------------------------------- *)
(* A total order.                                                            *)
(* ------------------------------------------------------------------------- *)

fun compare (v1,v2) =
    let
      val Version (i1,l1) = v1
      and Version (i2,l2) = v2
    in
      case Int.compare (i1,i2) of
        LESS => LESS
      | EQUAL => lexCompare Int.compare (l1,l2)
      | GREATER => GREATER
    end;

fun equal (Version v1) (Version v2) = v1 = v2;

(* ------------------------------------------------------------------------- *)
(* Pretty printing.                                                          *)
(* ------------------------------------------------------------------------- *)

val ppSeparator = Print.addString separatorString;

fun pp (Version (i,l)) =
    Print.program
      (Print.ppInt i :: map (Print.sequence ppSeparator o Print.ppInt) l);

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

  val separatorParser = exactString separatorString;

  val zeroParser = exactChar #"0" >> K 0;

  val nonzeroParser =
      exactChar #"1" >> K 1 ||
      exactChar #"2" >> K 2 ||
      exactChar #"3" >> K 3 ||
      exactChar #"4" >> K 4 ||
      exactChar #"5" >> K 5 ||
      exactChar #"6" >> K 6 ||
      exactChar #"7" >> K 7 ||
      exactChar #"8" >> K 8 ||
      exactChar #"9" >> K 9;

  val digitParser = zeroParser || nonzeroParser;

  local
    fun mkNum acc l =
        case l of
          [] => acc
        | d :: l => mkNum (10 * acc + d) l;
  in
    val componentParser =
        zeroParser ||
        nonzeroParser ++ many digitParser >> uncurry mkNum;
  end;
in
  val parser =
      componentParser ++
      many (separatorParser ++ componentParser >> snd) >>
      Version;
end;

end