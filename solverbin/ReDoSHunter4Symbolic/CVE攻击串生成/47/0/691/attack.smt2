(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 32 32) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.opt  (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) )  (str.to_re "\x5f")) )  (re.union  (str.to_re "\x22")  (str.to_re "\x27")))  (re.++  (str.to_re "\x26") (re.++  (re.union  (re.++  (str.to_re "\x5c\x72") (re.opt  (str.to_re "\x5c\x6e") ))  (str.to_re "\x5c\x6e")) (re.opt  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x21") (re.++ (re.+ re.allchar )  (re.union  (re.++  (str.to_re "\x5c\x72") (re.opt  (str.to_re "\x5c\x6e") ))  (str.to_re "\x5c\x6e"))))) ))))
))
(assert (= infix 
         (re.++  (str.to_re "\x26")  (re.union  (re.++  (str.to_re "\x5c\x72") (re.opt  (str.to_re "\x5c\x6e") ))  (str.to_re "\x5c\x6e"))) (re.inter (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )  (str.to_re "\x5c\x6e") )  (re.++  (str.to_re "\x21") (re.++ (re.+ re.allchar ) (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x21") (re.+ re.allchar ))))) 
))
(assert (= postfix 
         (str.to_re "\x21")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)