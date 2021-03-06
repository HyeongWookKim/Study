/* ANOVA1.SAS : ONE-WAY LAYOUT */
OPTIONS PS=60;
DATA WEIGHT;
  INPUT DIET $  GAIN @@;
  DATALINES;
A 5.6  B 4.8  C 5.2
A 6.0  B 6.1  C 5.0
A 5.7  B 4.9  C 4.4
A 6.4  B 5.3  C 4.6
;
RUN;
PROC ANOVA;
  CLASS DIET;
  MODEL GAIN=DIET;
  MEANS DIET;
RUN;  QUIT;
