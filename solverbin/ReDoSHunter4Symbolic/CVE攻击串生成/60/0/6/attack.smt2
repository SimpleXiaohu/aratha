(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.opt  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")) ) (re.++  (str.to_re "\x5c\x2f") (re.++ (re.*  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) )  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")))))  (re.++ (re.* re.allchar )  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))))
))
(assert (= infix 
         (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))  (re.++  (re.++ (re.+  (str.to_re "\x0d") ) (re.+  (re.++ (re.opt  (str.to_re "\x0d") )  (str.to_re "\x0a")) )) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.++ (re.opt  (str.to_re "\x0d") )  (str.to_re "\x0a")) ) (re.++  (str.to_re "\x26") (re.++  (re.++  (str.to_re "\x0d") (re.* re.allchar )) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" )))))))) 
))
(assert (= postfix 
         (str.to_re "\x25ce")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)