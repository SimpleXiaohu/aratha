(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x49") (re.++  (str.to_re "\x52") (re.++  (str.to_re "\x49")  (str.to_re "\x53")))))
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x3b")  (str.to_re "\x5c\x29"))) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x3b")  (str.to_re "\x5c\x29"))) ) (re.++  (re.*  (str.to_re "\x20") ))) (re.++  (str.to_re "\x26") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.inter (re.*  (str.to_re "\x20") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))  (re.inter  (re.++  (str.to_re "\x00") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++  (re.inter (re.*  (str.to_re "\x20") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))  (re.union  (str.to_re "\x3b") (re.union  (str.to_re "\x5c\x29")  (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6c")  (str.to_re "\x64")))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)