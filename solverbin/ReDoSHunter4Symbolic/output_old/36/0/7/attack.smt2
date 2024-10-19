(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x31") re.allchar)))))))))
))
(assert (= infix 
         (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.+ (re.range "0" "9") )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.++  (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.opt  (re.union  (str.to_re "\x61")  (str.to_re "\x62")) )) (re.+ (re.range "0" "9") ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)