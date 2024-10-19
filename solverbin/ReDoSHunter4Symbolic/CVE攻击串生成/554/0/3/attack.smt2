(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x20") (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.range "0" "9") )) ) (re.++ (re.opt  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.range "0" "9") )) ) (re.++  (str.to_re "\x3b")  (str.to_re "\x20"))))))))))))) (re.+  (str.to_re "\x3b") ))
))
(assert (= infix 
         (re.++ (re.+  (str.to_re "\x3b") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (str.to_re "\x3b") ) (re.++  (re.union  (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c")  (str.to_re "\x64"))))))  (re.++  (str.to_re "\x5c\x29") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x4b") (re.++  (str.to_re "\x69")  (str.to_re "\x74")))))))))))))) (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)