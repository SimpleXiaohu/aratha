(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
    (str.to_re "")
))
(assert (= infix 
        (re.inter  (re.++ (re.*  (re.++ (re.* re.allchar )  (str.to_re "\x2c")) ) (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) ))  (re.++ (re.*  (re.++ (re.* re.allchar )  (str.to_re "\x2c")) ) (re.++ (re.*  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) ) (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x41")  (str.to_re "\x22"))))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)