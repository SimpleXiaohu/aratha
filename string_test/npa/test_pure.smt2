(set-logic QF_AUFBVDTSNIA)

(set-option :produce-models true)


(declare-const attack RegLan)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const suffix RegLan)

(assert (= prefix 
     (re.++  (str.to_re "\u{3a}") (re.+ (re.range "\u{30}" "\u{39}") ))
))
(assert (= infix 
         (re.++ (re.+ (re.range "\u{30}" "\u{39}") ) (re.* (re.comp  (re.union  (str.to_re "\u{0a}")  (str.to_re "\u{0d}"))) ))
))

(declare-const infix_s String)
(assert (str.in_re infix_s ((_ re.loop 10 10) infix)))
(assert (>= (str.len infix_s) 10))

; (assert (= suffix 
;      (re.inter  (re.++  (str.to_re "\u{30}") (re.*  (re.union (re.union (re.range "\u{09}" "\u{0d}") (re.range "\u{20}" "\u{20}") (re.range "\u{85}" "\u{85}") (re.range "\u{a0}" "\u{a0}")) (re.union (re.range "\u{00}" "\u{08}") (re.range "\u{0e}" "\u{1f}") (re.range "\u{21}" "\u{84}") (re.range "\u{86}" "\u{9f}") (re.range "\u{a1}" "\u{ff}"))) )) (re.comp  (re.inter (re.* (re.union (re.range "\u{00}" "\u{09}") (re.range "\u{0b}" "\u{0c}") (re.range "\u{0e}" "\u{84}") (re.range "\u{86}" "\u{ff}")) )  (re.++   (re.union (re.union (re.range "\u{09}" "\u{0d}") (re.range "\u{20}" "\u{20}") (re.range "\u{85}" "\u{85}") (re.range "\u{a0}" "\u{a0}")) (re.union (re.range "\u{00}" "\u{08}") (re.range "\u{0e}" "\u{1f}") (re.range "\u{21}" "\u{84}") (re.range "\u{86}" "\u{9f}") (re.range "\u{a1}" "\u{ff}"))) (re.*   (re.union (re.union (re.range "\u{09}" "\u{0d}") (re.range "\u{20}" "\u{20}") (re.range "\u{85}" "\u{85}") (re.range "\u{a0}" "\u{a0}")) (re.union (re.range "\u{00}" "\u{08}") (re.range "\u{0e}" "\u{1f}") (re.range "\u{21}" "\u{84}") (re.range "\u{86}" "\u{9f}") (re.range "\u{a1}" "\u{ff}"))) )))))
; ))

(assert (= suffix re.all))

(assert (= attack (re.++ prefix (str.to_re infix_s) suffix)))
(declare-const regex_exec_ans String)
(assert (str.in_re regex_exec_ans (re.++ (re.* re.allchar) attack (re.* re.allchar))))

(assert (str.in_re regex_exec_ans (re.++ 
  (re.+ (re.inter (re.union (re.range "\u{0}" "9") (re.range ";" "\u{ff}")) (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}"))))
  (str.to_re ":")
  (re.+ (re.union (re.range "\u{0}" """") (re.range "$" "\u{ff}")))
  (re.opt (str.to_re ".git"))
)))

(declare-const regex_exec_61 String)

(assert (str.in_re regex_exec_61 (re.++ 
  (str.to_re "git+ssh://")
  (str.to_re regex_exec_ans)
  (re.opt (re.++ (str.to_re "#") (re.* re.allchar)))
)))

(check-sat)
(get-model)