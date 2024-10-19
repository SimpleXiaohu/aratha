(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x09")  (str.to_re "\x41")))
))
(assert (= infix 
        (re.inter (re.+  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x74"))) )  (re.++ (re.+  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x6e")  (str.to_re "\x5c\x74"))) ) (re.+  (str.to_re "\x5c\x6e") )) (re.+  (str.to_re "\x5c\x6e") ) )
))
(assert (= postfix 
         (re.inter  (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp (re.+  (str.to_re "\x5c\x6e") )))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)