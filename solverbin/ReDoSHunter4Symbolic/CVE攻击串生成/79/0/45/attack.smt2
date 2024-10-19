(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6e")  (str.to_re "\x74"))))))) (re.++ (re.+ re.allchar ) (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x76")  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))  (str.to_re "\x3a")))))) (re.+  (re.union  (str.to_re "\x5c\x2e") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) ))
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x5c\x2e")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2e")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) ) (re.++  (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)