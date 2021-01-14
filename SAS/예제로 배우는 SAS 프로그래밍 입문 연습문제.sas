libname sasbase "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\SAS_Data";

/********** 2장 연습문제 **********/

/* ex2_6 */
data ex2_6;
infile "F:\SAS 독학\ex2_6.txt";
input obs 1-2 city $ 3-12 name $ 13-18 age $ 19-20;
run;

/* ex2_8 */
proc import dbms=excel
					datafile="F:\SAS 독학\ex2_8.xlsx"
					out=out2_8
					replace;
		range="Sheet1$";
run;


/********** 3장 연습문제 **********/

/* ex3_2 */

/* (1) */
proc means data=sasbase.car maxdec=3 
mean std sum;
var mileage reliable;
run;
/* (2) */
proc means data=sasbase.car maxdec=3 
mean std sum;
var mileage reliable;
output out=out3_2 
mean(mileage reliable)=mean_a mean_b std(mileage reliable)=std_a std_b sum(mileage reliable)=sum_a sum_b;
run;
/* (3) */
proc means data=sasbase.car maxdec=3 
n nmiss min max range mean std cv;
/* nmiss는 결측값의 수를 출력 */
class manufact;
var mileage reliable;
run;

/* ex3_3 */

/* (1) */
proc univariate data=sasbase.car;
var mileage reliable;
run;
/* (2) */
proc univariate data=sasbase.car ;
var mileage reliable;
histogram mileage reliable;
probplot mileage reliable;
qqplot mileage reliable;
run;
/* (3) */
proc sort data=sasbase.car;
by size;
run;
proc univariate data=sasbase.car;
by size;
var mileage reliable;
run;

/* ex3_4 */

/* (1) */
proc freq data=sasbase.car;
tables size manufact reliable index / missing;
/* missing : Treats missing values as nonmissing */
run;
/* (2) */
proc freq data=sasbase.car;
tables size*manufact size*index;
run;
/* (3) */
proc freq data=sasbase.car;
tables size*index / out=out3_4;
run;

/* ex3_5 */

/* (1) */
proc plot data=sasbase.car;
plot mileage*reliable=model;
run;
/* (2) */
proc chart data=sasbase.car;
hbar size manufact;
pie size manufact;
run;
/* (3) */
proc chart data=sasbase.car;
hbar size / sumvar=mileage type=mean;
run;

/* ex3_7 */
data sasbase.ex3_7;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제3_7.txt" firstobs=4;
/* firstobs=n : txt파일에서 n번째 줄에서부터 자료를 읽기 시작하도록 지정하는 옵션 */
input name $ 1-10 gender $ 11-12 status 13-14 year 15-17 section $ 18-19 score 20-22 finalscore 23-24;
run;

proc sort data=sasbase.ex3_7;
by status;
run;
proc univariate data=sasbase.ex3_7;
by status;
var score;
run;

proc sort data=sasbase.ex3_7;
by year;
run;
proc univariate data=sasbase.ex3_7;
by year;
var score;
run;

/* ex3_8 */
proc plot data=sasbase.ex3_7;
plot score*finalscore=gender;
run;


/********** 5장 연습문제 **********/

/* ex5_4 */
data ex5_4;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제5_4.txt";
input id dept $ age test1 test2 gender $;
run;

/* ex5_5 */
data ex5_5;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제5_5.txt" firstobs=4;
input id 1-4 name $ 5-14 item1 15 item2 16 item3 17 item4 18 item5 19 item6 20 height 21-23 weight 24-25 age 26-28 region $;
run;

/* ex5_6 */
data ex5_6;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제5_5.txt" firstobs=4;
input id 4. name $10. (item1-item6) (1.) height 3. weight 2. age 2. region $;
run;

/* ex5_7 */
data ex5_7;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제5_7.txt" dsd;
input id dept $ age test1 test2 gender $;
run;

/* ex5_8 */
data ex5_8;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제5_8.txt" firstobs=4;
input @30 machine $ @;
	if machine="sm" then input name $ 1-8 gender $ 9 sales 10-14 region $ 20-24;
	if machine="c" then input name $ 1-8 region $ 10-14 sales 16-20 gender $ 21 age 22-23;
run;

/* ex5_9 */
data ex5_9;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제5_9.txt";
input last $ first $ gender $ math engl @@;
run;


/********** 6장 연습문제 **********/

/* ex6_1 */
data temper1;
	do obs=1 to 10;
		fahren=int(ranuni(0)*181 + 32);
		output;
	end;
drop obs;
run;
data temper2;
set temper1;
celsius=(5/9)*(fahren-32);
run;

/* ex6_2 */

/* (1) */
data ex6_2_1;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제6_2.txt" firstobs=3;
input id q1-q6;
small=min(of q1-q6);
run;
/* (2) */
data ex6_2_2;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제6_2.txt" firstobs=3;
input id q1-q6;
big=max(of q1-q6);
run;
/* (3) */
data ex6_2_3;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제6_2.txt" firstobs=3;
input id q1-q6;
total=sum(of q1-q6);
run;
/* (4) */
data ex6_2_4;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제6_2.txt" firstobs=3;
input id q1-q6;
mean=mean(of q1-q6);
run;

/* ex6_3 */
data ex6_3;
set ex6_2_4;
	if q6 >= mean then group="gtmean";
	else group="ltmean";
run;

/* ex6_4 */
data ex6_4;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제6_4.txt" firstobs=3;
input id x1-x3;
run;
proc sort data=ex6_4;
by id;
run;
data n_ex6_4;
set ex6_4;
retain old;
	if old=id then delete;
old=id;
drop old;
run;

/* ex6_5 */
data ex6_5;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제6_5.txt";
input x1-x5 a b c d y1-y5 z1-z3;
run;
data N_ex6_5;
set ex6_5;
array value_1 [5] x1-x5;
	do i=1 to 5;
		if value_1(i)=9 then value_1(i)=.;
	end;
array value_2 [4] a b c d;
	do i=1 to 4;
		if value_2(i)=99 then value_2(i)=.;
	end;
 array value_3 [8] y1-y5 z1-z3;
	do i=1 to 8;
		if value_3(i)=999 then value_3(i)=.;
	end;
drop i;
run;

/* ex6_8 */
data ex6_8;
input project_id startdate $ 9. enddate $ 10.;
cards;
398 17mar2007 02nov2007
942 22jan2008 11jul2008
167 15aug2009 15feb2010
250 04jan2011 11dec2011
;
run;
data n_ex6_8;
set ex6_8;
day=intck('day', startdate, enddate);
run;

/* ex6_9 */
data ex6_9;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제6_9.txt" firstobs=2;
input x1-x5;
run;
data n_ex6_9;
set ex6_9;
array value [5] x1-x5;
	do i=1 to 5;
		if value(i)=. then value(i)=0;
	end;
drop i;
run;


/********** 7장 연습문제 **********/

/* ex7_1 */

/* (1) */
data data1;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제7_1.txt" firstobs=3 obs=6;
input id gender $ height weight year;
run;
data data2;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제7_1.txt" firstobs=10 obs=13;
input id gender $ height weight year;
run;
data total;
set data1 data2;
run;
proc sort data=total;
by id;
run;

/* (2) */
data male;
set total;
	if gender="M" then output male;
run;

/* ex7_2 */
data infor;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제7_2.txt" firstobs=3 obs=6;
input id gender $ class $;
run;
data score;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제7_2.txt" firstobs=10 obs=13;
input id dept $ mid final;
run;
proc sort data=infor;
by id;
run;
proc sort data=score;
by id;
run;
data combined;
merge infor score;
by id;
run;

/* ex7_3 */
/* array문이랑 do-end문을 같이 사용하는 문제니까 잘 기억해두자!! */
data single;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제7_3.txt" firstobs=2;
input subject treat1 treat2 treat3;
run;
data multiple;
set single;
array new [3] treat1 treat2 treat3;
	do time=1 to 3;
		treat=new[time];
		output;
	end;
drop treat1 treat2 treat3;
run;

/* ex7_4 */
data chicken;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제7_4.txt";
do variety="A", "B", "C";  /* 콤마 반드시 찍어주자!! */
	do saryo=1 to 4;
		input weight @@;
		output;
	end;
end;
run;

/* ex7_5 */
/* retain문을 사용해서 푸는 문제니까 잘 기억해두자!! */
data city;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제7_5.txt" firstobs=3;
input income cost;
run;
proc means data=city mean noprint;
var income cost;
output out=out_city(keep=m_income m_cost)
mean=m_income m_cost;
run;
data city1;
set out_city;
retain m_income m_cost;
	do i =1 to 5;
		output;
	end;
drop i;
run;
data city2;
merge city city1;
ratio1=income/m_income;
ratio2=cost/m_cost;
run;

/* ex7_6 */

/* (1) */
data test;
input rep x1-x3;
trt=1; value=x1; output;
trt=2; value=x2; output;
trt=3; value=x3; output;
drop x1-x3;
cards;
1 20 25 26
2 15 17 13
;
run;
/* (2) */
data all male female;
input sex $ 1-2 id 4-5 grade $ 7;
	if sex=" " then do; list; delete; end; output all;
	if sex="m" then output male;
	if sex="f" then output female;
cards;
   11 a
f  22 b
m  33 b
m  44 a
;
run;
/* (3) */
data pay;
input id pay;
cards;
253 100
253 142
420 80
420 20
445 80
;
run;
proc sort data=pay;
by id;
run;

proc print;
title "pay data after sorting";
run;

data payroll;
set pay;
by id;
	if first.id then tot_pay=0;
tot_pay+pay;
drop pay;
	if last.id then output;
run;

proc print data=payroll;
title "payroll data";
run;

/* ex7_7 */
data part;
input number descript $ @@;
cards;
100 screwdr 200 wrench 300 hammer 400 plier
;
run;
data order;
input number company $ @@;
cards;
100 a 100 b 200 a 300 c 300 c
;
run;

proc sort data=part;
by number;
run;
proc sort data=order;
by number;
run;
data info;
merge part order;
by number;
run;

proc print data=part;
run;
proc print data=order;
run;
proc print data=info;
run;

/* ex7_9 */

/* (1), (2) */
data work.class;
set sashelp.class;
height_cm=height*2.54;
weight_kg=weight*0.4536;
run;


/********** 8장 연습문제 **********/

/* ex8_1 */
data ex8_1;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제8_1.txt";
input id 1-3 gender $ 4 agegrp 5 item1 6 item2 7 item3 8;
run;
data n_ex8_1;
set ex8_1;
sum_item=sum(of item1-item3);
run;
proc rank data=n_ex8_1 out=out8_1 ties=low descending;
/* ties=low : 둘 이상의 개체가 같은 순위를 가질 때, 그 개체들에 순위를 주는 기준을 결정 */
var sum_item;
run;

/* ex8_2 */
data male;
set out8_1;
if gender="m" then output male;
run;
proc print data=male;
run;

/* ex8_3 */
proc format;
value $gender_n "m"="남자" "f"="여자";
value agegrp_n 1="20세 이하"
					 	 2="21세 이상 40세 이하"
					 	 3="41세 이상 60세 이하"
					 	 4="60세 이상";
value item1_n 1="강한 부정" 
				  	  2="부정" 
				  	  3="그저 그러함" 
				  	  4="긍정"
					  5="강한 긍정";
value item2_n 1="강한 부정" 
				  	  2="부정" 
				  	  3="그저 그러함" 
				 	  4="긍정"
					  5="강한 긍정";
value item3_n 1="강한 부정" 
				  	  2="부정" 
				  	  3="그저 그러함" 
				  	  4="긍정"
					  5="강한 긍정";
run;
data ex8_3;
set ex8_1;
format gender $gender_n. agegrp agegrp_n. item1 item1_n. item2 item2_n. item3 item3_n.;
run;

/* ex8_4 */
data ex8_4;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제8_4.txt" firstobs=4;
input company $ 1-24 debt 25-32 accountnumber 33-38 town $;
run;
proc sort data=ex8_4 out=sort8_4;
by town company;
run;

/* ex8_5 */
proc print data=sort8_4;
by town;
sum debt;
run;

/* ex8_6 */
data ex8_6;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제8_6.txt" firstobs=4;
input company $ 1-14 date $ 15-20 time $ 21-28 price;
run;
proc sort data=ex8_6 out=sort8_6;
by company;
run;
proc transpose data=sort8_6 out=trans8_6;
by company;
id date;
run;

/* ex8_7 */
data ex8_7;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제8_7.txt" firstobs=3;
input id treat $ initwt wt3mos age;
run;
data n_ex8_7;
input id treat $ initwt wt3mos wt6mos age;
cards;
14 surgery 203.60 169.78 143.88 38
17 surgery 171.52 150.33 123.18 42
18 surgery 207.46 155.22 . 41
;
run;
proc datasets library=work nolist;
append base=work.ex8_7 data=work.n_ex8_7 force;
run;
proc print;
run;

/* ex8_8 */
data ex8_8;
infile "F:\SAS 독학\예제로 배우는 SAS 프로그래밍 입문 데이터\Raw_Data\연습문제8_8.txt" firstobs=3;
input name $ present taste;
run;
proc rank data=ex8_8 out=rank8_8 ties=low descending;
var present taste;
run;

/* ex8_9 */
data ex8_9;
set sashelp.shoes;
if product="Boot" then output ex8_9;
run;
proc summary data=ex8_9 print;
/* summary 프로시저에서는 print 옵션을 사용하지 않으면 결과를 출력하지 않는다 */
class region;
var sales;
run;

/* ex8_10 */
data drink;
input age drink count @@;
cards;
18 1 10 19 1 13 20 1 12
18 2 14 19 2 7 20 2 4
18 3 2 19 3 10 20 3 6
18 4 12 19 4 8 20 4 10
;
run;
proc print data=drink;
title "original dataset";
run;
proc format;
value p 1="coke"
			2="pepsi"
			3="fanta"
			4="others";
run;
proc freq data=drink;
tables age drink age*drink / out=outdata all;
weight count;
format drink p.;
title "frequency analysis";
run;
proc print data=outdata;
title "outdata from proc freq";
run;

/* ex8_11 */
data worker;
input job $ sex $ score day @@;
cards;
a m 76 29 b m 82 26 b f 69 24 a f 82 28
a m 77 30 b m 66 25 b f 50 20 a f 71 20
a m 88 30 b m 65 22 b f 53 19 a f 69 22
;
run;
proc means data=worker;
title "from proc means";
run;
proc means data=worker n maxdec=3 nmiss range uss css cv stderr t prt;
/* USS=Uncorrected Sum of Squares(수정되지 않은 제곱합), CSS=Corrected Sum of Squares(수정된 제곱합), prt=Pr>|t| */
var score day;
title "requested statistics";
run;
proc sort data=worker;
by job sex;
run;
proc means data=worker maxdec=3;
by job sex;
var score day;
output out=new mean=smean dmean stderr=sstderr dstderr;
title "statistics by job and sex";
run;
proc print data=new;
title "output dataset new";
run;

/* ex8_12 */
data student;
input name $ sex $ test1-test3;
stest1=test1;
stest2=test2;
stest3=test3;
cards;
kim m 94 91 87
choi f 96 95 98
lee m 91 85 92
lim m 86 77 90
huh f 76 86 69
cho m 88 71 59
yoo m 88 71 59
rho f 66 81 79
joh m 81 79 90
rha f 77 92 82
;
run;
proc sort data=student;
by sex;
run;
proc standard data=student mean=85 std=5 out=new2;
by sex;
var stest1-stest3;
run;
proc print data=new2;
by sex;
title "standardized test scores";
run;
proc means data=new2 maxdec=3 n mean std;
by sex;
run;

/* ex8_13 */
data score;
input name $ sex $ age score;
cards;
kim m 10 94
choi f 10 96
lee m 15 91
lim m 15 86
huh f 10 76
cho m 20 88
yoo m 20 71
rho f 20 66
john m 15 81
rha f 10 77
john f 15 55
ron f 20 78
;
run;
proc summary data=score;
class sex;
var age score;
output out=new3 sum=age_sum scor_sum std(score)=scor_std;
proc print data=new3;
run;
proc univariate data=score freq plot normal;
/* plot=정규확률그림, normal=정규성 검정 */
var score;
id name;
run;
