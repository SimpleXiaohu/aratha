(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.union  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x43")  (str.to_re "\x48"))) (re.union  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x47")  (str.to_re "\x48"))) (re.union  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x48")  (str.to_re "\x56"))) (re.union  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x48")  (str.to_re "\x57"))) (re.union  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x50")  (str.to_re "\x48"))) (re.union  (re.++  (str.to_re "\x53")  (str.to_re "\x43"))  (re.++  (str.to_re "\x53")  (str.to_re "\x4d"))))))))  (str.to_re "\x5c\x2d")))) (re.+  (re.union  (str.to_re "\x20") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))) ))
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))) ) (re.++ (re.opt  (str.to_re "\x5c\x2f") ) (re.*  (str.to_re "\x20") ))) (re.++  (str.to_re "\x26") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)