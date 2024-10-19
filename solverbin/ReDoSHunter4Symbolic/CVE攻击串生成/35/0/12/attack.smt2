(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x5c\x5b") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x70") (re.++ (re.opt  (str.to_re "\x73") ) (re.++  (str.to_re "\x3a") (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x5c\x2f") (re.+  (re.union  (str.to_re "\x5c\x5d") (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))) )))))))))) (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.*  (str.to_re "\x5c\x5d") ))  (re.++ (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.*  (str.to_re "\x5c\x5d") )) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x5d") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x5d") (re.++  (str.to_re "\x21")  (str.to_re "\x5d")))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)