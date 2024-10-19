(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x41")  (str.to_re "\x3a"))
))
(assert (= infix 
        (re.inter  (re.++ (re.+  (re.union  (str.to_re "\x40")  (str.to_re "\x3a")) ) (re.+  (str.to_re "\x40") ))  (re.++ (re.+  (re.union  (str.to_re "\x40")  (str.to_re "\x3a")) ) (re.+  (str.to_re "\x40") )) )
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp (re.+  (str.to_re "\x40") )))  (re.inter  (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp  (re.++ (re.+  (str.to_re "\x40") )  (re.++  (str.to_re "\x40") (re.++ (re.*  (str.to_re "\x5c\x2f") ) (re.++  (str.to_re "\x5c\x2f") (re.++ (re.+ re.allchar ) (re.++ (re.opt  (re.++  (str.to_re "\x2e") (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x69")  (str.to_re "\x74")))) ) (re.opt  (str.to_re "\x23") ))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)