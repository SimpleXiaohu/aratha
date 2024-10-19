(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x77") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x4c")  (str.to_re "\x3b"))))))))))))))))))))))))))))))))))))
))
(assert (= infix 
        (re.inter (re.*  (str.to_re "\x20") )  (re.++ (re.*  (str.to_re "\x20") ) (re.+  (re.union  (str.to_re "\x3b") (re.union  (str.to_re "\x2c")  (str.to_re "\x5c\x29"))) )) (re.+  (re.union  (str.to_re "\x3b") (re.union  (str.to_re "\x2c")  (str.to_re "\x5c\x29"))) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x41")  (str.to_re "\x3b")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)