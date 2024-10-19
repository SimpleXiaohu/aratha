(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x76") (re.++  (str.to_re "\x38") (re.++  (str.to_re "\x39")  (str.to_re "\x5f")))))) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ))  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )) )
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)