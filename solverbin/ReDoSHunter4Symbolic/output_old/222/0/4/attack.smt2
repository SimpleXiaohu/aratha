(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 1024 1024) infix) postfix)))
(assert (= prefix 
     (str.to_re "\x22")
))
(assert (= infix 
         (re.inter (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) )  (re.union  (re.union  (re.union  (str.to_re "\x7f") (re.union (re.range "\x0e" "\x1f") (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x0b") (re.range "\x01" "\x08"))))) (re.union  (str.to_re "\x21") (re.union (re.range "\x23" "\x5c\x5b") (re.range "\x5c\x5d" "\x7e"))))  (re.++  (str.to_re "\x5c\x5c")  (re.union (re.range "\x0d" "\x7f") (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x0b") (re.range "\x01" "\x09")))))) )  
))
(assert (= postfix 
         (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x00") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x41") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a")  (str.to_re "\x21"))))))))))))))))))))))))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)