(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e")  (str.to_re "\x65"))))))
))
(assert (= infix 
        (re.inter  (re.++ (re.* re.allchar ) (re.+ (re.range "0" "9") ))  (re.++ (re.* re.allchar ) (re.++  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x58") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x5c\x2f") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e"))))))))))))))))))) (re.+ (re.range "0" "9") ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x31")  (str.to_re "\x21")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)