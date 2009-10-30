(* ========================================================================= *)
(* THEORY PACKAGE DIRECTORIES                                                *)
(* Copyright (c) 2009 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

structure Directory :> Directory =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* Constants.                                                                *)
(* ------------------------------------------------------------------------- *)

val configFile = "config";

val packagesDirectory = "packages";

val theoryExtension = "txt";

(* ------------------------------------------------------------------------- *)
(* Directories and filenames.                                                *)
(* ------------------------------------------------------------------------- *)

fun mkConfigFilename {rootDirectory} =
    OS.Path.joinDirFile {dir = rootDirectory, file = configFile};

fun mkPackagesDirectory {rootDirectory} =
    OS.Path.joinDirFile
      {dir = rootDirectory, file = packagesDirectory};

fun mkPackageDirectory root pkg =
    let
      val directory = mkPackagesDirectory root
    in
      OS.Path.joinDirFile
        {dir = directory, file = PackageName.toString pkg}
    end;

fun mkTheoryFile pkg =
    OS.Path.joinBaseExt
      {base = PackageName.base pkg, ext = SOME theoryExtension};

fun mkTheoryFilename {directory} pkg =
      OS.Path.joinDirFile {dir = directory, file = mkTheoryFile pkg};

(* ------------------------------------------------------------------------- *)
(* Repos.                                                                    *)
(* ------------------------------------------------------------------------- *)

datatype repo =
    Repo of
      {name : string,
       packages : {filename : string} list option PackageNameMap.map ref};

fun mkRepo {name} =
    let
      val packages = ref (PackageNameMap.new ())
    in
      Repo
        {name = name,
         packages = packages}
    end;

fun nameRepo (Repo {name = x, ...}) = x;

fun filesRepo repo pkg =
    let
      val Repo {packages, ...} = repo
      val ref pkgs = packages
    in
      case PackageNameMap.peek pkgs pkg of
        SOME pf => pf
      | NONE => raise Bug "Directory.filesRepo: web repos not implemented"
    end;

fun containsRepo repo pkg = Option.isSome (filesRepo repo pkg);

(* ------------------------------------------------------------------------- *)
(* Configuration.                                                            *)
(* ------------------------------------------------------------------------- *)

datatype config =
    Config of
      {repos : repo list};

val defaultConfig =
    let
      val repos = []
    in
      Config {repos = repos}
    end;

local
  val reposHandler =
      let
        fun beginSection config = config

        fun processLine (line,config) =
            let
              val Config {repos} = config

              val repo = mkRepo {name = line}

              val repos = repos @ [repo]
            in
              Config {repos = repos}
            end

        fun endSection config = config
      in
        Config.SectionHandler
          {beginSection = beginSection,
           processLine = processLine,
           endSection = endSection}
      end;

  fun sectionHandler section =
      if section = "repos" then SOME reposHandler
      else NONE;

  val handler = Config.Handler sectionHandler;
in
  fun readConfig filename =
      Config.read handler defaultConfig filename
      handle IO.Io _ => defaultConfig;
end;

fun reposConfig (Config {repos = x, ...}) = x;

(* ------------------------------------------------------------------------- *)
(* Packages.                                                                 *)
(* ------------------------------------------------------------------------- *)

datatype package =
    Package of
      {directory : string,
       filename : string,
       contents : Package.package};

fun lookupPackage root pkg =
    let
      val directory = mkPackageDirectory root pkg

      val filename = mkTheoryFilename {directory = directory} pkg

      val maybeContents =
          SOME (Package.fromTextFile {filename = filename})
          handle IO.Io _ => NONE
    in
      case maybeContents of
        NONE => NONE
      | SOME contents =>
        let
          val package =
              Package
                {directory = directory,
                 filename = filename,
                 contents = contents}
        in
          SOME package
        end
    end;

fun mkPackage {filename} =
    let
      val directory = OS.Path.dir filename

      val contents = Package.fromTextFile {filename = filename}
    in
      Package
        {directory = directory,
         filename = filename,
         contents = contents}
    end;

fun directoryPackage (Package {directory = x, ...}) = {directory = x};

fun filenamePackage (Package {filename = x, ...}) = {filename = x};

fun contentsPackage (Package {contents = x, ...}) = x;

(* ------------------------------------------------------------------------- *)
(* A type of theory package directories.                                     *)
(* ------------------------------------------------------------------------- *)

datatype directory =
    Directory of
      {rootDirectory : string,
       config : config Lazy.lazy,
       packages : package option PackageNameMap.map ref};

fun mk {rootDirectory} =
    let
      fun thunkConfig () =
          let
            val filename = mkConfigFilename {rootDirectory = rootDirectory}
          in
            readConfig {filename = filename}
          end

      val config = Lazy.delay thunkConfig

      val packages = ref (PackageNameMap.new ())
    in
      Directory
        {rootDirectory = rootDirectory,
         config = config,
         packages = packages}
    end;

fun root (Directory {rootDirectory = x, ...}) = {directory = x};

fun config (Directory {config = x, ...}) = Lazy.force x;

fun repos dir = reposConfig (config dir);

fun lookup dir pkg =
    let
      val Directory {rootDirectory,packages,...} = dir

      val ref pkgs = packages
    in
      case PackageNameMap.peek pkgs pkg of
        SOME p => p
      | NONE =>
        let
          val mp = lookupPackage {rootDirectory = rootDirectory} pkg

          val pkgs = PackageNameMap.insert pkgs (pkg,mp)

          val () = packages := pkgs
        in
          mp
        end
    end;

end