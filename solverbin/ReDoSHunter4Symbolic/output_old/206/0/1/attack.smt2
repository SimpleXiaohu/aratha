(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x20")  (str.to_re "\x2f"))))))))))))))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.++ re.allchar (re.+ (re.range "0" "9") ))) (re.+ (re.range "0" "9") ) )
))
(assert (= postfix 
         (str.to_re "\x21")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)