(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 16 16) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x20") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x20") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x5c\x5b") (re.++ (re.*  (str.to_re "\x5c\x5d") ) (re.++  (str.to_re "\x5c\x5d") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x22") (re.++ (re.+ (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")))) ) (re.++ (re.opt  (re.++ (re.+  (str.to_re "\x20") ) (re.++ (re.*  (re.union  (str.to_re "\x5c\x22")  (re.++  (str.to_re "\x5c\x5c") re.allchar)) ) (re.opt  (re.++ (re.+  (str.to_re "\x20") ) (re.* (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")))) )) ))) ) (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x20") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x20") (re.++ (re.*  (str.to_re "\x20") ) (re.++  (str.to_re "\x20")  (str.to_re "\x22"))))))))))))))))))))  (re.union  (str.to_re "\x5c\x22")  (re.++  (str.to_re "\x5c\x5c") re.allchar)))
))
(assert (= infix 
         (re.inter  (re.++ (re.+  (str.to_re "\x5c\x22") ) (re.+  (re.++  (str.to_re "\x5c\x5c") re.allchar) )) (re.+  (re.++  (str.to_re "\x5c\x5c") re.allchar) )  (re.++  (str.to_re "\x5c\x5c") (re.* re.allchar )) )  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x5d") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x5d") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x21")  (str.to_re "\x0a"))))))))))))))))))))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)