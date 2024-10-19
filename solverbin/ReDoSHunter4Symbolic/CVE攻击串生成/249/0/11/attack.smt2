(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++ (re.opt  (re.union  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x47")  (str.to_re "\x20"))))))))  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x67")  (str.to_re "\x20"))))))))) )  (re.union  (re.++  (str.to_re "\x47") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x78") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x20")  (re.union  (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x49")  (str.to_re "\x49")))))))  (re.++  (str.to_re "\x53") (re.range "0" "9")))))))))) (re.union  (re.++  (str.to_re "\x47") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x39") (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x38")  (str.to_re "\x32")))))))) (re.union  (re.++  (str.to_re "\x47") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x39") (re.++  (str.to_re "\x32") (re.++  (str.to_re "\x30")  (str.to_re "\x35")))))))) (re.union  (re.++  (str.to_re "\x47") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x37")  (re.++  (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))) (re.*  (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))) )))))))  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x39") (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x30")  (str.to_re "\x35")))))))))))))))  (re.inter (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++ (re.opt  (str.to_re "\x5c\x2f") ) (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)