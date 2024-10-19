(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x25")
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x30") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x5c\x23")  (str.to_re "\x5c\x2b"))))) ) (re.+ (re.range "0" "9") )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x30") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x5c\x23")  (str.to_re "\x5c\x2b"))))) ) (re.++  (re.+ (re.range "0" "9") ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x31")  (str.to_re "\x21")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)