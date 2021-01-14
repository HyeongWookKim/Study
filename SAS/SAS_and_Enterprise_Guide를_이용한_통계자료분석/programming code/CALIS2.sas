/* CALIS2 구조모형과 측정모형이 있는 LISREL 모형 */
DATA A (TYPE=CORR);
    _TYPE_='CORR';
    INPUT _NAME_ $ Y1-Y6 X1-X3;
    DATALINES;
Y1   1.000       .       .       .       .       .       .       .       .
Y2   0.625   1.000       .       .       .       .       .       .       .
Y3   0.327   0.364   1.000       .       .       .       .       .       .
Y4   0.421   0.328   0.640   1.000       .       .       .       .       .
Y5   0.214   0.274   0.112   0.084   1.000       .       .       .       .
Y6   0.411   0.404   0.290   0.260   0.184   1.000       .       .       .
X1   0.324   0.405   0.305   0.279   0.049   0.222  1.000        .       .
X2   0.293   0.241   0.411   0.361   0.019   0.186   0.271   1.000       .
X3   0.299   0.286   0.519   0.501   0.078   0.336   0.230   0.295   1.000
;
PROC CALIS DATA=A CORR EDF=299 METHOD=ML ;
    LINEQS 
           Y1       =     F1             + EY1,
           Y2       = LY2 F1             + EY2,
           Y3       = LY3 F1             + EY3,
           Y4       =     F2             + EY4,
           Y5       = LY4 F2             + EY5,
           Y6       = LY5 F2             + EY6,
           X1       =     F3             + EX1,
           X2       = LX2 F3             + EX2,
           X3       = LX3 F3             + EX3,
           F1       = GAM1  F3           + D1,
           F2       = GAM2  F3 + BETA F1 + D2;
    STD
           EY1-EY6 = EEY1-EEY6,
           EX1-EX3 = EEX1-EEX3,
           D1-D2 = DD1-DD2,
           F3    = FF3;
    RUN;  QUIT;
