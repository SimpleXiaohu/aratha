(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x2f")  (str.to_re "\x5c\x6e"))
))
(assert (= infix 
         (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))  (re.++  (re.++ (re.+  (str.to_re "\x0d") ) (re.+  (re.++ (re.opt  (str.to_re "\x0d") )  (str.to_re "\x0a")) )) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.++ (re.opt  (str.to_re "\x0d") )  (str.to_re "\x0a")) ) (re.++  (str.to_re "\x26") (re.++  (re.++  (str.to_re "\x0d") (re.* re.allchar )) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" )))))))) 
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x0d") (re.++  (str.to_re "\x0a") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp  (re.inter (re.*  (re.++ (re.* re.allchar )  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))  (re.inter  (re.++  (str.to_re "\x0d") (re.++  (str.to_re "\x0a") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp  (re.++  (re.inter (re.*  (re.++ (re.* re.allchar )  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.++  (str.to_re "\x5c\x5c")  (re.++ (re.*  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) ) (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")) (re.* (re.range "\x00" "\xffff") ))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)