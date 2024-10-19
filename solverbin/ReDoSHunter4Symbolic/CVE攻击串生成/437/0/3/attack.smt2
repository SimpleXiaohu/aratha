(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x46") (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x45")  (str.to_re "\x20"))))))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )) (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) )
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)