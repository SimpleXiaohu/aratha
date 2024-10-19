(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 20000 20000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++ (re.+  (str.to_re "\x5c\x2d") )  (str.to_re "\x2d")) (re.+  (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x2b") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))))) ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x2b") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))))) ) (re.*  (re.union (re.range "\x21" "\x7e")  (str.to_re "\x3f")) ))  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f") (re.union  (str.to_re "\x2b") (re.union (re.range "0" "9") (re.union (re.range "\x41" "\x5a") (re.range "\x61" "\x7a"))))) ) (re.++  (re.++ (re.opt  (str.to_re "\x3d") ) (re.opt  (str.to_re "\x3d") )) (re.*  (re.union (re.range "\x21" "\x7e")  (str.to_re "\x3f")) ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x0d") (re.++  (str.to_re "\x41")  (str.to_re "\x0d")))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)