J$.iids = {"nBranches":2,"originalCodeFileName":"E:\\hudenghang\\aratha\\string_test\\search.js","instrumentedCodeFileName":"E:\\hudenghang\\aratha\\string_test\\search_jalangi_.js"};
jalangiLabel9:
    while (true) {
        try {
            J$.Se(185, 'E:\\hudenghang\\aratha\\string_test\\search_jalangi_.js', 'E:\\hudenghang\\aratha\\string_test\\search.js');
            function test_search(a) {
                jalangiLabel8:
                    while (true) {
                        try {
                            J$.Fe(129, arguments.callee, this, arguments);
                            arguments = J$.N(137, 'arguments', arguments, 4);
                            a = J$.N(145, 'a', a, 4);
                            if (J$.X1(209, J$.C(8, J$.B(10, '>=', J$.M(49, J$.R(33, 'a', a, 0), 'search', 0)(J$.T(41, "foo", 21, false)), J$.T(57, 0, 22, false), 0))))
                                J$.X1(89, J$.M(81, J$.R(65, 'console', console, 2), 'log', 0)(J$.T(73, 1, 22, false)));
                            else
                                J$.X1(121, J$.M(113, J$.R(97, 'console', console, 2), 'log', 0)(J$.T(105, 2, 22, false)));
                        } catch (J$e) {
                            J$.Ex(217, J$e);
                        } finally {
                            if (J$.Fr(225))
                                continue jalangiLabel8;
                            else
                                return J$.Ra();
                        }
                    }
            }
            test_search = J$.N(201, 'test_search', J$.T(193, test_search, 12, false, 129), 0);
            J$.X1(25, a = J$.W(17, 'a', J$.M(9, J$, 'readString', 0)(), J$.I(typeof a === 'undefined' ? undefined : a), 4));
            J$.X1(177, J$.F(169, J$.R(153, 'test_search', test_search, 1), 0)(J$.R(161, 'a', a, 2)));
        } catch (J$e) {
            J$.Ex(233, J$e);
        } finally {
            if (J$.Sr(241)) {
                J$.L();
                continue jalangiLabel9;
            } else {
                J$.L();
                break jalangiLabel9;
            }
        }
    }
// JALANGI DO NOT INSTRUMENT
