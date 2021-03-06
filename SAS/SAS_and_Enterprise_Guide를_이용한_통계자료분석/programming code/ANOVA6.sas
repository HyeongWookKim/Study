/* ANOVA6.SAS : THREE-WAY FACTORIAL DESIGN */
OPTIONS PS=55 NODATE;
TITLE1 'ANOVA : THREE-WAY FACTORIAL DESIGN';
DATA ;
  INPUT GROUP $ DRUG $ SEX $ SCORE @@;
  DATALINES;
N P M 50 N R M 67
N P F 45 N R F 60
N P M 55 N R M 58
N P F 52 N R F 65
H P M 70 H R M 51
H P F 72 H R F 57
H P M 68 H R M 48
H P F 75 H R F 55
;
RUN;
PROC ANOVA;
  CLASS SEX GROUP DRUG;
  MODEL SCORE=GROUP DRUG SEX SEX*GROUP SEX*DRUG GROUP*DRUG;
  MEANS GROUP DRUG SEX SEX*GROUP SEX*DRUG GROUP*DRUG;
RUN; QUIT;
