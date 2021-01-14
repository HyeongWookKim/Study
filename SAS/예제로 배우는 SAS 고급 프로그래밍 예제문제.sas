libname saspgm "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������";
libname sql "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\SQL";
libname macro "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\macro";

/********** 1�� �������� **********/

/* �� 1_1 */
data saspgm.one;
infile cards dlm='&$*,';
input a b c;
cards;
11&$12,13
2$$$22* 23
  3*  32,33
;
run;

/* �� 1_2_1 */

/* DLM �ɼ��� �̿� */
data saspgm.scores;
infile cards dlm=',';
input test1 test2 test3;
cards;
91,87,95
97,,92
1,1,1
;
run;

/* DSD �ɼ��� �̿� */
data saspgm.scores2;
infile cards dsd;
input test1 test2 test3;
cards;
91,87,95
97,,92
1,1,1
;
run;

/* �� 1_2_2 */
data saspgm.topics;
infile cards dsd;
input speaker : $15. title : $40. location & $10.;
cards;
Whitfield,"Looking at Water, Looking at Life",Blue Room
Fuentes,"Life After the Revolution",Red Room
Townsend,"Peace in Our Times",Green Room
;
run;

/* �� 1_3 */
data saspgm.ex1_3;
infile "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\ex1-03.txt" expandtabs;
input a b c;
run;

/* �� 1_4 */

/* FLOWOVER �ɼ� */
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

/* MISSOVER �ɼ� */
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

/* STOPOVER �ɼ� */
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

/* �� 1_5 */

/* ����Ʈ �ɼ�(FLOWOVER �ɼ�) */
data saspgm.ex1_5_1;
infile "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\ex1-05.txt";
input a 5.;
run;

/* MISSOVER �ɼ� */
data saspgm.ex1_5_2;
infile "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\ex1-05.txt" missover;
input a 5.;
run;

/* TRUNCOVER �ɼ� */
data saspgm.ex1_5_3;
infile "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\ex1-05.txt" truncover;
input a 5.;
run;

/* �� 1_6 */

/* �ɼ��� �������� ���� ��� */
data saspgm.ex1_6_1;
infile "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\ex1-06.txt";
input (id name class type) ($5.);
run;

/* LRECL=n �ɼǰ� PAD �ɼ��� ����� ��� */
data saspgm.ex1_6_2;
infile "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\ex1-06.txt" lrecl=20 pad;
input (id name class type) ($5.);
run;

/* LRECL=n �ɼǰ� LINESIZE=n �ɼ��� ����� ��� */
data saspgm.ex1_6_3;
infile "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\ex1-06.txt" lrecl=20 linesize=10;
input (id name class type) ($5.);
run;

/* �� 1_7 */
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

/* �� 1_8 */
data saspgm.ex1_8;
retain y 0;
input x @@;
y=0.2*x+0.8*y;
cards;
1 2 3 4 5
;
run;

/* �� 1_9 */

/* retain�� ��� */
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

/* ���� retain�� ��� */
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

/* �� 1_10 */
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
array k[*] a1-a5; /* array k[5] a1-a5; ��� �Է��� �Ͱ� ���� */
	do i=1 to 5;
		if k[i]=. then delete;
	end;
drop i;
run;

/* ARRAY�� ����, NMISS �Լ��� ����� ��� */
data saspgm.ex1_10_2;
set saspgm.ex1_10;
if nmiss(of a1-a5)>0 then delete;
run;

/* �� 1_11 */
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

/* �� 1_12 */
data saspgm.ex1_12;
array names[*] $ n1-n9;
array caps[*] $ c1-c9;
input names[*]; /* input (n1-n9) $ �� �����ϴ� */
	do i=1 to 9;
		caps[i]=upcase(names[i]);
	end;
drop i;
cards;
smithers michaels gonzalez hurth frank bleigh rounder joseph peters
;
run;

/* �� 1_13 */
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


/********** 2�� �������� **********/

/* �� 2_1 */
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

/* 1. ���ΰ��� */
data saspgm.combine1;
set saspgm.ex2_1_1 saspgm.ex2_1_2;
run;

/* 2. SET���� ���� ���ΰ��� */
data saspgm.combine2;
set saspgm.ex2_1_1;
set saspgm.ex2_1_2;
run;

/* 3. MERGE���� ���� ���ΰ��� */
data saspgm.combine3;
merge saspgm.ex2_1_1 saspgm.ex2_1_2;
run;

/* 4. ���� �����ֱ� */
proc sort data=saspgm.ex2_1_3;
by a;
run;
data saspgm.combine4;
set saspgm.ex2_1_1 saspgm.ex2_1_3;
by a;
run;

/* 5. SET���� ���� ���� ���ΰ��� */
data saspgm.combine5;
set saspgm.ex2_1_1;
set saspgm.ex2_1_3;
by a;
run;

/* 6. MERGE���� ���� ���� ���ΰ��� */
data saspgm.combine6;
merge saspgm.ex2_1_1 saspgm.ex2_1_3;
by a;
run;

/* �� 2_2 */
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

/* �Ϲ� MERGE�� ��� */
data saspgm.merge1;
merge saspgm.master saspgm.transact;
by a;
run;

/* UPDATE���� ���� ���� */
data saspgm.update1;
update saspgm.master saspgm.transact;
by a;
run;

/* �� 2_3 */
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

/* �� 2_4 */
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

/* �ڵ������� ���� ���ο� ������ �����ϰ��� �� �� */
data saspgm.combine8;
set saspgm.ex2_4_1;
n=_N_;
error=_ERROR_;
run;

/* �� 2_5 */
proc means data=saspgm.ex2_4_1;
var a;
output out=sumout sum(a)=suma;
run;
data saspgm.rone;
if _N_=1 then set sumout(keep=suma);
set saspgm.ex2_4_1(keep=a);
ratio=a/suma;
run;

/* �� 2_6 */
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

/* �������� ���� */
proc sort data=saspgm.ex2_6_1;
by name;
run;
data saspgm.ex2_6_3;
set saspgm.ex2_6_1;
by name;
first=first.name;
last=last.name;
run;

/* �������� ���� */
proc sort data=saspgm.ex2_6_1;
by descending name;
run;
data saspgm.ex2_6_4;
set saspgm.ex2_6_1;
by descending name;
first=first.name;
last=last.name;
run;

/* �� 2_7 */
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

/* �� 2_8 */
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

/* �� 2_9 */
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

/* "END=������" �ɼ� ��� */
data saspgm.ex2_9_2(drop=i);
set saspgm.ex2_9_1 end=lastone;
output;
	if lastone then do;
		do i=1 to 5;
			a=a+1; b=b+2; output;
		end;
	end;
run;

/* "NOBS=������", "POINT=������" �ɼ� ��� */
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

/* ex) ¦����°�� �ش��ϴ� ��ü�� ���ʷ� 50���� �а����ϴ� ��� */
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

/* �� 2_10 */

/* ���� �ܼ��������� */
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

/* �� 2_11 */

/* �񺹿� �ܼ��������� */
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

/* �� 2_12 */
data saspgm.ex2_12;
length fname $ 20;
infile "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\ex2-12.txt"
		column=clength filename=fname length=length line=line;
input id $ name $ class $;
cl=clength;
fn=fname;
le=length;
li=line;
run;


/********** 3�� �������� **********/

/* �� 3_1 */
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

/* �� 3_2 */

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

/* �� 3_3 */
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
��
ö
 ��
#04
&33
# 4
;
run;
proc sort data=saspgm.char;
by string;
run;

/* �� 3_4 */
data saspgm.name;
length first $5 last $10 degree $4 full $30;
infile cards missover;
input last $ first $ degree $;
if degree=' ' | degree='Unkn'    /* if degree=' ' or degree='Unkn' ��� �ص� �ȴ� */ 
                  then full=first||last||'(unknown)';       /* '(unknown)' ó�� ���ں����� �ƴ� ���ڿ��� ����ϴ� ��쿡�� ' '�� ���ڿ��� �ݾ� �־�� �Ѵ� */
        else           full=first||last||'('||degree||')';    /* ' ( ' �� ' ) ' ó�� ���ں����� �ƴ� ���ڿ��� ����ϴ� ��쿡�� ' '�� ���ڿ��� �ݾ� �־�� �Ѵ� */
cards;
Minsu  Park
HyunHee  Lee  PhD
ChulSu  Kim  MD
Inho  Choi  Unkn
;
run;

/* �� 3_5 */
data saspgm.testcn;
input sale $9.;
fmtsale=input(sale, comma9.);
cards;
2,115,353
;
run;

/* �� 3_6 */
data saspgm.testcnc;
input ymd 8.;
fmtymd=put(ymd, $8.);
cyear=substr(fmtymd, 1, 4);
nyear=input(cyear, 4.);
cards;
20010304
;
run;

/* �� 3_7 */
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

/* �� 3_8 */
data saspgm.dept;
input name $6. +1 bdate date7. +1 hired mmddyy8.;
hiredate=hired+(365.25*3);
hireqtr=qtr(hiredate);
if hired > '01jan94'd then new='YES';
format bdate mmddyy8. hired yymmdd8. hiredate weekdate17.;
cards;
��ö�� 01jan60 09-15-90
�ֹ��� 05oct49 01-24-92
�̿��� 18mar88 10-10-93
���μ� 29feb80 05-29-94
;
run;

/* �� 3_9 */
data saspgm.ex3_9_a;
infile 'F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\sales.dat';
input id @8 saled @15 asd @23 ascost;
diff=asd-saled;
run;
proc print data=saspgm.ex3_9_a;
run;

data saspgm.ex3_9_b;
infile 'F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\sales.dat';
input id @8 saled yymmdd6. @15 asd yymmdd6. @23 ascost;
diff=asd-saled;
run;
proc print data=saspgm.ex3_9_b;
run;

/* �� 3_10 */
data saspgm.ex3_10;
infile 'F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\sales.dat';
input id @8 saled yymmdd6. @15 asd yymmdd6. @23 ascost;
diff=asd-saled;
format saled asd yymmdd8.;
run;
proc print data=saspgm.ex3_10;
run;

/* SAS ��¥ ���� ����� �Լ�(��¥�Լ�, Date Function) */

/* 1. MDY(month, day, yrea) �Լ� */
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

/* 2. TODAY() �Լ� */
data saspgm.todayex;
set saspgm.mdyex;
today=today();
diff=today-newdate;
format today newdate yymmdd10.;
run;
proc print data=saspgm.todayex;
run;

/* 3. YYQ(year, quarter) �Լ� */
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

/* �� 3_11 */
data saspgm.fct_ex;
set saspgm.ex3_10;
sale_day=day(saled);
sale_mon=month(saled);
saleyear=year(saled);
s_weekend=weekday(saled);
keep saled asd ascost sale_day sale_mon saleyear s_weekend;
format asd date7.;
run;

/* �� 3_12 */

/* INTNX �Լ��� ��� ex1 */
data saspgm.intnxex1;
date2=intnx('month', '05jan2000'd, 10);
date3=intnx('year', date2, 1);
format date2 date3 yymmdd10.;
run;
proc print data=saspgm.intnxex1;
run;

/* INTNX �Լ��� ��� ex2 */
data saspgm.intnxex2;
date1=intnx('year', '18mar96'd, 2);
date2=intnx('year', '18jan98'd, 0);
date3=intnx('month', '21feb98'd, -1);
date4=intnx('month', '31dec97'd, 1);
format date1-date4 yymmdd6.;
run;
proc print data=saspgm.intnxex2;
run;

/* �� 3_13 */
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

/* �� 3_14 */
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


/********** 5�� �������� **********/

libname sql 'F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\SQL';

/* 5.1 SQL ���ν����� ���� */
data sql.kbl1;
input team $ name $ posi $ backn score freeth freetry reb assist foul time;
cards;
��� ����       F  7 24 1  2  1 4 3 38
��� ������     F 10 22 7  8  8 2 2 36
��� ������     G  5 14 5  6  2 7 0 32
��� ����       C 22 27 5  9 19 1 4 35
�Ｚ ������     F 14 37 9 11  2 3 2 40
�Ｚ ��Ʈ����   C 55 45 5  9 14 1 4 40
���� ���α�     G  5 28 8 10  2 2 2 36
���� ������     G 15 11 1  1  2 2 5 38
���� ����       G  9 23 7  9  2 4 0 34
���� �̹���     F 14 14 2  3  3 3 0 36
���� �׷���     G  9 33 1  3 14 1 2 40
���� ����ö     F 13 16 3  6  8 1 2 32
;
run;

data sql.kbl2;
input name $ backn suc2p try2p suc3p try3p;
cards;
����        7 10 11 1  4
������     10  6 10 1  4
������      5  3  6 1  3
����       22 11 15 0  1
������     14  5 11 6 11
��Ʈ����   55 20 31 0  0
���α�      5  4  7 4 12
������     15  5  6 0  0
����        9  5  8 2  8
�̹���     14  3  6 2  5
�׷���      9 14 18 1  3
����ö     13  2  7 3  6
;
run;

data sql.kbl3;
input team $ name $ posi $ backnum score freeth freetry reb assist foul time;
cards;
��� ���̺�   F 44 21 1  2  7 2 1 35
��� ������     F 10 22 3  4  3 2 4 37
��� ����       G  9 24 4  4  7 2 3 38
��� �迵��     F 11 18 4  4  3 3 2 36
�Ｚ ������     F 14 16 9 11  5 4 2 40
�Ｚ ��Ʈ����   C 55 27 5  5 12 0 1 34
���� ������     F 13 18 3  3  6 1 3 27
���� ��������   C 22 22 1  4 16 1 3 38
���� ����       G  9 28 5 13  3 3 0 40
���� �̹���     F 14 21 1  1  5 0 3 38
���� �׷���     G  9 21 2  4  3 2 4 38
���� �躴ö     G 10 23 5  6  8 6 3 40
;
run;

/* SQL�� �̿� */
proc sql;
	select team, sum(score) as totscore from sql.kbl1
	where posi='G'
	group by team
	order by totscore;
run;

/* �Ϲ����� SAS ���α׷� ��� */
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

/* �� 5_1 */
proc sql;
	select * from sql.kbl1;
run;

proc sql;
	select team, posi from sql.kbl1;
run;

proc sql;
	select * from sql.kbl1(drop=assist);
run;

/* �� 5_2 */

/* distinct ��ɾ� ��� �� */
proc sql;
	select team, posi from sql.kbl1;
run;

/* distinct ��ɾ� ��� �� */
proc sql;
	select distinct team, posi from sql.kbl1;
run;

/* �� 5_3 */
title '������ ������';
proc sql;
	select name, freeth, (freeth/freetry)*100 as percent
	from sql.kbl1;
run;

/* �� 5_4 */

/* CALCULATED ��ɾ ��� */
title '������ �������� ���� ����';
proc sql;
	select name, freeth, (freeth/freetry)*100 as percent,
		case
			when calculated percent<60 then '****'
			else ' '
		end
	from sql.kbl1;
run;

/* CALCULATED ��ɾ ������� �ʰ�, �� �ڵ�� ���� ��� ����ϱ� */
title '������ �������� ���� ����';
proc sql;
	select name, freeth, (freeth/freetry)*100 as percent,
		case
			when (freeth/freetry)*100<60 then '****'
			else ' '
		end
	from sql.kbl1;
run;

/* �� 5_5 */
proc sql;
	select name, freeth, (freeth/freetry)*100 as percent
	format=4.1 label='�����'
	from sql.kbl1;
run;

/* �� 5_6 */
title '�����Ǻ� ���� ����';
proc sql;
	select name, posi, score from sql.kbl1
	order by posi, score;
run;

/* AS ��ɾ ������� �ʾƼ� �����̸��� �������� ���� ��쿡, �� ������ ���ؼ� �����ϰ��� �� �� */
proc sql;
	select name, freeth, (freeth/freetry)*100
	format=4.1 label='�����'
	from sql.kbl1
	order by 3;
run;

/* �� 5_7 */

/* "���"�� �����ִ� �Լ� */
select avg(freeth/freetry*100) as avgper
format=4.1 label='��� ������ ������'
from sql.kbl1;

/* "���� ��"�� �����ִ� �Լ� */
select count(*) label='���� ��' from sql.kbl1;

/* "�ּڰ�"�� "�ִ�"�� �����ִ� �Լ� */
select min(score) label='���� ����', 
		  max(score) label='�ְ� ����'
from sql.kbl1;

/* "�հ�"�� �����ִ� �Լ� */
select sum(score) label='�ѵ���' from sql.kbl1;

/* �� 5_8 */
proc sql;
title '�����Ǻ� ������ ������';
	select posi, avg(freeth/freetry*100) as avgper
	format=4.1 label='��� ������ ������'
	from sql.kbl1
	group by posi;

title '�����Ǻ� ���� ��';
select posi, count(posi) from sql.kbl1
group by posi;

/* �� 5_9 */
proc sql;
title '������ �������� ���� ��';
	select team, avg(freeth/freetry*100) as avgper
	format=4.1 label='������ ������' from sql.kbl1 
	group by team
	having avgper>70;
run;

proc sql;
title '������ ������ ������';
	select posi, name, avg(freeth/freetry*100) as avgper
	format=4.1 label='������ ������' from sql.kbl1
	where posi='G'
	order by avgper;
run;

proc sql;
title '������ ��� ������ �������� ���� ��';
	select team, avg(freeth/freetry*100) as avgper
	format=4.1 label='������ ������' from sql.kbl1
	where posi='G'
	group by team
	having avgper>70;
run;

/* �� 5_10 */

/* �� ���� ���̺� �ٷ��_INTERSECT ��ɾ� */
proc sql;
title '�� ��⿡ ��� ������ ����';
	select name from sql.kbl1
	intersect
	select name from sql.kbl3;
run;

/* �� ���� ���̺� �ٷ��_EXCEPT ��ɾ� */
proc sql;
title '12�� ��⿡�� ������ ����';
	select team, name from sql.kbl1
	except
	select team, name from sql.kbl3;
run;

/* �� ���� ���̺� �ٷ��_UNION ��ɾ� */
proc sql;
title '������ ���� ����';
	select team, name from sql.kbl1 where team='����'
	union
	select team, name from sql.kbl3 where team='����';
run;

/* �� 5_11 */
proc sql;
title '�� ����� ��� ����';
	select '12�� ���:', avg(score)
	format=5.2 label='��� ����' from sql.kbl1
	union
	select '2�� ���:', avg(score)
	format=5.2 label='��� ����' from sql.kbl3;
run;

/* �� 5_12 */
proc sql;
create table sql.fthrow as
	select posi, avg(freeth/freetry*100) as avgper
	format=4.1 label='������ ������'
	from sql.kbl1 group by posi;
select * from sql.fthrow;
run;

/* �̹� �����ϰ� �ִ� ���̺��� �����Ͽ� ���ο� �̸����� ������ �� */
create table sql.new1 as
	select * from sql.fthrow;

create table sql.new2 as
	select * from sql.kbl2(drop=backn);

/* ���̺� ��ü�� �����ϰ��� �� �� */
/* drop table sql.kbl2; ��� �ϸ� �ȴ�(sql.kbl2 ���̺��� ������� �ȵǹǷ�, �����Ű���� �ʰ� �ּ� �޾Ƴ��� ��) */


/* �� 5_13 */

/* sql.kbl1���� 4���� ���� �����Ͽ�, �������� ����(G)�� �������� ��� sql.score��� ���̺� ���� */
proc sql;
create table sql.score as 
	select team, name, posi, score
	from sql.kbl1 where posi='G';
select * from sql.score;
run;

/* INSERT INTO���� �̿��� �� ���� �ֱ� */
proc sql;
insert into sql.score
	select team, name, posi, score from sql.kbl1
	where team in ('����');
select * from sql.score;
run;

/* �� 5_14 */
proc sql;
insert into sql.score
	set team='����',
		 name='��������',
		 posi='C',
		 score=31;
select * from sql.score;
run;

/* �� 5_15 */
proc sql;
insert into sql.score
	values ('���', '������', 'F', 8)
	values ('���', '�迵��', 'F', 12);
select * from sql.score;

/* ���� ����_DELETE ��ɾ� */
/* delete from sql.kbl1 where team='���'; ��� �ϸ� �ȴ�(sql.kbl1�� ���� �����Ǹ� �ȵǹǷ�, �����Ű���� �ʰ� �ּ� �޾Ƴ��� ��) */


/* �� 5_16 */
proc sql;
update sql.score
	set score=score*1.5;
select * from sql.score;

/* �� 5_17 */
proc sql;
update sql.score
	set score=score+5
	where team in ('����');
update sql.score
	set score=score-5
	where team in ('����');
select * from sql.score;

/* WHERE ���� ���� �� ����� �ʿ䰡 �ִ� ���_CASE ��ɾ ��� */
proc sql;
update sql.score
	set score=score+
		case 
				when team in ('����') then 5
				when team in ('����') then -5
				else 0
		end;
run;

/* �� 5_18 */
proc sql;
alter table sql.kbl1
	add pof num label='������ ������' format 6.2;
select team, name, posi, score, pof
from sql.kbl1
where posi='G';

proc sql;
update sql.kbl1
	set pof=(freeth/freetry)*100;
select team, name, posi, score, pof
from sql.kbl1
where posi='G';

/* CREATE TABLE ���� ����Ͽ� ���ο� ���̺� ���� */
create table sql.pof as
	select team, name, posi, score, (freeth/freetry)*100 as pof
	label='������ ������' format 6.2
	from sql.kbl1
	where posi='G';
select * from sql.pof;

/* ���� ����_DROP ��ɾ� */
/* alter table sql.kbl1
	drop assist, foul; ��� �ϸ� �ȴ�(sql.kbl1�� ���� �����Ǹ� �ȵǹǷ�, �����Ű���� �ʰ� �ּ� �޾Ƴ��� ��) */


/* �� 5_19 */
proc sql;
create view sql.view1 as
	select team label='����',
		count(team) as number label='���� ��',
		sum(score) as tot label='�� ����',
		avg(score) as aos format=5.2 label='��� ����'
	from sql.kbl1
	group by team;
select * from sql.view1;

/* ��(view) �Ǵ� ���̺�(table)�� ���� Ȯ�ΰ� ����_DESCRIBE �� */
describe view sql.view1;
describe table sql.kbl1;

/* ������ ��(view)�� SAS ���α׷����� �ٸ� ������ ���ϰ� �����ϰ� ��� ���� */
proc means data=sql.view1 maxdec=2;
var tot aos;
run;

/* ��(view)�� �̿�� ������ �� :
���� ��ü�� �Ǵ� ���̺��� ������ ������ ��� �̹� ������ ��� �۵����� �ʴ´� */
proc sql;
create table sql.kbl1 as
	select team, name, posi
	from sql.kbl1;

proc means data=sql.view1 maxdec=2;
var tot aos;
run;

/* �� 5_20 */
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

/* �� 5_21 */
proc sql;
	select k1.name, k1.posi, k1.reb as reb1, k3.reb as reb2
	from sql.kbl1 as k1 left join sql.kbl3 as k3
	on k1.name=k3.name;

proc sql;
	select k1.name, k1.posi, k1.reb as reb1, k3.reb as reb2
	from sql.kbl1 as k1 left join sql.kbl3 as k3
	on k1.name=k3.name and k3.posi='G';

/* �� 5_22 */

/* ���â�� k1 ���̺��� name, posi, reb1�� k3 ���̺��� reb2�� ��� */
/* ��, k3.name�� �ֵ� ���� �ϴ� k1.name �������� ���� ��� */
proc sql;
	select k1.name, k1.posi, k1.reb as reb1, k3.reb as reb2
	from sql.kbl1 as k1 right join sql.kbl3 as k3
	on k1.name=k3.name;

/* ���â�� k3 ���̺��� name, posi, reb2�� k1 ���̺��� reb1�� ��� */
/* ��, k1.name=k3.name�� k3.name�� ��� */
proc sql;
	select k3.name, k3.posi, k3.reb as reb2, k1.reb as reb1
	from sql.kbl1 as k1 right join sql.kbl3 as k3
	on k1.name=k3.name;

/* �� 5_23 */
proc sql;
	select k1.name, k1.posi, k1.reb as reb1, k3.reb as reb2
	from sql.kbl1 as k1 full join sql.kbl3 as k3
	on k1.name=k3.name;

/* �� 5_24 */
proc sql;
	select k1.posi, k1.name, coalesce(k3.score, k1.score)
	label='�ֱ� ����'
	from sql.kbl1 as k1 left join sql.kbl3 as k3
	on k1.name=k3.name;


/********** 4�� �������� **********/

libname macro "F:\SAS ����\������ ���� SAS ��� ���α׷��� ������\macro";

/* �� 4_1 */
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

/* �� 4_2 */
%let fer=exchange;

proc print;
title "Foreign &fer rate";
run;

/* �� 4_3 */
%let plot=%str(
	proc plot data=macro.exchange;
	plot buying*selling;
	run;
	);

&plot /* plot�� ȣ���� ��쿡�� �����ݷ�(;)�� �ʿ䰡 ���� */

/* �� 4_4 */
%let var1=buying;
%let var2=selling;

%let plot=%str(
	proc plot data=macro.exchange;
	plot &var1*&var2;
	run;
	);

&plot

/* �� 4_5 */
data macro.bankdata;
input name $ bis bcredit per @@;
cards;
����  6.50 26232  7.0 ���  7.62 14512  4.8 ���� -2.70 30559 11.4
����  6.90 13224  3.6 ����  0.97 24040 10.3 ��ȯ  6.79 25176  5.7
����  9.78  8921  3.2 ���� 10.29  5887  2.0 ���� 10.29 11066  4.1
�ѹ�  8.57  3293  3.4 ��ȭ  5.34  6023  7.9 ����  4.54  2930  5.7
�뵿  2.98  4869  9.6 �ϳ�  9.29  2494  2.4 ����  9.32  2894  3.2
��ȭ  5.45  2283 4.5
;
run;

%let dsn=macro.bankdata;

%macro corr;
	proc corr data=&dsn;
	var bis per;
	run;
%mend corr;

%corr

/* �� 4_6 */
%macro plot2(var1, var2);
	proc plot data=macro.bankdata;
	plot &var1*&var2;
	run;
%mend plot2;

%plot2(bis, per)
%plot2(bis,bcredit)

/* �� 4_7 */
%macro plot3(var1=bis, var2=per);
	proc plot data=macro.bankdata;
	plot &var1*&var2;
	run;
%mend plot3;

%plot3 ()
%plot3
%plot3(var1=bis, var2=bcredit)

/* �� 4_8 */
options mlogic mprint;

%plot3(var1=bis, var2=bcredit)

options nomlogic nomprint;

/* �� 4_9 */
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

/* �� 4_10 */
%macro condi(index, var1, var2);
	%if &index=yes %then %data;
	%corr
%mend condi;

%condi(yes, bis, per)
%condi(no, bis, bcredit)

/* �� 4_11 */
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

/* �� 4_12 */
%macro names(name, no);
	%do n=1 %to &no;
		&name&n;
	%end;
%mend names;

data %names(data, 5);
	x=0;
run;

/* �� 4_13 */
%macro namesx(name, no);
	%do n=1 %to &no;
		&name.x&n
	%end;
%mend namesx;

data %namesx(data, 5);
	y=0;
run;

/* �� 4_14 */
%macro dountil(no);
	%put ��ũ�� ���� ��ȣ : &no;
	%do %until(&no>3);
		%put ***&no***; %let no=%eval(&no+1);
	%end;
	%put ��ũ�� �� ��ȣ : &no;
%mend dountil;

%dountil(2)
%dountil(5)

/* �� 4_15 */
%macro dowhile(no);
	%put ��ũ�� ���� ��ȣ : &no;
	%do %while(&no<3);
		%put ***&no***;
		%let no=%eval(&no+1);
	%end;
	%put ��ũ�� �� ��ȣ : &no;
%mend dowhile;

%dowhile(1)
%dowhile(5)

/* �� 4_16 */
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

/* �� 4_17 */
%let x=100;
%let y=&x+200; %put &y;
%let z=%eval(&x+200); %put &z;
%let z=%eval(2+3=5); %put &z;

/* �� 4_18 */
%let title=Bridge over troubled water;
%let b=%index(&title, b);
%put b�� &b ��°�� ��Ÿ����;

/* �� 4_19 */
%let IMF=International Monetary Fund;
%let BIS=Bank for International Settlements;
%let title=�ٽö���;
%put *%length(&IMF)* **%length(&BIS)** ***%length(&title)***;
%put *%length(&IMF &title)***;

/* �� 4_20 */
%let title1=Bridge over troubled water;
%let b=%scan(&title1, 3); %put &b;
%let title2=Bridge$over troubled$water;
%let b=%scan(&title2, 3); %put &b;
%let b=%scan(&title2, 3, $); %put &b;

/* %SUBSTR �Լ� ���� */
title "�������� : %substr(&sysday, 1, 3), &sysdate";
title "�������� : %substr(&sysday, 2, 4), &sysdate";

/* �� 4_21 */
%macro condi2(index, var1, var2);
	%if %upcase(&index)=YES %then %data;
	%corr
%mend condi2;

%condi2(yes, bis, per)
%condi2(YeS, bis, bcredit)
%condi2(yEs, bis, bcredit)

/* �� 4_22 */
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

/* �� 4_23 */
%let b1='�ش���׾���';
%let b2='�濵�����ǰ�';
%let b3='�濵������ġ';
data macro.new2;
set macro.bankdata;
	if bis>=8 then id='b1';
	else if 6<=bis<8 then id='b2';
	else id='b3';
trt=symget(id);
run;

proc print data=macro.new2;
run;

/* �� 4_24 */
%let b1='�ش���׾���';
%let b2='�濵�����ǰ�';
%let b3='�濵������ġ';
data macro.new3;
set macro.bankdata;
	if bis>=8 then x=symget('b1');
	else if 6<=bis<8 then x=symget('b2');
	else x=symget('b3');
run;

proc print data=macro.new3;
run;

/* �� 4_25 */
data macro.new4;
set macro.bankdata;
	if bis>=8 then trt='�ش���׾���';
	else if 6<=bis<8 then trt='�濵�����ǰ�';
	else trt='�濵������ġ';
run;

/* �� 4_26 */
%let b1='�ش���׾���';
%let b2='�濵�����ǰ�';
%let b3='�濵������ġ';
data macro.new5;
set macro.bankdata;
trt=symget('b'||left(_n_));
run;

proc print data=macro.new5;
run;

/* �� 4_27 */
data macro.bank2;
input name $ bis @@;
call symput('bis', bis);
call symput('name', name);
call symput('test', 'testing value');
cards;
���   7.62 ����  -2.70 ����   0.97 ����   9.78
;
run;

%put &bis;
%put &name;
%put &test;

/* �� 4_28 */
data macro.day;
input samil mmddyy.;
call symput('day', put(samil, worddate.));
cards;
030198
;
run;

%put &day;

/* �� 4_29 */
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

%correct(����);
proc print data=macro.ex4_29;
run;

/* �� 4_30 */
/* �߸��� SYMPUT �Լ��� ��� ���� */
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

%correct(����);

/* �� 4_31 */
data macro.char1;
input c $;
call symput('char', c);
cards;
��
;
run;

data macro.char2;
length newchar $ 5;
newchar="&char" || "��";
run;

proc print data=macro.char2;
run;

/* �� 4_32 */
