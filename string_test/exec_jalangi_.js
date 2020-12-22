J$.iids = {"nBranches":2,"originalCodeFileName":"E:\\hudenghang\\aratha\\string_test\\exec.js","instrumentedCodeFileName":"E:\\hudenghang\\aratha\\string_test\\exec_jalangi_.js"};
jalangiLabel7:
    while (true) {
        try {
            J$.Se(209, 'E:\\hudenghang\\aratha\\string_test\\exec_jalangi_.js', 'E:\\hudenghang\\aratha\\string_test\\exec.js');
            function test_exec(a) {
                jalangiLabel6:
                    while (true) {
                        try {
                            J$.Fe(153, arguments.callee, this, arguments);
                            arguments = J$.N(161, 'arguments', arguments, 4);
                            a = J$.N(169, 'a', a, 4);
                            J$.X1(65, b = J$.W(57, 'b', J$.M(49, J$.T(33, /foo*/, 14, false), 'exec', 0)(J$.R(41, 'a', a, 0)), J$.I(typeof b === 'undefined' ? undefined : b), 4));
                            if (J$.X1(233, J$.C(8, J$.B(10, '!==', J$.R(73, 'b', b, 2), J$.T(81, null, 25, false), 0))))
                                J$.X1(113, J$.M(105, J$.R(89, 'console', console, 2), 'log', 0)(J$.T(97, 1, 22, false)));
                            else
                                J$.X1(145, J$.M(137, J$.R(121, 'console', console, 2), 'log', 0)(J$.T(129, 2, 22, false)));
                        } catch (J$e) {
                            J$.Ex(241, J$e);
                        } finally {
                            if (J$.Fr(249))
                                continue jalangiLabel6;
                            else
                                return J$.Ra();
                        }
                    }
            }
            test_exec = J$.N(225, 'test_exec', J$.T(217, test_exec, 12, false, 153), 0);
            J$.X1(25, a = J$.W(17, 'a', J$.M(9, J$, 'readString', 0)(), J$.I(typeof a === 'undefined' ? undefined : a), 4));
            J$.X1(201, J$.F(193, J$.R(177, 'test_exec', test_exec, 1), 0)(J$.R(185, 'a', a, 2)));
        } catch (J$e) {
            J$.Ex(257, J$e);
        } finally {
            if (J$.Sr(265)) {
                J$.L();
                continue jalangiLabel7;
            } else {
                J$.L();
                break jalangiLabel7;
            }
        }
    }
// JALANGI DO NOT INSTRUMENT
