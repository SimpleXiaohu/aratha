(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.++  (re.union  (str.to_re "\x69")  (str.to_re "\x49")) (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x64")  (str.to_re "\x79")))))) (re.++ (re.opt  (re.union  (str.to_re "\x20")  (str.to_re "\x5f")) ) (re.++  (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x63")  (str.to_re "\x74"))))))) (re.opt  (re.union  (str.to_re "\x5f") (re.union  (re.++  (str.to_re "\x5c\x3f")  (str.to_re "\x5f"))  (str.to_re "\x20"))) ))))))  (re.inter (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
         (re.++ (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++  (re.*  (str.to_re "\x20") ))) (re.++  (str.to_re "\x26") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)