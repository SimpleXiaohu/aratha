(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x57") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x4b") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x74")  (str.to_re "\x2f"))))))))))))
))
(assert (= infix 
         (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.+ (re.range "0" "9") )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.+ (re.range "0" "9") ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp (re.+ (re.range "0" "9") )))  (re.inter  (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp  (re.++ (re.+ (re.range "0" "9") )  (re.++  (str.to_re "\x5c\x2b") (re.++  (str.to_re "\x20") (re.++ (re.* re.allchar ) (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x66") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x72")  (str.to_re "\x69"))))))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)