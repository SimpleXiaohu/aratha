(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x61")  (str.to_re "\x5c\x28")))))  (re.inter (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
        (re.inter  (re.++ (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) ) (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) ))  (re.++ (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) ) (re.++ (re.+ re.allchar ) (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) ))) )
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.inter (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))  (re.inter  (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++  (re.inter (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))  (str.to_re "\x5c\x29")))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)