(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x53") (re.++ (re.range "\x36" "\x39") (re.+ (re.range "0" "9") )))))) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ))
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++  (re.*  (str.to_re "\x20") ))) (re.++  (str.to_re "\x26") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)