(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x60") (re.++  (str.to_re "\x60")  (str.to_re "\x60")))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.++ (re.opt (re.+  (re.union  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f")))) (re.union  (str.to_re "\x5c\x2b")  (str.to_re "\x5c\x2d"))) ) ) (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (re.inter  (re.inter (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ) (re.comp  (re.inter (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))  (re.inter (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ) (re.comp  (re.++  (re.inter (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))  (str.to_re "\x5c\x6e")))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)