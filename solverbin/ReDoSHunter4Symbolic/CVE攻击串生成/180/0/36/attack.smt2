(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x41")  (str.to_re "\x40"))
))
(assert (= infix 
        (re.inter (re.+  (re.union (re.range "0" "9") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "\x41" "\x5a") (re.union  (str.to_re "\x2e") (re.union (re.range "\x61" "\x7a")  (str.to_re "\x5f")))))) )  (re.++ (re.+  (re.union (re.range "0" "9") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "\x41" "\x5a") (re.union  (str.to_re "\x2e") (re.union (re.range "\x61" "\x7a")  (str.to_re "\x5f")))))) ) (re.++  (str.to_re "\x5c\x2e") (re.+  (re.union (re.range "0" "9") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "\x41" "\x5a") (re.union  (str.to_re "\x2e") (re.union (re.range "\x61" "\x7a")  (str.to_re "\x5f")))))) ))) (re.+  (re.union (re.range "0" "9") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "\x41" "\x5a") (re.union  (str.to_re "\x2e") (re.union (re.range "\x61" "\x7a")  (str.to_re "\x5f")))))) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x20")  (str.to_re "\x7e"))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)