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
          (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x46") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6b")  (str.to_re "\x2f"))))))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x40")  (str.to_re "\x25ce")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)