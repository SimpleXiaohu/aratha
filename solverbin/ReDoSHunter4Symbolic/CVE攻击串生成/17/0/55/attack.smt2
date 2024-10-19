(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.union  (str.to_re "\x5c\x2d") (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))  (str.to_re "\x5f")))  (re.++   (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "0" "9") (re.range "\x61" "\x7a")))) (re.*   (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "0" "9") (re.range "\x61" "\x7a")))) )))
))
(assert (= infix 
        (re.inter  (re.++   (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "0" "9") (re.range "\x61" "\x7a")))) (re.*   (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "0" "9") (re.range "\x61" "\x7a")))) ))  (re.++  (re.++   (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "0" "9") (re.range "\x61" "\x7a")))) (re.*   (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "0" "9") (re.range "\x61" "\x7a")))) )) (re.* (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) )) (re.* (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) ) )
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x61") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.inter (re.* (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))  (re.inter  (re.++  (str.to_re "\x61") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++  (re.inter (re.* (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f")))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)