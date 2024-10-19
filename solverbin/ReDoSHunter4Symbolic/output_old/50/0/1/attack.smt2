(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) ) (re.++ (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x58") (re.++ (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) ) (re.+ (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ))))))))))))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "0" "9") ) (re.+ (re.range "0" "9") ))  (re.++ (re.+ (re.range "0" "9") ) (re.++ re.allchar (re.+ (re.range "0" "9") ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x31")  (str.to_re "\x0a")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)