(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++ (re.opt  (str.to_re "\x5c\x2f") ) (re.+  (re.union (re.range "0" "9") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "\x41" "\x5a")  (str.to_re "\x5f")))) ))
))
(assert (= infix 
        (re.inter (re.+  (re.++ (re.+  (re.union (re.range "0" "9") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "\x41" "\x5a")  (str.to_re "\x5f")))) ) (re.opt  (str.to_re "\x5c\x2f") )) ) (re.+  (re.union (re.range "0" "9") (re.union  (str.to_re "\x5c\x2d") (re.union (re.range "\x41" "\x5a")  (str.to_re "\x5f")))) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x41")  (str.to_re "\x61")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)