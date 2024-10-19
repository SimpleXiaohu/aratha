(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x31") (re.++ re.allchar (re.++  (str.to_re "\x31") (re.++ re.allchar (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x31") (re.++ re.allchar (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x4f")  (str.to_re "\x4d")))))))))))))))))))))))))))
))
(assert (= infix 
        (re.inter (re.*  (str.to_re "\x3b") )  (re.++ (re.*  (str.to_re "\x3b") ) (re.++  (re.++  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))  (str.to_re "\x3b")) (re.++ (re.*  (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x5c\x2f") (re.* re.allchar ))))))))))))) ) (re.++  (str.to_re "\x4c")  (str.to_re "\x46")))) (re.+  (str.to_re "\x3b") ))) (re.+  (str.to_re "\x3b") ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x41")  (str.to_re "\x3b")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)