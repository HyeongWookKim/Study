/* POTTERY.SAS  고고학 자료 분석 */
DATA POTTERY;
    INPUT SITE $ A  B  C  D;
    DATALINES;
P0  30  10  10  39
P1  53   4  16   2
P2  73   1  41   1
P3  20   6   1   4
P4  46  36  37  13
P5  45   6  59  10
P6  16  28 169   5
;
PROC CORRESP DATA=POTTERY OUTC=RESULT PROFILE=BOTH SHORT; 
    VAR A  B  C  D;
    ID SITE;
RUN;
PROC PLOT DATA=RESULT;
    PLOT DIM2*DIM1='*' $ SITE
         /VPOS=20 HPOS=60 VAXIS=-2 TO 2 VREF=0 HREF=0;
RUN;   QUIT;
