(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6e")  (str.to_re "\x74"))))))) (re.+ re.allchar ))
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x76") (re.++  (re.union  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b"))))))  (str.to_re "\x3a")) (re.+  (re.union  (str.to_re "\x5c\x2e")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) )))) (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x76") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x5c\x2e") (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))))) (re.comp (re.+ re.allchar )))  (re.inter  (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x76") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x5c\x2e") (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))))) (re.comp  (re.++ (re.+ re.allchar )  (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6b") (re.++  (str.to_re "\x65") (re.++ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x6b")  (str.to_re "\x6f"))))))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)