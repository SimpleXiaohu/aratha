(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++ (re.+  (re.++  (str.to_re "\x5c\x2b") (re.+  (re.union  (str.to_re "\x3d")  (str.to_re "\x5c\x2d")) )) ) (re.++  (str.to_re "\x5c\x2b") (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")) (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )))))  (re.++  (re.union  (str.to_re "\x2b")  (str.to_re "\x7c")) (re.+ re.allchar )))
))
(assert (= infix 
        (re.inter  (re.union  (str.to_re "\x2b")  (str.to_re "\x7c")) (re.+ re.allchar ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21")  (str.to_re "\x41"))))))))))))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)