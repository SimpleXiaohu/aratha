(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x65")  (str.to_re "\x2f"))))))))
))
(assert (= infix 
         (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.+ (re.range "0" "9") ))) (re.++  (str.to_re "\x26") (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a")  (str.to_re "\x21"))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)