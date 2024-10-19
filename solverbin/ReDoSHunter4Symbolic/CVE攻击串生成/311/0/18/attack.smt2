(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x7a") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x6c")  (str.to_re "\x61")))))))  (re.inter (re.* re.allchar )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.+ (re.range "0" "9") )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x61")  (str.to_re "\x6d"))))))))) (re.++  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e"))))))))))) (re.+ (re.range "0" "9") ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x5c\x2e") (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))))))))))))))))) (re.comp (re.+ (re.range "0" "9") )))  (re.inter  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x62") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x5c\x2e") (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))))))))))))))))) (re.comp  (re.++ (re.+ (re.range "0" "9") )  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.range "0" "9") ))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)