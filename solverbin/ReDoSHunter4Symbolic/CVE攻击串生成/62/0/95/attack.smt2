(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 1024 1024) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3d") (re.++  (str.to_re "\x20")  (str.to_re "\x3d")))
))
(assert (= infix 
         (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")) (re.inter (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ re.allchar ) )  
))
(assert (= postfix 
         (str.to_re "\x21")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)