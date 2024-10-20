(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x31") (re.++ re.allchar (re.++  (str.to_re "\x31") (re.++ re.allchar  (str.to_re "\x31")))))))))))
))
(assert (= infix 
        (re.inter  (re.++ (re.* re.allchar ) (re.*  (str.to_re "\x3b") ))  (re.++ (re.* re.allchar ) (re.++  (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x45") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x5c\x2e") (re.++ (re.range "0" "9") (re.++  (str.to_re "\x3b") (re.++ (re.*  (re.++  (str.to_re "\x56") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x72")  (str.to_re "\x5c\x2f"))))))) ) (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x4f")  (str.to_re "\x4d"))))))))))))))))) (re.*  (str.to_re "\x3b") ))) )
))
(assert (= postfix 
         (str.to_re "\x40")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)