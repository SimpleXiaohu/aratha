(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 16 16) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.*  (re.union  (str.to_re "\x20")  (str.to_re "\x5c\x74")) )  (str.to_re "\x5c\x5b"))  (re.++  (re.union  (str.to_re "\x60") (re.union  (str.to_re "\x22") (re.union  (str.to_re "\x24")  (str.to_re "\x27")))) (re.++ (re.*  (re.union  (str.to_re "\x5c\x5c")  (re.++  (str.to_re "\x5c\x5c") re.allchar)) )  (re.union  (str.to_re "\x60") (re.union  (str.to_re "\x22") (re.union  (str.to_re "\x24")  (str.to_re "\x27")))))))
))
(assert (= infix 
         (re.++  (str.to_re "\x60") (re.++  (str.to_re "\x41")  (str.to_re "\x60")))
))
(assert (= postfix 
         (str.to_re "\x41")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)