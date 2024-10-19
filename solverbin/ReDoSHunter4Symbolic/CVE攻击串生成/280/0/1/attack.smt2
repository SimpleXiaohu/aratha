(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 512 512) infix) postfix)))
(assert (= prefix 
     (re.++ (re.* re.allchar )  (str.to_re "\x2c"))
))
(assert (= infix 
         (re.inter (re.* re.allchar )  (str.to_re "\x2c") )  
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a")  (str.to_re "\x40"))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)