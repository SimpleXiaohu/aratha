(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x4f") (re.++ (re.+  (str.to_re "\x53") ) (re.++  (str.to_re "\x31")  (str.to_re "\x5f"))))))))))))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "0" "9") ) (re.* re.allchar ))  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (re.++  (str.to_re "\x5f") (re.+ (re.range "0" "9") )) ) (re.* re.allchar ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21")  (str.to_re "\x0a")))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)