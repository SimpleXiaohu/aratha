J$.iids = {"nBranches":2,"originalCodeFileName":"E:\\hudenghang\\aratha\\string_test\\match.js","instrumentedCodeFileName":"E:\\hudenghang\\aratha\\string_test\\match_jalangi_.js"};
jalangiLabel7:
    while (true) {
        try {
            J$.Se(225, 'E:\\hudenghang\\aratha\\string_test\\match_jalangi_.js', 'E:\\hudenghang\\aratha\\string_test\\match.js');
            function test_match(a) {
                jalangiLabel6:
                    while (true) {
                        try {
                            J$.Fe(169, arguments.callee, this, arguments);
                            arguments = J$.N(177, 'arguments', arguments, 4);
                            a = J$.N(185, 'a', a, 4);
                            J$.X1(65, b = J$.W(57, 'b', J$.M(49, J$.R(33, 'a', a, 0), 'match', 0)(J$.T(41, /foo*/, 14, false)), J$.I(typeof b === 'undefined' ? undefined : b), 4));
                            if (J$.X1(249, J$.C(8, J$.B(10, '!==', J$.R(73, 'b', b, 2), J$.T(81, null, 25, false), 0))))
                                J$.X1(129, J$.M(121, J$.R(89, 'console', console, 2), 'log', 0)(J$.G(113, J$.R(97, 'b', b, 2), J$.T(105, 0, 22, false), 4)));
                            else
                                J$.X1(161, J$.M(153, J$.R(137, 'console', console, 2), 'log', 0)(J$.T(145, 1, 22, false)));
                        } catch (J$e) {
                            J$.Ex(257, J$e);
                        } finally {
                            if (J$.Fr(265))
                                continue jalangiLabel6;
                            else
                                return J$.Ra();
                        }
                    }
            }
            test_match = J$.N(241, 'test_match', J$.T(233, test_match, 12, false, 169), 0);
            J$.X1(25, a = J$.W(17, 'a', J$.M(9, J$, 'readString', 0)(), J$.I(typeof a === 'undefined' ? undefined : a), 4));
            J$.X1(217, J$.F(209, J$.R(193, 'test_match', test_match, 1), 0)(J$.R(201, 'a', a, 2)));
        } catch (J$e) {
            J$.Ex(273, J$e);
        } finally {
            if (J$.Sr(281)) {
                J$.L();
                continue jalangiLabel7;
            } else {
                J$.L();
                break jalangiLabel7;
            }
        }
    }
// JALANGI DO NOT INSTRUMENT
