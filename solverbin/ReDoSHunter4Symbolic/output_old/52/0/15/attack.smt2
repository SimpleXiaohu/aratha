(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x75")  (str.to_re "\x78"))))) (re.++  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x2f")) (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x5c\x2e") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e")))))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar ))  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar )) )
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)