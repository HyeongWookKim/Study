/* FACTOR2.SAS : FACTOR ANALYSIS FOR 10 PHYSICAL VARIABLES */
DATA PHYSICAL;
  INFILE 'C:\Users\Admin\Desktop\��������_14\dataset\Physical.DAT'
              FIRSTOBS=2 MISSOVER;
  INPUT ID V1-V10;
  LABEL V1='����' V2='�ѱ���' V3='�����' V4='ȭ��' V5='�Ҹű���'
        V6='��������' V7='�����յ�' V8='�����ѷ�' V9='�㸮�ѷ�'
        V10='�����̵ѷ�';
RUN;
PROC FACTOR DATA=PHYSICAL SCREE PREPLOT
            ROTATE=VARIMAX REORDER PLOT;
  VAR V1-V10;
RUN;
QUIT;
