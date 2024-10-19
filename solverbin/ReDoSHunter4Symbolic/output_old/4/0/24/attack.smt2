(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.+  (re.union (re.range "0" "9") (re.union  (str.to_re "\x5c\x2d") (re.range "\x61" "\x7a"))) ) (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) )) (re.+  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x5c\x74") (re.union  (str.to_re "\x2b") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))))))) ))
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x09") (re.union  (str.to_re "\x5c\x2b") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))))))) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x09") (re.union  (str.to_re "\x5c\x2b") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))))))) ) (re.++ (re.*  (str.to_re "\x3d") ) (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x41")  (str.to_re "\x0a"))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)