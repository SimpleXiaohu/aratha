(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++ (re.opt  (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x41")  (re.union  (str.to_re "\x20")  (str.to_re "\x5f")))))) ) (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x52") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x53") (re.opt  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f"))) )))))))) (re.+  (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x3b")  (str.to_re "\x5c\x29"))) ))
))
(assert (= infix 
        (re.inter (re.+  (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x3b")  (str.to_re "\x5c\x29"))) )  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x3b")  (str.to_re "\x5c\x29"))) ) (re.*  (str.to_re "\x20") )) (re.*  (str.to_re "\x20") ) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)