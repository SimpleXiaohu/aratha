(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
    (re.+  (re.union (re.range "0" "9")  (str.to_re "\x2e")) )
))
(assert (= infix 
         (re.++ (re.+  (re.union (re.range "0" "9")  (str.to_re "\x5c\x2e")) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union (re.range "0" "9")  (str.to_re "\x5c\x2e")) ) (re.++  (re.+  (re.union  (str.to_re "\x25")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x25")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x41")  (str.to_re "\x7e"))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)