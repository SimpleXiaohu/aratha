(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x40") (re.++  (str.to_re "\x5c\x28") (re.++ (re.+  (re.union  (str.to_re "\x22") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x5c\x72") (re.union  (str.to_re "\x29")  (str.to_re "\x3a")))))) ) (re.++ (re.opt  (re.++  (str.to_re "\x5c\x2f") (re.*  (re.union  (str.to_re "\x72") (re.union  (str.to_re "\x73") (re.union  (str.to_re "\x74") (re.union  (str.to_re "\x24") (re.union  (str.to_re "\x75") (re.union  (str.to_re "\x4c")  (str.to_re "\x6e"))))))) )) ) (re.++  (str.to_re "\x5c\x29") (re.++ (re.* re.allchar )  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))))))))  (re.++ (re.* re.allchar )  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))))
))
(assert (= infix 
        (re.* re.allchar )  (re.++  (re.++ (re.+  (str.to_re "\x0d") ) (re.+  (re.++ (re.opt  (str.to_re "\x0d") )  (str.to_re "\x0a")) )) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.++ (re.opt  (str.to_re "\x0d") )  (str.to_re "\x0a")) ) (re.++  (str.to_re "\x26") (re.++  (re.++  (str.to_re "\x0d") (re.* re.allchar )) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))))))  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x3a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x3a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41")  (str.to_re "\x3a")))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)