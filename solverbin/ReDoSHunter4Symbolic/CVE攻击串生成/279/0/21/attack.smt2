(set-logic QF_SLIA)
(declare-const result String)
(declare-const attack String)
(declare-const prefix RegLan)
(declare-const infix RegLan)
(declare-const postfix RegLan)
(declare-const postfixs String)

(assert (str.in_re attack (re.++ prefix ((_ re.loop 5000 5000) infix) postfix)))
(assert (= prefix 
    (re.+  (re.union  (str.to_re "\x5c\x2f") (re.range "\x600" "\x6ff")) )
))
(assert (= infix 
        (re.inter (re.+  (re.union  (str.to_re "\x5c\x2f") (re.range "\x600" "\x6ff")) )  (re.++ (re.+  (re.union  (str.to_re "\x5c\x2f") (re.range "\x600" "\x6ff")) )  (re.union   (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ (re.range "\x600" "\x6ff") ))  (re.++  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ (re.range "\x600" "\x6ff") ))    (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ (re.range "\x600" "\x6ff") )))))  (re.union   (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ (re.range "\x600" "\x6ff") ))  (re.++  (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ (re.range "\x600" "\x6ff") ))    (re.++ (re.* (re.union (re.range "\t" "\t") (re.range "\n" "\n") (re.range "\r" "\r") (str.to_re " ")) ) (re.+ (re.range "\x600" "\x6ff") )))) )
))
(assert (= postfix 
         (str.to_re "\x41")
))
(assert (str.in_re postfixs postfix))
(assert (>= (str.len postfixs) 1))
(assert (= result (str.++ attack postfixs)))
(check-sat)
(get-model)