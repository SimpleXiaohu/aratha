(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x5c\x28") (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) )))))) (re.+ re.allchar ))
))
(assert (= infix 
        (re.inter (re.+ re.allchar )  (re.++ (re.+ re.allchar ) (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) )) (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e") (re.union  (str.to_re "\x5c\x72")  (str.to_re "\x5c\x74")))) ) )
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)