(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x44") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x39")  (str.to_re "\x31")))))))))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar )) (re.* re.allchar ) )
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)