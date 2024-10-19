(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.inter (re.* re.allchar )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x09")) )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (re.++  (str.to_re "\x2c") (re.++ (re.*  (re.union  (str.to_re "\x20")  (str.to_re "\x09")) ) (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x09")) ))) (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x09")) ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x2c") (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))) (re.comp (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) )))  (re.inter  (re.++  (str.to_re "\x2c") (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))) (re.comp  (re.++ (re.+  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) )  (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x3d") (re.++ (re.opt  (re.union  (str.to_re "\x22")  (str.to_re "\x5c\x27")) ) (re.++ (re.*  (re.union  (str.to_re "\x22")  (str.to_re "\x5c\x27")) ) (re.opt  (re.union  (str.to_re "\x22")  (str.to_re "\x5c\x27")) )))))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)