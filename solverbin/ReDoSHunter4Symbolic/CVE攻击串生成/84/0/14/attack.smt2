(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x74")  (str.to_re "\x63")))
))
(assert (= infix 
        (re.inter (re.+  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.union  (str.to_re "\x3b") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f")))) )  (re.++ (re.+  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.union  (str.to_re "\x3b") (re.union  (str.to_re "\x5c\x2d")  (str.to_re "\x5f")))) ) (re.+  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) )) (re.+  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) ) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x7e") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x7e")  (str.to_re "\x21"))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)