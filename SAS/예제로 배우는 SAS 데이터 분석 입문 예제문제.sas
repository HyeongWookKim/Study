libname sasadv "F:\SAS 독학\예제로 배우는 SAS 데이터 분석 입문 데이터";

/********** 2장 예제문제 **********/

/* 예 2_1 */
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

options ps=55 ls=65 nodate pageno=1;

proc univariate data=sasadv.cholest;
by gender;
var super age;
label super='콜레스테롤 과포화율' age='나이';
run;

/* 예 2_2 */
proc rank data=sasadv.cholest out=rankout ties=low;
where gender='F';
var super;
ranks r_super;
run;

proc sort data=rankout;
by r_super;
run;

proc print data=rankout;
var r_super super;
run;

/* 예 2_3 */
proc univariate data=sasadv.cholest;
by gender;
var super age;
output out=univ_out
mean=s_mean std=s_std a_std
pctlpts=33.3 66.6 pctlpre=s_p a_p;
label super='콜레스테롤 과포화율' age='나이';
run;

proc print data=univ_out;
run;

/* 예 2_4 */
proc univariate data=sasadv.cholest;
class gender;
histogram age / outhistogram=outhisto
						cfill=orange
						vaxis=0 to 40 by 5
						midpoints=10 to 80 by 10
						nrow=1 ncol=2;
run;

proc print data=outhisto label;
run;

/* 예 2_5 */
proc univariate data=sasadv.cholest plot;
by gender;
var age;
run;

/* 예 2_6 */
proc boxplot data=sasadv.cholest;
plot age*gender / boxstyle=skeletal
							boxwidth=20 hoffset=15;
plot age*gender / boxstyle=schematic
							boxwidth=20 hoffset=15;
run;

/* 예 2_7 */
data sasadv.score;
input dept $ gender $ age score @@;
cards;
Stat M 10 94   Stat F 10 96   Stat M 15 91   Stat M 15 86
Stat F 10 76   Stat M 20 88   Math M 20 71   Math F 20 66
Math M 15 81   Math F 10 77   Math F 15 55   Math F 20 78
;
run;

proc means data=sasadv.score;
class dept gender;
var age score;
run;

proc means data=sasadv.score maxdec=2 max min mean;
class dept gender;
var age score;
output out=scoreout 
mean(age score)=m_age m_score std(age score)=s_age s_score;
run;

proc print data=scoreout;
run;

/* 예 2_8 */
proc summary data=sasadv.score;
class dept gender;
var age score;
output out=n_score mean(age score)= ;
run;

proc print data=n_score;
run;

/* 예 2_9 */
proc freq data=sasadv.score;
tables dept gender dept*gender;
tables dept*gender / norow nopercent;
run;

/* 예 2_10 */
data sasadv.drink;
input age drink $ count @@;
cards;
18  A  10  19  A  13  20  A  12
18  B  14  19  B   7  20  B   4
18  C   2  19  C  10  20  C   6
18  D  12  19  D   8  20  D  10
;
run;

proc freq data=sasadv.drink;
weight count;
tables age age*drink / nocol nopercent;
run;


/********** 3장 예제문제 **********/

/* 예 3_1 */
data discrete;
a_1 = pdf('binomial', 1, 0.05, 100);
a_2 = cdf('binomial', 10, 0.05, 100);
b_1 = pdf('hyper', 0, 1000, 50, 10);
b_2 = cdf('hyper', 5, 1000, 50, 10) - cdf('hyper', 2, 1000, 50, 10);
c_1 = pdf('poisson', 1, 5);
c_2 = cdf('poisson', 10, 5);
run;

proc print data=discrete;
run;

data prob1;
a_2 = probbnml(0.05, 100, 10);
b_2 = probhypr(1000, 50, 10, 5) - probhypr(1000, 50, 10, 2);
c_2 = poisson(5, 10);
run;

proc print data=prob1;
run;

/* 예 3_2 */
data continue;
a_1 = cdf('normal', -1.6449, 0, 1);
a_2 = probit(0.05);
b_1 = cdf('t', 1.6449, 50) - cdf('t', -1.6449, 50);
b_2 = tinv(0.05, 50);
c_1 = 1 - cdf('chisquared', 1, 5);
c_2 = cinv(0.95, 5);
d_1 = cdf('f', 1, 3, 10);
d_2 = finv(0.05, 3, 10);
run;

proc print data=continue;
run;

data prob2;
a_1 = probnorm(-1.6449);
b_1 = probt(1.6449, 50) - probt(-1.6449, 50);
c_1 = 1 - probchi(1, 5);
d_1 = probf(1, 3, 10);
run;

proc print data=prob2;
run;


/********** 4장 예제문제 **********/

/* 예 4_1 */
data sasadv.csi;
input csi @@;
label csi='소비자 만족도 지수';
cards;
75 63 49 86 53 80 70 72 81 80 69 76 85 95 66 77 77 63 58 74
68 90 82 59 60
;
run;

proc univariate data=sasadv.csi cibasic alpha=0.05;
var csi;
run;

/* 예 4_2 */
proc means data=sasadv.csi mean std clm alpha=0.05;
var csi;
run;

/* 예 4_3 */
data sasadv.poll;
input yesno $ count;
cards;
YES  250
NO   150
;
run;

proc freq data=sasadv.poll order=data;
weight count;
exact binomial;
tables yesno / alpha=0.05;
run;

/* 예 4_4 */
proc ttest data=sasadv.csi h0=70;
var csi;
run;

/* 예 4_5 */
proc univariate data=sasadv.csi mu0=70 alpha=0.05 cibasic;
var csi;
run;

/* 예 4_6 */
data sasadv.goods;
input state $ count @@;
cards;
Poor  54     Good  346
;
run;

proc freq data=sasadv.goods order=data;
weight count;
exact binomial;
tables state / binomial(p=0.15) alpha=0.05;
run;


/********** 5장 예제문제 **********/

/* 예 5_1 */
data sasadv.edu;
input group score @@;
cards;
1 65  1 70  1 76  1 63  1 72  1 71  1 68  1 68
2 75  2 80  2 72  2 77  2 69  2 81  2 71  2 78
;
run;

proc ttest data=sasadv.edu cochran;
class group;
var score;
run;

/* 예 5_2 */
data sasadv.paired;
input id pretest posttest @@;
cards;
01 80 82  02 73 71  03 70 95  04 60 69  05 88 100
06 84 71  07 65 75  08 37 60  09 91 95  10 98  99
11 52 65  12 78 83  13 40 60  14 79 86  15 59  62
;
run;

proc ttest data=sasadv.paired;
paired pretest*posttest;
run;

/* 예 5_3 */
data sasadv.support;
input gender $ yesno $ count @@;
cards;
남자  YES  110   남자  NO   140
여자  YES  104   여자  NO    96
;
run;

proc freq data=sasadv.support order=data;
weight count;
tables gender*yesno / nocol nopercent chisq fisher;
run;

/* 예 5_4 */
data sasadv.mcpaired;
input pre $ post $ count @@;
cards;
YES  YES  63   YES  NO    4
NO   YES  21   NO   NO   12
;
run;

proc freq data=sasadv.mcpaired order=data;
weight count;
exact mcnem;
tables pre*post / nocol;
run;


/********** 6장 예제문제 **********/

/* 예 6_1 */
data sasadv.harvest;
input fertil $ yield @@;
cards;
F1 148 F1  76 F1 134 F1  98
F2 166 F2 153 F2 255
F3 264 F3 214 F3 327 F3 304
F4 335 F4 436 F4 423 F4 380 F4 465
;
run;

proc anova data=sasadv.harvest;
class fertil;
model yield=fertil;
means fertil / hovtest=bartlett;
means fertil / tukey cldiff alpha=0.10;
means fertil / tukey lines alpha=0.10;
run;

/* 예 6_2 */
data sasadv.prefer;
    do product = 'A1', 'A2', 'A3', 'A4';
        do customer = 1 to 5 by 1;
    input prefer @@;
    output;
        end;
    end;
cards;
5  7  9 10  8
2  3  4  5  2
4  7  6  5  7
6  4  2  2  1
;
run;

proc anova data=sasadv.prefer;
class product customer;
model prefer=product customer;
means product / duncan tukey alpha=0.10;
run;

/* 예 6_3 */
data sasadv.sales;
    do city = 'Lagre ', 'Middle', 'Small ';
        do design = 'A', 'B', 'C';
            do rep = 1, 2, 3;
                input sales @@;
                output;
            end;
        end;
    end;
cards;
23 20 21   22 19 20   19 18 21
22 20 19   24 25 22   20 19 22
18 18 16   21 23 20   20 22 24
;
run;

proc anova data=sasadv.sales;
class city design;
model sales=city design city*design;
means city design city*design;
run;

/* 예 6_4 */
proc summary data=sasadv.sales nway;
class city design;
var sales;
output out=meanout mean(sales)=mean;
run;

symbol1 i=join w=1 v=dot cv=black h=2;
symbol2 i=join w=1 v=circle cv=red h=2;
symbol3 i=join w=1 v=square cv=blue h=2;

proc gplot data=meanout;
plot mean*city=design;
run;

/* 예 6_5 */
data sasadv.ancova;
input group $ age score @@;
cards;
A 31 30 A 28  0 A 25 10 A 34 40 A 39 55
A 26 20 A 30 65 A 26  5 A 31 40 A 23  0
B 36 65 B 33 50 B 31 90 B 29 25 B 41 99
B 36 60 B 32 25 B 32 80 B 27  5 B 32 99
;
run;

proc glm data=sasadv.ancova;
class group;
model score=age group / solution;
run;

/* 예 6_6 */
proc ttest data=sasadv.ancova;
class group;
var score;
run;

/* 예 6_7 */
proc glm data=sasadv.ancova;
class group;
model score=age group age*group / solution;
run;


/********** 7장 예제문제 **********/

/* 예 7_1 */
data sasadv.student;
input age income expense @@;
cards;
25 170 67 28 177 62 20 165 53 16 150 48 19 160 58 21 160 59
22 173 60 16 169 57 20 169 70 19 170 71 20 179 63 26 180 75
23 174 82 16 179 60 25 189 82 17 169 74 30 180 77
;
run;

proc corr data=sasadv.student pearson spearman nosimple;
var age income expense;
run;

/* 예 7_2 */
data sasadv.satis;
input age age_level satis1 satis2 @@;
cards;
28  2   0  70  23  2   0  55  26  2   5  65  27  2   5  65
25  2  10  60  26  2  20  65  29  2  25  70  31  3  25  75
32  3  25  80  34  3  40  85  31  3  40  75  33  3  50  80
39  3  55  95  36  3  60  90  30  3  65  75  36  3  65  90
32  3  80  80  39  3  85  95  31  3  90  75  32  3  95  80
;
run;

/* 피어슨 상관계수 */
proc corr data=sasadv.satis;
var age satis1 satis2;
run;

/* 편상관계수 */
proc corr data=sasadv.satis nosimple;
var satis1 satis2;
partial age;
run;

/* 예 7_3 */
proc sort data=sasadv.satis;
by age_level;
run;

proc corr data=sasadv.satis nosimple;
var satis1 satis2;
by age_level;
run;

/* 예 7_4 */
data sasadv.alpha;
infile 'F:\SAS 독학\예제로 배우는 SAS 데이터 분석 입문 데이터\alpha.txt';
input q01-q10;
run;

proc corr data=sasadv.alpha nocorr alpha;
var q01 q02 q03;
run;

/* 예 7_5 */
proc corr data=sasadv.alpha nocorr alpha;
var q04 q05 q06 q07;
run;

/* 예 7_6 */
data sasadv.alpha2;
set sasadv.alpha;
q07=6-q07;
run;

proc corr data=sasadv.alpha2 nocorr alpha;
var q04 q05 q06 q07;
run;

/* 예 7_7 */
proc corr data=sasadv.alpha nocorr alpha;
var q08 q09 q10;
run;


/********** 8장 예제문제 **********/

/* 예 8_1 */
data sasadv.adsales;
input company adver sales @@;
cards;
01  11  23  02  19  32  03  23  36  04  26  46  05  56  93
06  62  99  07  29  49  08  30  50  09  38  65  10  39  70
11  46  71  12  49  89
;
run;

proc reg data=sasadv.adsales;
model sales=adver;
plot sales*adver;
run;

/* 예 8_2 */
proc reg data=sasadv.adsales;
model sales=adver / p clm;
run;

/* 예 8_3 */
proc reg data=sasadv.adsales graphics;
model sales=adver / r;
output out=regout student=std_r;
plot student.*adver;
run;

/* 예 8_4 */
proc univariate data=regout;
histogram std_r / normal(mu=est sigma=est)
							cfill=grey
							midpoint=-3 to 3 by 1;
inset normal(cvm cvmpval ad adpval);
run;

proc univariate data=regout;
probplot std_r / normal(mu=est sigma=est);
inset mean std;
run;

/* 예 8_5 */
proc reg data=sasadv.adsales;
model sales=adver / dw;
run;

/* 예 8_6 */
data sasadv.satisfac;
infile 'F:\SAS 독학\예제로 배우는 SAS 데이터 분석 입문 데이터\satisfaction.txt';
input id 3. x1 1. x2 1. x3 1. x4 1. y 1.;
label x1 = '디자인'
         x2 = '편리성'
         x3 = '성능'
         x4 = '견고성'
         y  = '구입의향';
run;

proc corr data=sasadv.satisfac;
var y x1-x4;
run;

proc reg data=sasadv.satisfac;
model y=x1-x4 / stb;
run;

/* 예 8_7 */
data sasadv.fitness;
input oxygen age weight runtime rstpulse runpulse maxpulse @@;
cards;
44.609 44 89.47 11.37 62 178 182  45.313 40 75.07 10.07 62 185 185
54.297 44 85.84  8.65 45 156 168  59.571 42 68.15  8.17 40 166 172
49.874 38 89.02  9.22 55 178 180  44.811 47 77.45 11.63 58 176 176
45.681 40 75.98 11.95 70 176 180  49.091 43 81.19 10.85 64 162 170
39.442 44 81.42 13.08 63 174 176  60.055 38 81.87  8.63 48 170 186
50.541 44 73.03 10.13 45 168 168  37.388 45 87.66 14.03 56 186 192
44.754 45 66.45 11.12 51 176 176  47.273 47 79.15 10.60 47 162 164
51.855 54 83.12 10.33 50 166 170  49.156 49 81.42  8.95 44 180 185
40.836 51 69.63 10.95 57 168 172  46.672 51 77.91 10.00 48 162 168
46.774 48 91.63 10.25 48 162 164  50.388 49 73.37 10.08 67 168 168
39.407 57 73.37 12.63 58 174 176  46.080 54 79.38 11.17 62 156 165
45.441 52 76.32  9.63 48 164 166  54.625 50 70.87  8.92 48 146 155
45.118 51 67.25 11.08 48 172 172  39.203 54 91.63 12.88 44 168 172
45.790 51 73.71 10.47 59 186 188  50.545 57 59.08  9.93 49 148 155
48.673 49 76.32  9.40 56 186 188  47.920 48 61.24 11.50 52 170 176
47.467 52 82.78 10.50 53 170 172
;
run;

proc reg data=sasadv.fitness;
model oxygen=age weight runtime rstpulse runpulse maxpulse
						/ selection=backward slstay=0.15;
run;

/* 예 8_8 */
data sasadv.multico;
input y x1 x2 x3 x4 @@;
cards;
4.00  4.00  4.00  4.00  4.00  4.00  4.00  4.00  3.00  3.50
4.00  4.00  3.00  4.50  4.00  4.00  4.00  4.00  3.00  3.50
5.00  5.00  5.00  4.00  4.50  4.00  4.00  5.00  3.00  3.50
4.00  4.00  4.00  3.00  3.50  5.00  5.00  4.00  4.00  4.50
4.00  4.00  4.00  3.50  4.00  4.00  4.00  5.00  3.00  3.50
3.00  4.00  4.00  3.00  3.50  4.00  3.00  3.00  3.00  3.00
4.00  4.00  4.00  4.00  4.00  4.00  4.00  4.00  3.00  3.50
4.00  4.00  4.00  3.00  3.50  4.00  4.00  3.00  2.50  3.00
4.00  4.00  3.00  3.00  3.50  4.00  4.00  5.00  5.00  4.50
5.00  4.00  4.00  5.00  4.50  5.00  5.00  4.00  4.00  4.50
;
run;

proc reg data=sasadv.multico;
model y=x1-x4 / vif collin;
run;

/* 예 8_9 */
proc reg data=sasadv.multico;
model y=x1 x3 / vif collin;
run;

/* 예 8_10 */
data sasadv.dummy;
input id y age region @@;
cards;
 1  46  21  1   2  39  21  3   3  62  21  3   4  38  21  2
 5  39  21  3   6  70  22  2   7  39  22  2   8  35  22  1
 9  41  22  3  10  41  23  2  11  50  23  1  12  71  23  2
13  66  23  3  14  38  24  1  15  68  24  3  16  44  24  3
17  43  24  2  18  44  25  2  19  46  25  3  20  53  25  1
21  41  26  1  22  71  26  3  23  46  26  2  24  76  26  2
25  57  27  1  26  49  28  2  27  58  28  1  28  74  28  3
29  45  28  1  30  48  30  1  31  53  30  2  32  77  30  3
33  79  30  2  34  85  31  2  35  50  31  1  36  56  32  2
37  81  32  3  38  53  33  1  39  88  33  2  40  60  34  2
41  86  35  3  42  93  36  2  43  63  36  2  44  58  36  1
45  64  37  2  46  64  40  1
;
run;

data sasadv.dummy1;
set sasadv.dummy;
d1=0; d2=0;
if region=1 then d1=1;
if region=2 then d2=1;
run;

proc reg data=sasadv.dummy1;
model y=age d1 d2;
run;

/* 예 8_11 */
data sasadv.mobile;
input year t yt @@;
yts=log(yt);
cards;
1984   1     27  1985   2     47  1986   3     71
1987   4    103  1988   5    204  1989   6    397
1990   7    800  1991   8   1662  1992   9   2719
1993  10   4718  1994  11   9600  1995  12  16410
1996  13  28900  1997  14  45700
;
run;

/* 데이터의 산점도 확인 */
proc gplot data=sasadv.mobile;
plot yt*t;
run;

/* 변수변환에 의한 곡선추정 */
proc reg data=sasadv.mobile;
model yts=t;
run;

/* 예 8_12 */
proc nlin data=sasadv.mobile;
parms m=100000 a=-5 b=0.5;
model yt=(m*exp(a+b*t)) / (1+exp(a+b*t));
run;


/********** 9장 예제문제 **********/

/* 예 9_1 */
data sasadv.soft;
input age $ beverage $ count @@;
cards;
20대 coke 10 20대 pepsi 14 20대 fanta  4 20대 others 12
30대 coke 13 30대 pepsi  9 20대 fanta 10 30대 others  8
40대 coke 12 40대 pepsi  8 20대 fanta 10 40대 others 10
;
run;

proc freq data=sasadv.soft order=data;
weight count;
exact fisher;
tables age*beverage / nocol nopercent expected chisq;
run;

/* 예 9_2 */
data sasadv.bean;
input type count @@;
cards;
1 315 2 108 3 101 4 32
;
run;

proc freq data=sasadv.bean;
weight count;
tables type / nocum testp=(0.5625 0.1875 0.1875 0.0625);
run;

/* 예 9_3 */
data sasadv.edueco;
input edu eco count @@;
cards;
1 1 255   1 2 105   1 3  81
2 1 110   2 2  92   2 3  66
3 1  90   3 2 113   3 3  88
;
run;

proc freq data=sasadv.edueco order=data;
weight count;
tables edu*eco / nocol nopercent chisq measures;
run;


/********** 10장 예제문제 **********/

/* 예 10_1 */
data sasadv.diff;
input diff @@;
cards;
-21.7  8.8  9.6  3.1  4.1  0.8
  1.8  3.3  0.7 10.3  1.4  2.5
;
run;

proc univariate data=sasadv.diff normal plot;
var diff;
run;

/* 예 10_2 */
proc univariate data=sasadv.cholest;
by gender;
probplot age / normal(mu=est sigma=est);
inset max min mean median std;
run;

proc univariate data=sasadv.cholest;
by gender;
qqplot age / normal(mu=est sigma=est);
inset max min mean median std;
run;

/* 예 10_3 */
proc univariate data=sasadv.cholest;
class gender;
histogram age / normal(mu=est sigma=est)
						outhistogram=outhisto
						cfill=orange
						vaxis=0 to 40 by 5
						midpoints=10 to 80 by 10;
inset normal(ksd ksdpval);
run;

proc univariate data=sasadv.cholest;
class gender;
qqplot age / normal(mu=est sigma=est) nrow=1 ncol=2;
inset mean std;
run;

/* 예 10_4 */
proc univariate data=sasadv.diff normal mu0=0;
var diff;
run;

/* 예 10_5 */
data sasadv.mice;
input drug $ days @@;
cards;
A  1  A  1  A  3  A  3  A  4
B  3  B  4  B  4  B 10  B 10  B 26
;
run;

proc npar1way data=sasadv.mice wilcoxon;
exact wilcoxon;
class drug;
var days;
run;

/* 예 10_6 */
data sasadv.perfume;
input company $ weight @@;
cards;
A 117.1 A 121.3 A 127.8 A 121.9
A 117.4 A 124.5 A 119.5 A 115.1
B 123.5 B 125.3 B 126.5 B 127.9
B 122.1 B 125.6 B 129.8 B 117.2
;
run;

proc npar1way data=sasadv.perfume AB;
exact AB;
class company;
var weight;
run;

/* 예 10_7 */
data sasadv.health;
input pre post @@;
diff=post-pre;
cards;
63.1 41.4 46.5 55.3 40.1 49.7 48.5 51.6
33.2 37.3 38.8 39.6 48.3 50.1 40.5 43.8
36.9 37.6 40.5 50.8 42.2 43.6 34.9 37.4
;
run;

proc univariate data=sasadv.health;
var diff;
run;

/* 예 10_8 */
data sasadv.fly;
input type $ effect @@;
cards;
A 72 A 65 A 67 A 75 A 62 A 73
B 55 B 59 B 68 B 70 B 53 B 50
C 64 C 74 C 61 C 58 C 51 C 69
;
run;

proc npar1way data=sasadv.fly wilcoxon;
exact wilcoxon;
class type;
var effect;
run;
