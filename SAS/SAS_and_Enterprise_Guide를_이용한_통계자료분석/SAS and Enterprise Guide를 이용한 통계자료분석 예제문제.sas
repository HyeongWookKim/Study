libname saseg "F:\SAS 독학\SAS and Enterprise Guide를 이용한 통계자료분석\dataset";

/********** 8장 예제문제 **********/

/* ex8_1 */
proc glm data=saseg.cures;
class drug disease;
model y=drug disease drug*disease / ss1 ss2 ss3;
run; quit;

/* ex8_2 */
proc glm data=saseg.drugtest;
class drug;
model y=x drug / solution;
lsmeans drug / pdiff;
run; quit;

/* ex8_3 */
proc glm data=saseg.repeat;
class group;
model pretest posttest=group;
repeated time 2 (0 1);
run; quit;

/* ex8_4 */
data saseg.dogs;
input drug $ depl $ hist0 hist1 hist3 hist5 @@;
lhist0=log(hist0); 
lhist1=log(hist1);
lhist3=log(hist3);
lhist5=log(hist5);
cards;
MORPHINE N .04 .20 .10 .08 MORPHINE N .02 .06 .02 .02
MORPHINE N .07 1.40 .48 .24 MORPHINE N .17 .57 .35 .24
MORPHINE Y .10 .09 .13 .14 MORPHINE Y .12 .11 .10 .  
MORPHINE Y .07 .07 .06 .07 MORPHINE Y .05 .07 .06 .07
TRIMETH N .03 .62 .31 .22 TRIMETH N .03 1.05 .73 .60
TRIMETH N .07 .83 1.07 .80 TRIMETH N .09 3.13 2.06 1.23
TRIMETH Y .10 .09 .09 .08 TRIMETH Y .08 .09 .09 .10
TRIMETH Y .13 .10 .12 .12 TRIMETH Y .06 .05 .05 .05
;
run;
proc glm data=saseg.dogs;
class drug depl;
model lhist0--lhist5=drug depl drug*depl / nouni;
repeated time 4 (0 1 3 5) polynomial / printe summary;
run; quit;

/********** 9장 예제문제 **********/

/* ex9_1 */
proc freq data=saseg.survival order=data;
weight count;
tables hosp surv hosp*surv / nocol nocum expected chisq measures;
run;

/* ex9_2 */
data saseg.marriage;
length educ $10;
input educ $ mstatus $ count @@;
cards;
COLLEGE POOR 72 COLLEGE GOOD 112 COLLEGE EXCEL 245
HIGH POOR 65 HIGH GOOD 90 HIGH EXCEL 120
MIDDLE POOR 95 MIDDLE GOOD 103 MIDDLE EXCEL 98
;
run;
proc freq data=saseg.marriage;
weight count;
tables educ*mstatus / nocol nocum nopercent expected chisq;
run;

/* ex9_3 */
proc catmod data=saseg.survival;
weight count;
model hosp*surv=_response_ / ml nogls pred=freq;
loglin hosp|surv;
run;
loglin hosp surv;
run;
quit;

/* ex9_4 */
proc catmod data=saseg.survival2;
weight count;
model hosp*surv*cond=_response_ / ml nogls pred=freq;
loglin hosp|surv hosp|cond surv|cond;
run;
loglin hosp|cond surv|cond;
run;
quit;

/* ex9_5 */
proc catmod data=saseg.mort;
weight count;
population D T;
model S=D T / freq ml noprofile;
run;
model S=D / freq ml noprofile;
run;
model S=T / freq ml noprofile;
run;
proc catmod data=saseg.mort;
weight count;
model S*D*T=_response_ / ml pred=freq;
loglin S|D S|T D|T;
run; quit;

/* ex9_6 */
proc logistic data=saseg.ingots;
model ready/total=heat soak;
run;
proc logistic data=saseg.ingots;
model ready/total=heat;
run; quit;

/* ex9_7 */
proc genmod data=saseg.survival;
class hosp surv;
model count=hosp surv hosp*surv / dist=poi link=log;
run; quit;

/* ex9_8 */
proc genmod data=saseg.survival2;
class hosp surv cond;
model count=hosp surv cond hosp*surv hosp*cond surv*cond
					/ dist=poi link=log;
run;
proc genmod data=saseg.survival2;
class hosp surv cond;
model count=hosp surv cond hosp*cond surv*cond
					/ dist=poi link=log obstats residuals;
run; quit;

/* ex9_9 */
proc genmod data=saseg.ingots;
model ready/total=heat soak / dist=bin link=logit;
run; quit;

/* ex9_10 */
data saseg.chal;
input temp td @@;
cards;
66 0 70 1 69 0 68 0 67 0 72 0 73 0 70 0
57 1 63 1 70 1 78 0 67 0 53 1 67 0 75 0
70 0 81 0 76 0 79 0 75 1 76 0 58 1
;
run;
proc logistic data=saseg.chal descending;
model td=temp;
run;
proc genmod data=saseg.chal descending;
model td=temp / dist=bin link=logit;
run; quit;
