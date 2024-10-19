(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x58") (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x4f")  (str.to_re "\x5f"))))))
))
(assert (= infix 
        (re.inter (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )  (re.++ (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++  (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x61")  (str.to_re "\x62"))) (re.* re.allchar ))) (re.* re.allchar ) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)