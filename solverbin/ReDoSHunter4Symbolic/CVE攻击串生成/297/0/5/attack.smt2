(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x5c\x5c") (re.+  (str.to_re "\x64") ))
))
(assert (= infix 
        (re.inter (re.+  (str.to_re "\x64") )  (re.++ (re.+  (str.to_re "\x64") ) (re.+  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")) )) (re.+  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x25ce")  (str.to_re "\x30"))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)