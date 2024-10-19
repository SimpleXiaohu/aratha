(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
    (str.to_re "")
))
(assert (= infix 
          (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x52") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x55")  (str.to_re "\x20"))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x3b")  (str.to_re "\x40"))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)