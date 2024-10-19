(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x75")  (str.to_re "\x73"))))  (re.inter (re.* re.allchar )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
        (re.inter  (re.++ (re.* re.allchar ) (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x3b"))) ))  (re.++ (re.* re.allchar ) (re.++  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55")  (str.to_re "\x53")))) (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x3b"))) ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x41")  (str.to_re "\x7e")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)