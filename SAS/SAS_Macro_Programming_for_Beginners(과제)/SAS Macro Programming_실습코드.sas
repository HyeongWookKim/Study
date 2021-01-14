/*예제로 배우는 SAS 데이터 분석 입문 연습문제2-4*/

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


/*예제로 배우는 SAS 데이터 분석 입문 연습문제2-9*/
OPTIONS VALIDVARNAME=ANY;
DATA AREA1;
INPUT 측정결과 @@;
DATALINES;
95 96 92 102 103 93 101 92 95 90
;
RUN;
DATA AREA2;
INPUT 측정결과 @@;
DATALINES;
184 202 215 204 195 201 169 182 192
;
RUN;
DATA AREA3;
INPUT 측정결과 @@;
DATALINES;
215 214 197 216 215 208 228 208 216 214 227
;
RUN;
DATA AREA4;
INPUT 측정결과 @@;
DATALINES;
155 142 146 149 146 152 159
;
RUN;

PROC MEANS DATA=AREA1;
VAR 측정결과;
RUN;


/*Q3*/

%MACRO Q3;
%DO I = 1 %TO 4;
PROC MEANS DATA=AREA&I;
VAR 측정결과;
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
/*=========================추가===========================*/
/*========================================================*/
/* 자동으로 생성된 매크로 변수 */
%put _automatic_;

/* 글로벌 심볼에 갖고 있는 값 */
%put &sysday;

/* 글로벌 심볼에 갖고 있지 않은 값이면 처리할 수 없음 */
%put &sysday1 ;

/* ' '안에 있는 매크로 변수는 참조 되지 않고 " " 안에 있어야 참조 가능 */
%put '오늘은 &sysday 입니다' ;
%put "오늘은 &sysday 입니다" ;



options symbolgen;
%let m_gender = 여;
%let m_age = 13;
proc print data = sashelp.class;
 where sex = "&m_gender" /*문자상수처럼 활용*/ and age > &m_age; /*숫자처럼 활용*/
run;


%let year = %substr(&sysdate9, 6,4);
%let year_6 = %eval(&year.-6);
%put &year_6;


%let m_title1 = title "작성자 ; 홍길동";;
%put &m_title1;

%let m_title2 = %str(title "작성자 ; 홍길동";);
%put &m_title2;
proc print data = sashelp.class;
 &m_title2;
run;
