(declare-const attack RegLan)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const suffix RegLan)

(assert (= prefix 
     (re.++  (re.++  (str.to_re "\u{68}") (re.++  (str.to_re "\u{74}") (re.++  (str.to_re "\u{74}") (re.++  (str.to_re "\u{70}") (re.++  (str.to_re "\u{73}") (re.++  (str.to_re "\u{3a}") (re.++  (str.to_re "\u{2f}")  (str.to_re "\u{2f}"))))))))  (re.inter (re.* (re.union (re.range "\u{00}" "\u{09}") (re.range "\u{0b}" "\u{0c}") (re.range "\u{0e}" "\u{84}") (re.range "\u{86}" "\u{ff}")) )  (re.++   (re.union (re.union (re.range "\u{09}" "\u{0d}") (re.range "\u{20}" "\u{20}") (re.range "\u{85}" "\u{85}") (re.range "\u{a0}" "\u{a0}")) (re.union (re.range "\u{00}" "\u{08}") (re.range "\u{0e}" "\u{1f}") (re.range "\u{21}" "\u{84}") (re.range "\u{86}" "\u{9f}") (re.range "\u{a1}" "\u{ff}"))) (re.*   (re.union (re.union (re.range "\u{09}" "\u{0d}") (re.range "\u{20}" "\u{20}") (re.range "\u{85}" "\u{85}") (re.range "\u{a0}" "\u{a0}")) (re.union (re.range "\u{00}" "\u{08}") (re.range "\u{0e}" "\u{1f}") (re.range "\u{21}" "\u{84}") (re.range "\u{86}" "\u{9f}") (re.range "\u{a1}" "\u{ff}"))) ))))
))
(assert (= infix 
         (re.++  (str.to_re "\u{31}")  (str.to_re "\u{2f}"))
))

(declare-const infix_s String)
(assert (str.in_re infix_s ((_ re.loop 20 20) infix)))
(assert (>= (str.len infix_s) 20))

(assert (= suffix 
     (re.++  (str.to_re "\u{0a}") (re.++  (str.to_re "\u{21}") (re.++  (str.to_re "\u{0a}") (re.++  (str.to_re "\u{21}")  (str.to_re "\u{0a}")))))
))

(assert (= attack (re.++ prefix (str.to_re infix_s) suffix)))
(declare-const regex_exec_ans String)
(assert (str.in_re regex_exec_ans attack))
