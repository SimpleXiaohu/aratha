(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x54")  (str.to_re "\x43")))
))
(assert (= infix 
        (re.inter (re.+  (str.to_re "\x3b") )  (re.++ (re.+  (str.to_re "\x3b") ) (re.*  (str.to_re "\x20") )) (re.*  (str.to_re "\x20") ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3b")  (str.to_re "\x25ce")))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)