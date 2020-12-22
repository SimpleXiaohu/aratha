J$.iids = {"nBranches":4,"originalCodeFileName":"E:\\hudenghang\\aratha\\string_test\\replace.js","instrumentedCodeFileName":"E:\\hudenghang\\aratha\\string_test\\replace_jalangi_.js"};
jalangiLabel11:
    while (true) {
        try {
            J$.Se(209, 'E:\\hudenghang\\aratha\\string_test\\replace_jalangi_.js', 'E:\\hudenghang\\aratha\\string_test\\replace.js');
            function replace_test(a) {
                jalangiLabel10:
                    while (true) {
                        try {
                            J$.Fe(153, arguments.callee, this, arguments);
                            arguments = J$.N(161, 'arguments', arguments, 4);
                            a = J$.N(169, 'a', a, 4);
                            if (J$.X1(249, J$.C(16, J$.B(10, '===', J$.R(33, 'a', a, 0), J$.T(41, "bbb", 21, false), 0))))
                                J$.X1(73, J$.M(65, J$.R(49, 'console', console, 2), 'log', 0)(J$.T(57, 1, 22, false)));
                            else if (J$.X1(241, J$.C(8, J$.B(18, '===', J$.M(105, J$.R(81, 'a', a, 0), 'replace', 0)(J$.T(89, "a", 21, false), J$.T(97, "b", 21, false)), J$.T(113, "bbb", 21, false), 0))))
                                J$.X1(145, J$.M(137, J$.R(121, 'console', console, 2), 'log', 0)(J$.T(129, 2, 22, false)));
                        } catch (J$e) {
                            J$.Ex(257, J$e);
                        } finally {
                            if (J$.Fr(265))
                                continue jalangiLabel10;
                            else
                                return J$.Ra();
                        }
                    }
            }
            J$.N(217, 'a', a, 0);
            replace_test = J$.N(233, 'replace_test', J$.T(225, replace_test, 12, false, 153), 0);
            var a = J$.X1(25, J$.W(17, 'a', J$.M(9, J$, 'readString', 0)(), a, 3));
            J$.X1(201, J$.F(193, J$.R(177, 'replace_test', replace_test, 1), 0)(J$.R(185, 'a', a, 1)));
        } catch (J$e) {
            J$.Ex(273, J$e);
        } finally {
            if (J$.Sr(281)) {
                J$.L();
                continue jalangiLabel11;
            } else {
                J$.L();
                break jalangiLabel11;
            }
        }
    }
// JALANGI DO NOT INSTRUMENT
