(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const infixs String)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix))))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\u{67}") (re.++  (str.to_re "\u{69}") (re.++  (str.to_re "\u{74}") (re.++  (str.to_re "\u{2b}") (re.++  (str.to_re "\u{73}") (re.++  (str.to_re "\u{73}") (re.++  (str.to_re "\u{68}") (re.++  (str.to_re "\u{3a}") (re.++  (str.to_re "\u{2f}")  (str.to_re "\u{2f}")))))))))) (re.+  (re.union  (str.to_re "\u{23}")  (str.to_re "\u{3a}")) ))
))
(assert (= infix 
        (re.inter (re.+  (re.union  (str.to_re "\u{23}")  (str.to_re "\u{3a}")) )  (re.++ (re.+  (re.union  (str.to_re "\u{23}")  (str.to_re "\u{3a}")) ) (re.++  (str.to_re "\u{3a}") (re.+ (re.comp  (str.to_re "\u{23}")) ))) (re.+ (re.comp  (str.to_re "\u{23}")) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\u{41}") (re.++  (str.to_re "\u{23}") (re.++  (str.to_re "\u{0a}") (re.++  (str.to_re "\u{41}") (re.++  (str.to_re "\u{23}")  (str.to_re "\u{0a}"))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (>= (str.len infixs) 1))
(assert (= result (str.++ attack postfixs)))
