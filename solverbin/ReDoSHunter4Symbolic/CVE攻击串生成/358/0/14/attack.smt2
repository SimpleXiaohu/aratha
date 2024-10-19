(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.union  (re.++  (str.to_re "\x78") (re.++  (str.to_re "\x38") (re.++  (str.to_re "\x36") (re.++  (str.to_re "\x5f") (re.++  (str.to_re "\x36")  (str.to_re "\x34"))))))  (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x36")  (str.to_re "\x34")))))))) (re.++  (str.to_re "\x5c\x20") (re.++ (re.+ (re.range "0" "9") ) (re.++  (str.to_re "\x5c\x2e") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e")))))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
         (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) )) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+ (re.range "0" "9") ) (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6d")  (str.to_re "\x65"))))))) (re.*  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ))) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))
))
(assert (= postfix 
        (str.to_re "")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)