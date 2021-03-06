(* ========================================================================= *)
(* PACKAGE DOCUMENTS                                                         *)
(* Copyright (c) 2010 Joe Leslie-Hurd, distributed under the MIT license     *)
(* ========================================================================= *)

signature PackageDocument =
sig

(* ------------------------------------------------------------------------- *)
(* Package document filenames.                                               *)
(* ------------------------------------------------------------------------- *)

val mkFilename : PackageNameVersion.nameVersion -> {filename : string}

val destFilename : {filename : string} -> PackageNameVersion.nameVersion option

val isFilename : {filename : string} -> bool

(* ------------------------------------------------------------------------- *)
(* A type of package documents.                                              *)
(* ------------------------------------------------------------------------- *)

type document

(* ------------------------------------------------------------------------- *)
(* Constructors and destructors.                                             *)
(* ------------------------------------------------------------------------- *)

datatype document' =
    Document' of
      {information : PackageInformation.information option,
       checksum : Checksum.checksum option,
       summary : PackageSummary.summary,
       files : {theory : string option, tarball : string option},
       tool : Html.inline list}

val mk : document' -> document

val dest : document -> document'

(* ------------------------------------------------------------------------- *)
(* Output formats.                                                           *)
(* ------------------------------------------------------------------------- *)

val toHtml : document -> Html.html

val toHtmlFile : {document : document, filename : string} -> unit

end
