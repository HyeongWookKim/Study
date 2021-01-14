libname saspgm "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터";
libname sql "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\SQL";
libname macro "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\macro";

/********** 1장 예제문제 **********/

/* 예 1_1 */
data saspgm.one;
infile cards dlm='&$*,';
input a b c;
cards;
11&$12,13
2$$$22* 23
  3*  32,33
;
run;

/* 예 1_2_1 */

/* DLM 옵션의 이용 */
data saspgm.scores;
infile cards dlm=',';
input test1 test2 test3;
cards;
91,87,95
97,,92
1,1,1
;
run;

/* DSD 옵션의 이용 */
data saspgm.scores2;
infile cards dsd;
input test1 test2 test3;
cards;
91,87,95
97,,92
1,1,1
;
run;

/* 예 1_2_2 */
data saspgm.topics;
infile cards dsd;
input speaker : $15. title : $40. location & $10.;
cards;
Whitfield,"Looking at Water, Looking at Life",Blue Room
Fuentes,"Life After the Revolution",Red Room
Townsend,"Peace in Our Times",Green Room
;
run;

/* 예 1_3 */
data saspgm.ex1_3;
infile "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\ex1-03.txt" expandtabs;
input a b c;
run;

/* 예 1_4 */

/* FLOWOVER 옵션 */
data saspgm.ex1_4_1;
infile cards flowover;
input a b c;
cards;
1 2 3
4 5
6 7 8
9 0 1 2
3 4 5
;
run;

/* MISSOVER 옵션 */
data saspgm.ex1_4_2;
infile cards missover;
input a b c;
cards;
1 2 3
4 5
6 7 8
9 0 1 2
3 4 5
;
run;

/* STOPOVER 옵션 */
data saspgm.ex1_4_3;
infile cards stopover;
input a b c;
cards;
1 2 3
4 5
6 7 8
9 0 1 2
3 4 5
;
run;

/* 예 1_5 */

/* 디폴트 옵션(FLOWOVER 옵션) */
data saspgm.ex1_5_1;
infile "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\ex1-05.txt";
input a 5.;
run;

/* MISSOVER 옵션 */
data saspgm.ex1_5_2;
infile "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\ex1-05.txt" missover;
input a 5.;
run;

/* TRUNCOVER 옵션 */
data saspgm.ex1_5_3;
infile "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\ex1-05.txt" truncover;
input a 5.;
run;

/* 예 1_6 */

/* 옵션을 지정하지 않은 경우 */
data saspgm.ex1_6_1;
infile "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\ex1-06.txt";
input (id name class type) ($5.);
run;

/* LRECL=n 옵션과 PAD 옵션을 사용한 경우 */
data saspgm.ex1_6_2;
infile "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\ex1-06.txt" lrecl=20 pad;
input (id name class type) ($5.);
run;

/* LRECL=n 옵션과 LINESIZE=n 옵션을 사용한 경우 */
data saspgm.ex1_6_3;
infile "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\ex1-06.txt" lrecl=20 linesize=10;
input (id name class type) ($5.);
run;

/* 예 1_7 */
data saspgm.ex1_7;
length name $8 class $7;
input name $ class $;
cards;
H.C.KANG    CHEM101
Y.C.JUNG    ENGL201
S.H.JUN     MATH102
H.C.KANG    MATH102
K.J.AHAN    CHEM101
S.H.JUN     ENGE201
K.J.AHAN    CHEM101
S.H.JUN     CHEM101
Y.C.JUNG    ENGL201
H.C.KANG    MATH102
;
run;
proc sort data=saspgm.ex1_7;
by name;
run;
data saspgm.ex1_7_1;
retain oldname;
set saspgm.ex1_7;
if name=oldname then delete;
oldname=name;
drop oldname;
run;

/* 예 1_8 */
data saspgm.ex1_8;
retain y 0;
input x @@;
y=0.2*x+0.8*y;
cards;
1 2 3 4 5
;
run;

/* 예 1_9 */

/* retain문 사용 */
data saspgm.ex1_9_1;
input x1 x2 x3;
retain k 0;
if nmiss(of x1-x3)>0 then k=k+1;
cards;
1 2 3
4 5 .
. 7 .
. 8 9
1 2 3
;
run;

/* 함축 retain문 사용 */
data saspgm.ex1_9_2;
input x1 x2 x3;
if nmiss(of x1-x3)>0 then k+1;
cards;
1 2 3
4 5 .
. 7 .
. 8 9
1 2 3
;
run;

/* 예 1_10 */
data saspgm.ex1_10;
input a1-a5;
cards;
11  12  13  14  15
21   .  23  24  25
31  32  33  34  35
41  42  43  44  45
51  52  53   .  55
;
run;
data saspgm.ex1_10_1;
set saspgm.ex1_10;
array k[*] a1-a5; /* array k[5] a1-a5; 라고 입력한 것과 같다 */
	do i=1 to 5;
		if k[i]=. then delete;
	end;
drop i;
run;

/* ARRAY문 말고, NMISS 함수를 사용할 경우 */
data saspgm.ex1_10_2;
set saspgm.ex1_10;
if nmiss(of a1-a5)>0 then delete;
run;

/* 예 1_11 */
data saspgm.ex1_11;
input a1b1-a1b5 a2b1-a2b5;
cards;
11   12   13   14   15   21    22    23    24    25
31   32   33   34   35   41    42    43    44    45
;
run;
data saspgm.ex1_11_1;
format c1-c5 5.3;
array k1[2,5] a1b1-a1b5 a2b1-a2b5;
array k2[5] c1-c5;
set saspgm.ex1_11;
	do j=1 to dim2(k1);
		k2[j]=k1[1,j]/k1[2,j];
	end;
dim1_k1=dim1(k1);
dim2_k1=dim2(k1);
dim_k2=dim(k2);
drop j;
run;

/* 예 1_12 */
data saspgm.ex1_12;
array names[*] $ n1-n9;
array caps[*] $ c1-c9;
input names[*]; /* input (n1-n9) $ 과 동일하다 */
	do i=1 to 9;
		caps[i]=upcase(names[i]);
	end;
drop i;
cards;
smithers michaels gonzalez hurth frank bleigh rounder joseph peters
;
run;

/* 예 1_13 */
data saspgm.ex1_13(drop=i);
array test[3] _temporary_ (90 80 70);
array score[3] s1-s3;
input id score[*];
	do i=1 to 3;
		if score[i]>=test[i] then
		do; newscore=score[i]; output;
		end;
	end;
cards;
1234 99 60 82
5678 80 85 75
;
run;


/********** 2장 예제문제 **********/

/* 예 2_1 */
data saspgm.ex2_1_1;
input a b;
cards;
1    5
2    6
3    7
4    8
;
run;

data saspgm.ex2_1_2;
input c d;
cards;
 9    15
10    16
11    17
12    18
13    19
14    20
;
run;

data saspgm.ex2_1_3;
input a b e;
cards;
21    24    29
22    25    30
23    26    31
 1    27    32
 2    28    33
;
run;

/* 1. 세로결합 */
data saspgm.combine1;
set saspgm.ex2_1_1 saspgm.ex2_1_2;
run;

/* 2. SET문에 의한 가로결합 */
data saspgm.combine2;
set saspgm.ex2_1_1;
set saspgm.ex2_1_2;
run;

/* 3. MERGE문에 의한 가로결합 */
data saspgm.combine3;
merge saspgm.ex2_1_1 saspgm.ex2_1_2;
run;

/* 4. 세로 끼워넣기 */
proc sort data=saspgm.ex2_1_3;
by a;
run;
data saspgm.combine4;
set saspgm.ex2_1_1 saspgm.ex2_1_3;
by a;
run;

/* 5. SET문에 의한 대응 가로결합 */
data saspgm.combine5;
set saspgm.ex2_1_1;
set saspgm.ex2_1_3;
by a;
run;

/* 6. MERGE문에 의한 대응 가로결합 */
data saspgm.combine6;
merge saspgm.ex2_1_1 saspgm.ex2_1_3;
by a;
run;

/* 예 2_2 */
data saspgm.master;
input a b c $;
cards;
1    11    C1
2    12    C2
3    13     .
4    14    C4
;
run;

data saspgm.transact;
input a b e c $;
cards;
5     15     21    C5
6      .     22    C6
7     17     23    C7
8     18      .    C8
1      .     24     .
2     19     25     .
3     20     26    C3
;
run;

proc sort data=saspgm.transact;
by a;
run;

/* 일반 MERGE문 사용 */
data saspgm.merge1;
merge saspgm.master saspgm.transact;
by a;
run;

/* UPDATE문에 의한 갱신 */
data saspgm.update1;
update saspgm.master saspgm.transact;
by a;
run;

/* 예 2_3 */
data saspgm.ex2_3_1;
input x y z;
cards;
 5    1    3
 5    2    2
10    1    4
 2    1    1
 2    2    5
19    1    3
;
run;

data saspgm.ex2_3_2(drop=z);
merge saspgm.ex2_3_1 saspgm.ex2_3_1(firstobs=2 keep=x rename=(x=next));
if x=next then match='YES';
else match='NO';
run;

/* 예 2_4 */
data saspgm.ex2_4_1;
input a;
cards;
1
2
3
;
run;

data saspgm.ex2_4_2;
input b;
cards;
11
12
13
14
;
run;

data saspgm.ex2_4_3;
input c;
cards;
31
32
33
34
35
;
run;

data saspgm.combine7;
set saspgm.ex2_4_1;
if _N_=2 then set saspgm.ex2_4_2;
if _N_=3 then set saspgm.ex2_4_3;
run;

/* 자동변수의 값을 새로운 변수로 저장하고자 할 때 */
data saspgm.combine8;
set saspgm.ex2_4_1;
n=_N_;
error=_ERROR_;
run;

/* 예 2_5 */
proc means data=saspgm.ex2_4_1;
var a;
output out=sumout sum(a)=suma;
run;
data saspgm.rone;
if _N_=1 then set sumout(keep=suma);
set saspgm.ex2_4_1(keep=a);
ratio=a/suma;
run;

/* 예 2_6 */
data saspgm.ex2_6_1;
input name $ score;
cards;
A      1
B      2
D      3
C      5
C      4
C      6
D      7
;
run;

data saspgm.ex2_6_2;
set saspgm.ex2_6_1;
by name notsorted;
first=first.name;
last=last.name;
run;

/* 오름차순 정렬 */
proc sort data=saspgm.ex2_6_1;
by name;
run;
data saspgm.ex2_6_3;
set saspgm.ex2_6_1;
by name;
first=first.name;
last=last.name;
run;

/* 내림차순 정렬 */
proc sort data=saspgm.ex2_6_1;
by descending name;
run;
data saspgm.ex2_6_4;
set saspgm.ex2_6_1;
by descending name;
first=first.name;
last=last.name;
run;

/* 예 2_7 */
data saspgm.class;
input id $ name $ class $;
cards;
3456   H.C.KANG   CHEM101
3456   H.C.KANG   MATH102
3456   H.C.KANG   MATH102
2345   J.H.CHOI   CHEM101
2345   J.H.CHOI   ENGE201
2345   J.H.CHOI   MATH102
1234   K.J.AHAN   CHEM101
1234   K.J.AHAN   CHEM101
4567   Y.C.JUNG   ENGL201
4567   Y.C.JUNG   ENGL201
;
run;

data saspgm.dups saspgm.nodups;
set saspgm.class;
by name class;
if first.class and last.class then output saspgm.nodups;
else output saspgm.dups;
run;

/* 예 2_8 */
data saspgm.ex2_8_1;
input name $ class $;
cards;
B.S.CHOI    MATH201
H.C.KANG    CHEM101
K.J.AHAN    CHEM101
S.H.JUN     MATH102
Y.C.JUNG    ENGL201
;
run;

data saspgm.ex2_8_2;
input name $ score;
cards;
B.Y.LEE       50
J.C.KIM       70
S.H.JUN       90
Y.C.JUNG      80
Y.H.PARK      60
;
run;

data saspgm.ex2_8_3;
merge saspgm.ex2_8_1(in=in1) saspgm.ex2_8_2(in=in2);
by name;
if in1 and in2 then origin='both';
	else if in1 then origin='one';
	else origin='two';
run;

/* 예 2_9 */
data saspgm.ex2_9_1;
input a b;
cards;
1     2
2     4
3     6
4     8
5    10
;
run;

/* "END=변수명" 옵션 사용 */
data saspgm.ex2_9_2(drop=i);
set saspgm.ex2_9_1 end=lastone;
output;
	if lastone then do;
		do i=1 to 5;
			a=a+1; b=b+2; output;
		end;
	end;
run;

/* "NOBS=변수명", "POINT=변수명" 옵션 사용 */
data saspgm.ex2_9_3(drop=i);
	if _N_=1 then set saspgm.ex2_9_1 point=lastobs nobs=lastobs;
	do i=1 to 5;
		a=a+1; b=b+2; output;
	end;
	stop;
run;
data saspgm.ex2_9_4;
set saspgm.ex2_9_1 saspgm.ex2_9_3;
run;

/* ex) 짝수번째에 해당하는 개체를 차례로 50개만 읽고자하는 경우 */
data saspgm.test;
    do i=1 to 100;
        output;
    end;
run;

data saspgm.sample;
	do obsnum=2 to 100 by 2;
		set saspgm.test point=obsnum;
		if _ERROR_ then abort;
		output;
	end;
	stop;
run;

/* 예 2_10 */

/* 복원 단순임의추출 */
data saspgm.pop;
	do popid=1 to 1000;
		output;
	end;
run;

data saspgm.sample1(drop=i);
choice=int(ranuni(36830)*n)+1;
set saspgm.pop point=choice nobs=n;
i+1;
if i > 100 then stop;
run;

proc sort data=saspgm.sample1;
by popid;
run;

/* 예 2_11 */

/* 비복원 단순임의추출 */
data saspgm.sample2(drop=k n);
retain k 100 n;
set saspgm.pop nobs=total;
if _N_=1 then n=total;
if ranuni(1230498) <= k/n then
	do;
		output;
		k=k-1;
	end;
n=n-1;
if k=0 then stop;
run;

/* 예 2_12 */
data saspgm.ex2_12;
length fname $ 20;
infile "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\ex2-12.txt"
		column=clength filename=fname length=length line=line;
input id $ name $ class $;
cl=clength;
fn=fname;
le=length;
li=line;
run;


/********** 3장 예제문제 **********/

/* 예 3_1 */
data saspgm.score;
length name $ 9 grade $ 6;
input name $ score;
if 1<=score<=3 then grade='LOW';
	else if 4<=score<=7 then grade='MIDDLE';
	else if 8<=score<=10 then grade='HIGH';
cards;
HyunCheol 7
YongChan 10
MinHee 3
;
run;

/* 예 3_2 */

/* 1. INPUT lastname $ name1 $; */
data saspgm.ex3_2_1;
length lastname $15 name1 $8;
input lastname $ name1 $;
cards;
Longlastname1  John
Mc Allister  Mike
Longlastname3  Jim
;
run;

/* 2. INPUT lastname $15. name1 $; */
data saspgm.ex3_2_2;
length lastname $15 name1 $8;
input lastname $15. name1 $;
cards;
Longlastname1  John
Mc Allister  Mike
Longlastname3  Jim
;
run;

/* 3. INPUT lastname $13. name1 $char6.; */
data saspgm.ex3_2_3;
length lastname $15 name1 $8;
input lastname $13. name1 $char6.;
cards;
Longlastname1  John
Mc Allister  Mike
Longlastname3  Jim
;
run;

/* 4. INPUT lastname & $15. name1 $; */
data saspgm.ex3_2_4;
length lastname $15 name1 $8;
input lastname & $15. name1 $;
cards;
Longlastname1  John
Mc Allister  Mike
Longlastname3  Jim
;
run;

/* 예 3_3 */
data saspgm.char;
input string $char3.;
if string <= 'M' then sign1='T';
if string <=: 'M' then sign2='T';
cards;
001
 20
  5
Min
min
 OP
김
철
 현
#04
&33
# 4
;
run;
proc sort data=saspgm.char;
by string;
run;

/* 예 3_4 */
data saspgm.name;
length first $5 last $10 degree $4 full $30;
infile cards missover;
input last $ first $ degree $;
if degree=' ' | degree='Unkn'    /* if degree=' ' or degree='Unkn' 라고 해도 된다 */ 
                  then full=first||last||'(unknown)';       /* '(unknown)' 처럼 문자변수가 아닌 문자열을 사용하는 경우에는 ' '로 문자열을 닫아 주어야 한다 */
        else           full=first||last||'('||degree||')';    /* ' ( ' 과 ' ) ' 처럼 문자변수가 아닌 문자열을 사용하는 경우에는 ' '로 문자열을 닫아 주어야 한다 */
cards;
Minsu  Park
HyunHee  Lee  PhD
ChulSu  Kim  MD
Inho  Choi  Unkn
;
run;

/* 예 3_5 */
data saspgm.testcn;
input sale $9.;
fmtsale=input(sale, comma9.);
cards;
2,115,353
;
run;

/* 예 3_6 */
data saspgm.testcnc;
input ymd 8.;
fmtymd=put(ymd, $8.);
cyear=substr(fmtymd, 1, 4);
nyear=input(cyear, 4.);
cards;
20010304
;
run;

/* 예 3_7 */
data saspgm.ex3_7_1;
input name $ resp1 resp2 resp3;
cards;
Kang      10       9        8
Park       2       8        4
Lee        5       7        6
;
run;

data saspgm.ex3_7_2(drop=resp1 resp2 resp3 i);
set saspgm.ex3_7_1;
array ttt[*] resp1 resp2 resp3;
length item $ 5;
	do i=1 to dim(ttt);
		response=ttt[i];
		call vname(ttt[i], item);
		output;
	end;
run;

/* 예 3_8 */
data saspgm.dept;
input name $6. +1 bdate date7. +1 hired mmddyy8.;
hiredate=hired+(365.25*3);
hireqtr=qtr(hiredate);
if hired > '01jan94'd then new='YES';
format bdate mmddyy8. hired yymmdd8. hiredate weekdate17.;
cards;
김철수 01jan60 09-15-90
최민지 05oct49 01-24-92
이영희 18mar88 10-10-93
오인수 29feb80 05-29-94
;
run;

/* 예 3_9 */
data saspgm.ex3_9_a;
infile 'F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\sales.dat';
input id @8 saled @15 asd @23 ascost;
diff=asd-saled;
run;
proc print data=saspgm.ex3_9_a;
run;

data saspgm.ex3_9_b;
infile 'F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\sales.dat';
input id @8 saled yymmdd6. @15 asd yymmdd6. @23 ascost;
diff=asd-saled;
run;
proc print data=saspgm.ex3_9_b;
run;

/* 예 3_10 */
data saspgm.ex3_10;
infile 'F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\sales.dat';
input id @8 saled yymmdd6. @15 asd yymmdd6. @23 ascost;
diff=asd-saled;
format saled asd yymmdd8.;
run;
proc print data=saspgm.ex3_10;
run;

/* SAS 날짜 값을 만드는 함수(날짜함수, Date Function) */

/* 1. MDY(month, day, yrea) 함수 */
data saspgm.mdyexam1;
input mon day year;
newdate=mdy(mon, day, year);
format newdate yymmdd8.;
cards;
12 11 1997
03 18 1998
;
run;
proc print data=saspgm.mdyexam1;
run;

data saspgm.mdyex;
input mon day year;
newdate=mdy(mon, day, year);
format newdate yymmdd10.;
cards;
12 11 1997
03 18 1998
;
run;
proc print data=saspgm.mdyex;
run;

/* 2. TODAY() 함수 */
data saspgm.todayex;
set saspgm.mdyex;
today=today();
diff=today-newdate;
format today newdate yymmdd10.;
run;
proc print data=saspgm.todayex;
run;

/* 3. YYQ(year, quarter) 함수 */
data saspgm.yyqex;
input year qrt;
newdate=yyq(year, qrt);
format newdate yymmdd10.;
cards;
1993 3
1996 1
1967 1
1965 3
;
run;

/* 예 3_11 */
data saspgm.fct_ex;
set saspgm.ex3_10;
sale_day=day(saled);
sale_mon=month(saled);
saleyear=year(saled);
s_weekend=weekday(saled);
keep saled asd ascost sale_day sale_mon saleyear s_weekend;
format asd date7.;
run;

/* 예 3_12 */

/* INTNX 함수의 사용 ex1 */
data saspgm.intnxex1;
date2=intnx('month', '05jan2000'd, 10);
date3=intnx('year', date2, 1);
format date2 date3 yymmdd10.;
run;
proc print data=saspgm.intnxex1;
run;

/* INTNX 함수의 사용 ex2 */
data saspgm.intnxex2;
date1=intnx('year', '18mar96'd, 2);
date2=intnx('year', '18jan98'd, 0);
date3=intnx('month', '21feb98'd, -1);
date4=intnx('month', '31dec97'd, 1);
format date1-date4 yymmdd6.;
run;
proc print data=saspgm.intnxex2;
run;

/* 예 3_13 */
data saspgm.intnxex3;
input sales;
date=intnx('month', '01jan2001'd, _N_ -1);
format date yymon7.;
cards;
113
137
149
;
run;
proc print data=saspgm.intnxex3;
run;

/* 예 3_14 */
data saspgm.formatex;
input id @8 saled yymmdd6. @15 asd yymmdd6. @23 ascost;
diff=asd-saled;
format saled asd yymmdd8.;
cards;
000001 980123 980310  5000
000002 980125 980215  15000
000003 980211 980301  7000
000004 980301 980320  9000
;
run;

data saspgm.intckex;
set saspgm.formatex;
today=today();
nas_week=intck('week', saled, asd);
nmonth=intck('month', saled, today);
format today yymmdd8.;
run;
proc print data=saspgm.intckex;
run;


/********** 5장 예제문제 **********/

libname sql 'F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\SQL';

/* 5.1 SQL 프로시저의 이해 */
data sql.kbl1;
input team $ name $ posi $ backn score freeth freetry reb assist foul time;
cards;
대우 김훈       F  7 24 1  2  1 4 3 38
대우 우지원     F 10 22 7  8  8 2 2 36
기아 강동희     G  5 14 5  6  2 7 0 32
기아 리드       C 22 27 5  9 19 1 4 35
삼성 문경은     F 14 37 9 11  2 3 2 40
삼성 스트릭랜   C 55 45 5  9 14 1 4 40
나래 정인교     G  5 28 8 10  2 2 2 36
나래 주희정     G 15 11 1  1  2 2 5 38
나산 조던       G  9 23 7  9  2 4 0 34
나산 이민형     F 14 14 2  3  3 3 0 36
동양 그레이     G  9 33 1  3 14 1 2 40
동양 전희철     F 13 16 3  6  8 1 2 32
;
run;

data sql.kbl2;
input name $ backn suc2p try2p suc3p try3p;
cards;
김훈        7 10 11 1  4
우지원     10  6 10 1  4
강동희      5  3  6 1  3
리드       22 11 15 0  1
문경은     14  5 11 6 11
스트릭랜   55 20 31 0  0
정인교      5  4  7 4 12
주희정     15  5  6 0  0
조던        9  5  8 2  8
이민형     14  3  6 2  5
그레이      9 14 18 1  3
전희철     13  2  7 3  6
;
run;

data sql.kbl3;
input team $ name $ posi $ backnum score freeth freetry reb assist foul time;
cards;
대우 데이비스   F 44 21 1  2  7 2 1 35
대우 우지원     F 10 22 3  4  3 2 4 37
기아 허재       G  9 24 4  4  7 2 3 38
기아 김영만     F 11 18 4  4  3 3 2 36
삼성 문경은     F 14 16 9 11  5 4 2 40
삼성 스트릭랜   C 55 27 5  5 12 0 1 34
나래 장윤섭     F 13 18 3  3  6 1 3 27
나래 윌리포드   C 22 22 1  4 16 1 3 38
나산 조던       G  9 28 5 13  3 3 0 40
나산 이민형     F 14 21 1  1  5 0 3 38
동양 그레이     G  9 21 2  4  3 2 4 38
동양 김병철     G 10 23 5  6  8 6 3 40
;
run;

/* SQL의 이용 */
proc sql;
	select team, sum(score) as totscore from sql.kbl1
	where posi='G'
	group by team
	order by totscore;
run;

/* 일반적인 SAS 프로그램 사용 */
proc summary data=sql.kbl1;
	where posi='G';
	class team;
	var score;
	output out=sumscore sum=totscore;
run;

proc sort data=sumscore;
	by totscore;
run;

proc print data=sumscore ;
	var team totscore;
	where _type_=1;
run;

/* 예 5_1 */
proc sql;
	select * from sql.kbl1;
run;

proc sql;
	select team, posi from sql.kbl1;
run;

proc sql;
	select * from sql.kbl1(drop=assist);
run;

/* 예 5_2 */

/* distinct 명령어 사용 전 */
proc sql;
	select team, posi from sql.kbl1;
run;

/* distinct 명령어 사용 후 */
proc sql;
	select distinct team, posi from sql.kbl1;
run;

/* 예 5_3 */
title '자유투 성공률';
proc sql;
	select name, freeth, (freeth/freetry)*100 as percent
	from sql.kbl1;
run;

/* 예 5_4 */

/* CALCULATED 명령어를 사용 */
title '자유투 성공률이 낮은 선수';
proc sql;
	select name, freeth, (freeth/freetry)*100 as percent,
		case
			when calculated percent<60 then '****'
			else ' '
		end
	from sql.kbl1;
run;

/* CALCULATED 명령어를 사용하지 않고, 위 코드와 같은 결과 출력하기 */
title '자유투 성공률이 낮은 선수';
proc sql;
	select name, freeth, (freeth/freetry)*100 as percent,
		case
			when (freeth/freetry)*100<60 then '****'
			else ' '
		end
	from sql.kbl1;
run;

/* 예 5_5 */
proc sql;
	select name, freeth, (freeth/freetry)*100 as percent
	format=4.1 label='백분율'
	from sql.kbl1;
run;

/* 예 5_6 */
title '포지션별 득점 순위';
proc sql;
	select name, posi, score from sql.kbl1
	order by posi, score;
run;

/* AS 명령어를 사용하지 않아서 변수이름이 정해지지 않은 경우에, 그 변수에 의해서 정렬하고자 할 때 */
proc sql;
	select name, freeth, (freeth/freetry)*100
	format=4.1 label='백분율'
	from sql.kbl1
	order by 3;
run;

/* 예 5_7 */

/* "평균"을 구해주는 함수 */
select avg(freeth/freetry*100) as avgper
format=4.1 label='평균 자유투 성공률'
from sql.kbl1;

/* "행의 수"를 구해주는 함수 */
select count(*) label='행의 수' from sql.kbl1;

/* "최솟값"과 "최댓값"을 구해주는 함수 */
select min(score) label='최하 득점', 
		  max(score) label='최고 득점'
from sql.kbl1;

/* "합계"를 구해주는 함수 */
select sum(score) label='총득점' from sql.kbl1;

/* 예 5_8 */
proc sql;
title '포지션별 자유투 성공률';
	select posi, avg(freeth/freetry*100) as avgper
	format=4.1 label='평균 자유투 성공률'
	from sql.kbl1
	group by posi;

title '포지션별 선수 수';
select posi, count(posi) from sql.kbl1
group by posi;

/* 예 5_9 */
proc sql;
title '자유투 성공률이 높은 팀';
	select team, avg(freeth/freetry*100) as avgper
	format=4.1 label='자유투 성공률' from sql.kbl1 
	group by team
	having avgper>70;
run;

proc sql;
title '가드의 자유투 성공률';
	select posi, name, avg(freeth/freetry*100) as avgper
	format=4.1 label='자유투 성공률' from sql.kbl1
	where posi='G'
	order by avgper;
run;

proc sql;
title '가드의 평균 자유투 성공률이 높은 팀';
	select team, avg(freeth/freetry*100) as avgper
	format=4.1 label='자유투 성공률' from sql.kbl1
	where posi='G'
	group by team
	having avgper>70;
run;

/* 예 5_10 */

/* 두 개의 테이블 다루기_INTERSECT 명령어 */
proc sql;
title '두 경기에 모두 출전한 선수';
	select name from sql.kbl1
	intersect
	select name from sql.kbl3;
run;

/* 두 개의 테이블 다루기_EXCEPT 명령어 */
proc sql;
title '12월 경기에만 출전한 선수';
	select team, name from sql.kbl1
	except
	select team, name from sql.kbl3;
run;

/* 두 개의 테이블 다루기_UNION 명령어 */
proc sql;
title '나래팀 출전 선수';
	select team, name from sql.kbl1 where team='나래'
	union
	select team, name from sql.kbl3 where team='나래';
run;

/* 예 5_11 */
proc sql;
title '두 경기의 평균 득점';
	select '12월 경기:', avg(score)
	format=5.2 label='평균 득점' from sql.kbl1
	union
	select '2월 경기:', avg(score)
	format=5.2 label='평균 득점' from sql.kbl3;
run;

/* 예 5_12 */
proc sql;
create table sql.fthrow as
	select posi, avg(freeth/freetry*100) as avgper
	format=4.1 label='자유투 성공률'
	from sql.kbl1 group by posi;
select * from sql.fthrow;
run;

/* 이미 존재하고 있는 테이블을 복사하여 새로운 이름으로 저장할 때 */
create table sql.new1 as
	select * from sql.fthrow;

create table sql.new2 as
	select * from sql.kbl2(drop=backn);

/* 테이블 자체를 제고하고자 할 때 */
/* drop table sql.kbl2; 라고 하면 된다(sql.kbl2 테이블이 사라지면 안되므로, 실행시키지는 않고 주석 달아놓은 것) */


/* 예 5_13 */

/* sql.kbl1에서 4개의 열을 선택하여, 포지션이 가드(G)인 선수만을 모아 sql.score라는 테이블 생성 */
proc sql;
create table sql.score as 
	select team, name, posi, score
	from sql.kbl1 where posi='G';
select * from sql.score;
run;

/* INSERT INTO문을 이용한 행 끼워 넣기 */
proc sql;
insert into sql.score
	select team, name, posi, score from sql.kbl1
	where team in ('동양');
select * from sql.score;
run;

/* 예 5_14 */
proc sql;
insert into sql.score
	set team='나래',
		 name='윌리포드',
		 posi='C',
		 score=31;
select * from sql.score;
run;

/* 예 5_15 */
proc sql;
insert into sql.score
	values ('기아', '김유택', 'F', 8)
	values ('기아', '김영만', 'F', 12);
select * from sql.score;

/* 행의 삭제_DELETE 명령어 */
/* delete from sql.kbl1 where team='기아'; 라고 하면 된다(sql.kbl1의 행이 삭제되면 안되므로, 실행시키지는 않고 주석 달아놓은 것) */


/* 예 5_16 */
proc sql;
update sql.score
	set score=score*1.5;
select * from sql.score;

/* 예 5_17 */
proc sql;
update sql.score
	set score=score+5
	where team in ('동양');
update sql.score
	set score=score-5
	where team in ('나래');
select * from sql.score;

/* WHERE 문을 여러 번 사용할 필요가 있는 경우_CASE 명령어를 사용 */
proc sql;
update sql.score
	set score=score+
		case 
				when team in ('동양') then 5
				when team in ('나래') then -5
				else 0
		end;
run;

/* 예 5_18 */
proc sql;
alter table sql.kbl1
	add pof num label='자유투 성공률' format 6.2;
select team, name, posi, score, pof
from sql.kbl1
where posi='G';

proc sql;
update sql.kbl1
	set pof=(freeth/freetry)*100;
select team, name, posi, score, pof
from sql.kbl1
where posi='G';

/* CREATE TABLE 문을 사용하여 새로운 테이블 생성 */
create table sql.pof as
	select team, name, posi, score, (freeth/freetry)*100 as pof
	label='자유투 성공률' format 6.2
	from sql.kbl1
	where posi='G';
select * from sql.pof;

/* 열의 삭제_DROP 명령어 */
/* alter table sql.kbl1
	drop assist, foul; 라고 하면 된다(sql.kbl1의 열이 삭제되면 안되므로, 실행시키지는 않고 주석 달아놓은 것) */


/* 예 5_19 */
proc sql;
create view sql.view1 as
	select team label='구단',
		count(team) as number label='선수 수',
		sum(score) as tot label='총 득점',
		avg(score) as aos format=5.2 label='평균 득점'
	from sql.kbl1
	group by team;
select * from sql.view1;

/* 뷰(view) 또는 테이블(table)의 내용 확인과 삭제_DESCRIBE 문 */
describe view sql.view1;
describe table sql.kbl1;

/* 생성된 뷰(view)는 SAS 프로그램에서 다른 데이터 파일과 동일하게 사용 가능 */
proc means data=sql.view1 maxdec=2;
var tot aos;
run;

/* 뷰(view)를 이용시 주의할 점 :
뷰의 모체가 되는 테이블의 내용이 수정될 경우 이미 생성된 뷰는 작동하지 않는다 */
proc sql;
create table sql.kbl1 as
	select team, name, posi
	from sql.kbl1;

proc means data=sql.view1 maxdec=2;
var tot aos;
run;

/* 예 5_20 */
proc sql;
	select kbl1.team, kbl1.name, kbl1.posi, suc3p, 
	kbl1.score as score1, kbl3.score as score2
	from sql.kbl1, sql.kbl2, sql.kbl3
	where kbl1.name=kbl2.name=kbl3.name and kbl3.posi='G';

proc sql;
	select kbl1.team, kbl1.name, kbl1.posi, suc3p, 
	kbl1.score as score1, kbl3.score as score2
	from sql.kbl1, sql.kbl2, sql.kbl3
	where kbl1.name=kbl3.name and kbl3.posi='G';

proc sql;
	select k1.team, k1.name, k1.posi, suc3p,
	k1.score as score1, k3.score as score2
	from sql.kbl1 as k1, sql.kbl2 as k2, sql.kbl3 as k3
	where k1.name=k2.name=k3.name and k3.posi='G';

/* 예 5_21 */
proc sql;
	select k1.name, k1.posi, k1.reb as reb1, k3.reb as reb2
	from sql.kbl1 as k1 left join sql.kbl3 as k3
	on k1.name=k3.name;

proc sql;
	select k1.name, k1.posi, k1.reb as reb1, k3.reb as reb2
	from sql.kbl1 as k1 left join sql.kbl3 as k3
	on k1.name=k3.name and k3.posi='G';

/* 예 5_22 */

/* 결과창에 k1 테이블의 name, posi, reb1과 k3 테이블의 reb2을 출력 */
/* 즉, k3.name이 있든 말든 일단 k1.name 기준으로 값을 출력 */
proc sql;
	select k1.name, k1.posi, k1.reb as reb1, k3.reb as reb2
	from sql.kbl1 as k1 right join sql.kbl3 as k3
	on k1.name=k3.name;

/* 결과창에 k3 테이블의 name, posi, reb2와 k1 테이블의 reb1을 출력 */
/* 즉, k1.name=k3.name인 k3.name을 출력 */
proc sql;
	select k3.name, k3.posi, k3.reb as reb2, k1.reb as reb1
	from sql.kbl1 as k1 right join sql.kbl3 as k3
	on k1.name=k3.name;

/* 예 5_23 */
proc sql;
	select k1.name, k1.posi, k1.reb as reb1, k3.reb as reb2
	from sql.kbl1 as k1 full join sql.kbl3 as k3
	on k1.name=k3.name;

/* 예 5_24 */
proc sql;
	select k1.posi, k1.name, coalesce(k3.score, k1.score)
	label='최근 득점'
	from sql.kbl1 as k1 left join sql.kbl3 as k3
	on k1.name=k3.name;


/********** 4장 예제문제 **********/

libname macro "F:\SAS 독학\예제로 배우는 SAS 고급 프로그래밍 데이터\macro";

/* 예 4_1 */
data macro.exchange;
input currency $ buying selling basic;
cards;
dollar    1577 1708 1642.5
yen       1229 1331 1280.0
pound     2589 2805 2697.0
;
run;

%let fer=exchange;

data temp;
set &fer;
run;

proc print data=temp;
run;

/* 예 4_2 */
%let fer=exchange;

proc print;
title "Foreign &fer rate";
run;

/* 예 4_3 */
%let plot=%str(
	proc plot data=macro.exchange;
	plot buying*selling;
	run;
	);

&plot /* plot을 호출할 경우에는 세미콜론(;)이 필요가 없다 */

/* 예 4_4 */
%let var1=buying;
%let var2=selling;

%let plot=%str(
	proc plot data=macro.exchange;
	plot &var1*&var2;
	run;
	);

&plot

/* 예 4_5 */
data macro.bankdata;
input name $ bis bcredit per @@;
cards;
조흥  6.50 26232  7.0 상업  7.62 14512  4.8 제일 -2.70 30559 11.4
한일  6.90 13224  3.6 서울  0.97 24040 10.3 외환  6.79 25176  5.7
국민  9.78  8921  3.2 주택 10.29  5887  2.0 신한 10.29 11066  4.1
한미  8.57  3293  3.4 동화  5.34  6023  7.9 동남  4.54  2930  5.7
대동  2.98  4869  9.6 하나  9.29  2494  2.4 보람  9.32  2894  3.2
평화  5.45  2283 4.5
;
run;

%let dsn=macro.bankdata;

%macro corr;
	proc corr data=&dsn;
	var bis per;
	run;
%mend corr;

%corr

/* 예 4_6 */
%macro plot2(var1, var2);
	proc plot data=macro.bankdata;
	plot &var1*&var2;
	run;
%mend plot2;

%plot2(bis, per)
%plot2(bis,bcredit)

/* 예 4_7 */
%macro plot3(var1=bis, var2=per);
	proc plot data=macro.bankdata;
	plot &var1*&var2;
	run;
%mend plot3;

%plot3 ()
%plot3
%plot3(var1=bis, var2=bcredit)

/* 예 4_8 */
options mlogic mprint;

%plot3(var1=bis, var2=bcredit)

options nomlogic nomprint;

/* 예 4_9 */
%macro data;
	data temp; 
	set macro.bankdata; 
	if bis>8;
	run;
%mend;

%macro corr;
	proc corr;
	var &var1 &var2;
	run;
%mend corr;

%macro combine(var1, var2);
	%data
	%corr
%mend combine;

%combine(bis, per)

/* 예 4_10 */
%macro condi(index, var1, var2);
	%if &index=yes %then %data;
	%corr
%mend condi;

%condi(yes, bis, per)
%condi(no, bis, bcredit)

/* 예 4_11 */
%macro data1;
	data temp;
	set macro.bankdata;
	if bis>8;
	run;
%mend data1;
%macro data2;
	data temp;
	set macro.bankdata;
	if bis<8;
	run;
%mend data2;
%macro corr;
	proc corr;
	var &var1 &var2;
	run;
%mend corr;

%macro condi(index, var1, var2);
	%if &index=yes %then
		%do; title "Corr for BIS>8";
			%data1
			%corr
		%end;
	%else
		%do; title "Corr for BIS<8";
			%data2
			%corr
		%end;
%mend condi;

%condi(yes, bis, per)
%condi(no, bis, per)

/* 예 4_12 */
%macro names(name, no);
	%do n=1 %to &no;
		&name&n;
	%end;
%mend names;

data %names(data, 5);
	x=0;
run;

/* 예 4_13 */
%macro namesx(name, no);
	%do n=1 %to &no;
		&name.x&n
	%end;
%mend namesx;

data %namesx(data, 5);
	y=0;
run;

/* 예 4_14 */
%macro dountil(no);
	%put 매크로 시작 번호 : &no;
	%do %until(&no>3);
		%put ***&no***; %let no=%eval(&no+1);
	%end;
	%put 매크로 끝 번호 : &no;
%mend dountil;

%dountil(2)
%dountil(5)

/* 예 4_15 */
%macro dowhile(no);
	%put 매크로 시작 번호 : &no;
	%do %while(&no<3);
		%put ***&no***;
		%let no=%eval(&no+1);
	%end;
	%put 매크로 끝 번호 : &no;
%mend dowhile;

%dowhile(1)
%dowhile(5)

/* 예 4_16 */
%macro temp;
	%let vname1=aaa;
	%let vname2=bbb;
	%let vname3=ccc;
	%do i=1 %to 3;
		%put result1=&vname&i;
		%put result2=&&vname&i;
	%end;
%mend temp;

%temp

/* 예 4_17 */
%let x=100;
%let y=&x+200; %put &y;
%let z=%eval(&x+200); %put &z;
%let z=%eval(2+3=5); %put &z;

/* 예 4_18 */
%let title=Bridge over troubled water;
%let b=%index(&title, b);
%put b는 &b 번째에 나타난다;

/* 예 4_19 */
%let IMF=International Monetary Fund;
%let BIS=Bank for International Settlements;
%let title=다시뛰자;
%put *%length(&IMF)* **%length(&BIS)** ***%length(&title)***;
%put *%length(&IMF &title)***;

/* 예 4_20 */
%let title1=Bridge over troubled water;
%let b=%scan(&title1, 3); %put &b;
%let title2=Bridge$over troubled$water;
%let b=%scan(&title2, 3); %put &b;
%let b=%scan(&title2, 3, $); %put &b;

/* %SUBSTR 함수 예제 */
title "보고일자 : %substr(&sysday, 1, 3), &sysdate";
title "보고일자 : %substr(&sysday, 2, 4), &sysdate";

/* 예 4_21 */
%macro condi2(index, var1, var2);
	%if %upcase(&index)=YES %then %data;
	%corr
%mend condi2;

%condi2(yes, bis, per)
%condi2(YeS, bis, bcredit)
%condi2(yEs, bis, bcredit)

/* 예 4_22 */
%let b=bis;
data macro.new1;
length y $ 2;
set macro.bankdata;
w=symget('b');
x="&b";
y='&b';
z=&b;
run;

proc print data=macro.new1; 
run;

/* 예 4_23 */
%let b1='해당사항없음';
%let b2='경영개선권고';
%let b3='경영개선조치';
data macro.new2;
set macro.bankdata;
	if bis>=8 then id='b1';
	else if 6<=bis<8 then id='b2';
	else id='b3';
trt=symget(id);
run;

proc print data=macro.new2;
run;

/* 예 4_24 */
%let b1='해당사항없음';
%let b2='경영개선권고';
%let b3='경영개선조치';
data macro.new3;
set macro.bankdata;
	if bis>=8 then x=symget('b1');
	else if 6<=bis<8 then x=symget('b2');
	else x=symget('b3');
run;

proc print data=macro.new3;
run;

/* 예 4_25 */
data macro.new4;
set macro.bankdata;
	if bis>=8 then trt='해당사항없음';
	else if 6<=bis<8 then trt='경영개선권고';
	else trt='경영개선조치';
run;

/* 예 4_26 */
%let b1='해당사항없음';
%let b2='경영개선권고';
%let b3='경영개선조치';
data macro.new5;
set macro.bankdata;
trt=symget('b'||left(_n_));
run;

proc print data=macro.new5;
run;

/* 예 4_27 */
data macro.bank2;
input name $ bis @@;
call symput('bis', bis);
call symput('name', name);
call symput('test', 'testing value');
cards;
상업   7.62 제일  -2.70 서울   0.97 국민   9.78
;
run;

%put &bis;
%put &name;
%put &test;

/* 예 4_28 */
data macro.day;
input samil mmddyy.;
call symput('day', put(samil, worddate.));
cards;
030198
;
run;

%put &day;

/* 예 4_29 */
%macro correct(company);
	data _null_;
	set macro.bank2;
	call symput('bankname', name);
	run;
	%if &bankname=&company %then
		%do;
			data macro.ex4_29;
			set macro.bank2;
			bis=bis+2;
			run;
		%end;
%mend correct;

%correct(국민);
proc print data=macro.ex4_29;
run;

/* 예 4_30 */
/* 잘못된 SYMPUT 함수의 사용 예시 */
%macro correct(company);
	data macro.ex4_30;
	set macro.bank2;
	call symput('bankname', name);
	%if &bankname=&company %then
		%do;
			bis=bis+2;
		%end;
	run;
%mend correct;

%correct(국민);

/* 예 4_31 */
data macro.char1;
input c $;
call symput('char', c);
cards;
글
;
run;

data macro.char2;
length newchar $ 5;
newchar="&char" || "자";
run;

proc print data=macro.char2;
run;

/* 예 4_32 */
