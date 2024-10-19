(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.union  (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x47") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x65")  (str.to_re "\x72"))))))))) (re.union  (re.++  (str.to_re "\x44") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65")  (str.to_re "\x72"))))))) (re.union  (re.++  (str.to_re "\x46") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x69")  (str.to_re "\x63")))))))))) (re.union  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x6b") (re.++  (str.to_re "\x65")  (str.to_re "\x79")))))))))))  (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e")  (str.to_re "\x65")))))))))))))) (re.++  (str.to_re "\x20") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e")))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
         (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.+  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09") (re.union  (str.to_re "\x0b")  (str.to_re "\x5c\x2e"))))))) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09") (re.union  (str.to_re "\x0b")  (str.to_re "\x5c\x2e"))))))) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp (re.+  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))  (str.to_re "\x2e")) )))  (re.inter  (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp  (re.++ (re.+  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))  (str.to_re "\x2e")) )  (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.opt (re.+  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))  (str.to_re "\x2e")) ) ))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)