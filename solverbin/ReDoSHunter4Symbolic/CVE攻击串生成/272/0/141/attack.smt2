(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 128 128) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x31") (re.++ re.allchar (re.++  (str.to_re "\x31") (re.++ re.allchar (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x31") (re.++ re.allchar (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x4d")  (str.to_re "\x3b"))))))))))))))))))))))))))))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72")  (str.to_re "\x73")))))))) (re.++  (str.to_re "\x26") (re.++  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x5c\x2f") (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)