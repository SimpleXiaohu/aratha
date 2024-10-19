(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x3b")
))
(assert (= infix 
         (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.+  (str.to_re "\x5c\x2f") ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (str.to_re "\x5c\x2f") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp (re.+  (str.to_re "\x5c\x2f") )))  (re.inter  (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++ (re.+  (str.to_re "\x5c\x2f") )  (re.++  (str.to_re "\x5f") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e")  (re.union  (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c")  (str.to_re "\x64"))))))  (re.++  (str.to_re "\x5c\x29") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x4b") (re.++  (str.to_re "\x69")  (str.to_re "\x74")))))))))))))))))))))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)