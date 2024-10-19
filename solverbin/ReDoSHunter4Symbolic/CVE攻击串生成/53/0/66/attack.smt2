(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++  (re.union  (str.to_re "\x22")  (str.to_re "\x27"))  (re.union  (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x72"))) (re.union  (re.++  (str.to_re "\x5c\x5c") (re.++  (str.to_re "\x7a")  (re.union  (re.++  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x6e")) (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")))))  (re.++  (str.to_re "\x5c\x5c")  (re.union  (re.++  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x6e"))  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))))))))
))
(assert (= infix 
         (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))  (re.++  (re.++ (re.+  (re.union  (re.++ (re.opt  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27")) )  (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x0a")  (str.to_re "\x0d"))))  (re.++  (str.to_re "\x5c\x5c") (re.++  (str.to_re "\x7a")  (re.union  (re.++  (str.to_re "\x0d")  (str.to_re "\x0a"))  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))))))) ) (re.+  (re.union  (re.++ (re.opt  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27")) )  (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x0a")  (str.to_re "\x0d"))))  (re.++  (str.to_re "\x5c\x5c")  (re.union  (re.++  (str.to_re "\x0d")  (str.to_re "\x0a"))  (re.union  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b"))))))  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))))))) )) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (re.++ (re.opt  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27")) )  (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x0a")  (str.to_re "\x0d"))))  (re.++  (str.to_re "\x5c\x5c")  (re.union  (re.++  (str.to_re "\x0d")  (str.to_re "\x0a"))  (re.union  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b"))))))  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))))))) ) (re.++  (str.to_re "\x26") (re.++  (re.++  (str.to_re "\x5c\x5c") (re.* re.allchar )) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))))))  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x22")  (str.to_re "\x22"))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)