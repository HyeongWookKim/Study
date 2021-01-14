/*    HTWT1.SAS : HEIGHT-WEIGHT DATA FILE    */
OPTIONS PS=35 LS=100 NODATE;
DATA HTWT;
  INPUT  ID $   NAME $   SEX $   AGE   HEIGHT   WEIGHT;
  DATALINES;
  1 ALFRED    M 14 59.0 112.5
  2 ALICE     F 13 56.5  84.0
  3 BARBARA   F 13 65.3  98.0
  4 CAROL     F 14 62.8 102.5
  5 HENRY     M 14 63.5 102.5
  6 JAMES     M 12 57.3  83.0
  7 JANE      F 12 59.3  84.5
  8 JANET     F 15 62.5 112.5
  9 JEFFERY   M 13 62.5  84.0
 10 JOHN      M 12 59.0  99.5
 11 JOYCE     F 11 51.3  50.5
 12 JUDY      F 14 64.3  90.0
 13 LOUISE    F 12 56.3  77.0
 14 MARY      F 15 66.5 112.0
 15 PHILIP    M 16 72.0 150.0
 16 ROBERT    M 12 64.3 123.0
 17 RONALD    M 15 67.0 133.0
 18 THOMAS    M 11 57.5  85.0
 19 WILLIAM   M 15 66.5 112.0
;
PROC PRINT;
PROC MEANS;
  VAR HEIGHT WEIGHT;
PROC PLOT;
  PLOT WEIGHT*HEIGHT;
PROC REG;
  MODEL WEIGHT=HEIGHT;
  OUTPUT OUT=NEW P=PREDICT R=RESID;
PROC PRINT DATA=NEW;
RUN;
PROC PLOT;
  PLOT WEIGHT*HEIGHT PREDICT*HEIGHT='P'/OVERLAY;
  PLOT RESID*HEIGHT / VREF=0;
RUN;
PROC SORT;
  BY SEX;
PROC MEANS MAXDEC=3;
  BY SEX;
  VAR HEIGHT WEIGHT;
RUN;
PROC CHART;
  VBAR AGE / SUBGROUP=SEX DISCRETE;
  VBAR AGE / GROUP=SEX DISCRETE; 
RUN;
QUIT;


