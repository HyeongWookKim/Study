/* CALIS1.SAS  수리능력과 언어능력의 연관성 분석 */
data A (TYPE=COV);
    _TYPE_='COV';
    INPUT _NAME_ $ X1-X6;
    DATALINES;
X1    5.000   .      .      .      .      .
X2    3.439  5.000   .      .      .      .
X3    3.410  3.351  5.000   .      .      .
X4    1.288  1.354  1.164  5.000   .      .
X5    1.329  1.320  1.190  3.595  5.000   .
X6    1.248  1.329  1.181  3.470  3.464  5.000
;
PROC CALIS DATA=A COV EDF=199;
    LINEQS
           X1 =     F1 + E1,
           X2 = LX2 F1 + E2,
           X3 = LX3 F1 + E3,
           X4 =     F2 + E4,
           X5 = LX5 F2 + E5,
           X6 = LX6 F2 + E6;
    STD
           E1-E6 = EE1-EE6,
           F1    = FF1,
           F2    = FF2;
    COV
           F1 F2 = FF12;
    RUN;  QUIT;

