J$.iids = {"nBranches":4,"originalCodeFileName":"E:\\hudenghang\\aratha\\string_test\\test.js","instrumentedCodeFileName":"E:\\hudenghang\\aratha\\string_test\\test_jalangi_.js"};
jalangiLabel11:
    while (true) {
        try {
            J$.Se(233, 'E:\\hudenghang\\aratha\\string_test\\test_jalangi_.js', 'E:\\hudenghang\\aratha\\string_test\\test.js');
            function escapeAttribute(value1, value2) {
                jalangiLabel10:
                    while (true) {
                        try {
                            J$.Fe(161, arguments.callee, this, arguments);
                            arguments = J$.N(169, 'arguments', arguments, 4);
                            value1 = J$.N(177, 'value1', value1, 4);
                            value2 = J$.N(185, 'value2', value2, 4);
                            if (J$.X1(281, J$.C(16, J$.M(73, J$.T(57, /foo*/, 14, false), 'test', 0)(J$.R(65, 'value1', value1, 0))))) {
                                J$.X1(105, J$.M(97, J$.R(81, 'console', console, 2), 'log', 0)(J$.T(89, 0, 22, false)));
                            } else if (J$.X1(273, J$.C(8, J$.B(10, '===', J$.R(113, 'value1', value1, 0), J$.R(121, 'value2', value2, 0), 0))))
                                J$.X1(153, J$.M(145, J$.R(129, 'console', console, 2), 'log', 0)(J$.T(137, 1, 22, false)));
                        } catch (J$e) {
                            J$.Ex(289, J$e);
                        } finally {
                            if (J$.Fr(297))
                                continue jalangiLabel10;
                            else
                                return J$.Ra();
                        }
                    }
            }
            J$.N(241, 'value1', value1, 0);
            J$.N(249, 'value2', value2, 0);
            escapeAttribute = J$.N(265, 'escapeAttribute', J$.T(257, escapeAttribute, 12, false, 161), 0);
            var value1 = J$.X1(25, J$.W(17, 'value1', J$.M(9, J$, 'readString', 0)(), value1, 3));
            var value2 = J$.X1(49, J$.W(41, 'value2', J$.M(33, J$, 'readString', 0)(), value2, 3));
            J$.X1(225, J$.F(217, J$.R(193, 'escapeAttribute', escapeAttribute, 1), 0)(J$.R(201, 'value1', value1, 1), J$.R(209, 'value2', value2, 1)));
        } catch (J$e) {
            J$.Ex(305, J$e);
        } finally {
            if (J$.Sr(313)) {
                J$.L();
                continue jalangiLabel11;
            } else {
                J$.L();
                break jalangiLabel11;
            }
        }
    }
// JALANGI DO NOT INSTRUMENT
