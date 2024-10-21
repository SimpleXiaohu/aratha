(set-logic QF_AUFBVDTSNIA)

(set-option :produce-models true)



; Datatypes

; Val is the datatype for an ECMAScript value.

(declare-datatype Val (
    (undefined)
    (null)
    (Boolean (bool Bool))
    (Str (str String))
    (Num (num Int))
    (Obj (id Int))))

(declare-datatype MaybeVal (
    (Nothing)
    (Just (just Val))))

(define-fun Int32ToInt ((x (_ BitVec 32))) Int
    (let ((nx (bv2nat x)))
        (ite (>= nx 2147483648) (- nx 4294967296) nx)))
(define-fun Int32ToUInt ((x (_ BitVec 32))) Int (bv2nat x))

; ECMAScript internal functions
;
; These will have the same name as the functions in the specification with
; "js." prepended. The generally return values of an SMT-LIB sort, and may
; need to be wrapped with Val.

(define-sort Properties () (Array String MaybeVal))
(declare-fun GetProperties (Int) Properties)

(define-fun NumberToString ((x Int)) String (ite (>= x 0) (str.from_int x) (str.++ "-" (str.from_int (- x)))))

(define-fun js.ToString ((x Val)) String
    (ite (is-Str x) (str x)
    (ite (is-undefined x) "undefined"
    (ite (is-null x) "null"
    (ite (is-Boolean x) (ite (bool x) "true" "false")
    (ite (is-Num x) (NumberToString (num x))
    "[object Object]"))))))

; TODO: implement more of the string-to-number semantics
(define-fun StringToNumber ((x String)) Int
    (ite (= x "") 0
    (ite (str.prefixof "-" x) (- (str.to_int (str.substr x 1 (- (str.len x) 1))))
    (str.to_int x))))

(define-fun js.ToNumber ((x Val)) Int
    (ite (is-Num x) (num x)
    (ite (is-undefined x) 0
    (ite (is-null x) 0
    (ite (is-Boolean x) (ite (bool x) 1 0)
    (ite (is-Str x) (StringToNumber (str x))
    0)))))) ; Otherwise we're an Object, but we don't have NaNs, so we'll return zero here.

(define-fun js.ToInteger ((x Val)) Int (js.ToNumber x))

(define-fun js.ToBoolean ((x Val)) Bool
    (ite (is-Num x) (distinct (num x) 0)
    (ite (is-undefined x) false
    (ite (is-null x) false
    (ite (is-Boolean x) (bool x)
    (ite (is-Str x) (distinct (str x) "")
    true))))))

(define-fun SameType ((x Val) (y Val)) Bool (or
    (and (is-undefined x) (is-undefined y))
    (and (is-null x) (is-null y))
    (and (is-Boolean x) (is-Boolean y))
    (and (is-Str x) (is-Str y))
    (and (is-Num x) (is-Num y))))

(define-fun typeof ((x Val)) String
    (ite (is-Num x) "number"
    (ite (is-undefined x) "undefined"
    (ite (is-Boolean x) "boolean"
    (ite (is-Str x) "string"
    "object"))))) ; NOTE: typeof null === "object"

(define-fun EmptyObject () Properties ((as const Properties) Nothing))

(define-fun StringToObject ((s String)) Properties (store EmptyObject "length" (Just (Num (str.len s)))))
(define-fun NumberToObject ((x Int)) Properties EmptyObject)
(define-fun BooleanToObject ((p Bool)) Properties EmptyObject)

(define-fun js.ToObject ((o Val)) Properties
    (ite (is-Obj o) (GetProperties (id o))
    (ite (is-Str o) (StringToObject (str o))
    EmptyObject)))

(define-fun GetField ((o Properties) (k Val)) Val
    (let ((v (select o (js.ToString k))))
        (ite (is-Just v) (just v) undefined)))
(define-fun PutField ((o Properties) (k Val) (v Val)) Properties (store o (js.ToString k) (Just v)))
(define-fun DeleteField ((o Properties) (k Val)) Properties (store o (js.ToString k) Nothing))

(define-fun MutableToProps ((base Val) (modified Properties)) Properties
    (ite (is-Obj base) modified (js.ToObject base)))

; ECMAScript expressions

; Binary operators

(define-fun js.in ((x String) (y Properties)) Bool (is-Just (select y x)))

; Relational operators
(define-fun js.=== ((x Val) (y Val)) Bool (= x y))

(define-fun js.!== ((x Val) (y Val)) Bool (not (js.=== x y)))

(define-fun js.== ((x Val) (y Val)) Bool
    (ite (SameType x y) (js.=== x y)
    (ite (and (is-null x) (is-undefined y)) true
    (ite (and (is-null y) (is-undefined x)) true
    (ite (and (is-Num x) (is-Str y)) (= (num x) (js.ToNumber y))
    (ite (and (is-Num y) (is-Str x)) (= (num y) (js.ToNumber x))
    (ite (is-Boolean x) (let ((nx (js.ToNumber x)))
        (ite (is-Num y) (= nx (num y))
        (ite (is-Str y) (= nx (js.ToNumber y))
        false)))
    (ite (is-Boolean y) (let ((ny (js.ToNumber y)))
        (ite (is-Num x) (= (num x) ny)
        (ite (is-Str x) (= ny (js.ToNumber x))
        false)))
    false))))))))

(define-fun js.!= ((x Val) (y Val)) Bool (not (js.== x y)))

;(define-fun CharToCode ((x String)) Int
;    (ite (= x "\x00") 0
;    1))
;(define-fun StrLessThan ((x String) (y String)) Bool
;    (and (not (str.prefixof y x)) (or (str.prefixof x y)
;    (exists ((i Int)) (and (<= 0 i) (< i (str.len x)) (< i (str.len y)) (= (str.substr x 0 i) (str.substr y 0 i)) (< (CharToCode (str.at x i)) (CharToCode (str.at y i))))))))

; NOTE: "ab" < "ac" returns false by this definition, even though "c" < "a".
; This is because we can't implement the character-level < operation, since Z3
; doesn't (yet) let us access individual characters within strings/sequences.
(define-fun StrLessThan ((x String) (y String)) Bool
    (and (not (str.prefixof y x)) (str.prefixof x y)))

(define-fun ToPrimitive ((x Val)) Val (ite (is-Obj x) (Str "[object Object]") x))

(define-fun IsNumber ((x Val)) Bool (and
    (not (is-undefined x))
    (not (is-Obj x))
    (=> (is-Str x) (let ((sx (str x))) (or (distinct (str.to_int sx) (- 1)) (= sx "") (= sx "-1"))))))

(define-fun AbsRelComp ((x Val) (y Val)) Bool
    (let ((px (ToPrimitive x)) (py (ToPrimitive y)))
    (and (=> (not (and (is-Str px) (is-Str py))) (< (js.ToNumber px) (js.ToNumber py)))
    (=> (and (is-Str px) (is-Str py)) (StrLessThan (str px) (str py))))))

(define-fun IsDefinedComp ((x Val) (y Val)) Bool (or (and (IsNumber x) (IsNumber y)) (and (or (is-Str x) (is-Obj x)) (or (is-Str y) (is-Obj y)))))

(define-fun js.< ((x Val) (y Val)) Bool (and (IsDefinedComp x y) (AbsRelComp x y)))
(define-fun js.> ((x Val) (y Val)) Bool (and (IsDefinedComp y x) (AbsRelComp y x)))
(define-fun js.<= ((x Val) (y Val)) Bool (and (IsDefinedComp y x) (not (AbsRelComp y x))))
(define-fun js.>= ((x Val) (y Val)) Bool (and (IsDefinedComp x y) (not (AbsRelComp x y))))

; Object relational operators

; BUG: Since there is little to no support for recursive functions, our
; axiomatization does not support prototypes, so we can never produce a model
; satisfying instanceof. As such, we define it to always be false.
(define-fun js.instanceof ((obj Val) (proto Val)) Bool false)

; Arithmetic operators
(define-fun js.+ ((x Val) (y Val)) Val
    (ite (or (is-Str x) (is-Str y))
        (Str (str.++ (js.ToString x) (js.ToString y)))
        (Num (+ (js.ToNumber x) (js.ToNumber y)))))

(define-fun js.- ((x Val) (y Val)) Val
    (Num (- (js.ToNumber x) (js.ToNumber y))))

(define-fun js.* ((x Val) (y Val)) Val
    (Num (* (js.ToNumber x) (js.ToNumber y))))

(define-fun js./ ((x Val) (y Val)) Val
    (Num (div (js.ToNumber x) (js.ToNumber y))))

(define-fun js.% ((x Val) (y Val)) Val
    (Num (mod (js.ToNumber x) (js.ToNumber y))))

; Unary operators

(define-fun js.! ((x Bool)) Bool (not x))
(define-fun js.void ((x Val)) Val undefined)
(define-fun js.typeof ((x Val)) Val (Str (typeof x)))
(define-fun js.u+ ((x Val)) Val (Num (js.ToNumber x)))
(define-fun js.u- ((x Val)) Val (Num (- (js.ToNumber x))))

(define-fun min ((x Int) (y Int)) Int (ite (< x y) x y))
(define-fun max ((x Int) (y Int)) Int (ite (> x y) x y))
(define-fun clamp ((x Int) (lower Int) (upper Int)) Int (min (max x lower) upper))

; String functions

(define-fun substring ((x String) (start Int) (end Int)) String (str.substr x start (- end start)))
(define-fun js.substring ((x String) (start Int) (end Val)) String
    (let ((len (str.len x)))
        (let (
            (fs (clamp start 0 len))
            (fe (clamp (ite (is-undefined end) len (js.ToInteger end)) 0 len)))
                (substring x (min fs fe) (max fs fe)))))

(define-fun js.substr ((x String) (start Int) (len Val)) String
    (ite (>= start (str.len x))
        ""
        (let ((sp (ite (>= start 0) start (max 0 (+ (str.len x) start)))))
            (let ((remlen (- (str.len x) sp)))
                (str.substr x sp (ite (is-undefined len) remlen (clamp (js.ToInteger len) 0 remlen)))))))

(define-fun js.slice ((x String) (start Int) (end Val)) String
    (let ((len (str.len x)))
        (let ((ie (ite (is-undefined end) len (js.ToInteger end))))
            (let (
                (from (ite (< start 0) (max 0 (+ len start)) (min start len)))
                (to (ite (< ie 0) (max 0 (+ len ie)) (min ie len))))
                    (str.substr x from (max 0 (- to from)))))))

(define-fun Split1 ((x String) (delim String)) Properties
    (let ((n (str.indexof x delim 0)))
        (ite (= n (- 1))
            (store EmptyObject "0" (Just (Str x)))
            (store EmptyObject "0" (Just (Str (str.substr x 0 n)))))))

(define-fun Split2 ((x String) (delim String)) Properties
    (let ((n (str.indexof x delim 0)))
        (ite (= n (- 1))
            (store EmptyObject "0" (Just (Str x)))
            (store
                (store EmptyObject "0" (Just (Str (str.substr x 0 n))))
                "1"
                (Just (Str (str.substr
                    x
                    (+ n 1)
                    (- (str.len x) (+ n 1)))))))))

(define-fun js.split ((x String) (delim String) (maxSplits Int)) Properties
    (ite (= 0 maxSplits)
        EmptyObject
        (ite (= 1 maxSplits) (Split1 x delim) (Split2 x delim))))

(define-fun js.constructArray ((len Val)) Properties
    (ite (is-Num len)
        (store EmptyObject "length" (Just len))
        (store (store EmptyObject "length" (Just (Num 1))) "0" (Just len))))

(define-fun IsWhitespaceString ((s String)) Bool (str.in_re s (re.* (re.union (str.to_re " ") (str.to_re "\xa0") (str.to_re "\t") (str.to_re "\f") (str.to_re "\v") (str.to_re "\r") (str.to_re "\n")))))

; TODO: implement parseInt for radices other than 10
(define-fun ParseIntCondition ((s String) (radix Int) (ws String) (numPart String) (rem String) (i Int)) Bool
    (and
        (= s (str.++ ws numPart rem))
        (IsWhitespaceString ws)
        (not (= "" numPart))
        (str.in_re numPart (re.++ (re.opt (str.to_re "-")) (re.+ (re.range "0" "9"))))
        (or (= 0 radix) (<= 2 radix 36))
        (or (= "" rem) (distinct (str.at rem 0) "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"))
        (or (= radix 0) (= radix 10) (< i radix 10))
        (= i (StringToNumber numPart))))

(define-fun TOFIXED_ZEROS () String "00000000000000000000")

(define-fun js.toFixed ((n Int) (fracDigits Int)) String
    (ite (<= 1 fracDigits 20)
        (str.++ (NumberToString n) "." (str.substr TOFIXED_ZEROS 0 fracDigits))
        (NumberToString n)))

; The number regex for JavaScript is:
; \s*(0(x|X)[0-9a-fA-F]+|(+|-)?[0-9]*(\.)?[0-9]+(e|E)(+|-)?[0-9]+)\s*
; FIXME: add support for whitespace before and after
(define-fun IsFiniteNumberString ((s String)) Bool
    (str.in_re s (re.opt (re.union
        (re.++
            (str.to_re "0")
            (re.union (str.to_re "x") (str.to_re "X"))
            (re.+ (re.union
                (re.range "0" "9")
                (re.range "a" "f")
                (re.range "A" "F"))))
        (re.++
            (re.opt (re.union (str.to_re "+") (str.to_re "-")))
            (re.* (re.range "0" "9"))
            (re.union ; Need at least one digit before or after the point.
                (re.++ (re.range "0" "9") (re.opt (str.to_re ".")))
                (re.++ (str.to_re ".") (re.range "0" "9")))
            (re.* (re.range "0" "9"))
            (re.opt (re.++
                (re.union (str.to_re "e") (str.to_re "E"))
                (re.opt (re.union (str.to_re "+") (str.to_re "-")))
                (re.+ (re.range "0" "9")))))))))

(define-fun IsNumberString ((s String)) Bool (or
    (IsFiniteNumberString s)
    (not (distinct s "Infinity" "+Infinity" "-Infinity"))))

(define-fun js.isFinite ((v Val)) Bool
    (and
        (not (or (is-Obj v) (is-undefined v)))
        (=> (is-Str v) (IsFiniteNumberString (str v)))))
;(define-fun js.Number.isFinite ((v Val)) Bool (and (is-Num v) (js.isFinite v)))
(define-fun js.Number.isFinite ((v Val)) Bool (is-Num v))

(define-fun js.isNaN ((v Val)) Bool (or
    (is-undefined v)
    (is-Obj v)
    (and (is-Str v) (not (IsNumberString (str v))))))
(define-fun js.Number.isNaN ((v Val)) Bool false)

; FIXME: this only works for ASCII.
(define-fun js.isLowerCase ((s String)) Bool (not (str.in_re s (re.++ re.allchar (re.range "A" "Z") re.allchar))))
(define-fun js.toLowerCase ((s String)) String s)
(define-fun js.isUpperCase ((s String)) Bool (not (str.in_re s (re.++ re.allchar (re.range "a" "z") re.allchar))))
(define-fun js.toUpperCase ((s String)) String s)


(define-fun IntToInt32 ((x Int)) (_ BitVec 32) ((_ int2bv 32) x))
(define-fun js.ToInt32 ((x Val)) (_ BitVec 32) (IntToInt32 (js.ToNumber x)))

; Bit shift operators
(define-fun js.<< ((x Val) (y Val)) Val
    (let ((bx (js.ToInt32 x)) (by (js.ToInt32 y)))
        (Num (Int32ToInt (bvshl bx by)))))

(define-fun js.>> ((x Val) (y Val)) Val
    (let ((bx (js.ToInt32 x)) (by (js.ToInt32 y)))
        (Num (Int32ToInt (bvashr bx by)))))

(define-fun js.>>> ((x Val) (y Val)) Val
    (let ((bx (js.ToInt32 x)) (by (js.ToInt32 y)))
        (Num (Int32ToUInt (bvlshr bx by)))))

; Bitwise operators

; BUG: There seems to be an issue with Z3's bridge between integers and
; bitvectors. Currently waiting on a fix. Until then, bit ops may be incorrect.
; https://github.com/Z3Prover/z3/issues/948

(define-fun IntAnd32 ((x Int) (y Int)) Int
    (Int32ToInt (bvand (IntToInt32 x) (IntToInt32 y))))

(define-fun IntOr32 ((x Int) (y Int)) Int
    (Int32ToInt (bvor (IntToInt32 x) (IntToInt32 y))))

(define-fun IntXor32 ((x Int) (y Int)) Int
    (Int32ToInt (bvxor (IntToInt32 x) (IntToInt32 y))))

(define-fun IntNot32 ((x Int)) Int
    (Int32ToInt (bvnot (IntToInt32 x))))

(define-fun js.& ((x Val) (y Val)) Val
    (Num (IntAnd32 (js.ToNumber x) (js.ToNumber y))))

(define-fun js.bitor ((x Val) (y Val)) Val
    (Num (IntOr32 (js.ToNumber x) (js.ToNumber y))))

(define-fun js.^ ((x Val) (y Val)) Val
    (Num (IntXor32 (js.ToNumber x) (js.ToNumber y))))

(define-fun js.~ ((x Val)) Val
    (Num (IntNot32 (js.ToNumber x))))
(push 1)

(declare-const var0 Val)

(assert (is-Str var0))

; (assert (not (distinct (str var0) "")))

(check-sat)

(get-model)

(pop 1)

(push 1)

(declare-const var0 Val)

(assert (is-Str var0))

(assert (not (not (distinct (str var0) ""))))

(check-sat)

(get-model)

(push 1)

; (assert (not (distinct (str var0) "")))

(check-sat)

(get-model)

(assert (distinct (str var0) ""))

(check-sat)

(push 1)

(pop 1)

(get-model)

(push 1)

(assert (str.in_re (str var0) (re.++ (re.++ (str.to_re "") (re.union (str.to_re ".") (re.++ (str.to_re "~") (str.to_re "/")) (re.union (str.to_re "/") (str.to_re "\\")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")))) re.all)))

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert (not (str.in_re (str var0) (re.++ (re.++ (str.to_re "") (re.union (str.to_re ".") (re.++ (str.to_re "~") (str.to_re "/")) (re.union (str.to_re "/") (str.to_re "\\")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")))) re.all))))

(check-sat)

(get-model)

(assert (str.in_re (str var0) (re.++ (re.++ (str.to_re "") (str.to_re "file:")) re.all)))

(push 1)

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert (not (str.in_re (str var0) (re.++ (re.++ (str.to_re "") (str.to_re "file:")) re.all))))

(check-sat)

(get-model)

(push 1)

; (assert (not (distinct (str var0) "")))

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert (distinct (str var0) ""))

(check-sat)

(get-model)

(push 1)

(assert (str.in_re (str var0) (re.++ (re.++ (str.to_re "") (str.to_re "npm:")) re.all)))

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert (not (str.in_re (str var0) (re.++ (re.++ (str.to_re "") (str.to_re "npm:")) re.all))))

(check-sat)

(get-model)

(push 1)

(assert (distinct (str (js.typeof var0)) "string"))

(check-sat)

(pop 1)

(push 1)

(assert (not (distinct (str (js.typeof var0)) "string")))

(check-sat)

(get-model)

(push 1)

(assert (not (not (js.in (str.++ (str var0) "{""noGitPlus"":true,""noCommittish"":true}") EmptyObject))))

(check-sat)

(pop 1)

(push 1)

(assert (not (js.in (str.++ (str var0) "{""noGitPlus"":true,""noCommittish"":true}") EmptyObject)))

(check-sat)

(get-model)

(push 1)

; (assert false)

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert (not false))

(check-sat)

(get-model)

(push 1)

(assert (= (str var0) ""))

(check-sat)

(pop 1)

(push 1)

(assert (not (= (str var0) "")))

(check-sat)

(get-model)

(push 1)

(assert (str.in_re (str var0) (re.++ (str.to_re "") (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")) (re.union (re.range "\u{0}" "$") (re.range "&" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")) (re.union (re.range "\u{0}" "r") (re.range "t" "\u{ff}")) (re.union (re.range "\u{0}" "-") (re.range "/" "\u{ff}")) (re.union (re.range "\u{0}" ",") (re.range "." "\u{ff}"))) (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")) (re.union (re.range "\u{0}" "$") (re.range "&" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")) (re.union (re.range "\u{0}" "r") (re.range "t" "\u{ff}")))) (str.to_re "/") (re.+ (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")) (re.union (re.range "\u{0}" "r") (re.range "t" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")) (re.union (re.range "\u{0}" "$") (re.range "&" "\u{ff}")))) (re.opt (re.++ (str.to_re "#") (re.* re.allchar))) (str.to_re ""))))

(check-sat)

(get-model)

(pop 1)

(push 1)

(check-sat)

(assert (not (str.in_re (str var0) (re.++ (str.to_re "") (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")) (re.union (re.range "\u{0}" "$") (re.range "&" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")) (re.union (re.range "\u{0}" "r") (re.range "t" "\u{ff}")) (re.union (re.range "\u{0}" "-") (re.range "/" "\u{ff}")) (re.union (re.range "\u{0}" ",") (re.range "." "\u{ff}"))) (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")) (re.union (re.range "\u{0}" "$") (re.range "&" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")) (re.union (re.range "\u{0}" "r") (re.range "t" "\u{ff}")))) (str.to_re "/") (re.+ (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")) (re.union (re.range "\u{0}" "r") (re.range "t" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")) (re.union (re.range "\u{0}" "$") (re.range "&" "\u{ff}")))) (re.opt (re.++ (str.to_re "#") (re.* re.allchar))) (str.to_re "")))))

(get-model)

(push 1)

; (assert false)

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert true)

(check-sat)

(get-model)

(push 1)

; (declare-const regex_exec_0 String)

(declare-const regex_exec_1 String)

(declare-const regex_exec_2 String)

(declare-const regex_exec_4 String)

(declare-const regex_exec_5 String)

(declare-const regex_exec_6 String)

(declare-const regex_exec_7 String)

(declare-const regex_exec_9 String)

(declare-const regex_exec_10 String)

(declare-const regex_exec_11 String)

(declare-const regex_exec_12 String)

(declare-const regex_exec_13 String)

(declare-const regex_exec_14 String)

(declare-const regex_exec_16 String)

(declare-const regex_exec_17 String)

(declare-const regex_exec_18 String)

(declare-const regex_exec_19 String)

(declare-const regex_exec_20 String)

(declare-const regex_exec_21 String)

(declare-const regex_exec_22 String)

(declare-const regex_exec_23 String)

(declare-const regex_exec_24 String)

(declare-const regex_exec_25 String)

(declare-const regex_exec_26 String)

(declare-const regex_exec_27 String)

(declare-const regex_exec_28 String)

(declare-const regex_exec_29 String)

(declare-const regex_exec_30 String)

(declare-const regex_exec_32 String)

(declare-const regex_exec_33 String)

(declare-const regex_exec_34 String)

(declare-const regex_exec_35 String)

(declare-const regex_exec_36 String)

(declare-const regex_capture_3 Val)

(assert (or (is-undefined regex_capture_3) (is-Str regex_capture_3)))

(declare-const regex_capture_8 Val)

(assert (or (is-undefined regex_capture_8) (is-Str regex_capture_8)))

(declare-const regex_capture_15 Val)

(assert (or (is-undefined regex_capture_15) (is-Str regex_capture_15)))

(declare-const regex_capture_31 Val)

(assert (or (is-undefined regex_capture_31) (is-Str regex_capture_31)))

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (= (Str regex_exec_0) var0)))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (not (or (is-undefined (ite (= (Str regex_exec_0) var0) (Obj 6) null)) (is-null (ite (= (Str regex_exec_0) var0) (Obj 6) null))))))

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4))))

(get-model)

(pop 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4)))))

(push 1)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 1)))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4)))))

(get-model)

(push 1)

; (declare-const regex_exec_37 String)

(declare-const regex_exec_38 String)

(declare-const regex_exec_39 String)

(declare-const regex_exec_41 String)

(declare-const regex_exec_42 String)

(declare-const regex_exec_43 String)

(declare-const regex_exec_44 String)

(declare-const regex_exec_45 String)

(declare-const regex_exec_46 String)

(declare-const regex_exec_47 String)

(declare-const regex_exec_48 String)

(declare-const regex_exec_49 String)

(declare-const regex_exec_50 String)

(declare-const regex_exec_51 String)

(declare-const regex_exec_52 String)

(declare-const regex_exec_54 String)

(declare-const regex_exec_55 String)

(declare-const regex_exec_57 String)

(declare-const regex_exec_56 String)

(declare-const regex_exec_59 String)

(declare-const regex_exec_60 String)

(declare-const regex_capture_40 Val)

(assert (or (is-undefined regex_capture_40) (is-Str regex_capture_40)))

(declare-const regex_capture_53 Val)

(assert (or (is-undefined regex_capture_53) (is-Str regex_capture_53)))

(declare-const regex_capture_58 Val)

(assert (or (is-undefined regex_capture_58) (is-Str regex_capture_58)))

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (not (= (Str regex_exec_37) var0)))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (declare-const regex_exec_37 String)

(declare-const regex_exec_38 String)

(declare-const regex_exec_39 String)

(declare-const regex_exec_41 String)

(declare-const regex_exec_42 String)

(declare-const regex_exec_43 String)

(declare-const regex_exec_44 String)

(declare-const regex_exec_45 String)

(declare-const regex_exec_46 String)

(declare-const regex_exec_47 String)

(declare-const regex_exec_48 String)

(declare-const regex_exec_49 String)

(declare-const regex_exec_50 String)

(declare-const regex_exec_51 String)

(declare-const regex_exec_52 String)

(declare-const regex_exec_54 String)

(declare-const regex_exec_55 String)

(declare-const regex_exec_56 String)

(declare-const regex_exec_57 String)

(declare-const regex_exec_59 String)

(declare-const regex_exec_60 String)

(declare-const regex_capture_40 Val)

(assert (or (is-undefined regex_capture_40) (is-Str regex_capture_40)))

(declare-const regex_capture_53 Val)

(assert (or (is-undefined regex_capture_53) (is-Str regex_capture_53)))

(assert (or (is-undefined regex_capture_58) (is-Str regex_capture_58)))

(declare-const regex_capture_58 Val)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (= (Str regex_exec_37) var0))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (not (not (or (is-undefined (ite (= (Str regex_exec_37) var0) (Obj 8) null)) (is-null (ite (= (Str regex_exec_37) var0) (Obj 8) null))))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (js.=== (GetField (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58)) (Num 1)) (Str "github")))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.!== (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)) (Str "github.com"))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (js.!== (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)) (Str "github.com")))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (not (or (is-undefined (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))) (is-null (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)))))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (distinct (str.replace (js.ToString (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))) "/^www[.]/" "") "github.com")))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 1)))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4)))))

(get-model)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (not (= (Str regex_exec_37) var0)))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

(check-sat)

; (assert (= (Str regex_exec_37) var0))

(get-model)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (js.=== (GetField (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58)) (Num 1)) (Str "bitbucket")))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (js.!== (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)) (Str "bitbucket.org"))))

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (js.!== (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)) (Str "bitbucket.org")))

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (distinct (str.replace (js.ToString (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))) "/^www[.]/" "") "bitbucket.org")))

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (distinct (str.replace (js.ToString (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))) "/^www[.]/" "") "bitbucket.org"))

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 1)))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 1))))

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4))))

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4)))))

(get-model)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (not (= (Str regex_exec_37) var0)))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (= (Str regex_exec_37) var0))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (js.=== (GetField (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58)) (Num 1)) (Str "gitlab")))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (not (js.=== (GetField (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58)) (Num 1)) (Str "gitlab"))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)))))

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.!== (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)) (Str "gitlab.com"))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (js.!== (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)) (Str "gitlab.com")))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (distinct (str.replace (js.ToString (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))) "/^www[.]/" "") "gitlab.com")))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (distinct (str.replace (js.ToString (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))) "/^www[.]/" "") "gitlab.com"))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 1)))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 1))))

(check-sat)

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 4)))))

(get-model)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (not (= (Str regex_exec_37) var0)))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

(check-sat)

; (assert (= (Str regex_exec_37) var0))

(get-model)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

; (assert (js.=== (GetField (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58)) (Num 1)) (Str "gist")))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 8) (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58))))

; (assert (and (= regex_exec_37 (str.++ regex_exec_38 regex_exec_39 regex_exec_43 regex_exec_44 regex_exec_50 regex_exec_57)) (str.in_re regex_exec_38 (str.to_re "")) (and (ite (= regex_exec_39 "") (is-undefined regex_capture_40) (= regex_capture_40 (Str regex_exec_39))) (and (= regex_exec_39 (str.++ regex_exec_41 regex_exec_42)) (str.in_re regex_exec_41 (re.* (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))) (str.in_re regex_exec_42 (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}"))))) (str.in_re regex_exec_43 (str.to_re ":")) (and (str.in_re regex_exec_45 (re.++ (re.+ (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.to_re "@"))) (and (= regex_exec_44 (str.++ regex_exec_46 regex_exec_49)) (and (= regex_exec_46 (str.++ regex_exec_47 regex_exec_48)) (str.in_re regex_exec_47 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_48 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_49 (str.to_re "@"))) (or (= regex_exec_44 regex_exec_45) (= regex_exec_44 ""))) (and (str.in_re regex_exec_51 (re.++ (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_50 (str.++ regex_exec_52 regex_exec_56)) (and (ite (= regex_exec_52 "") (is-undefined regex_capture_53) (= regex_capture_53 (Str regex_exec_52))) (and (= regex_exec_52 (str.++ regex_exec_54 regex_exec_55)) (str.in_re regex_exec_54 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.opt (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_55 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_56 (str.to_re "/"))) (or (= regex_exec_50 regex_exec_51) (= regex_exec_50 ""))) (and (ite (= regex_exec_57 "") (is-undefined regex_capture_58) (= regex_capture_58 (Str regex_exec_57))) (and (= regex_exec_57 (str.++ regex_exec_59 regex_exec_60)) (str.in_re regex_exec_59 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_60 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))))))

(check-sat)

; (assert (not (js.=== (GetField (store (store (store (store EmptyObject "0" (Just (Str regex_exec_37))) "1" (Just regex_capture_40)) "2" (Just regex_capture_53)) "3" (Just regex_capture_58)) (Num 1)) (Str "gist"))))

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (js.ToBoolean (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))))

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (js.!== (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)) (Str "gist.github.com"))))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

(check-sat)

; (assert (js.!== (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2)) (Str "gist.github.com")))

(get-model)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (not (distinct (str.replace (js.ToString (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))) "/^www[.]/" "") "gist.github.com")))

(check-sat)

(get-model)

(pop 1)

(push 1)

; (assert (= (GetProperties 6) (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31))))

; (assert (and (= regex_exec_0 (str.++ regex_exec_1 regex_exec_2 regex_exec_6 regex_exec_7 regex_exec_11 regex_exec_12 regex_exec_14 regex_exec_25 regex_exec_29 regex_exec_36)) (str.in_re regex_exec_1 (str.to_re "")) (and (ite (= regex_exec_2 "") (is-undefined regex_capture_3) (= regex_capture_3 (Str regex_exec_2))) (and (= regex_exec_2 (str.++ regex_exec_4 regex_exec_5)) (str.in_re regex_exec_4 (re.* (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}")))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))) (str.in_re regex_exec_5 (re.union (re.range "\u{0}" "?") (re.range "A" "\u{ff}"))))) (str.in_re regex_exec_6 (str.to_re "@")) (and (ite (= regex_exec_7 "") (is-undefined regex_capture_8) (= regex_capture_8 (Str regex_exec_7))) (and (= regex_exec_7 (str.++ regex_exec_9 regex_exec_10)) (str.in_re regex_exec_9 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_10 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (str.in_re regex_exec_11 (str.to_re ":")) (and (str.in_re regex_exec_13 (str.to_re "/")) (str.in_re regex_exec_12 (str.to_re "/")) (or (= regex_exec_12 regex_exec_13) (= regex_exec_12 ""))) (and (ite (= regex_exec_14 "") (is-undefined regex_capture_15) (= regex_capture_15 (Str regex_exec_14))) (and (= regex_exec_14 (str.++ regex_exec_16 regex_exec_22)) (and (str.in_re regex_exec_17 (re.++ (re.+ (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.to_re "/"))) (and (= regex_exec_16 (str.++ regex_exec_18 regex_exec_21)) (and (= regex_exec_18 (str.++ regex_exec_19 regex_exec_20)) (str.in_re regex_exec_19 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_20 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_21 (str.to_re "/"))) (or (= regex_exec_16 regex_exec_17) (= regex_exec_16 ""))) (and (= regex_exec_22 (str.++ regex_exec_23 regex_exec_24)) (str.in_re regex_exec_23 (re.* (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}"))) (str.in_re regex_exec_24 (re.union (re.range "\u{0}" ".") (re.range "0" "\u{ff}")))))) (and (str.in_re regex_exec_26 (re.++ (str.to_re ".") (str.to_re "git"))) (and (= regex_exec_25 (str.++ regex_exec_27 regex_exec_28)) (str.in_re regex_exec_27 (str.to_re ".")) (str.in_re regex_exec_28 (str.to_re "git"))) (or (= regex_exec_25 regex_exec_26) (= regex_exec_25 ""))) (and (str.in_re regex_exec_30 (re.++ (str.to_re "#") (re.* re.allchar))) (and (ite (= regex_exec_29 "") (is-undefined regex_capture_31) (= regex_capture_31 (Str regex_exec_29))) (and (= regex_exec_29 (str.++ regex_exec_32 regex_exec_33)) (str.in_re regex_exec_32 (str.to_re "#")) (and (= regex_exec_33 (str.++ regex_exec_34 regex_exec_35)) (str.in_re regex_exec_34 (re.* re.allchar)) (str.in_re regex_exec_35 (re.opt re.allchar)) (str.in_re regex_exec_35 re.allchar)))) (or (= regex_exec_29 regex_exec_30) (= regex_exec_29 ""))) (str.in_re regex_exec_36 (str.to_re ""))))

; (assert (distinct (str.replace (js.ToString (GetField (store (store (store (store (store EmptyObject "0" (Just (Str regex_exec_0))) "1" (Just regex_capture_3)) "2" (Just regex_capture_8)) "3" (Just regex_capture_15)) "4" (Just regex_capture_31)) (Num 2))) "/^www[.]/" "") "gist.github.com"))

(check-sat)

(get-model)

(push 1)

; (assert false)

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert true)

(check-sat)

(get-model)

(push 1)

(assert (js.ToBoolean (GetField (PutField EmptyObject (js.+ var0 (Str "{""noGitPlus"":true,""noCommittish"":true}")) undefined) (js.+ var0 (Str "{""noGitPlus"":true,""noCommittish"":true}")))))

(check-sat)

(pop 1)

(push 1)

(assert (not (js.ToBoolean (GetField (PutField EmptyObject (js.+ var0 (Str "{""noGitPlus"":true,""noCommittish"":true}")) undefined) (js.+ var0 (Str "{""noGitPlus"":true,""noCommittish"":true}"))))))

(check-sat)

(get-model)

(push 1)

; (assert (not (distinct (str var0) "")))

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert (distinct (str var0) ""))

(check-sat)

(get-model)

(push 1)

(assert (not (str.in_re (str var0) (re.++ (re.++ (str.to_re "") (re.opt (re.++ (str.to_re "git") (str.to_re "+"))) (re.+ (re.range "a" "z")) (str.to_re ":")) re.all))))

(check-sat)

(get-model)

(pop 1)

(push 1)

(assert (str.in_re (str var0) (re.++ (re.++ (str.to_re "") (re.opt (re.++ (str.to_re "git") (str.to_re "+"))) (re.+ (re.range "a" "z")) (str.to_re ":")) re.all)))

(check-sat)

(get-model)

(push 1)

(declare-const regex_exec_61 String)

(declare-const regex_exec_62 String)

(declare-const regex_exec_63 String)

(declare-const regex_exec_64 String)

(declare-const regex_exec_66 String)

(declare-const regex_exec_67 String)

(declare-const regex_exec_68 String)

(declare-const regex_exec_69 String)

(declare-const regex_exec_70 String)

(declare-const regex_exec_71 String)

(declare-const regex_exec_72 String)

(declare-const regex_exec_73 String)

(declare-const regex_exec_74 String)

(declare-const regex_exec_75 String)

(declare-const regex_exec_76 String)

(declare-const regex_exec_77 String)

(declare-const regex_exec_78 String)

(declare-const regex_exec_80 String)

(declare-const regex_exec_81 String)

(declare-const regex_exec_82 String)

(declare-const regex_capture_65 Val)

(assert (or (is-undefined regex_capture_65) (is-Str regex_capture_65)))

(declare-const regex_capture_79 Val)

(assert (or (is-undefined regex_capture_79) (is-Str regex_capture_79)))

(assert (= (GetProperties 15) (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79))))

(assert (and (= regex_exec_61 (str.++ regex_exec_62 regex_exec_63 regex_exec_64 regex_exec_75 regex_exec_82)) (str.in_re regex_exec_62 (str.to_re "")) (str.in_re regex_exec_63 (str.to_re "git+ssh://")) (and (ite (= regex_exec_64 "") (is-undefined regex_capture_65) (= regex_capture_65 (Str regex_exec_64))) (and (= regex_exec_64 (str.++ regex_exec_66 regex_exec_69 regex_exec_70 regex_exec_73)) (and (= regex_exec_66 (str.++ regex_exec_67 regex_exec_68)) (str.in_re regex_exec_67 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_69 (str.to_re ":")) (and (= regex_exec_70 (str.++ regex_exec_71 regex_exec_72)) (str.in_re regex_exec_71 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (and (str.in_re regex_exec_74 (str.to_re ".git")) (str.in_re regex_exec_73 (str.to_re ".git")) (or (= regex_exec_73 regex_exec_74) (= regex_exec_73 ""))))) (and (str.in_re regex_exec_76 (re.++ (str.to_re "#") (re.* re.allchar))) (and (= regex_exec_75 (str.++ regex_exec_77 regex_exec_78)) (str.in_re regex_exec_77 (str.to_re "#")) (and (ite (= regex_exec_78 "") (is-undefined regex_capture_79) (= regex_capture_79 (Str regex_exec_78))) (and (= regex_exec_78 (str.++ regex_exec_80 regex_exec_81)) (str.in_re regex_exec_80 (re.* re.allchar)) (str.in_re regex_exec_81 (re.opt re.allchar)) (str.in_re regex_exec_81 re.allchar)))) (or (= regex_exec_75 regex_exec_76) (= regex_exec_75 ""))) (str.in_re regex_exec_82 (str.to_re ""))))

(assert (not (= (Str regex_exec_61) var0)))

(check-sat)

(get-model)

(pop 1)

(push 1)

(declare-const regex_exec_61 String)

(declare-const regex_exec_62 String)

(declare-const regex_exec_63 String)

(declare-const regex_exec_64 String)

(declare-const regex_exec_66 String)

(declare-const regex_exec_67 String)

(declare-const regex_exec_68 String)

(declare-const regex_exec_69 String)

(declare-const regex_exec_70 String)

(declare-const regex_exec_71 String)

(declare-const regex_exec_72 String)

(declare-const regex_exec_73 String)

(declare-const regex_exec_74 String)

(declare-const regex_exec_75 String)

(declare-const regex_exec_76 String)

(declare-const regex_exec_77 String)

(declare-const regex_exec_78 String)

(declare-const regex_exec_80 String)

(declare-const regex_exec_81 String)

(declare-const regex_exec_82 String)

(declare-const regex_capture_65 Val)

(assert (or (is-undefined regex_capture_65) (is-Str regex_capture_65)))

(declare-const regex_capture_79 Val)

(assert (or (is-undefined regex_capture_79) (is-Str regex_capture_79)))

(assert (= (GetProperties 15) (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79))))

(assert (and (= regex_exec_61 (str.++ regex_exec_62 regex_exec_63 regex_exec_64 regex_exec_75 regex_exec_82)) (str.in_re regex_exec_62 (str.to_re "")) (str.in_re regex_exec_63 (str.to_re "git+ssh://")) (and (ite (= regex_exec_64 "") (is-undefined regex_capture_65) (= regex_capture_65 (Str regex_exec_64))) (and (= regex_exec_64 (str.++ regex_exec_66 regex_exec_69 regex_exec_70 regex_exec_73)) (and (= regex_exec_66 (str.++ regex_exec_67 regex_exec_68)) (str.in_re regex_exec_67 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_69 (str.to_re ":")) (and (= regex_exec_70 (str.++ regex_exec_71 regex_exec_72)) (str.in_re regex_exec_71 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (and (str.in_re regex_exec_74 (str.to_re ".git")) (str.in_re regex_exec_73 (str.to_re ".git")) (or (= regex_exec_73 regex_exec_74) (= regex_exec_73 ""))))) (and (str.in_re regex_exec_76 (re.++ (str.to_re "#") (re.* re.allchar))) (and (= regex_exec_75 (str.++ regex_exec_77 regex_exec_78)) (str.in_re regex_exec_77 (str.to_re "#")) (and (ite (= regex_exec_78 "") (is-undefined regex_capture_79) (= regex_capture_79 (Str regex_exec_78))) (and (= regex_exec_78 (str.++ regex_exec_80 regex_exec_81)) (str.in_re regex_exec_80 (re.* re.allchar)) (str.in_re regex_exec_81 (re.opt re.allchar)) (str.in_re regex_exec_81 re.allchar)))) (or (= regex_exec_75 regex_exec_76) (= regex_exec_75 ""))) (str.in_re regex_exec_82 (str.to_re ""))))

(assert (= (Str regex_exec_61) var0))

(check-sat)

(get-model)

(push 1)

(assert (= (GetProperties 15) (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79))))

(assert (and (= regex_exec_61 (str.++ regex_exec_62 regex_exec_63 regex_exec_64 regex_exec_75 regex_exec_82)) (str.in_re regex_exec_62 (str.to_re "")) (str.in_re regex_exec_63 (str.to_re "git+ssh://")) (and (ite (= regex_exec_64 "") (is-undefined regex_capture_65) (= regex_capture_65 (Str regex_exec_64))) (and (= regex_exec_64 (str.++ regex_exec_66 regex_exec_69 regex_exec_70 regex_exec_73)) (and (= regex_exec_66 (str.++ regex_exec_67 regex_exec_68)) (str.in_re regex_exec_67 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_69 (str.to_re ":")) (and (= regex_exec_70 (str.++ regex_exec_71 regex_exec_72)) (str.in_re regex_exec_71 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (and (str.in_re regex_exec_74 (str.to_re ".git")) (str.in_re regex_exec_73 (str.to_re ".git")) (or (= regex_exec_73 regex_exec_74) (= regex_exec_73 ""))))) (and (str.in_re regex_exec_76 (re.++ (str.to_re "#") (re.* re.allchar))) (and (= regex_exec_75 (str.++ regex_exec_77 regex_exec_78)) (str.in_re regex_exec_77 (str.to_re "#")) (and (ite (= regex_exec_78 "") (is-undefined regex_capture_79) (= regex_capture_79 (Str regex_exec_78))) (and (= regex_exec_78 (str.++ regex_exec_80 regex_exec_81)) (str.in_re regex_exec_80 (re.* re.allchar)) (str.in_re regex_exec_81 (re.opt re.allchar)) (str.in_re regex_exec_81 re.allchar)))) (or (= regex_exec_75 regex_exec_76) (= regex_exec_75 ""))) (str.in_re regex_exec_82 (str.to_re ""))))

(assert (not (not (or (is-undefined (ite (= (Str regex_exec_61) var0) (Obj 15) null)) (is-null (ite (= (Str regex_exec_61) var0) (Obj 15) null))))))

(check-sat)

(pop 1)

(push 1)

(assert (= (GetProperties 15) (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79))))

(assert (and (= regex_exec_61 (str.++ regex_exec_62 regex_exec_63 regex_exec_64 regex_exec_75 regex_exec_82)) (str.in_re regex_exec_62 (str.to_re "")) (str.in_re regex_exec_63 (str.to_re "git+ssh://")) (and (ite (= regex_exec_64 "") (is-undefined regex_capture_65) (= regex_capture_65 (Str regex_exec_64))) (and (= regex_exec_64 (str.++ regex_exec_66 regex_exec_69 regex_exec_70 regex_exec_73)) (and (= regex_exec_66 (str.++ regex_exec_67 regex_exec_68)) (str.in_re regex_exec_67 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_69 (str.to_re ":")) (and (= regex_exec_70 (str.++ regex_exec_71 regex_exec_72)) (str.in_re regex_exec_71 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (and (str.in_re regex_exec_74 (str.to_re ".git")) (str.in_re regex_exec_73 (str.to_re ".git")) (or (= regex_exec_73 regex_exec_74) (= regex_exec_73 ""))))) (and (str.in_re regex_exec_76 (re.++ (str.to_re "#") (re.* re.allchar))) (and (= regex_exec_75 (str.++ regex_exec_77 regex_exec_78)) (str.in_re regex_exec_77 (str.to_re "#")) (and (ite (= regex_exec_78 "") (is-undefined regex_capture_79) (= regex_capture_79 (Str regex_exec_78))) (and (= regex_exec_78 (str.++ regex_exec_80 regex_exec_81)) (str.in_re regex_exec_80 (re.* re.allchar)) (str.in_re regex_exec_81 (re.opt re.allchar)) (str.in_re regex_exec_81 re.allchar)))) (or (= regex_exec_75 regex_exec_76) (= regex_exec_75 ""))) (str.in_re regex_exec_82 (str.to_re ""))))

(check-sat)

(assert (not (or (is-undefined (ite (= (Str regex_exec_61) var0) (Obj 15) null)) (is-null (ite (= (Str regex_exec_61) var0) (Obj 15) null)))))

(get-model)

(push 1)

(assert (= (GetProperties 15) (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79))))

(assert (and (= regex_exec_61 (str.++ regex_exec_62 regex_exec_63 regex_exec_64 regex_exec_75 regex_exec_82)) (str.in_re regex_exec_62 (str.to_re "")) (str.in_re regex_exec_63 (str.to_re "git+ssh://")) (and (ite (= regex_exec_64 "") (is-undefined regex_capture_65) (= regex_capture_65 (Str regex_exec_64))) (and (= regex_exec_64 (str.++ regex_exec_66 regex_exec_69 regex_exec_70 regex_exec_73)) (and (= regex_exec_66 (str.++ regex_exec_67 regex_exec_68)) (str.in_re regex_exec_67 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_69 (str.to_re ":")) (and (= regex_exec_70 (str.++ regex_exec_71 regex_exec_72)) (str.in_re regex_exec_71 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (and (str.in_re regex_exec_74 (str.to_re ".git")) (str.in_re regex_exec_73 (str.to_re ".git")) (or (= regex_exec_73 regex_exec_74) (= regex_exec_73 ""))))) (and (str.in_re regex_exec_76 (re.++ (str.to_re "#") (re.* re.allchar))) (and (= regex_exec_75 (str.++ regex_exec_77 regex_exec_78)) (str.in_re regex_exec_77 (str.to_re "#")) (and (ite (= regex_exec_78 "") (is-undefined regex_capture_79) (= regex_capture_79 (Str regex_exec_78))) (and (= regex_exec_78 (str.++ regex_exec_80 regex_exec_81)) (str.in_re regex_exec_80 (re.* re.allchar)) (str.in_re regex_exec_81 (re.opt re.allchar)) (str.in_re regex_exec_81 re.allchar)))) (or (= regex_exec_75 regex_exec_76) (= regex_exec_75 ""))) (str.in_re regex_exec_82 (str.to_re ""))))

(assert (not (not (or (is-undefined (GetField (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79)) (Num 1))) (is-null (GetField (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79)) (Num 1)))))))

(check-sat)

(pop 1)

(push 1)

(assert (= (GetProperties 15) (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79))))

(assert (and (= regex_exec_61 (str.++ regex_exec_62 regex_exec_63 regex_exec_64 regex_exec_75 regex_exec_82)) (str.in_re regex_exec_62 (str.to_re "")) (str.in_re regex_exec_63 (str.to_re "git+ssh://")) (and (ite (= regex_exec_64 "") (is-undefined regex_capture_65) (= regex_capture_65 (Str regex_exec_64))) (and (= regex_exec_64 (str.++ regex_exec_66 regex_exec_69 regex_exec_70 regex_exec_73)) (and (= regex_exec_66 (str.++ regex_exec_67 regex_exec_68)) (str.in_re regex_exec_67 (re.* (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_68 (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))) (str.in_re regex_exec_69 (str.to_re ":")) (and (= regex_exec_70 (str.++ regex_exec_71 regex_exec_72)) (str.in_re regex_exec_71 (re.* (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))) (str.in_re regex_exec_72 (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))) (and (str.in_re regex_exec_74 (str.to_re ".git")) (str.in_re regex_exec_73 (str.to_re ".git")) (or (= regex_exec_73 regex_exec_74) (= regex_exec_73 ""))))) (and (str.in_re regex_exec_76 (re.++ (str.to_re "#") (re.* re.allchar))) (and (= regex_exec_75 (str.++ regex_exec_77 regex_exec_78)) (str.in_re regex_exec_77 (str.to_re "#")) (and (ite (= regex_exec_78 "") (is-undefined regex_capture_79) (= regex_capture_79 (Str regex_exec_78))) (and (= regex_exec_78 (str.++ regex_exec_80 regex_exec_81)) (str.in_re regex_exec_80 (re.* re.allchar)) (str.in_re regex_exec_81 (re.opt re.allchar)) (str.in_re regex_exec_81 re.allchar)))) (or (= regex_exec_75 regex_exec_76) (= regex_exec_75 ""))) (str.in_re regex_exec_82 (str.to_re ""))))

(check-sat)

(assert (not (or (is-undefined (GetField (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79)) (Num 1))) (is-null (GetField (store (store (store EmptyObject "0" (Just (Str regex_exec_61))) "1" (Just regex_capture_65)) "2" (Just regex_capture_79)) (Num 1))))))

(get-model)

