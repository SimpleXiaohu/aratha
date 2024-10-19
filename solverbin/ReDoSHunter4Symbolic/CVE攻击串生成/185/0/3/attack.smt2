(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++ (re.opt  (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5c\x2b")) ) (re.+ (re.range "\x31" "\x39") ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "\x31" "\x39") ) (re.* (re.range "0" "9") ))  (re.++ (re.+ (re.range "\x31" "\x39") ) (re.* (re.range "0" "9") )) )
))
(assert (= postfix 
         (str.to_re "\x25ce")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)