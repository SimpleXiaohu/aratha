(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
    (re.+  (re.++ (re.* re.allchar )  (str.to_re "\x2c")) )
))
(assert (= infix 
        (re.inter (re.+  (re.++ (re.* re.allchar )  (str.to_re "\x2c")) )  (re.++ (re.+  (re.++ (re.* re.allchar )  (str.to_re "\x2c")) ) (re.+ re.allchar )) (re.+ re.allchar ) )
))
(assert (= postfix 
         (re.inter  (re.++  (str.to_re "\x2c") (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp (re.+ re.allchar )))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)