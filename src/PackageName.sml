(* ========================================================================= *)
(* PACKAGE NAMES                                                             *)
(* Copyright (c) 2010 Joe Hurd, distributed under the MIT license            *)
(* ========================================================================= *)

structure PackageName :> PackageName =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* Constants.                                                                *)
(* ------------------------------------------------------------------------- *)

val authorString = "author"
and avoidString = "a"
and descriptionString = "description"
and extraSuffixString = "file"
and gilithString = "gilith"
and haskellString = "haskell"
and installedString = "installed"
and licenseString = "license"
and mainString = "main"
and nameString = "name"
and opentheoryString = "opentheory"
and requiresString = "requires"
and separatorChar = #"-"
and showString = "show"
and srcString = "src"
and testString = "test"
and versionString = "version";

val separatorString = str separatorChar;

(* ------------------------------------------------------------------------- *)
(* A type of theory package names.                                           *)
(* ------------------------------------------------------------------------- *)

datatype name = Name of string list;

(* ------------------------------------------------------------------------- *)
(* Concatenation.                                                            *)
(* ------------------------------------------------------------------------- *)

fun append (Name n1) (Name n2) = Name (n1 @ n2);

local
  fun add (Name n, l) = n @ l;
in
  fun concat ns =
      if List.null ns then raise Error "PackageName.concat"
      else
        let
          val n = List.foldl add [] (List.rev ns)
        in
          Name n
        end;
end;

(* ------------------------------------------------------------------------- *)
(* A total order.                                                            *)
(* ------------------------------------------------------------------------- *)

fun compare (Name n1, Name n2) = lexCompare String.compare (n1,n2);

fun equal (n1 : name) n2 = n1 = n2;

(* ------------------------------------------------------------------------- *)
(* Generating fresh names.                                                   *)
(* ------------------------------------------------------------------------- *)

fun avoidName i = Name [avoidString ^ Int.toString i];

fun variantName {avoid} n =
    let
      fun mkNum i =
          let
            val ni = append n (avoidName i)
          in
            if avoid ni then mkNum (i + 1) else ni
          end
    in
      if avoid n then mkNum 1 else n
    end;

(* ------------------------------------------------------------------------- *)
(* Prefix and suffix names.                                                  *)
(* ------------------------------------------------------------------------- *)

local
  fun stripStrictPrefix xs ys =
      case ys of
        [] => NONE
      | y :: ys' =>
        case xs of
          [] => SOME ys
        | x :: xs' => if x = y then stripStrictPrefix xs' ys' else NONE;
in
  fun destStrictPrefix (Name xs) (Name ys) =
      case stripStrictPrefix xs ys of
        NONE => NONE
      | SOME ys => SOME (Name ys);

  fun destStrictSuffix (Name xs) (Name ys) =
      case stripStrictPrefix (List.rev xs) (List.rev ys) of
        NONE => NONE
      | SOME ys => SOME (Name (List.rev ys));
end;

fun isStrictPrefix n1 n2 = Option.isSome (destStrictPrefix n1 n2);

fun isStrictSuffix n1 n2 = Option.isSome (destStrictSuffix n1 n2);

fun isPrefix n1 n2 = equal n1 n2 orelse isStrictPrefix n1 n2;

fun isSuffix n1 n2 = equal n1 n2 orelse isStrictSuffix n1 n2;

local
  fun collect acc xs =
      case xs of
        [] => acc
      | _ :: xs => collect (xs :: acc) xs;

  fun revMap f =
      let
        fun g (xs,ns) = f xs :: ns
      in
        List.foldl g []
      end;

  fun revName xs = Name (List.rev xs);
in
  fun strictPrefixes (Name xs) = revMap revName (collect [] (List.rev xs));

  fun strictSuffixes (Name xs) = revMap Name (collect [] xs);
end;

fun prefixes n = n :: strictPrefixes n;

fun suffixes n = n :: strictSuffixes n;

(* ------------------------------------------------------------------------- *)
(* Pretty printing.                                                          *)
(* ------------------------------------------------------------------------- *)

fun toString (Name n) = String.concatWith separatorString n;

val pp = Print.ppMap toString Print.ppString;

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

  val componentParser =
      let
        fun isInitialChar c = Char.isLower c

        fun isSubsequentChar c = Char.isLower c orelse Char.isDigit c
      in
        (some isInitialChar ++ many (some isSubsequentChar)) >>
        (fn (c,cs) => String.implode (c :: cs))
      end;
in
  val parser =
      componentParser ++
      many (separatorParser ++ componentParser >> snd) >>
      (fn (b,l) => Name (b :: l));
end;

fun fromString s =
    Parse.fromString parser s
    handle Parse.NoParse =>
      raise Error ("bad package name format: " ^ s);

(* ------------------------------------------------------------------------- *)
(* Theory block names.                                                       *)
(* ------------------------------------------------------------------------- *)

val mainTheory = Name [mainString];

(* ------------------------------------------------------------------------- *)
(* Tag names.                                                                *)
(* ------------------------------------------------------------------------- *)

(* Package basics *)

val authorTag = Name [authorString];

val descriptionTag = Name [descriptionString];

val licenseTag = Name [licenseString];

val nameTag = Name [nameString];

val versionTag = Name [versionString];

(* Extra package files *)

val extraSuffixTag = Name [extraSuffixString];

(* Package requirements *)

val requiresTag = Name [requiresString];

(* Shows *)

val showTag = Name [showString];

(* ------------------------------------------------------------------------- *)
(* Directory checksums names.                                                *)
(* ------------------------------------------------------------------------- *)

val installedChecksums = Name [installedString];

(* ------------------------------------------------------------------------- *)
(* Repo names.                                                               *)
(* ------------------------------------------------------------------------- *)

val gilithRepo = Name [gilithString];

(* ------------------------------------------------------------------------- *)
(* Haskell export names.                                                     *)
(* ------------------------------------------------------------------------- *)

val haskell = Name [haskellString]
and srcHaskellTheory = Name [srcString]
and testHaskellTheory = Name [testString];

local
  val opentheory = Name [opentheoryString];
in
  fun exportHaskell hn =
      if equal hn haskell then SOME opentheory
      else
        case destStrictPrefix haskell hn of
          SOME n => SOME (append opentheory n)
        | NONE => NONE;
end;

fun isHaskell hn = Option.isSome (exportHaskell hn);

(* ------------------------------------------------------------------------- *)
(* Export names.                                                             *)
(* ------------------------------------------------------------------------- *)

fun isExport n = isHaskell n;

end

structure PackageNameOrdered =
struct type t = PackageName.name val compare = PackageName.compare end

structure PackageNameMap = KeyMap (PackageNameOrdered)

structure PackageNameSet =
struct

  local
    structure S = ElementSet (PackageNameMap);
  in
    open S;
  end;

  local
    fun addStrictPrefixes (n,s) =
        if member n s then s
        else addList s (PackageName.strictPrefixes n);
  in
    val strictPrefixes = foldr addStrictPrefixes empty;
  end;

  val pp =
      Print.ppMap
        toList
        (Print.ppBracket "{" "}" (Print.ppOpList "," PackageName.pp));

end
