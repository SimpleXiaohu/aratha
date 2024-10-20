(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.union  (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x55") (re.++  (re.union  (str.to_re "\x20")  (str.to_re "\x2b")) (re.++  (str.to_re "\x4f")  (str.to_re "\x53")))))) (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x65") (re.++  (re.union  (str.to_re "\x20")  (str.to_re "\x2b")) (re.++  (str.to_re "\x4f")  (str.to_re "\x53")))))))))  (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x55") (re.++  (re.union  (str.to_re "\x20")  (str.to_re "\x2b")) (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e")  (str.to_re "\x65")))))))))))) (re.++ (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x2b")) ) (re.++ (re.+ (re.range "0" "9") )  (re.union  (str.to_re "\x5c\x2e")  (str.to_re "\x5f"))))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (re.++  (re.union  (str.to_re "\x5c\x2e")  (str.to_re "\x5f")) (re.+ (re.range "0" "9") )) ) (re.* re.allchar ))) (re.* re.allchar ) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)