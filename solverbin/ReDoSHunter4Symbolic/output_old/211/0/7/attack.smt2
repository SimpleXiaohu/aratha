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
        (re.inter  (re.inter  (re.++  (str.to_re "\x5c\x3f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x3d") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))))) (re.comp  (re.inter (re.*  (re.union  (str.to_re "\x24")  (str.to_re "\x26")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))  (re.inter  (re.++  (str.to_re "\x5c\x3f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x3d") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))))) (re.comp  (re.++  (re.inter (re.*  (re.union  (str.to_re "\x24")  (str.to_re "\x26")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.opt  (re.++  (str.to_re "\x26") (re.+ re.allchar )) )))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)