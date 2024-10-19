(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x58") (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x4f")  (re.union  (str.to_re "\x20")  (str.to_re "\x5f"))))))))  (re.inter (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
        (re.inter (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )  (re.++ (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++  (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x61")  (str.to_re "\x62"))) (re.* re.allchar ))) (re.* re.allchar ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3b")  (str.to_re "\x0a"))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)