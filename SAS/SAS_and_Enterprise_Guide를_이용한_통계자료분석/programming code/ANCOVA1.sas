/* ANCOVA1.SAS : ANALYSIS OF COVARIANCE */
DATA DRUGTEST;
  INPUT DRUG $ X Y @@;
  DATALINES;
  A 11   6  D   6  0  F 16  13
  A  8   0  D   6  2  F 13  10
  A  5   2  D   7  3  F 11  18
  A 14   8  D   8  1  F  9   5
  A 19  11  D  18 18  F 21  23
  A  6   4  D   8  4  F 16  12
  A 10  13  D  19 14  F 12   5
  A  6   1  D   8  9  F 12  16
  A 11   8  D   5  1  F  7   1
  A  3   0  D  15  9  F 12  20
;
RUN;
PROC GLM;
  CLASS DRUG;
  MODEL Y=X DRUG / SOLUTION;
  LSMEANS DRUG / PDIFF;
RUN;
QUIT;
