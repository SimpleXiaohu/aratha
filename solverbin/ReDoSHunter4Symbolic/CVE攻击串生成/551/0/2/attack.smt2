(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x64") (re.++  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x2d")) (re.++ (re.+ (re.range "0" "9") ) (re.++  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.range "0" "9") )) (re.++ (re.opt  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.range "0" "9") )) ) (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.++  (re.++  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))) (re.*  (re.++  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))) )) (re.++  (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f")) (re.++  (re.union "" (re.union  (re.++  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))  "")  (re.++  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))   (re.++  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))  "")))) (re.++ (re.opt  (str.to_re "\x5c\x2d") ) (re.++ (re.*  (str.to_re "\x20") )  (str.to_re "\x3b")))))))))))))))))))  (re.inter (re.*  (str.to_re "\x20") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
         (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp (re.+ re.allchar )))  (re.inter  (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++ (re.+ re.allchar )  (re.union  (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x64")  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x2f"))))))))  (str.to_re "\x5c\x29"))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)