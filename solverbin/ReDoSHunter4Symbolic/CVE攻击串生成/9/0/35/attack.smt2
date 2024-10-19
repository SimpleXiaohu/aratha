(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x5c\x5b")  (re.union  (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x5d")  (str.to_re "\x22"))) (re.union  (re.++  (re.union  (str.to_re "\x22")  (str.to_re "\x27")) (re.++ (re.*  (re.union  (str.to_re "\x5c\x5c")  (re.++  (str.to_re "\x5c\x5c") re.allchar)) )  (re.union  (str.to_re "\x22")  (str.to_re "\x27"))))  (re.++  (str.to_re "\x5c\x5c") re.allchar))))
))
(assert (= infix 
         (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))  (re.++  (re.++ (re.+  (re.union  (re.++  (str.to_re "\x5c\x5c")  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")))  (re.union  (str.to_re "\x5c\x5c") (re.union  (str.to_re "\x5c\x5d")  (str.to_re "\x5c\x22")))) ) (re.+  (re.union  (re.++  (str.to_re "\x5c\x5c")  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")))  (re.++  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27")) (re.++ (re.*  (re.union  (re.++ (re.opt  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27")) )  (str.to_re "\x5c\x5c"))  (re.++  (str.to_re "\x5c\x5c")  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")))) )  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27"))))) )) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (re.++  (str.to_re "\x5c\x5c")  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")))  (re.++  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27")) (re.++ (re.*  (re.union  (re.++ (re.opt  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27")) )  (str.to_re "\x5c\x5c"))  (re.++  (str.to_re "\x5c\x5c")  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")))) )  (re.union  (str.to_re "\x5c\x22")  (str.to_re "\x27"))))) ) (re.++  (str.to_re "\x26") (re.++  (re.++  (str.to_re "\x27") (re.* re.allchar )) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))))))  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)