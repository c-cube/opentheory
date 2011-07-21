(* ========================================================================= *)
(* HIGHER ORDER LOGIC CONSTANTS                                              *)
(* Copyright (c) 2009 Joe Hurd, distributed under the GNU GPL version 2      *)
(* ========================================================================= *)

structure Const :> Const =
struct

open Useful;

(* ------------------------------------------------------------------------- *)
(* A type of constants.                                                      *)
(* ------------------------------------------------------------------------- *)

type const = TypeTerm.const;

type constData =
     {name : Name.name,
      prov : TypeTerm.provConst};

val mk = TypeTerm.Const;

fun dest (TypeTerm.Const data) = data;

(* ------------------------------------------------------------------------- *)
(* Constructors and destructors.                                             *)
(* ------------------------------------------------------------------------- *)

val name = TypeTerm.nameConst;

val prov = TypeTerm.provConst;

fun mkUndef name =
    let
      val prov = TypeTerm.UndefProvConst
    in
      mk
        {name = name,
         prov = prov}
    end;

fun isUndef c =
    case prov c of
      TypeTerm.UndefProvConst => true
    | _ => false;

(* ------------------------------------------------------------------------- *)
(* A total order.                                                            *)
(* ------------------------------------------------------------------------- *)

val compare = TypeTerm.compareConst;

val equal = TypeTerm.equalConst;

(* ------------------------------------------------------------------------- *)
(* Reconstructing the type from the provenance.                              *)
(* ------------------------------------------------------------------------- *)

local
  fun isoTys ot =
      let
        val (pred,tyVars) =
            case TypeOp.prov ot of
              TypeTerm.DefProvOpTy def =>
              let
                val TypeTerm.DefOpTy {pred,vars} = def
              in
                (pred,vars)
              end
            | _ => raise Bug "Const.typeOf.AbsProvConst: not a defined type op"

        val abs = Type.mkOp (ot, List.map Type.mkVar tyVars)
        and rep = Type.domainFun (TypeTerm.typeOf pred)
      in
        {abs = abs, rep = rep}
      end;
in
  fun typeOf c =
      case prov c of
        TypeTerm.UndefProvConst => NONE
      | TypeTerm.DefProvConst def =>
        let
          val TypeTerm.DefConst tm = def
        in
          SOME (TypeTerm.typeOf tm)
        end
      | TypeTerm.AbsProvConst ot =>
        let
          val {abs,rep} = isoTys ot
        in
          SOME (Type.mkFun (rep,abs))
        end
      | TypeTerm.RepProvConst ot =>
        let
          val {abs,rep} = isoTys ot
        in
          SOME (Type.mkFun (abs,rep))
        end;
end;

(* ------------------------------------------------------------------------- *)
(* Primitive constants.                                                      *)
(* ------------------------------------------------------------------------- *)

(* Equality *)

val eq = mkUndef Name.eqConst;

val isEq = equal eq;

(* Hilbert's choice operator *)

val select = mkUndef Name.selectConst;

val isSelect = equal select;

(* ------------------------------------------------------------------------- *)
(* Pretty printing.                                                          *)
(* ------------------------------------------------------------------------- *)

fun ppWithShow show = Print.ppMap (Show.showName show o name) Name.pp;

val pp = ppWithShow Show.default;

val toString = Print.toString pp;

(* ------------------------------------------------------------------------- *)
(* HTML output.                                                              *)
(* ------------------------------------------------------------------------- *)

fun toHtml show =
    let
      val ppTy = Type.ppHtml show
    in
      fn ((c,ty),n) =>
         let
           val class = "const"

           val title = Html.encode (Name.toString (name c))

           val title =
               case ty of
                 NONE => title
               | SOME t => title ^ " : " ^ Print.toLine ppTy t

           val attrs = Html.fromListAttrs [("class",class),("title",title)]

           val inlines = Name.toHtml (Show.showName show n)
         in
           [Html.Span (attrs,inlines)]
         end
    end;

end

structure ConstOrdered =
struct type t = Const.const val compare = Const.compare end

structure ConstMap = KeyMap (ConstOrdered)

structure ConstSet = ElementSet (ConstMap)
