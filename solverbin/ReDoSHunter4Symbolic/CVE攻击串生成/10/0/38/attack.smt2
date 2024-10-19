(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x40")
))
(assert (= infix 
         (re.++  (re.++ (re.+  (re.++ (re.*  (re.++  (str.to_re "\x3a")  (str.to_re "\x3a")) ) (re.++ (re.opt  (str.to_re "\x27") ) (re.++ (re.opt (re.range "0" "9") ) (re.+  (re.union  (str.to_re "\x5c\x24")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) )))) ) (re.*  (re.++  (str.to_re "\x3a")  (str.to_re "\x3a")) )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.++ (re.*  (re.++  (str.to_re "\x3a")  (str.to_re "\x3a")) ) (re.++ (re.opt  (str.to_re "\x27") ) (re.++ (re.opt (re.range "0" "9") ) (re.+  (re.union  (str.to_re "\x5c\x24")  (re.union (re.range "\x41" "\x5a") (re.union (re.range "\x61" "\x7a") (re.union (re.range "0" "9")  (str.to_re "\x5f"))))) )))) ) (re.++  (re.*  (re.++  (str.to_re "\x3a")  (str.to_re "\x3a")) ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x40") (re.++  (str.to_re "\x23") (re.++  (str.to_re "\x3a") (re.++  (str.to_re "\x3a") (re.++  (str.to_re "\x27")  (str.to_re "\x31"))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)