(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++ (re.opt  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x4b") (re.++  (str.to_re "\x59")  (re.union  (str.to_re "\x20")  (str.to_re "\x5f"))))) ) (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x5c\x2d") (re.++  (re.union  (str.to_re "\x41")  (str.to_re "\x54"))  (re.++  (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))) (re.*  (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))) ))))))))) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ))
))
(assert (= infix 
        (re.inter (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.* re.allchar )) (re.* re.allchar ) )
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)