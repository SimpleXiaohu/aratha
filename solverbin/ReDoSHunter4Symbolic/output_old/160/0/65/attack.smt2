(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6f")  (str.to_re "\x64")))) (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e")  (str.to_re "\x65"))))))  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x61")  (str.to_re "\x64")))))) (re.++  (str.to_re "\x3b") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x55") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x20") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5f")))))))))))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
         (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (re.++  (str.to_re "\x5f") (re.+ (re.range "0" "9") )) ) (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.inter (re.* re.allchar )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))  (re.inter  (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++  (re.inter (re.* re.allchar )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c")  (str.to_re "\x65"))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)