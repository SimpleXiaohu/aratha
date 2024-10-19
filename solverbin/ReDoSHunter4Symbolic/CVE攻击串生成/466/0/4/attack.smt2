(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x53")  (str.to_re "\x36"))))
))
(assert (= infix 
         (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.++  (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x3b")  (str.to_re "\x25ce")))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)