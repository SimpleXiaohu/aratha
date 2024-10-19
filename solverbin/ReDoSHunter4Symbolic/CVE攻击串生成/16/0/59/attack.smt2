(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.opt (re.opt  (str.to_re "\x5c\x2f") ) ) (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))  (re.union   (str.to_re "\x5c\x2e")  (re.++  (str.to_re "\x5c\x2e")    (str.to_re "\x5c\x2e"))))
))
(assert (= infix 
        (re.inter  (re.++  (re.union   (str.to_re "\x5c\x2e")  (re.++  (str.to_re "\x5c\x2e")    (str.to_re "\x5c\x2e"))) (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x2e")) ))  (re.++  (re.union   (str.to_re "\x5c\x2e")  (re.++  (str.to_re "\x5c\x2e")    (str.to_re "\x5c\x2e"))) (re.++  (str.to_re "\x5c\x2e") (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x2e")) ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x2f") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x2f")  (str.to_re "\x41"))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)