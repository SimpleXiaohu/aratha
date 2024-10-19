(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.inter  (re.++  (re.++  (str.to_re "\x44") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x69")  (str.to_re "\x6e"))))))) (re.++  (re.union  (str.to_re "\x20") (re.union  (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x44") (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x4e")  (str.to_re "\x5c\x2f")))))  (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x54")  (str.to_re "\x5c\x2d"))))))) (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x5c\x2e") (re.+ (re.range "0" "9") )))))  (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) (re.* (re.range "\x00" "\xffff") )))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.+ (re.range "0" "9") ))) (re.+ (re.range "0" "9") ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x31")  (str.to_re "\x21")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)