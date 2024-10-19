(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x78") (re.++  (str.to_re "\x38") (re.++  (str.to_re "\x36") (re.++  (str.to_re "\x5f") (re.++  (str.to_re "\x36") (re.++  (str.to_re "\x34") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x31") (re.++ re.allchar (re.++  (str.to_re "\x31") re.allchar))))))))))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar ))  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar )) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x31")  (str.to_re "\x0a")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)