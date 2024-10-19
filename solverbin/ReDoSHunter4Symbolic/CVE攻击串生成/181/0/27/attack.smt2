(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 8 8) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3c") (re.++  (str.to_re "\x31")  (str.to_re "\x20")))
))
(assert (= infix 
          (re.++  (re.++ (re.+  (re.union  (re.++  (str.to_re "\x27") (re.++ (re.*  (str.to_re "\x27") )  (str.to_re "\x27")))  (str.to_re "\x3e")) ) (re.+  (re.union  (re.++  (str.to_re "\x27") (re.++ (re.*  (str.to_re "\x27") )  (str.to_re "\x27")))  (re.++  (str.to_re "\x5c\x22") (re.++ (re.*  (str.to_re "\x5c\x22") )  (str.to_re "\x5c\x22")))) )) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (re.++  (str.to_re "\x27") (re.++ (re.*  (str.to_re "\x27") )  (str.to_re "\x27")))  (re.++  (str.to_re "\x5c\x22") (re.++ (re.*  (str.to_re "\x5c\x22") )  (str.to_re "\x5c\x22")))) ) (re.++  (str.to_re "\x26") (re.++  (re.++  (str.to_re "\x5c\x22") (re.* re.allchar )) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))))))  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x22") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))) (re.comp (re.+  (re.union  (re.++  (str.to_re "\x22") (re.++ (re.*  (str.to_re "\x22") )  (str.to_re "\x22"))) (re.union  (re.++  (str.to_re "\x27") (re.++ (re.*  (str.to_re "\x27") )  (str.to_re "\x27")))  (str.to_re "\x3e"))) )))  (re.inter  (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x22") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))) (re.comp  (re.++ (re.+  (re.union  (re.++  (str.to_re "\x22") (re.++ (re.*  (str.to_re "\x22") )  (str.to_re "\x22"))) (re.union  (re.++  (str.to_re "\x27") (re.++ (re.*  (str.to_re "\x27") )  (str.to_re "\x27")))  (str.to_re "\x3e"))) )  (re.++ (re.opt  (str.to_re "\x5c\x2f") )  (str.to_re "\x3e"))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)