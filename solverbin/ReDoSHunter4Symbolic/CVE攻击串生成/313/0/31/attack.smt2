(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x7a") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x6c")  (str.to_re "\x61")))))))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.+ (re.range "0" "9") )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (re.++  (str.to_re "\x46") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x66") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e")  (str.to_re "\x67")))))))))))))))))) (re.++  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x5c\x2e") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e"))))))))))))) (re.+ (re.range "0" "9") ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)