(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 512 512) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x7b") (re.++  (str.to_re "\x67") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x6e") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x72") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x74") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x5f") (re.++  (str.to_re "\x63") (re.++  (str.to_re "\x6f") (re.++  (str.to_re "\x64") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x5f") (re.++  (str.to_re "\x65") (re.++  (str.to_re "\x78") (re.++  (str.to_re "\x61") (re.++  (str.to_re "\x6d") (re.++  (str.to_re "\x70") (re.++  (str.to_re "\x6c")  (str.to_re "\x65"))))))))))))))))))))))
))
(assert (= infix 
         (re.++  (str.to_re "\x5c\x28") (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))  (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26")  (re.++  (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar re.allchar))))) (re.*  (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar re.allchar))))) ))))))  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))  (re.++  (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) )  (str.to_re "\x5c\x29")) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))
))
(assert (= postfix 
         (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a") (re.++  (str.to_re "\x21") (re.++  (str.to_re "\x0a")  (str.to_re "\x21")))))))))))))))))))))
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)