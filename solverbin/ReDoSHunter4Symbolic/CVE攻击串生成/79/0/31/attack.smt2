(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x76")  (str.to_re "\x3a")))))))))))
))
(assert (= infix 
        (re.inter (re.+  (re.union  (str.to_re "\x5c\x2e") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) )  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2e") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) ) (re.+ re.allchar )) (re.+ re.allchar ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x7e")  (str.to_re "\x0a")))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)