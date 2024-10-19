(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 1510 1510) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3b") (re.*  (str.to_re "\x20") )) (re.+  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x47") (re.++  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f"))) (re.*  (str.to_re "\x20") ))))))))) ))
))
(assert (= infix 
        (re.inter (re.+  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x47") (re.++  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f"))) (re.*  (str.to_re "\x20") ))))))))) )  (re.++ (re.+  (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x55") (re.++  (str.to_re "\x4e") (re.++  (str.to_re "\x47") (re.++  (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f"))) (re.*  (str.to_re "\x20") ))))))))) ) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) )) (re.+  (re.union  (str.to_re "\x5c\x2f")  (str.to_re "\x3b")) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x3b") (re.++  (str.to_re "\x25ce") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x25ce")  (str.to_re "\x3b"))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)