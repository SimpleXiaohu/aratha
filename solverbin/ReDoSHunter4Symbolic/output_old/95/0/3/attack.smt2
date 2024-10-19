(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x7b")
))
(assert (= infix 
         (re.++ (re.+  (str.to_re "\x2c") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (str.to_re "\x2c") ) (re.++ (re.*  (re.++  (str.to_re "\x5c\x7b") (re.++ (re.+  (str.to_re "\x2c") )  (str.to_re "\x5c\x7d"))) ) (re.*  (str.to_re "\x2c") ))) (re.++  (str.to_re "\x26") (re.++ (re.*  (str.to_re "\x2c") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x21")  (str.to_re "\x25ce")))))))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)