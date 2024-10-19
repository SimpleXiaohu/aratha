(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3c") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6e") (re.++ (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x3d") (re.++  (re.union  (str.to_re "\x22")  (str.to_re "\x27")) (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x2d") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x3a") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x73") (re.++  (re.union  (str.to_re "\x22")  (str.to_re "\x27"))  (str.to_re "\x3e")))))))))))))))))))))))))))))))  (re.inter (re.* (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)