(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
    (str.to_re "")
))
(assert (= infix 
         (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f") (re.range "\x600" "\x6ff")) ) (re.++  (str.to_re "\x26") (re.++  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f") (re.range "\x600" "\x6ff")) ) (re.++   (re.++   (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.+ (re.range "\x600" "\x6ff") )) (re.*   (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.+ (re.range "\x600" "\x6ff") )) )))) (re.++  (str.to_re "\x26") (re.++  (re.++   (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.+ (re.range "\x600" "\x6ff") )) (re.*   (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.+ (re.range "\x600" "\x6ff") )) )) (re.++  (str.to_re "\x26") (re.+ re.allchar )))))))
))
(assert (= postfix 
         (str.to_re "\x41")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)