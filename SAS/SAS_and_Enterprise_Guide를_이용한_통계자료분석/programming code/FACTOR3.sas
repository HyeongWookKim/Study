/* FACTOR3.SAS : �ӻ�ο� �귡������ �Ҹ����� */
DATA BRA;
  INFILE 'C:\Users\Admin\Desktop\��������_14\dataset\Qustnair.DAT';
  INPUT (Q1-Q9) (1.) +1 (Q10-Q18) (1.);
RUN;
PROC FACTOR DATA=BRA ROTATE=VARIMAX REORDER N=5;
RUN; QUIT;
