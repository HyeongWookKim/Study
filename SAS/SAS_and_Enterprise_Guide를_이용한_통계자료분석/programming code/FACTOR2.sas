/* FACTOR2.SAS : FACTOR ANALYSIS FOR 10 PHYSICAL VARIABLES */
DATA PHYSICAL;
  INFILE 'C:\Users\Admin\Desktop\공개강좌_14\dataset\Physical.DAT'
              FIRSTOBS=2 MISSOVER;
  INPUT ID V1-V10;
  LABEL V1='신장' V2='총길이' V3='등길이' V4='화장' V5='소매길이'
        V6='바지길이' V7='밑위앞뒤' V8='가슴둘레' V9='허리둘레'
        V10='엉덩이둘레';
RUN;
PROC FACTOR DATA=PHYSICAL SCREE PREPLOT
            ROTATE=VARIMAX REORDER PLOT;
  VAR V1-V10;
RUN;
QUIT;
