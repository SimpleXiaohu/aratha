(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x2f")
))
(assert (= infix 
        (re.inter (re.* re.allchar )  (re.++ (re.* re.allchar ) (re.++  (re.++  (re.union  (str.to_re "\x5c\x3f")  (str.to_re "\x26")) (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x74")  (str.to_re "\x5c\x3d"))))))) (re.*  (re.union  (str.to_re "\x24")  (str.to_re "\x26")) ))) (re.*  (re.union  (str.to_re "\x24")  (str.to_re "\x26")) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x26") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x26")  (str.to_re "\x0a")))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)