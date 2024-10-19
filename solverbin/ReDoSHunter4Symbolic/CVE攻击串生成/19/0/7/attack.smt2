(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.union  (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))))))))))  (re.++ (re.range "0" "9")   (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")))))))))))) (re.++  (str.to_re "\x5c\x2e") (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x5c\x5b") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x20"))))))) (re.+ re.allchar ))
))
(assert (= infix 
        (re.inter (re.+ re.allchar )  (re.++ (re.+ re.allchar ) (re.++  (str.to_re "\x5c\x5d") (re.+  (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x22") (re.++ (re.+ re.allchar )  (str.to_re "\x22")))) ))) (re.+  (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x22") (re.++ (re.+ re.allchar )  (str.to_re "\x22")))) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce")  (str.to_re "\x0a"))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)