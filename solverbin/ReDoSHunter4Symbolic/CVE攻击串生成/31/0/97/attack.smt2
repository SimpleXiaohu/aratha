(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x5c\x2e") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) ))
))
(assert (= infix 
        (re.inter  (re.union  (re.++  (re.inter  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) ))  (re.++ (re.* (re.range "\x00" "\xffff") ) (re.inter re.allchar (re.comp (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))))))  (re.inter  (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) (re.* (re.range "\x00" "\xffff") ))  (re.++  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x3d") (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ))) (re.++ (re.*  (str.to_re "\x3b") ) (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )))))  (re.++  (re.inter  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) ))  (re.++ (re.* (re.range "\x00" "\xffff") ) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))))  (re.inter  (re.++ (re.inter re.allchar (re.comp (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")))) (re.* (re.range "\x00" "\xffff") ))  (re.++  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x3d") (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ))) (re.++ (re.*  (str.to_re "\x3b") ) (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ))))))  (re.union  (re.++  (re.inter  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) ))  (re.++ (re.* (re.range "\x00" "\xffff") ) (re.inter re.allchar (re.comp (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))))))  (re.inter  (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) (re.* (re.range "\x00" "\xffff") ))  (re.++  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x3d") (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ))) (re.++ (re.*  (str.to_re "\x3b") ) (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )))))  (re.++  (re.inter  (re.++  (str.to_re "\x5c\x2e") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")) ))  (re.++ (re.* (re.range "\x00" "\xffff") ) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))))  (re.inter  (re.++ (re.inter re.allchar (re.comp (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_")))) (re.* (re.range "\x00" "\xffff") ))  (re.++  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++  (str.to_re "\x3d") (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ))) (re.++ (re.*  (str.to_re "\x3b") ) (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )))))) )
))
(assert (= postfix 
         (str.to_re "\x25ce")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)