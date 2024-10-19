(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3c") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x3d") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x3a") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x22")  (str.to_re "\x3e")))))))))))))))))))))))))))))))
))
(assert (= infix 
        (re.inter (re.* (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) )  (re.++ (re.* (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) ) (re.+  (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x72")) )) (re.+  (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x72")) ) )
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x0d") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp (re.+  (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x72")) )))  (re.inter  (re.++  (str.to_re "\x0d") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++ (re.+  (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x72")) )  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x3c") (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6e")  (str.to_re "\x3e"))))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)