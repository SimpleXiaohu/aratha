(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 64 64) infix) postfix)))
(assert (= prefix 
    (str.to_re "")
))
(assert (= infix 
        (re.inter  (re.union  (str.to_re "\x2b")  (str.to_re "\x7c")) (re.+ re.allchar ) )
))
(assert (= postfix 
         (str.to_re "\x21")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)