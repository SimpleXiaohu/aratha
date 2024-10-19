(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x46") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x72")  (str.to_re "\x6b"))))))))) (re.++  (str.to_re "\x5c\x2f") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e")))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "0" "9") ) (re.+ (re.range "0" "9") ))  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.+ (re.range "0" "9") ))) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)