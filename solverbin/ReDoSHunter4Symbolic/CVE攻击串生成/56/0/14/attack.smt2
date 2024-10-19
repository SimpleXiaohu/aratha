(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 1024 1024) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x31")
))
(assert (= infix 
         (re.inter (re.+ (re.range "0" "9") ) (re.+ (re.range "0" "9") ) )  (str.to_re "\x5f") 
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x5f") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))) (re.comp  (re.++ (re.+ (re.range "0" "9") ) (re.*  (re.++  (str.to_re "\x5f") (re.+ (re.range "0" "9") )) ))))  (re.inter  (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x31") (re.++  (str.to_re "\x5f") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))) (re.comp  (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.*  (re.++  (str.to_re "\x5f") (re.+ (re.range "0" "9") )) )) (re.opt  (re.++  (str.to_re "\x65") (re.++ (re.opt  (re.union  (str.to_re "\x2b")  (str.to_re "\x5c\x2d")) ) (re.+ (re.range "0" "9") ))) )))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)