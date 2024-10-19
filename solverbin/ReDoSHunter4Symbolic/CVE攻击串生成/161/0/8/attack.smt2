(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x5c\x25") (re.opt  (re.union  (re.++  (str.to_re "\x5c\x28") (re.++ (re.+  (re.union (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) (re.union  (str.to_re "\x2e")  (str.to_re "\x5f"))) )  (str.to_re "\x5c\x29")))  (re.++  (re.++ (re.range "\x31" "\x39") (re.* (re.range "0" "9") ))  (str.to_re "\x5c\x24"))) ))  (re.inter (re.*  (re.union  (str.to_re "\x30") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x5c\x23")  (str.to_re "\x2b"))))) )  (re.++   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) (re.*   (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))))
))
(assert (= infix 
         (re.++  (re.++ (re.*  (re.union  (str.to_re "\x30") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x5c\x23")  (str.to_re "\x5c\x2b"))))) ) (re.+ (re.range "0" "9") )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.*  (re.union  (str.to_re "\x30") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x5c\x23")  (str.to_re "\x5c\x2b"))))) ) (re.++  (re.++ (re.opt  (re.union  (str.to_re "\x5c\x2a") (re.+ (re.range "0" "9") )) ) (re.opt  (str.to_re "\x5c\x2e") )) (re.+ (re.range "0" "9") ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)