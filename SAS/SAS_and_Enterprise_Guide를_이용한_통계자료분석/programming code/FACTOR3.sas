/* FACTOR3.SAS : 임산부용 브래지어의 불만조사 */
DATA BRA;
  INFILE 'C:\Users\Admin\Desktop\공개강좌_14\dataset\Qustnair.DAT';
  INPUT (Q1-Q9) (1.) +1 (Q10-Q18) (1.);
RUN;
PROC FACTOR DATA=BRA ROTATE=VARIMAX REORDER N=5;
RUN; QUIT;
