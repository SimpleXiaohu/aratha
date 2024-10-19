(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (str.to_re "\x5c\x25") (re.++ (re.opt  (re.union  (re.++  (str.to_re "\x5c\x28") (re.++ (re.+  (re.union (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) (re.union  (str.to_re "\x2e")  (str.to_re "\x5f"))) )  (str.to_re "\x5c\x29")))  (re.++  (re.++ (re.range "\x31" "\x39") (re.* (re.range "0" "9") ))  (str.to_re "\x5c\x24"))) ) (re.*  (re.union  (str.to_re "\x30") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x5c\x2d") (re.union  (str.to_re "\x5c\x23")  (str.to_re "\x2b"))))) ))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.+ (re.range "0" "9") ))) (re.+ (re.range "0" "9") ) )
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp (re.+ (re.range "0" "9") )))  (re.inter  (re.++  (str.to_re "\x30") (re.++  (str.to_re "\x30") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) ))) (re.comp  (re.++ (re.+ (re.range "0" "9") )  (re.++ (re.opt  (re.union  (str.to_re "\x68") (re.union  (str.to_re "\x6c")  (str.to_re "\x4c"))) )  (re.union  (str.to_re "\x62") (re.union  (str.to_re "\x63") (re.union  (str.to_re "\x64") (re.union  (str.to_re "\x65") (re.union  (str.to_re "\x45") (re.union  (str.to_re "\x66") (re.union  (str.to_re "\x46") (re.union  (str.to_re "\x67") (re.union  (str.to_re "\x47") (re.union  (str.to_re "\x5c\x25") (re.union  (str.to_re "\x69") (re.union  (str.to_re "\x6f") (re.union  (str.to_re "\x4f") (re.union  (str.to_re "\x73") (re.union  (str.to_re "\x75") (re.union  (str.to_re "\x78")  (str.to_re "\x58"))))))))))))))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)