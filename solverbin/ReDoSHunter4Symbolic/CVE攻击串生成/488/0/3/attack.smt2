(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.++  (str.to_re "\x53")  (str.to_re "\x43"))  (str.to_re "\x5c\x2d")))) (re.+  (re.union  (str.to_re "\x20") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))) ))
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")))) ) (re.++ (re.opt  (str.to_re "\x5c\x2f") ) (re.*  (str.to_re "\x20") ))) (re.++  (str.to_re "\x26") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.inter (re.*  (str.to_re "\x20") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))  (re.inter  (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )) (re.comp  (re.++  (re.inter (re.*  (str.to_re "\x20") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))  (str.to_re "\x5c\x29")))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)