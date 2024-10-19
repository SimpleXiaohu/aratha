(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 16 16) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x3c") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) ) (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )))  (re.union  (re.++  (str.to_re "\x22") (re.++ (re.*  (str.to_re "\x22") )  (str.to_re "\x22"))) (re.union  (re.++  (str.to_re "\x27") (re.++ (re.*  (str.to_re "\x27") )  (str.to_re "\x27")))  (str.to_re "\x3e"))))
))
(assert (= infix 
         (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" )))) (re.inter  (re.++ (re.+  (re.union  (re.++  (str.to_re "\x22") (re.++ (re.*  (str.to_re "\x22") )  (str.to_re "\x22")))  (re.++  (str.to_re "\x27") (re.++ (re.*  (str.to_re "\x27") )  (str.to_re "\x27")))) ) (re.+  (re.union  (re.++  (str.to_re "\x22") (re.++ (re.*  (str.to_re "\x22") )  (str.to_re "\x22")))  (str.to_re "\x3e")) )) (re.+  (re.union  (re.++  (str.to_re "\x22") (re.++ (re.*  (str.to_re "\x22") )  (str.to_re "\x22")))  (str.to_re "\x3e")) )  (re.++  (str.to_re "\x27") (re.* re.allchar )) )  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)