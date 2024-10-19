(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x5c\x24") (re.++  (re.union  (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x76") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x71") (re.++  (str.to_re "\x75")  (str.to_re "\x65"))))))  (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x76") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x61")  (str.to_re "\x79")))))))) (re.++  (re.++  (str.to_re "\x5c\x7b") (re.opt  (str.to_re "\x25") )) (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )))) (re.+  (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x22") (re.union  (str.to_re "\x23") (re.union (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) (re.union  (str.to_re "\x5c\x27")  (str.to_re "\x2e")))))) ))
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x5c\x22") (re.union  (str.to_re "\x5c\x23") (re.union  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f")))) (re.union  (str.to_re "\x5c\x27")  (str.to_re "\x5c\x2e")))))) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x5c\x22") (re.union  (str.to_re "\x5c\x23") (re.union  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f")))) (re.union  (str.to_re "\x5c\x27")  (str.to_re "\x5c\x2e")))))) ) (re.++  (re.+  (re.union  (str.to_re "\x25") (re.union  (str.to_re "\x2c") (re.union  (str.to_re "\x3d")  (str.to_re "\x5c\x7d")))) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x25") (re.union  (str.to_re "\x2c") (re.union  (str.to_re "\x3d")  (str.to_re "\x5c\x7d")))) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x25") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x7e")  (str.to_re "\x25"))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)