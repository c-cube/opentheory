(* ========================================================================= *)
(* READING OBJECTS FROM COMMANDS                                             *)
(* Copyright (c) 2004 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

signature ObjectRead =
sig

(* ------------------------------------------------------------------------- *)
(* A type of parameters for reading objects from commands.                   *)
(* ------------------------------------------------------------------------- *)

type parameters =
     {known : ObjectThms.thms,
      interpretation : Interpretation.interpretation,
      savable : bool}

(* ------------------------------------------------------------------------- *)
(* A type of states for reading objects from commands.                       *)
(* ------------------------------------------------------------------------- *)

type state

val initial : parameters -> state

val parameters : state -> parameters

val stack : state -> ObjectStack.stack

val dict : state -> ObjectDict.dict

val thms : state -> Thm.thm ObjectProvMap.map

(* ------------------------------------------------------------------------- *)
(* Executing commands.                                                       *)
(* ------------------------------------------------------------------------- *)

val execute : Command.command -> state -> state

val executeStream : Command.command Stream.stream -> state -> state

(* ------------------------------------------------------------------------- *)
(* Executing text files.                                                     *)
(* ------------------------------------------------------------------------- *)

val executeTextFile : {filename : string} -> state -> state

(* ------------------------------------------------------------------------- *)
(* Profiling inference functions.                                            *)
(* ------------------------------------------------------------------------- *)

(*OpenTheoryDebug
type inferenceCount

val ppInferenceCount : inferenceCount Print.pp

val theInferenceCount : unit -> inferenceCount
*)

end
