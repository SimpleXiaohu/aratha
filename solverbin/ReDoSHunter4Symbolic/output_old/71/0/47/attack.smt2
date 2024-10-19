(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x20") (re.++ (re.+  (str.to_re "\x3b") ) (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x20") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x5c\x2f") (re.++ (re.+  (re.union  (str.to_re "\x3b")  (str.to_re "\x5c\x29")) ) (re.++  (re.union  (str.to_re "\x3b")  (str.to_re "\x5c\x29")) (re.++ (re.opt  (str.to_re "\x20") ) (re.++ (re.opt  (re.union  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x52") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x3b") (re.++ (re.opt  (str.to_re "\x20") ) (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x3b") (re.opt  (str.to_re "\x20") )))))))))))) (re.union  (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x3b") (re.opt  (str.to_re "\x20") )))))))  (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x3b") (re.opt  (str.to_re "\x20") ))))))))))))))))) ) (re.++  (re.union  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55")  (str.to_re "\x53"))))  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x75")  (str.to_re "\x73"))))) (re.++ (re.*  (str.to_re "\x3b") )  (str.to_re "\x3b"))))))))))))))))))))))))))))))))))  (re.inter (re.*  (str.to_re "\x20") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
         (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.+  (re.union  (str.to_re "\x3b") (re.union  (str.to_re "\x2c")  (str.to_re "\x5c\x29"))) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x3b") (re.union  (str.to_re "\x2c")  (str.to_re "\x5c\x29"))) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x41")  (str.to_re "\x3b")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)