(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x54")  (str.to_re "\x56"))))) (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x5c\x2e") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x5c\x2e") (re.++  (str.to_re "\x31") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x5c\x2e") (re.++ (re.range "0" "9") (re.++  (str.to_re "\x3b") (re.++ (re.*  (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x72")  (str.to_re "\x5c\x2f"))))))) ) (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x4f")  (str.to_re "\x4d")))))))))))))))))))))))))  (re.inter (re.*  (str.to_re "\x3b") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
        (re.inter  (re.++ (re.*  (str.to_re "\x3b") ) (re.*  (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x5c\x2f") (re.* re.allchar ))))))))))))) ))  (re.++ (re.*  (str.to_re "\x3b") ) (re.++  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))  (str.to_re "\x3b")) (re.*  (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x5c\x2f") (re.* re.allchar ))))))))))))) ))) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)