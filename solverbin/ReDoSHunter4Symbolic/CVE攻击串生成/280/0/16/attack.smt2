(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
    (re.+  (re.++ (re.* re.allchar )  (str.to_re "\x2c")) )
))
(assert (= infix 
         (re.++ (re.+  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) )  (str.to_re "\x2c")) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) )  (str.to_re "\x2c")) ) (re.++  (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x31")  (str.to_re "\x0a")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)