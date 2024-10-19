(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x64")  (str.to_re "\x3b")))))
))
(assert (= infix 
        (re.inter  (re.++ (re.* re.allchar ) (re.+ (re.range "0" "9") ))  (re.++ (re.* re.allchar ) (re.++  (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x55") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x53")  (re.union  (str.to_re "\x20")  (str.to_re "\x2b")))))))) (re.+ (re.range "0" "9") ))) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)