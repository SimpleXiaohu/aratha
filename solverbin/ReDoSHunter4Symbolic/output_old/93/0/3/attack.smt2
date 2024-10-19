(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x30") (re.++ re.allchar (re.++  (str.to_re "\x30")  (str.to_re "\x3b"))))))))))))
))
(assert (= infix 
        (re.inter  (re.++ (re.* re.allchar ) (re.*  (str.to_re "\x20") ))  (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x3b") (re.*  (str.to_re "\x20") ))) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)