(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6f")  (str.to_re "\x64")))) (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x63")  (str.to_re "\x68")))))))))) (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e")  (str.to_re "\x65"))))))  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x61")  (str.to_re "\x64")))))))  (str.to_re "\x3b"))  (re.inter (re.* re.allchar )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.+ (re.range "0" "9") )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x55") (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x53") (re.++  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x2b")) (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x5f") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5f"))))))))))) (re.+ (re.range "0" "9") ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x31")  (str.to_re "\x0a")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)