(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3b")  (re.inter (re.*  (str.to_re "\x20") )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
        (re.inter  (re.++ (re.*  (str.to_re "\x20") ) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ))  (re.++ (re.*  (str.to_re "\x20") ) (re.++  (re.++ (re.*  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x64")  (re.union  (str.to_re "\x20")  (str.to_re "\x5f")))))))))) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x25ce")  (str.to_re "\x3b"))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)