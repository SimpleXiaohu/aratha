(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x43")  (str.to_re "\x2d"))))
))
(assert (= infix 
        (re.inter (re.+  (re.union  (str.to_re "\x20") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))) )  (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))) ) (re.++ (re.opt  (str.to_re "\x5c\x2f") ) (re.*  (str.to_re "\x20") ))) (re.*  (str.to_re "\x20") ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x7e")  (str.to_re "\x20"))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)