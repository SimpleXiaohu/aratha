(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
    (str.to_re "")
))
(assert (= infix 
         (re.++ (re.+  (re.union (re.range "0" "9")  (str.to_re "\x5c\x2e")) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union (re.range "0" "9")  (str.to_re "\x5c\x2e")) ) (re.++  (re.+  (re.union  (str.to_re "\x25")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) ))) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x25")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) ) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (re.inter  (re.++  (str.to_re "\x5c\x2e") (re.++  (str.to_re "\x25") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp (re.+  (re.union  (str.to_re "\x25") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) )))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)