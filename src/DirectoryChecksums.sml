(* ========================================================================= *)
(* PACKAGE DIRECTORY CHECKSUMS                                               *)
(* Copyright (c) 2010 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

structure DirectoryChecksums :> DirectoryChecksums =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* Constants.                                                                *)
(* ------------------------------------------------------------------------- *)

val fileExtension = "pkg";

(* ------------------------------------------------------------------------- *)
(* Checksums filenames.                                                      *)
(* ------------------------------------------------------------------------- *)

fun mkFilename base =
    let
      val filename =
          OS.Path.joinBaseExt
            {base = base,
             ext = SOME fileExtension}
    in
      {filename = filename}
    end;

(* ------------------------------------------------------------------------- *)
(* A pure type of package checksums.                                         *)
(* ------------------------------------------------------------------------- *)

datatype pureChecksums =
    PureChecksums of Checksum.checksum PackageNameMap.map;

val emptyPure = PureChecksums (PackageNameMap.new ());

fun peekPure (PureChecksums m) = PackageNameMap.peek m;

fun memberPure n (PureChecksums m) = PackageNameMap.inDomain n m;

fun insertPure pc (n,c) =
    if memberPure n pc then
      raise Error ("multiple entries for package " ^ PackageName.toString n)
    else
      let
        val PureChecksums m = pc

        val m = PackageNameMap.insert m (n,c)
      in
        PureChecksums m
      end;

fun uncurriedInsertPure (n_c,pc) = insertPure pc n_c;

fun deletePure (PureChecksums m) n =
    PureChecksums (PackageNameMap.delete m n);

local
  infixr 9 >>++
  infixr 8 ++
  infixr 7 >>
  infixr 6 ||

  open Parse;
in
  val parserPackageChecksum =
      (PackageName.parser ++
       exactChar #" " ++
       Checksum.parser ++
       exactChar #"\n") >>
      (fn (n,((),(c,()))) => [(n,c)]);
end;

fun fromTextFilePure {filename} =
    let
      (* Estimating parse error line numbers *)

      val lines = Stream.fromTextFile {filename = filename}

      val {chars,parseErrorLocation} = Parse.initialize {lines = lines}
    in
      (let
         (* The character stream *)

         val chars = Parse.everything Parse.any chars

         (* The package stream *)

         val pkgs = Parse.everything parserPackageChecksum chars
       in
         Stream.foldl uncurriedInsertPure emptyPure pkgs
       end
       handle Parse.NoParse => raise Error "parse error")
      handle Error err =>
        raise Error ("error in installed package list \"" ^ filename ^ "\" " ^
                     parseErrorLocation () ^ "\n" ^ err)
    end;

local
  fun toLinePackageChecksum (n,c) =
      PackageName.toString n ^ " " ^ Checksum.toString c ^ "\n";
in
  fun toTextFilePure {checksums = PureChecksums m, filename = f} =
      let
        val strm = PackageNameMap.toStream m

        val strm = Stream.map toLinePackageChecksum strm
      in
        Stream.toTextFile {filename = f} strm
      end;
end;

(* ------------------------------------------------------------------------- *)
(* A type of package directory checkums.                                     *)
(* ------------------------------------------------------------------------- *)

datatype checksums =
    Checksums of
      {filename : string,
       checksums : pureChecksums option ref};

(* ------------------------------------------------------------------------- *)
(* Constructors and destructors.                                             *)
(* ------------------------------------------------------------------------- *)

fun mk {filename} =
    let
      val checksums = ref NONE
    in
      Checksums
        {filename = filename,
         checksums = checksums}
    end;

fun filename (Checksums {filename = x, ...}) = {filename = x};

fun checksums chks =
    let
      val Checksums {checksums = rox, ...} = chks

      val ref ox = rox
    in
      case ox of
        SOME x => x
      | NONE =>
        let
          val x = fromTextFilePure (filename chks)

          val () = rox := SOME x
        in
          x
        end
    end;

(* ------------------------------------------------------------------------- *)
(* Creating a new package checksums file.                                    *)
(* ------------------------------------------------------------------------- *)

fun create {filename} =
    let
      val cmd = "touch " ^ filename

(*OpenTheoryTrace1
      val () = print (cmd ^ "\n")
*)

      val () =
          if OS.Process.isSuccess (OS.Process.system cmd) then ()
          else raise Error "creating an empty installed package list failed"
    in
      ()
    end;

(* ------------------------------------------------------------------------- *)
(* Looking up packages.                                                      *)
(* ------------------------------------------------------------------------- *)

fun peek chks n = peekPure (checksums chks) n;

fun member n chks = memberPure n (checksums chks);

(* ------------------------------------------------------------------------- *)
(* Adding a new package.                                                     *)
(* ------------------------------------------------------------------------- *)

fun add chks (n,c) =
    let
      val Checksums {filename = f, checksums = rox} = chks

      val () =
          case !rox of
            NONE => ()
          | SOME x => rox := SOME (insertPure x (n,c))

      val cmd =
          "echo \"" ^ PackageName.toString n ^ " " ^
          Checksum.toString c ^ "\"" ^ " >> " ^ f

(*OpenTheoryTrace1
      val () = print (cmd ^ "\n")
*)

      val () =
          if OS.Process.isSuccess (OS.Process.system cmd) then ()
          else raise Error "adding to the installed package list failed"
    in
      ()
    end;

(* ------------------------------------------------------------------------- *)
(* Deleting a package.                                                       *)
(* ------------------------------------------------------------------------- *)

fun delete chks n =
    let
      val x = deletePure (checksums chks) n

      val Checksums {filename = f, checksums = rox} = chks

      val () = rox := SOME x

      val () = toTextFilePure {checksums = x, filename = f}
    in
      ()
    end;

(* ------------------------------------------------------------------------- *)
(* Updating the package list.                                                *)
(* ------------------------------------------------------------------------- *)

fun update chks {url} =
    let
      val Checksums {filename = f, checksums = rox} = chks

      val () = rox := NONE

      val cmd = "curl --silent --show-error " ^ url ^ " --output " ^ f

(*OpenTheoryTrace1
      val () = print (cmd ^ "\n")
*)

      val () =
          if OS.Process.isSuccess (OS.Process.system cmd) then ()
          else raise Error "updating the package list failed"
    in
      ()
    end;

end
