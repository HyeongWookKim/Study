libname sasadv "F:\SAS 독학\예제로 배우는 SAS 데이터 분석 입문 데이터";

/********** 2장 연습문제 **********/

/* ex2_1 */
data sasadv.cholest;
input gender $ age super @@;
cards;
M  23  40   M  64  88   M  66 110   M  31  86   M  55 137
M  48  78   M  58 111   M  31  88   M  27  80   M  25  86
M  20  80   M  32  47   M  63 106   M  23  65   M  62  74
M  43  66   M  43  79   M  36  58   M  67 123   M  27  87
M  29  88   M  48  90   M  63  56   M  27  73   M  19 112
M  59 110   M  65 118   M  26  52   M  53 106   M  42  67
M  60  57   F  30  66   F  25  69   F  40  65   F  38  52
F  57  84   F  33  86   F  23  35   F  42 116   F  49  76
F  35  55   F  49  73   F  44  89   F  50 127   F  60  87
F  63 142   F  47  77   F  23  76   F  27  58   F  36  91
F  48 107   F  23  98   F  74 128   F  44  84   F  56 146
F  53  75   F  37 120   F  41  80   F  41  82   F  57 123
;
run;
proc sort data=sasadv.cholest;
by gender;
run;
proc univariate data=cholest plot;
by gender;
var age super;
run;
proc boxplot data=sasadv.cholest;
plot age*gender;
plot super*gender;
run;

/* ex2_2 */
data sasadv.protein;
input ingest @@;
cards;
10.1   8.9  13.5   7.8   9.7  10.6   8.4   9.5  18.0  10.2
 5.3  13.9   9.0   9.5   9.4   6.9   6.2   6.2   7.1   9.9
13.1  17.4   9.3  11.4   4.4
;
run;

/* (가) */
proc univariate data=sasadv.protein;
var ingest;
run;

/* (나) */
proc univariate data=sasadv.protein plot;
var ingest;
run;

/* ex2_3 */
data sasadv.king;
input name $ age @@;
    if _N_<=14 then war='Before'; 
	else war='After';
    agegroup=INT(age/10)*10;
cards;
태조   73    정종   62   태종   45   세종   53   문종   38
단종   16    세조   51   예종   28   성종   37   연산군 30
중종   56    인종   30   명종   33   선조   56   광해군 66
인조   54    효종   40   현종   33   숙종   59   경종   36
영조   82    정조   48   순조   44   헌종   22   철종   32
고종   67    순종   52
;
run;

/* (가) */
proc sort data=sasadv.king;
by war;
run;
proc univariate data=sasadv.king plot;
by war;
var age;
run;

/* (나) */
proc means data=sasadv.king
max min median mean std;
class war;
output out=out2_3;
run;

/* (다) */
proc freq data=sasadv.king;
tables war agegroup war*agegroup;
run;

/* ex2_4 */
data sasadv.ex2_4;
input size $ 1-13 manufact $ 14-26 model $ 27-42 mileage 43-54 reliable 55-64 index;
cards;
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
run;

/* (가) */
proc means data=sasadv.ex2_4
mean std maxdec=3;
var mileage reliable;
output out=out2_4;
run;

/* (나) */
proc freq data=sasadv.ex2_4;
tables size index size*index;
run;

/* ex2_5 */

/* (가) */
proc freq data=sasadv.survey;
tables q1;
run;

/* (나) */
proc freq data=sasadv.survey;
tables q2;
run;
proc univariate data=sasadv.survey;
var q2;
histogram q2 / normal;
run;

/* (다) */
proc freq data=sasadv.survey;
tables q4_1 q4_2 q4_3 q4_4;
run;

/* (라) */
proc gchart data=sasadv.survey;
pie q4_1 q4_2 q4_3 q4_4;
run;

/* (마) */
proc means data=sasadv.survey mean;
class q4_1;
var q3_1 q3_2 q3_3 q3_4 q3_5;
run;
proc means data=sasadv.survey mean;
class q4_2;
var q3_1 q3_2 q3_3 q3_4 q3_5;
run;
proc means data=sasadv.survey mean;
class q4_3;
var q3_1 q3_2 q3_3 q3_4 q3_5;
run;
proc means data=sasadv.survey mean;
class q4_4;
var q3_1 q3_2 q3_3 q3_4 q3_5;
run;

/* ex2_6 */
data sasadv.ex2_6;
input cholest @@;
cards;
239 161 210 179 212 195 301 357 233 256 
234 195 199 284 245 174 310 286 176 212 
297 249 282 233 205 286 269 305 247 292
;
run;

/* (가) */
proc freq data=sasadv.ex2_6;
tables cholest;
run;
proc univariate data=sasadv.ex2_6;
var cholest;
histogram cholest / normal;
run;

/* (나) */
proc means data=sasadv.ex2_6
mean median var std;
var cholest;
run;

/* ex2_7 */
data sasadv.ex2_7;
input before after;
cards;
72    74
70    72
68    69
67    68
73    72
71    72
72    72
70    71
69    67
70    73
68    69
72    71
69    68
66    74
73    73
71    70
70    74
72    68
70    71
69    74
72    74
73    69
;
run;

/* (가), (나) */
proc freq data=sasadv.ex2_7;
tables before after;
run;
proc univariate data=sasadv.ex2_7;
var before after;
histogram before after / normal;
run;
proc means data=sasadv.ex2_7
mean median std;
var before after;
run;

/* ex2_8 */
data sasadv.ex2_8;
input date temp @@;
cards;
1 24 2 27 3 28 4 32 5 30 6 35 7 26 8 29 9 31 10 30
11 35 12 37 13 34 14 33 15 34 16 29 17 35 18 32 19 34 20 34
21 29 22 30 23 29 24 36 25 35 26 33 27 37 28 29 29 40 30 32
;
run;

/* (가) */
proc freq data=sasadv.ex2_8;
tables temp;
run;
proc univariate data=sasadv.ex2_8;
var temp;
histogram temp / normal;
run;

/* (나) */
proc sgplot data=sasadv.ex2_8;
series x=date y=temp;
run;

/* (다) */
proc means data=sasadv.ex2_8
mean median var std;
var temp;
run;

/* ex2_9 */
data sasadv.ex2_9;
input region $ carbon;
cards;
A     95
A     96
A     92
A    102
A    103
A     93
A    101
A     92
A     95
A     90
B    184
B    202
B    215
B    204
B    195
B    201
B    169
B    182
B    192
C    215
C    214
C    197
C    216
C    215
C    208
C    228
C    208
C    216
C    214
C    227
D    155
D    142
D    146
D    149
D    146
D    152
D    159
;
run;

/* (가), (나) */
proc freq data=sasadv.ex2_9;
tables carbon;
run;

proc sort data=sasadv.ex2_9;
by region;
run;
proc univariate data=sasadv.ex2_9;
by region;
var carbon;
histogram carbon / normal;
run;

proc means data=sasadv.ex2_9
mean median std;
class region;
var carbon;
run;


/********** 3장 연습문제 **********/

/* ex3_2 */

/* 복원추출인 경우 : 이항분포 사용 */
data sasadv.ex3_2_1;
a_1 = pdf('binomial', 10, 0.95, 10);
run;

proc print data=sasadv.ex3_2_1;
run;

/* 비복원추출인 경우 : 초기하분포 사용 */
data sasadv.ex3_2_2;
a_2 = pdf('hyper', 10, 1000, 950, 10);
run;

proc print data=sasadv.ex3_2_2;
run;

/* ex3_3 */

/* (가) */
data sasadv.ex3_3_1;
a_1 = 1 - cdf('normal', 180, 170, 5);
run;

proc print data=sasadv.ex3_3_1;
run;

/* (나) */
data sasadv.ex3_3_2;
a_2 = cdf('normal', 175, 170, 0.5);
run;

proc print data=sasadv.ex3_3_2;
run;

/* ex3_33 */

/* (나) */
data sasadv.ex3_33_1;
a_1 = 1 - cdf('normal', 0.4216, 0, 1);
run;

proc print data=sasadv.ex3_33_1;
run;

/* (다) */
data sasadv.ex3_33_2;
a_2 = 1 - cdf('normal', 2.1082, 0, 1);
run;

proc print data=sasadv.ex3_33_2;
run;


/********** 4장 연습문제 **********/

/* ex4_1 */
data sasadv.ex4_1;
input mileage @@;
cards;
21.0   22.7   25.8   20.6   18.5   21.4   19.3
17.6   22.7   20.6   17.9   18.3   24.7   23.3
24.3   21.5   20.0   19.8   22.9   19.9
;
run;
proc ttest data=sasadv.ex4_1 h0=20 alpha=0.05;
var mileage;
run;

/* ex4_2 */
data sasadv.deer;
input hindleg foreleg @@;
diff=hindleg-foreleg;
cards;
142 138   140 136   144 147   144 139   142 143
146 141   149 143   150 145   142 136   148 146
;
run;
proc univariate data=sasadv.deer normal plot;
var diff;
run;


/********** 5장 연습문제 **********/

/* ex5_1 */

/* (가), (나) */
data sasadv.ex5_1;
input grade $ score;
cards;
Good      0.58
Good      2.80
Good      2.77
Good      3.50
Good      2.67
Good      2.97
Good      2.18
Good      3.24
Good      1.49
Good      2.19
Good      2.70
Good      2.57
Bad       2.28
Bad       1.06
Bad       1.08
Bad       0.07
Bad       0.16
Bad       0.70
Bad       0.75
Bad       1.61
Bad       0.34
Bad       1.15
Bad       0.44
Bad       0.86
;
run;
proc ttest data=sasadv.ex5_1;
class grade;
var score;
run;

/* ex5_2 */
data sasadv.ex5_2;
input machine $ mercury;
cards;
A    0.95
A    0.82
A    0.78
A    0.96
A    0.71
A    0.86
A    0.99
B    0.89
B    0.91
B    0.94
B    0.91
B    0.90
B    0.89
;
run;
proc ttest data=sasadv.ex5_2 cochran;
class machine;
var mercury;
run;

/* ex5_3 */
data sasadv.ex5_3;
input raw roasted;
cards;
61   56
60   54
56   47
63   59
56   51
63   51
69   57
56   54
44   63
61   58
;
run;
proc ttest data=sasadv.ex5_3;
paired raw*roasted;
run;

/* ex5_4 */
data sasadv.ex5_4;
length contract $ 10.;
input insurance $ contract $ count @@;
cards;
A 총계약자 2350 A 계약파기자 580
B 총계약자 5210 B 계약파기자 1500
;
run;
proc freq data=sasadv.ex5_4 order=data;
weight count;
tables insurance*contract / nocol nopercent chisq fisher;
run;

/* ex5_5 */

/* (가), (나) */
data sasadv.ex5_5;
input method $ lifetime;
cards;
A    2.0
A    2.1
A    2.5
A    3.0
A    3.3
A    4.2
A    4.2
A    4.3
A    6.8
A    7.6
B    3.6
B    3.7
B    3.9
B    3.9
B    3.9
B    4.0
B    4.0
B    4.0
B    4.1
B    4.2
B    4.3
;
run;
proc ttest data=sasadv.ex5_5;
class method;
var lifetime;
run;

/* ex5_6 */
data sasadv.deer;
input hindleg foreleg @@;
diff=hindleg-foreleg;
cards;
142 138   140 136   144 147   144 139   142 143
146 141   149 143   150 145   142 136   148 146
;
run;
proc ttest data=sasadv.deer;
paired hindleg*foreleg;
run;

/* ex5_9 */
data sasadv.ex5_9;
input type $ crop;
cards;
A    31
A    34
A    29
A    26
A    32
A    35
A    38
A    34
A    30
A    29
A    32
A    31
B    26
B    24
B    28
B    29
B    30
B    29
B    32
B    26
B    31
B    29
B    32
B    28
;
run;
proc ttest data=sasadv.ex5_9;
class type;
var crop;
run;

/* ex5_10 */
data sasadv.ex5_10;
input type $ day @@;
cards;
post 4 post 6 post 8 post 3 post 3 post 7 post 4 post 5 post 9 post 10 post 9 post 7
comp 3 comp 4 comp 6 comp 2 comp 5 comp 8 comp 3 comp 5 comp 10 comp 9 comp 8 comp 5
;
run;
proc ttest data=sasadv.ex5_10;
class type;
var day;
run;

/* ex5_11 */
data sasadv.ex5_11;
input company $ content;
cards;
A    1
A    2
A    3
A    4
A    5
A    6
A    7
B    1
B    2
B    2
B    1
B    2
B    1
B    1
;
run;
proc ttest data=sasadv.ex5_11 cochran;
class company;
var content;
run;

/* ex5_12 */
data sasadv.ex5_12;
input pre post;
cards;
1.45      0.19
0.79      0.15
0.93      1.19
1.35      0.67
0.80      0.39
2.50      1.58
0.41      1.58
1.56      0.91
1.93      0.28
1.35      0.12
2.37      1.03
0.77      0.35
0.77      0.27
0.33      0.58
1.42      0.68
0.51      0.82
2.83      1.28
1.01      2.02
0.81      0.24
3.48      0.36
;
run;
proc ttest data=sasadv.ex5_12;
paired pre*post;
run;

/* ex5_13 */

/* (가), (나) */
data sasadv.ex5_13;
input group $ energy;
cards;
A    35.3
A    35.9
A    37.2
A    33.0
A    31.9
A    33.7
A    36.0
A    35.0
A    33.3
A    36.6
A    37.9
A    35.6
A    29.0
A    33.7
A    35.7
B    32.4
B    34.0
B    34.4
B    31.8
B    35.0
B    34.6
B    34.6
B    33.5
B    33.6
B    31.5
B    33.8
;
run;
proc ttest data=sasadv.ex5_13;
class group;
var energy;
run;


/********** 6장 연습문제 **********/

/* ex6_1 */
data sasadv.ex6_1;
input cotton $ tensile;
cards;
15%     7
15%     7
15%    15
15%    11
15%     9
20%    12
20%    17
20%    12
20%    18
20%    18
25%    14
25%    18
25%    18
25%    19
25%    19
30%    19
30%    25
30%    22
30%    19
30%    23
35%     7
35%    10
35%    11
35%    15
35%    11
;
run;
proc anova data=sasadv.ex6_1;
class cotton;
model tensile=cotton;
means cotton / tukey cldiff;
run;

/* ex6_2 */
data sasadv.ex6_2;
input type $ production @@;
cards;
A   67   A   72   A   75   A   42   A   53
B   72   B   52   B   63   B   55   B   48
C   60   C   82   C   65   C   77   C   75
D   48   D   61   D   57   D   64   D   50
E   64   E   65   E   70   E   68   E   53
;
run;
proc anova data=sasadv.ex6_2;
class type;
model production=type;
means type;
run;

/* ex6_3 */
data sasadv.ex6_3;
input concentration $ tensile;
cards;
A1    46.8
A1    58.0
A1    51.4
A1    61.0
A1    45.8
A2    51.2
A2    62.4
A2    30.6
A2    46.0
A2    48.8
A3    50.2
A3    38.2
A3    46.8
A3    26.7
A3    22.7
A4    21.4
A4    22.1
A4    28.2
A4    42.7
A4    25.2
;
run;
proc anova data=sasadv.ex6_3;
class concentration;
model tensile=concentration;
means concentration / tukey cldiff;
run;

/* ex6_4 */
data sasadv.ex6_4;
input ethanol $ blink @@;
cards;
0㎎ 86 0㎎ 79 0㎎ 73 0㎎ 72 0㎎ 89
1㎎ 57 1㎎ 70 1㎎ 57 1㎎ 55 1㎎ 54
2㎎ 50 2㎎ 43 2㎎ 47 2㎎ 49 2㎎ 42
3㎎ 30 3㎎ 38 3㎎ 27 3㎎ 38 3㎎ 38
;
run;
proc anova data=sasadv.ex6_4;
class ethanol;
model blink=ethanol;
means ethanol;
run;

/* ex6_5 */
data sasadv.ex6_5;
input board $ insect_num @@;
cards;
레몬색 45 레몬색 59 레몬색 48 레몬색 46 레몬색 38 레몬색 47
흰색   21 흰색   12 흰색   14 흰색   17 흰색   13 흰색   17
녹색   37 녹색   32 녹색   15 녹색   25 녹색   39 녹색   41
파란색 16 파란색 11 파란색 20 파란색 21 파란색 14 파란색  7
;
run;
proc anova data=sasadv.ex6_5;
class board;
model insect_num=board;
means board / cldiff;
run;

/* ex6_7 */
data sasadv.ex6_7;
input treatment $ obs;
cards;
T1     31
T1     20
T1     18
T1     17
T1      9
T1      8
T1     10
T1      7
T1    120
T1     15
T2     18
T2     17
T2     14
T2     11
T2     10
T2      7
T2      5
T2      6
T2     88
T2     11
;
run;
/* 독립표본 t-test */
proc ttest data=sasadv.ex6_7;
class treatment;
var obs;
run;
/* 일원배치 분산분석(One-way ANOVA) */
proc anova data=sasadv.ex6_7;
class treatment;
model obs=treatment;
means treatment / cldiff;
run;

/* ex6_8 */
data sasadv.ex6_8;
input method $ time @@;
cards;
A 55    B 61   C 42   D 168
A 49   B 113   C 97   D 137
A 42    B 30   C 81   D 169
A 21    B 89   C 95    D 85
A 22    B 63   C 92   D 154
;
run;
proc anova data=sasadv.ex6_8;
class method;
model time=method;
means method;
run;

/* ex6_9 */
data sasadv.ex6_9;
	do lab='A', 'B', 'C', 'D';
		do food='음식 1', '음식 2', '음식 3';
	input cholesterol @@;
	output;
		end;
	end;
cards;
3.4     2.6     2.8
3.0     2.7     3.1
3.3     3.0     3.4
3.5     3.1     3.7
;
run;
proc anova data=sasadv.ex6_9;
class lab food;
model cholesterol=lab food;
means food / duncan tukey alpha=0.05;
run;

/* ex6_10 */
data sasadv.ex6_10;
	do machine='A', 'B', 'C';
		do technician=1 to 3 by 1;
	input quality @@;
	output;
		end;
	end;
cards;
11  15  20
14  23  16
11  14  15
;
run;
proc anova data=sasadv.ex6_10;
class machine technician;
model quality=machine technician;
means machine;
run;

/* ex6_11 */
data sasadv.ex6_11;
input element level weight_plus;
cards;
1       1      73
1       1     102
1       1     118
1       1     104
1       1      81
1       1     107
1       1     100
1       1      87
1       1     117
1       1     111
2       1      98
2       1      74
2       1      56
2       1     111
2       1      95
2       1      88
2       1      82
2       1      77
2       1      86
2       1      92
3       1      94
3       1      79
3       1      96
3       1      98
3       1     102
3       1     102
3       1     108
3       1      91
3       1     120
3       1     105
1       2      90
1       2      76
1       2      90
1       2      64
1       2      86
1       2      51
1       2      72
1       2      90
1       2      95
1       2      78
2       2     107
2       2      95
2       2      97
2       2      80
2       2      98
2       2      74
2       2      74
2       2      67
2       2      89
2       2      58
3       2      49
3       2      82
3       2      73
3       2      86
3       2      81
3       2      97
3       2     106
3       2      70
3       2      61
3       2      82
;
run;
proc anova data=sasadv.ex6_11;
class element level;
model weight_plus=element level element*level;
means element level element*level;
run;
/* 평균 프로파일 도표(상호작용 효과 확인을 위해) */
proc summary data=sasadv.ex6_11 nway;
class element level;
var weight_plus;
output out=meanout6_11 mean(weight_plus)=mean;
run;

symbol1 i=join w=1 v=dot cv=black h=2;
symbol2 i=join w=1 v=circle cv=red h=2;
symbol3 i=join w=1 v=square cv=blue h=2;

proc gplot data=meanout6_11;
plot mean*element=level;
run;
/* 평균 프로파일 도표를 보면, 상호작용 효과가 존재한다고 나오는데..? 유의수준을 0.10으로 두고 해석해야하나..? */

/* ex6_12 */
data sasadv.ex6_12;
	do cure='A', 'B', 'C';
		do trt='X', 'Y';
	input value @@;
	output;
		end;
	end;
cards;
11   6   6   0  16  13
 8   0   6   2  13  10
 5   2   7   3  11  18
14   8   8   1   9   5
19  11  18  18  21  23
 6   4   8   4  16  12
10  13  19  14  12   5
 6   1   8   9  12  16
11   8   5   1   7   1
 3   0  15   9  12  20
 ;
run;
 /* 보기 쉽게 정렬 */
proc sort data=sasadv.ex6_12 out=sasadv.ex6_12_1;
by cure;
run;
proc sort data=sasadv.ex6_12_1 out=sasadv.ex6_12_2;
by trt;
run;
 
/* (가) */
/* 반응변수를 처리 후의 수치(Y)로 하기 위한 데이터 전처리 */
data sasadv.ex6_12_Y;
set sasadv.ex6_12;
if trt='X' then delete;
rename trt=trt_Y value=value_Y;
run;

proc anova data=sasadv.ex6_12_Y;
class cure;
model value_Y=cure;
means cure / tukey alpha=0.05 cldiff;
run;

/* (나) */
/* 데이터 전처리 */
data sasadv.ex6_12_X;
set sasadv.ex6_12;
if trt='Y' then delete;
rename trt=trt_X value=value_X;
run;

proc sort data=sasadv.ex6_12_X;
by cure;
run;
proc sort data=sasadv.ex6_12_Y;
by cure;
run;

data sasadv.n_ex6_12;
merge sasadv.ex6_12_X sasadv.ex6_12_Y;
by cure;
run;
/* 기울기의 동일성에 대한 검정 */
proc glm data=sasadv.n_ex6_12;
class trt;
model value_Y=value_X trt value_X*trt / solution;
run;
/* 공분산분석 */
proc glm data=sasadv.ex6_12;
class trt cure;
model value=trt cure trt*cure / solution;
run;


/********** 7장 연습문제 **********/

/* ex7_1 */
data sasadv.ex7_1;
input x y @@;
cards;
23.1  10.5  37.9  22.8  39.5  23.1
32.8  16.7  30.5  14.1  24.2  12.4
31.8  18.2  25.1  12.9  52.5  24.9
32.0  17.0  12.4   8.8  21.1  10.5
30.4  16.3  35.1  17.4  27.6  16.1
24.0  10.5  31.5  14.9
;
run;

/* (가) */
proc gplot data=sasadv.ex7_1;
plot y*x;
run;

/* (나), (다) */
proc corr data=sasadv.ex7_1
pearson spearman kendall;
var x y;
run;

/* ex7_2 */
data sasadv.ex7_2;
input x y;
cards;
1  4
2  1
3  0
4  1
5  4
;
run;

/* (가), (나), (다) */
proc gplot data=sasadv.ex7_2;
plot y*x;
run;
proc corr data=sasadv.ex7_2 pearson;
var x y;
run;

/* (라) */
proc corr data=sasadv.ex7_2 spearman;
var x y;
run;

/* ex7_3 */
data sasadv.ex7_3;
input inject time;
cards;
1    3.5
3    2.4
4    2.1
7    1.3
9    1.2
12   2.2
13   2.6
14   4.2
;
run;

/* (가) */
proc corr data=sasadv.ex7_3 pearson;
var inject time;
run;

/* (나) */
proc gplot data=sasadv.ex7_3;
plot time*inject;
run;

/* ex7_4 */
data sasadv.ex7_4;
input x y @@;
cards;
45  30  37  55  22  28
43  52  34  25  58  44
46  45  30  30  60  61
49  38  31  40  52  58
50  62  27  45  26  17
;
run;

/* (가) */
proc gplot data=sasadv.ex7_4;
plot y*x;
run;
proc corr data=sasadv.ex7_4 pearson;
var x y;
run;

/* (나) */
data sasadv.n_ex7_4;
set sasadv.ex7_4;
if x>=27 & x<=37 then delete;
run;
proc gplot data=sasadv.n_ex7_4;
plot y*x;
run;
proc corr data=sasadv.n_ex7_4 pearson;
var x y;
run;

/* ex7_5 */
data sasadv.ex7_5;
input q1-q10;
cards;
2     1     5     2     4     2     3     5     5     2
1     1     2     4     2     1     2     2     4     4
2     2     3     3     3     1     1     2     4     2
4     4     4     1     5     5     5     4     1     1
1     2     5     1     5     2     1     5     5     1
5     5     1     5     1     4     5     2     2     5
5     5     5     1     4     4     5     5     1     1
1     1     3     4     3     1     2     3     4     3
3     3     4     2     5     3     3     5     4     2
5     4     1     4     2     5     5     1     1     5
4     5     4     1     5     4     4     5     2     1
2     2     5     1     4     4     4     5     3     1
3     4     5     2     5     3     3     4     3     2
2     2     2     5     2     1     1     2     5     5
4     3     4     2     4     4     4     5     4     1
5     4     1     4     1     5     5     1     1     5
5     5     3     2     2     4     4     3     1     3
4     5     2     5     1     5     5     1     2     5
3     3     2     5     2     3     3     2     3     4
;
run;
proc corr data=sasadv.ex7_5 nocorr alpha;
var q3 q4 q5 q8 q10;
run;
proc corr data=sasadv.ex7_5 nocorr alpha;
var q1 q2 q6 q7 q9;
run;

/* "q9" 에 대한 질문 순서 수정 후, 신뢰도 분석 */
data sasadv.n_ex7_5;
set sasadv.ex7_5;
q9=6-q9;
run;
proc corr data=sasadv.n_ex7_5 nocorr alpha;
var q1 q2 q6 q7 q9;
run;


/********** 8장 연습문제 **********/

/* ex8_1 */
data sasadv.ex8_1;
input x y @@;
cards;
0.150      0.154      0.090      0.082      0.110      0.078
0.100      0.085      0.090      0.072      0.120      0.097
0.900      0.079      0.090      0.080      0.100      0.088
0.140      0.144      0.095      0.090      0.060      0.053
0.080      0.078      0.040      0.050      0.080      0.072
;
run;
proc corr data=sasadv.ex8_1;
var y x;
run;
proc reg data=sasadv.ex8_1;
model y=x / r dw;
output out=regout8_1 student=std_r8_1;
plot y*x;
plot student.*x;
run;

/* 표준화잔차에 대한 히스토그램 및 정규확률도표 */
proc univariate data=regout8_1;
histogram std_r8_1 / normal(mu=est sigma=est)
								cfill=grey
								midpoint=-3 to 3 by 1;
inset normal(cvm cvmpval ad adpval);
run;
proc univariate data=regout8_1;
probplot std_r8_1 / normal(mu=est sigma=est);
inset mean std;
run;

/* ex8_2 */

/* 전진선택법 */
proc reg data=sasadv.satisfac;
model y=x1 x2 x3 x4 / selection=forward;
run;

/* 후진제거법 */
proc reg data=sasadv.satisfac;
model y=x1 x2 x3 x4 / selection=backward;
run;

/* 단계적 선택법 */
proc reg data=sasadv.satisfac;
model y=x1 x2 x3 x4 / selection=stepwise;
run;

/* ex8_3 */
data sasadv.ex8_3;
input x1 x2 x3 x4 y;
cards;
21   1  71.0  12.7  170
22   6  56.5   8.0  120
24   5  56.0   4.3  125
24   1  61.0   4.3  148
25   1  65.0  20.7  140
27  19  62.0   5.7  106
28   5  53.0   8.0  120
28  25  53.0   0.0  108
31   6  65.0  10.0  124
32  13  57.0   6.0  134
33  13  66.5   8.3  116
33  10  59.1  10.3  114
34  15  64.0   7.0  130
35  18  69.5   7.0  118
35   2  64.0   6.7  138
36  12  56.5  11.7  134
36  15  57.0   6.0  120
37  16  55.0   7.0  120
37  17  57.0  11.7  114
38  10  58.0  13.0  124
38  18  59.5   7.7  114
38  11  61.0   4.0  136
38  11  57.0   3.0  126
39  21  57.5   5.0  124
39  24  74.0  15.7  128
39  14  72.0  13.3  134
41  25  62.5   8.0  112
41  32  68.0  11.3  128
41   5  63.4  13.7  134
42  12  68.0  10.7  128
43  25  69.0   6.0  140
43  26  73.0   5.7  138
43  10  64.0   7.0  118
44  19  65.0   7.7  110
44  18  71.0   4.3  142
45  10  60.2   3.3  134
47   1  55.0   4.0  116
50  43  70.0  11.7  132
54  40  87.0  11.3  152
;
run;

/* 다중공선성 진단 */
proc corr data=sasadv.ex8_3;
var y x1 x2 x3 x4;
run;
proc reg data=sasadv.ex8_3;
model y=x1 x2 x3 x4 / r dw vif collin;
run;

/* 변수선택 - 단계적 선택법(x2, x3 선택됨) */
proc reg data=sasadv.ex8_3;
model y=x1 x2 x3 x4 / selection=stepwise;
run;
proc reg data=sasadv.ex8_3;
model y=x2 x3 / r dw;
run;

/* ex8_5 */
data sasadv.ex8_5;
input IQ score;
cards;
100    3.0
120    3.8
110    3.1
105    2.9
 85    2.6
 95    2.9
130    3.6
100    2.8
105    3.1
 90    2.4
;
run;

/* (가), (나), (다), (라), (마) */
proc reg data=sasadv.ex8_5;
model score=IQ / p cli clb stb; /* stb : 회귀계수들에 대한 95% 신뢰구간 출력 */
plot score*IQ;
run;

/* ex8_6 */
data sasadv.ex8_6;
input x y;
cards;
1.89    1.83
1.77    1.77
1.71    1.67
1.74    1.80
1.92    1.86
1.83    1.77
1.77    1.74
1.77    1.80
1.77    1.74
;
run;

/* (가) */
proc gplot data=sasadv.ex8_6;
plot y*x;
run;

/* (나), (다), (라) */
proc reg data=sasadv.ex8_6;
model y=x / p cli stb;
plot y*x;
run;

/* (마) */
proc corr data=sasadv.ex8_6;
var y x;
run;

/* ex8_7 */
data sasadv.ex8_7;
input ver math gpa;
cards;
623    509    2.6
593    611    2.8
584    738    3.0
669    701    2.9
578    635    2.9
520    583    2.8
578    614    3.0
695    634    3.3
613    693    2.3
726    800    3.9
490    701    1.2
537    681    2.1
558    602    2.3
578    665    3.0
646    573    2.0
557    674    3.2
597    602    2.4
669    653    2.0
519    529    3.0
653    668    2.8
;
run;

/* 다중공선성 진단 */
proc corr data=sasadv.ex8_7;
var gpa ver math;
run;
proc reg data=sasadv.ex8_7;
model gpa=ver math / dw vif collin;
plot gpa*ver gpa*math;
run;

/* 변수선택 - 단계적 선택법(ver만 선택됨) */
proc reg data=sasadv.ex8_7;
model gpa=ver math / selection=stepwise;
run;
proc reg data=sasadv.ex8_7;
model gpa=ver / dw vif collin;
run;

/* ex8_8 */
data sasadv.ex8_8;
input y y_hat;
x+1; /* x는 연도를 코드화 한 것 */
cards;
309.9    283.1
323.7    301.9
324.1    320.6
355.3    339.4
383.4    358.2
395.1    376.9
412.8    395.7
407.0    414.5
438.0    433.2
446.1    452.0
452.5    470.8
447.3    489.5
475.9    508.3
487.7    527.1
497.2    545.8
529.8    564.6
551.0    583.4
581.1    602.1
617.8    620.9
658.1    639.7
675.2    658.4
706.6    677.2
725.6    696.0
722.5    714.7
745.4    733.5
790.7    752.3
;
run;
proc corr data=sasadv.ex8_8;
var y x;
run;
proc reg data=sasadv.ex8_8;
model y=x / dw;
output out=regout8_8 student=std_r8_8;
plot student.*x y*x;
run;

/* ex8_9 */

/* 1. 가변수를 직접 생성해서 분석 */
data sasadv.dummy2;
set sasadv.dummy;
d1=0; d2=0;
if region=1 then d1=1;
if region=2 then d2=1;
z1=d1*age; z2=d2*age;
run;
proc reg data=sasadv.dummy2;
model y=age d1 d2 z1 z2;
run;

/* 2. 가변수를 직접 생성하지 않고, 'GLM 프로시저'로 분석 */
proc glm data=sasadv.dummy2;
class region;
model y=age region age*region / solution;
run;

/* <예 8.10>과 동일한 결과를 얻기 위해서 수정된 'GLM 프로시저' */
proc glm data=sasadv.dummy2;
class region;
model y=age region / solution;
run;


/********** 9장 연습문제 **********/

/* ex9_1 */
data sasadv.ex9_1;
input claim count fx;
cards;
0  22  0.135
1  53  0.271
2  58  0.271
3  39  0.180
4  20  0.090
5   8  0.053
;
run;
proc freq data=sasadv.ex9_1;
weight count;
tables claim / nocum testp=(0.135 0.271 0.271 0.180 0.090 0.053);
run;

/* ex9_2 */
data sasadv.ex9_2;
input region $ refrigerator $ count @@;
cards;
서울 A 48 서울 B 42
충청도 A 43 충청도 B 49
전라도 A 65 전라도 B 53
경상도 A 59 경상도 B 76
;
run;
proc freq data=sasadv.ex9_2 order=data;
weight count;
tables region*refrigerator / nocol nopercent chisq;
run;

/* ex9_3 */
data sasadv.ex9_3;
input region $ candidate $ count @@;
cards;
서울 노태우 1683 서울 김영삼 1637 서울 김대중 1833 서울 김종필 461
부산 노태우 641 부산 김영삼 1117 부산 김대중 182 부산 김종필 52
대구 노태우 800 대구 김영삼 275 대구 김대중 30 대구 김종필 23
인천 노태우 326 인천 김영삼 249 인천 김대중 177 인천 김종필 76
광주 노태우 23 광주 김영삼 2 광주 김대중 450 광주 김종필 1
;
run;
proc freq data=sasadv.ex9_3 order=data;
weight count;
tables region*candidate / nocol nopercent chisq measures;
run;

/* ex9_4 */
data sasadv.ex9_4;
length rank $10; /* rank 변수의 최대치 길이가 '8'인데 '10'으로 늘려줌. 이때 중요한 건, length 명령문의 위치(input 명령문 위에 위치)이다 */
input rank $ plan $ count @@;
cards;
Clerical A 140 Clerical B 40 Clerical C 20
Executive A 70 Executive B 20 Executive C 10
Factory A 160 Factory B 30 Factory C 10
Supervisor A 80 Supervisor B 10 Supervisor C 10
;
run;

/* (다) */
proc freq data=sasadv.ex9_4 order=data;
weight count;
tables rank*plan / nocol nopercent chisq;
run;

/* (라) */
proc freq data=sasadv.ex9_4 order=data;
weight count;
tables rank*plan / nocol nopercent chisq cellchi2 expected;
run;

/* (마) */
proc freq data=sasadv.ex9_4 order=data;
weight count;
tables rank*plan / nocol nopercent chisq measures;
run;

/* ex9_5 */
data sasadv.ex9_5;
input color $ count @@;
cards;
흰색 69 상아색 75 올리브색 67 회색 49
;
run;
proc freq data=sasadv.ex9_5;
weight count;
tables color / nocum testp=(0.2654 0.2885 0.2577 0.1885);
run;

/* ex9_6 */
data sasadv.ex9_6;
input vegetable $ pollution $ count @@;
cards;
양상추 심각 32 양상추 보통 8
시금치 심각 28 시금치 보통 12
토마토 심각 19 토마토 보통 21
;
run;
proc freq data=sasadv.ex9_6 order=data;
weight count;
tables vegetable*pollution / nocol nopercent chisq;
run;

/* ex9_7 */
data sasadv.ex9_7;
input entrance $ count @@;
cards;
A 238 B 216 C 302 D 294 E 199
;
run;
proc freq data=sasadv.ex9_7;
weight count;
tables entrance / nocum testp=(0.1906 0.1729 0.2418 0.2354 0.1593);
run;

/* ex9_8 */
data sasadv.ex9_8;
input sex $ grade $ count @@;
cards;
여학생 A 19 여학생 B 44 여학생 C 13 여학생 D 3
남학생 A 19 남학생 B 58 남학생 C 31 남학생 D 13
;
run;
proc freq data=sasadv.ex9_8 order=data;
weight count;
tables sex*grade / nocol nopercent chisq measures;
run;

/* ex9_9 */
data sasadv.ex9_9;
input region $ income $ count @@;
cards;
도시 상 76 도시 중상 53 도시 중하 59 도시 하 48
농촌 상 124 농촌 중상 147 농촌 중하 141 농촌 하 152
;
run;
proc freq data=sasadv.ex9_9 order=data;
weight count;
tables region*income / nocol nopercent chisq measures;
run;


/********** 10장 연습문제 **********/

/* ex10_1 */
data sasadv.ex10_1;
input Zn @@;
cards;
437 358  72  43 107 223  60  72  54  35  70  20  34  24  24  51  23
;
run;
proc univariate data=sasadv.ex10_1 normal plot;
var Zn;
run;

/* ex10_2 */
data sasadv.ex10_2;
input paint $ time;
cards;
Old    6.6
Old    5.8
Old    7.8
Old    5.7
Old    6.0
Old    8.4
Old    8.8
Old    8.4
Old    7.3
Old    5.8
Old    5.8
Old    6.5
New    6.4
New    5.8
New    7.4
New    5.5
New    6.3
New    7.8
New    8.6
New    8.2
New    7.0
New    4.9
New    5.9
New    6.5
;
run;

/* 데이터의 정규성 검정 */
proc univariate data=sasadv.ex10_2 normal plot;
class paint;
var time;
run;

/* 1. t-test */
proc ttest data=sasadv.ex10_2 cochran;
class paint;
var time;
run;

/* 2. rank-sum test */
proc npar1way data=sasadv.ex10_2 wilcoxon;
exact wilcoxon;
class paint;
var time;
run;

/* ex10_3 */
proc npar1way data=sasadv.ex10_2 AB;
exact AB;
class paint;
var time;
run;

/* ex10_4 */
data sasadv.ex10_4;
input group $ score @@;
cards;
A 772  A 764  A 600  A  564
B 792  B 612  B 592  
C 752  C 680  C 624  C  580  C 572
;
run;

/* 1. 일원분류 분산분석 */
proc anova data=sasadv.ex10_4;
class group;
model score=group;
means group / hovtest=bartlett;
run;

/* 2. Kruskal-Wallis test */
proc npar1way data=sasadv.ex10_4 wilcoxon;
exact wilcoxon;
class group;
var score;
run;
