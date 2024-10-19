(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x75")  (str.to_re "\x73"))))  (re.inter (re.* re.allchar )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
        (re.inter (re.* re.allchar )  (re.++ (re.* re.allchar ) (re.++  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x53") (re.++ (re.*  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x3b"))) ) (re.opt  (re.union  (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x66") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x20") (re.++  (re.union  (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x61")  (str.to_re "\x64")))  (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6d")  (str.to_re "\x65"))))))  (str.to_re "\x20")))))))))))))) (re.union  (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x66") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72")  (str.to_re "\x20")))))))))))) (re.union  (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x66") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x65")  (str.to_re "\x20"))))))))  (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x78") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x73")  (re.union  (str.to_re "\x20")  (str.to_re "\x5f")))))))))) )))))) (re.+  (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))) ))) (re.+  (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))) ) )
))
(assert (= postfix 
         (re.inter  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x41") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))) (re.comp (re.+  (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))) )))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)