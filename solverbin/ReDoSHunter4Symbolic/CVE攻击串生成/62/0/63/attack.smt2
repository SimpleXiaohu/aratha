(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 1024 1024) infix) postfix)))
(assert (= prefix 
     (re.++  (str.to_re "\x3d") (re.++  (str.to_re "\x20")  (str.to_re "\x3d")))
))
(assert (= infix 
         (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x0d") )  (str.to_re "\x0a"))  (str.to_re "\x0d")) (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))  (re.++ (re.*  (re.union  (str.to_re "\x0c") (re.union  (str.to_re "\x20") (re.union  (str.to_re "\x0a") (re.union  (str.to_re "\x0d") (re.union  (str.to_re "\x09")  (str.to_re "\x0b")))))) ) (re.++  (str.to_re "\x26") (re.++ (re.+  (re.union  (str.to_re "\x0a")  (str.to_re "\x0d")) ) (re.++  (str.to_re "\x26")  (re.++  (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar re.allchar))))) (re.*  (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar (re.++ re.allchar re.allchar))))) ))))))  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))  (re.++  (re.++  (str.to_re "\x26")  (re.++ "" (re.* "" ))))
))
(assert (= postfix 
        (re.inter  (re.inter  (re.++  (str.to_re "\x0d") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))))) (re.comp  (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")) (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ re.allchar )))))  (re.inter  (re.++  (str.to_re "\x0d") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x09") (re.++  (str.to_re "\x20") (re.*  (re.union (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " ")) (re.inter re.allchar (re.comp (re.union (str.to_re "\t") (str.to_re "\n") (str.to_re "\r") (str.to_re " "))))) )))))))) (re.comp  (re.++  (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")) (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ re.allchar ))) (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72")) (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.++ (re.+  (re.++ (re.+  (str.to_re "\x3d") ) (re.+  (str.to_re "\x20") )) ) (re.++ (re.+  (str.to_re "\x3d") )  (re.union  (re.++  (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))) (re.*  (re.++  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))  (re.union  (re.++ (re.opt  (str.to_re "\x5c\x72") )  (str.to_re "\x5c\x6e"))  (str.to_re "\x5c\x72"))) ))  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.* (re.range "\x00" "\xffff") )))))))))) )
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)