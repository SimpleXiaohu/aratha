(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.++  (str.to_re "\x44") (re.++  (str.to_re "\x61")  (str.to_re "\x72"))) (re.++  (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x69")  (str.to_re "\x6e"))) (re.++  (str.to_re "\x5c\x2f") (re.++  (re.++  (str.to_re "\x31")  (str.to_re "\x33")) re.allchar)))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar )) (re.* re.allchar ) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)