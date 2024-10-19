(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 2010 2010) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3b")  (re.inter (re.*  (str.to_re "\x20") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
        (re.inter (re.+  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x47") (re.++  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f"))) (re.*  (str.to_re "\x20") ))))))))) )  (re.++ (re.+  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x47") (re.++  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f"))) (re.*  (str.to_re "\x20") ))))))))) ) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) )
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)