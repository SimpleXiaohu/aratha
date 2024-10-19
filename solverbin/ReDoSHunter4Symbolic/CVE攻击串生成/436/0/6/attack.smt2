(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.union  (re.++  (str.to_re "\x46") (re.++  (str.to_re "\x6c")  (str.to_re "\x79")))  (re.++  (str.to_re "\x46") (re.++  (str.to_re "\x4c")  (str.to_re "\x59")))) (re.++  (re.union  (str.to_re "\x20")  (str.to_re "\x5f")) (re.++  (str.to_re "\x46")  (re.union  (str.to_re "\x33")  (str.to_re "\x34"))))))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
         (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.++  (re.*  (str.to_re "\x3b") ))) (re.++  (str.to_re "\x26") (re.++ (re.*  (str.to_re "\x3b") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x21")  (str.to_re "\x3b"))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)