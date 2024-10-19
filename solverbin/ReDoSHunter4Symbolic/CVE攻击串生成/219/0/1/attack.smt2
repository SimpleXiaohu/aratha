(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 10000 10000) infix) postfix)))
(assert (= prefix 
     (re.++  (re.++  (re.union  (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x43") (re.++  (str.to_re "\x61")  (str.to_re "\x62")))) (re.union  (re.++  (str.to_re "\x4c") (re.++  (str.to_re "\x75") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x70")  (str.to_re "\x65"))))))))) (re.union  (re.++  (str.to_re "\x4f") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72")  (str.to_re "\x61"))))) (re.union  (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x69")  (str.to_re "\x64"))))))) (re.union  (re.++  (str.to_re "\x4a") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x6e")  (str.to_re "\x65"))))))) (re.union  (re.++  (str.to_re "\x50") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x6c") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x69")  (str.to_re "\x73"))))))) (re.union  (re.++  (str.to_re "\x4d") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x73") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x66") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x6b") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x44") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x69") (re.++  (str.to_re "\x76") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x53") (re.++  (str.to_re "\x79") (re.++  (str.to_re "\x6e")  (str.to_re "\x63"))))))))))))))))))))))  (re.++  (str.to_re "\x54") (re.++  (str.to_re "\x68") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x20") (re.++  (str.to_re "\x42") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x74")  (str.to_re "\x21"))))))))))))))) (re.++  (str.to_re "\x20") (re.++ (re.+ (re.range "0" "9") )  (str.to_re "\x5c\x2e")))) (re.+ (re.range "0" "9") ))
))
(assert (= infix 
        (re.inter (re.+ (re.range "0" "9") )  (re.++ (re.+ (re.range "0" "9") ) (re.++ (re.opt  (str.to_re "\x5c\x2e") ) (re.+ (re.range "0" "9") ))) (re.+ (re.range "0" "9") ) )
))
(assert (= postfix 
         (str.to_re "\x21")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)