(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x5c\x5c") (re.+  (str.to_re "\x64") ))
))
(assert (= infix 
         (re.++ (re.+  (str.to_re "\x64") ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (str.to_re "\x64") ) (re.++  (re.+  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.inter  (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x64") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp (re.+  (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a")) )))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)