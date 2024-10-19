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
         (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x09")  (str.to_re "\x41")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)