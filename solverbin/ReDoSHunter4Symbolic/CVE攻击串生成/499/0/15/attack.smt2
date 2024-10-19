(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x53")  (str.to_re "\x4d"))))))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)