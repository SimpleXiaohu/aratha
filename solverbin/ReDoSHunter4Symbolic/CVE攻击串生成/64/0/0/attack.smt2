(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.*  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) ) (re.++ (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")))) (re.opt  (str.to_re "\x2c") ))) (re.+  (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x2c"))) ))
))
(assert (= infix 
        (re.inter (re.*  (re.++ (re.opt  (str.to_re "\x2c") ) (re.+  (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x2c"))) )) ) (re.+  (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x2c"))) ) )
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp (re.+  (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x2c"))) )))  (re.inter  (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++ (re.+  (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x2c"))) ) (re.*  (re.++  (str.to_re "\x2c") (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")) (re.++ (re.*  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) ) (re.++ (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) ) (re.++ (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")))) (re.*  (re.++ (re.opt  (str.to_re "\x2c") ) (re.+  (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x2c"))) )) )))))) )))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)