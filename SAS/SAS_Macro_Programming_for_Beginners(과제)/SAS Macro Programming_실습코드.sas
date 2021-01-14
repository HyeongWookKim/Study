/*������ ���� SAS ������ �м� �Թ� ��������2-4*/

DATA EX2_4;
LENGTH MANUFACT  MODEL $10.;
INPUT SIZE$ MANUFACT$ MODEL&$ MILEAGE RELIABLE INDEX;
DATALINES;
Small        Chevrolet    Geo Prizm       33          5         4
Small        Honda        Civic           29          5         4
Small        Toyota       Corolla         30          5         4
Small        Ford         Escort          27          3         3
Small        Dodge        Colt            34          .         .
Compact      Ford         Tempo           24          1         3
Compact      Chrysler     Le Baron        23          3         3
Compact      Buick        Skylark         21          3         3
Compact      Plymouth     Acclaim         24          3         3
Compact      Chevrolet    Corsica         25          2         3
Compact      Pontiac      Sunbird         24          1         3
Mid-Sized    Toyota       Camry           24          5         4
Mid-Sized    Honda        Accord          26          5         4
Mid-Sized    Ford         Taurus          20          3         3
;
RUN;

/*Q1*/
%LET PAR1 = MILEAGE; 
%LET PAR2 = RELIABLE; 

%PUT &PAR1;
%PUT &PAR2;

PROC SORT DATA=EX2_4; BY SIZE; RUN;
PROC MEANS DATA=EX2_4 MEAN STD MAXDEC=3;
VAR MILEAGE;
BY SIZE; OUTPUT OUT=MILEAGE;
RUN;
PROC MEANS DATA=EX2_4 MEAN STD MAXDEC=3;
VAR RELIABLE;
BY SIZE; OUTPUT OUT=RELIABLE;
RUN;


/*Q2*/
%MACRO Q2(VAR);
PROC SORT DATA=EX2_4; BY SIZE; RUN;
PROC MEANS DATA=EX2_4 MEAN STD MAXDEC=3;
VAR &VAR;
BY SIZE; OUTPUT OUT=&VAR;
RUN;
%MEND;

%Q2(MILEAGE);
%Q2(RELIABLE);


/*������ ���� SAS ������ �м� �Թ� ��������2-9*/
OPTIONS VALIDVARNAME=ANY;
DATA AREA1;
INPUT ������� @@;
DATALINES;
95 96 92 102 103 93 101 92 95 90
;
RUN;
DATA AREA2;
INPUT ������� @@;
DATALINES;
184 202 215 204 195 201 169 182 192
;
RUN;
DATA AREA3;
INPUT ������� @@;
DATALINES;
215 214 197 216 215 208 228 208 216 214 227
;
RUN;
DATA AREA4;
INPUT ������� @@;
DATALINES;
155 142 146 149 146 152 159
;
RUN;

PROC MEANS DATA=AREA1;
VAR �������;
RUN;


/*Q3*/

%MACRO Q3;
%DO I = 1 %TO 4;
PROC MEANS DATA=AREA&I;
VAR �������;
RUN;
%END;
%MEND;

/*Debugging*/
*1. options mprint;
OPTIONS MPRINT;
%Q3;

*2. options minoperator mlogic;
options minoperator mlogic;
%macro test(value) / mindelimiter=',';

   %if &value in 1,2,3,4,5,6 %then 
       %put Value found within list.;
   %else %put Value not in list.;

%mend;
%test(3);
options minoperator mlogic=off;
%test(3);

/*Macro function*/
*1. %eval or %sysevalf;
%LET A=2; %LET B=3;
%LET C=&A+&B; %PUT &C; 
%LET D=%EVAL(&A+&B);%PUT &D;

%LET E=%EVAL(&A+0.1);%PUT &E;
%LET E_AD=%SYSEVALF(&A+0.1);%PUT &E_AD;


%let a=1+2;  %let b=10*3;  %let c=5/3; 
%let eval_a=%eval(&a); %let eval_b=%eval(&b); %let eval_c=%eval(&c); 
%put &a is &eval_a; %put &b is &eval_b; %put &c is &eval_c;


/*========================================================*/
/*=========================�߰�===========================*/
/*========================================================*/
/* �ڵ����� ������ ��ũ�� ���� */
%put _automatic_;

/* �۷ι� �ɺ��� ���� �ִ� �� */
%put &sysday;

/* �۷ι� �ɺ��� ���� ���� ���� ���̸� ó���� �� ���� */
%put &sysday1 ;

/* ' '�ȿ� �ִ� ��ũ�� ������ ���� ���� �ʰ� " " �ȿ� �־�� ���� ���� */
%put '������ &sysday �Դϴ�' ;
%put "������ &sysday �Դϴ�" ;



options symbolgen;
%let m_gender = ��;
%let m_age = 13;
proc print data = sashelp.class;
 where sex = "&m_gender" /*���ڻ��ó�� Ȱ��*/ and age > &m_age; /*����ó�� Ȱ��*/
run;


%let year = %substr(&sysdate9, 6,4);
%let year_6 = %eval(&year.-6);
%put &year_6;


%let m_title1 = title "�ۼ��� ; ȫ�浿";;
%put &m_title1;

%let m_title2 = %str(title "�ۼ��� ; ȫ�浿";);
%put &m_title2;
proc print data = sashelp.class;
 &m_title2;
run;
