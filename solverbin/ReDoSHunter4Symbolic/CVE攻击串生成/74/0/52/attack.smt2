(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x69")  (str.to_re "\x64"))))))) (re.+ re.allchar ))
))
(assert (= infix 
        (re.inter (re.+ re.allchar )  (re.++ (re.+ re.allchar ) (re.++  (re.++  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) (re.++ (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (re.union  (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x73") (re.++ (re.+  (re.union  (str.to_re "\x26") (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))) ) (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )))))))))))))  (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x4e")  (re.union  (str.to_re "\x52")  (str.to_re "\x54"))))) (re.opt  (str.to_re "\x56") )))) (re.* re.allchar ))) (re.* re.allchar ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a")  (str.to_re "\x21"))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)