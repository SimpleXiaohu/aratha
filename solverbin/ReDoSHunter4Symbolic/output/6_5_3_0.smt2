(set-logic QF_S)
(declare-const x String)
(assert (str.in.re x (re.inter (re.+  (re.++ (re.+  (re.union (re.range "\u{30}" "\u{39}") (re.union  (str.to.re "\u{2d}") (re.union (re.range "\u{41}" "\u{5a}")  (str.to.re "\u{5f}")))) ) (re.opt  (str.to.re "\u{2f}") )) ) (re.+  (re.union (re.range "\u{30}" "\u{39}") (re.union  (str.to.re "\u{2d}") (re.union (re.range "\u{41}" "\u{5a}")  (str.to.re "\u{5f}")))) ) )))
(check-sat)
(get-model)