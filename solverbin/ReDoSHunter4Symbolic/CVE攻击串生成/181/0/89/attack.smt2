(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 16 16) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3c") (re.++  (str.to_re "\x31")  (str.to_re "\x20")))
))
(assert (= infix 
          (re.++  (re.++ (re.+  (re.union  (re.++  (str.to_re "\x5c\x22") (re.++ (re.*  (str.to_re "\x5c\x22") )  (str.to_re "\x5c\x22")))  (str.to_re "\x3e")) ) (re.+  (re.union  (re.++  (str.to_re "\x5c\x22") (re.++ (re.*  (str.to_re "\x5c\x22") )  (str.to_re "\x5c\x22")))  (re.++  (str.to_re "\x27") (re.++ (re.*  (str.to_re "\x27") )  (str.to_re "\x27")))) )) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (re.++  (str.to_re "\x5c\x22") (re.++ (re.*  (str.to_re "\x5c\x22") )  (str.to_re "\x5c\x22")))  (str.to_re "\x3e")) ) (re.++  (str.to_re "\x26") (re.++  (re.++  (str.to_re "\x27") (re.* re.allchar )) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" )))))))) 
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x27") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3e") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x27") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x27") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3e") (re.++  (str.to_re "\x22") (re.++  (str.to_re "\x27")  (str.to_re "\x21")))))))))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)