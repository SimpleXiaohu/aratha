(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x46") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6b") (re.++  (str.to_re "\x2f")  (str.to_re "\x38")))))))))))
))
(assert (= infix 
        (re.inter  (re.++ (re.* re.allchar ) (re.* re.allchar ))  (re.++ (re.* re.allchar ) (re.++  (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x44") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x35") (re.++  (str.to_re "\x5c\x2e") (re.+ (re.range "0" "9") )))))))))))) (re.* re.allchar ))) )
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)