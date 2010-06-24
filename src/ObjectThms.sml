(* ========================================================================= *)
(* SYMBOLS CONTAINED IN A SET OF THEOREM OBJECTS                             *)
(* Copyright (c) 2004 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

structure ObjectThms :> ObjectThms =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* A type of object set theorems.                                            *)
(* ------------------------------------------------------------------------- *)

datatype thms =
    Thms of
      {thms : ThmSet.set,
       symbol : Symbol.symbol,
       typeOps : ObjectProv.object NameMap.map,
       consts : ObjectProv.object NameMap.map,
       seqs : ObjectProv.object SequentMap.map};

val empty =
    let
      val thms = ThmSet.empty
      and symbol = Symbol.empty
      and typeOps = NameMap.new ()
      and consts = NameMap.new ()
      and seqs = SequentMap.new ()
    in
      Thms
        {thms = thms,
         symbol = symbol,
         typeOps = typeOps,
         consts = consts,
         seqs = seqs}
    end;

fun thms (Thms {thms = x, ...}) = x;

fun symbol (Thms {symbol = x, ...}) = x;

local
  fun addSyms ((_,th),sym) = Symbol.addSequent sym (Thm.sequent th);

  fun getSyms objThs = List.foldl addSyms Symbol.empty objThs;
in
  fun fromList objThs =
      let
        val sym = getSyms objThs

        val ots = Symbol.typeOps sym
        and cons = Symbol.consts sym

        fun adds seen otO_conO objs =
            case objs of
              [] => otO_conO
            | obj :: objs =>
              let
                val id = ObjectProv.id obj
              in
                if IntSet.member id seen then adds seen otO_conO objs
                else
                  let
                    val seen = IntSet.add seen id

                    val otO_conO =
                        case ObjectProv.object obj of
                          Object.TypeOp ot =>
                          if not (TypeOpSet.member ot ots) then otO_conO
                          else
                            let
                              val (otO,conO) = otO_conO

                              val n = TypeOp.name ot

                              val otO = NameMap.insert otO (n,obj)
                            in
                              (otO,conO)
                            end
                        | Object.Const con =>
                          if not (ConstSet.member con cons) then otO_conO
                          else
                            let
                              val (otO,conO) = otO_conO

                              val n = Const.name con

                              val conO = NameMap.insert conO (n,obj)
                            in
                              (otO,conO)
                            end
                        | _ => otO_conO

                    val objs =
                        case ObjectProv.provenance obj of
                          ObjectProv.Default => objs
                        | ObjectProv.Command {arguments,...} => arguments @ objs
                  in
                    adds seen otO_conO objs
                  end
              end

        fun split (obj,th) (ths,seqs) =
            let
              val ths = ThmSet.add ths th
              and seqs = SequentMap.insert seqs (Thm.sequent th, obj)
            in
              (obj,(ths,seqs))
            end

        val ths = ThmSet.empty
        and seqs = SequentMap.new ()

        val (objs,(ths,seqs)) = maps split objThs (ths,seqs)

        val otO = NameMap.new ()
        and conO = NameMap.new ()

        val (otO,conO) = adds IntSet.empty (otO,conO) objs
      in
        Thms
          {thms = ths,
           symbol = sym,
           typeOps = otO,
           consts = conO,
           seqs = seqs}
      end
end;

(* ------------------------------------------------------------------------- *)
(* Looking up symbols and theorems.                                          *)
(* ------------------------------------------------------------------------- *)

fun peekThm (Thms {seqs,...}) seq = SequentMap.peek seqs seq;

fun peekTypeOp (Thms {typeOps,...}) n = NameMap.peek typeOps n;

fun peekConst (Thms {consts,...}) n = NameMap.peek consts n;

(* ------------------------------------------------------------------------- *)
(* Merging.                                                                  *)
(* ------------------------------------------------------------------------- *)

local
  fun noDups _ = raise Bug "ObjectThms.union.noDups";

  fun pickSnd (_,obj) = SOME obj;
in
  fun union thms1 thms2 =
      let
        val Thms
              {thms = ths1,
               symbol = sym1,
               typeOps = ots1,
               consts = cons1,
               seqs = seqs1} = thms1
        and Thms
              {thms = ths2,
               symbol = sym2,
               typeOps = ots2,
               consts = cons2,
               seqs = seqs2} = thms2

        val ths = ThmSet.union ths1 ths2
        and sym = Symbol.union sym1 sym2
        and ots = NameMap.union noDups ots1 ots2
        and cons = NameMap.union noDups cons1 cons2
        and seqs = SequentMap.union pickSnd seqs1 seqs2
      in
        Thms
          {thms = ths,
           symbol = sym,
           typeOps = ots,
           consts = cons,
           seqs = seqs}
      end;
end;

local
  fun uncurriedUnion (thms1,thms2) = union thms1 thms2;
in
  fun unionList thmsl =
      case thmsl of
        [] => empty
      | thms :: thmsl => List.foldl uncurriedUnion thms thmsl;
end;

(***
        

        val seqs = Li
                  in
                    case ObjectProv.provenance obj of
                ObjectProv.Pnull =>
                let
                  val sym = ObjectProv.symbolAddList sym [obj]
                in
                  adds objA seqs sym seen objs
                end
              | ObjectProv.Pcall _ => adds objA seqs sym seen objs
              | ObjectProv.Pcons (objH,objT) =>
                adds objA seqs sym seen (objH :: objT :: objs)
              | ObjectProv.Pref objR =>
                adds objA seqs sym seen (objR :: objs)
              | ObjectProv.Pthm _ =>
                let
                  val th =
                      case ObjectProv.object obj of
                        Object.Thm th => th
                      | _ => raise Bug "ObjectThms.add: bad thm"

                  val seq = Thm.sequent th
                in
                  if SequentMap.inDomain seq seqs then
                    adds objA seqs sym seen objs
                  else
                    let
                      val seqs = SequentMap.insert seqs (seq,(th,objA,obj))

                      val sym = ObjectProv.symbolAddList sym [obj]
                    in
                      adds objA seqs sym seen objs
                    end
                end
            end
        end;

        val (thms,seqs) =

        val 
      in
      end;
end;
    

fun objects (Thms {objs,...}) = objs;

local
  fun add (_,(_,_,objTh),set) = ObjectProvSet.add set objTh;
in
  fun thmObjects (Thms {seqs,...}) =
      SequentMap.foldl add ObjectProvSet.empty seqs;
end;

fun symbol (Thms {symbol = x, ...}) = x;

(* ------------------------------------------------------------------------- *)
(* Adding objects.                                                           *)
(* ------------------------------------------------------------------------- *)

local
  fun adds objA seqs sym seen objs =
      case objs of
        [] => (seqs,sym,seen)
      | obj :: objs =>
        let
          val id = ObjectProv.id obj
        in
          if IntSet.member id seen then adds objA seqs sym seen objs
          else
            let
              val seen = IntSet.add seen id
            in
              case ObjectProv.provenance obj of
                ObjectProv.Pnull =>
                let
                  val sym = ObjectProv.symbolAddList sym [obj]
                in
                  adds objA seqs sym seen objs
                end
              | ObjectProv.Pcall _ => adds objA seqs sym seen objs
              | ObjectProv.Pcons (objH,objT) =>
                adds objA seqs sym seen (objH :: objT :: objs)
              | ObjectProv.Pref objR =>
                adds objA seqs sym seen (objR :: objs)
              | ObjectProv.Pthm _ =>
                let
                  val th =
                      case ObjectProv.object obj of
                        Object.Thm th => th
                      | _ => raise Bug "ObjectThms.add: bad thm"

                  val seq = Thm.sequent th
                in
                  if SequentMap.inDomain seq seqs then
                    adds objA seqs sym seen objs
                  else
                    let
                      val seqs = SequentMap.insert seqs (seq,(th,objA,obj))

                      val sym = ObjectProv.symbolAddList sym [obj]
                    in
                      adds objA seqs sym seen objs
                    end
                end
            end
        end;
in
  fun add thms obj =
      let
        val Thms {objs,seqs,symbol,seen} = thms

        val objs = ObjectProvSet.add objs obj
        and (seqs,symbol,seen) = adds obj seqs symbol seen [obj]
      in
        Thms
          {objs = objs,
           seqs = seqs,
           symbol = symbol,
           seen = seen}
      end;
end;

fun singleton obj = add empty obj;

local
  fun add1 (obj,thms) = add thms obj;
in
  fun addList thms objs = List.foldl add1 thms objs;

  fun addSet thms objs = ObjectProvSet.foldl add1 thms objs;
end;

fun union ths1 ths2 =
    let
      val Thms
            {objs = objs1,
             seqs = seqs1,
             symbol = sym1,
             seen = seen1} = ths1
      and Thms
            {objs = objs2,
             seqs = seqs2,
             symbol = sym2,
             seen = seen2} = ths2

      val objs = ObjectProvSet.union objs1 objs2

      val seqs = SequentMap.union (SOME o fst) seqs1 seqs2

      val sym = Symbol.union sym1 sym2

      val seen = IntSet.union seen1 seen2
    in
      Thms
        {objs = objs,
         seqs = seqs,
         symbol = sym,
         seen = seen}
    end;

val fromList = addList empty;

(* ------------------------------------------------------------------------- *)
(* Searching for theorems.                                                   *)
(* ------------------------------------------------------------------------- *)

fun search (Thms {seqs,...}) seq =
    case SequentMap.peek seqs seq of
      NONE => NONE
    | SOME (th,obj,objTh) =>
      let
        val th = Rule.alpha seq th
      in
        SOME (th,obj,objTh)
      end;

local
  fun add (_,(th,_,_),set) = ThmSet.add set th;
in
  fun toThmSet (Thms {seqs,...}) =
      SequentMap.foldl add ThmSet.empty seqs;
end;
***)

end
