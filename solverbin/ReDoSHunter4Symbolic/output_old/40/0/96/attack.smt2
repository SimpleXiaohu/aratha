(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6f")  (str.to_re "\x64")))) (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x63")  (str.to_re "\x68")))))))))) (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e")  (str.to_re "\x65"))))))  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x61")  (str.to_re "\x64"))))))) (re.++  (str.to_re "\x3b") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x55") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x53") (re.++  (re.union  (str.to_re "\x20")  (str.to_re "\x2b")) (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x5f") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5f")))))))))))))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar ))  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar )) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)