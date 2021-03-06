/* CATMOD1.SAS : ANALYSIS OF SURVIVAL RATE FREQUENCY TABLE */
DATA SURVIVAL;
  INPUT HOSP $ SURV $ COUNT @@;
  DATALINES;
A DEAD 63 A ALIVE 2037 B DEAD 16 B ALIVE 784
;
RUN;
PROC CATMOD;
  WEIGHT COUNT;
  MODEL HOSP*SURV=_RESPONSE_ / ML NOGLS PRED=FREQ;
  LOGLIN HOSP|SURV;
RUN;
  LOGLIN HOSP SURV;
RUN;
QUIT;
