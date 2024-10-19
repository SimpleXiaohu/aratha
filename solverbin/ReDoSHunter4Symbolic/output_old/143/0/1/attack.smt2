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
          (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x59") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x20")  (str.to_re "\x33")))))))))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x40")  (str.to_re "\x40")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)