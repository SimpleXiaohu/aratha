(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x09")  (str.to_re "\x41")))
))
(assert (= infix 
        (re.inter (re.+  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x74"))) )  (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x74"))) ) (re.+  (str.to_re "\x5c\x6e") )) (re.+  (str.to_re "\x5c\x6e") ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x41")  (str.to_re "\x0a"))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)