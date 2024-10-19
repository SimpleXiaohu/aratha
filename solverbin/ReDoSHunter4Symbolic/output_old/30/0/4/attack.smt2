(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.++  (str.to_re "\x48") (re.++  (str.to_re "\x54")  (str.to_re "\x43"))) (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x20") (re.++ (re.+ (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")))) ) (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x20") (re.++ (re.+ (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")))) ) (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x20") (re.++ (re.+ (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")))) ) (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x5c\x2f") (re.++  (str.to_re "\x20") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e"))))))))))))))))))))))))))))))))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter  (re.++ (re.+ (re.range "0" "9") ) (re.+ (re.range "0" "9") ))  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.+ (re.range "0" "9") ))) )
))
(assert (= postfix 
         (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x20")  (str.to_re "\x21"))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)