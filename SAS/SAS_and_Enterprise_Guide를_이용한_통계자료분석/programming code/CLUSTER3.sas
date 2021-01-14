/* CLUSTER3.SAS : ANALYSIS OF BODY SIZE DATA */
OPTIONS PS=40;
DATA PHYSICAL;
  INFILE 'C:\Users\Admin\Desktop\��������_14\dataset\Physical.DAT'
              FIRSTOBS=2 MISSOVER;
  INPUT ID V1-V10;
  LABEL V1='����' V2='�ѱ���' V3='�����' V4='ȭ��' V5='�Ҹű���'
        V6='��������' V7='�����յ�' V8='�����ѷ�' V9='�㸮�ѷ�'
        V10='�����̵ѷ�';
RUN;
PROC CLUSTER DATA=PHYSICAL METHOD=WARD PRINT=0 CCC;
  VAR V1 V2 V5 V6 V8 V9 V10;
RUN;
PROC PLOT;
  PLOT _CCC_*_NCL_/VPOS=25  HAXIS=1 TO 20 BY 1 ;
RUN; QUIT;
