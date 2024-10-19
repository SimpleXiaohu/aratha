(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const infixs String)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 40000 40000) infix))))
(assert (= prefix 
     (re.++  (str.to_re "\u{3a}") (re.+ (re.range "\u{30}" "\u{39}") ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "\u{30}" "\u{39}") ) (re.* (re.union (re.range "\u{00}" "\u{09}") (re.range "\u{0b}" "\u{0c}") (re.range "\u{0e}" "\u{84}") (re.range "\u{86}" "\u{ff}")) ))  (re.++ (re.+ (re.range "\u{30}" "\u{39}") ) (re.++ (re.opt  (str.to_re "\u{2f}") ) (re.* (re.union (re.range "\u{00}" "\u{09}") (re.range "\u{0b}" "\u{0c}") (re.range "\u{0e}" "\u{84}") (re.range "\u{86}" "\u{ff}")) ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\u{0a}") (re.++  (str.to_re "\u{31}")  (str.to_re "\u{0a}")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (>= (str.len infixs) 1))
(assert (= result (str.++ attack postfixs)))
