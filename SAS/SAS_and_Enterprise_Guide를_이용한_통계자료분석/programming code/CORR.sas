/* CORR.SAS */
DATA AVERAGE;
  SET SURVEY;
  AVGA1=MEAN(OF A1-A4);
  AVGA2=MEAN(OF A6-A9 A11);
  AVGA3=MEAN(OF A12-A17);
  AVGB1=MEAN(OF B1-B4 B6 B7 B9);
  AVGB2=MEAN(OF B11-B14 B17-B18);
  AVGB3=MEAN(OF B19-B22 B24);
RUN;
PROC CORR NOSIMPLE; VAR AVGA1-AVGA3;  WITH AVGB1-AVGB3;
RUN;
