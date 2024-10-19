(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 16 16) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x22")
))
(assert (= infix 
         (re.++  (str.to_re "\x26") (re.++  (str.to_re "\x5c\x72") (re.++  (str.to_re "\x5c\x6e") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x26") (re.++  (str.to_re "\x5c\x72") (re.++  (str.to_re "\x21")  (str.to_re "\x31")))))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21")  (str.to_re "\x0a"))))))))))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)