(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x2f")
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (re.++  (re.union  (str.to_re "\x5c\x3f")  (str.to_re "\x5c\x26")) (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x5c\x3d") (re.++ (re.*  (re.union  (str.to_re "\x5c\x24")  (str.to_re "\x5c\x26")) )  (str.to_re "\x5c\x26"))))))))) (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
         (re.inter  (re.++  (str.to_re "\x26") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x3d") (re.++  (str.to_re "\x26") (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))))))) (re.comp (re.+ re.allchar )))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)