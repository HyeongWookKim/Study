  /* Student Activity 17 */

  /* Modify the  %Let statement by adding 
	 one of the following JobCode values:
	 FA1, FA2, FA3, ME1, ME2, ME3, NA1, NA2, PT1, PT2, 
     PT3, TA1, TA2, TA3 */

  /* How many FA3 employees have an above average salary? */
  /* What is the average salary for level 2 mechanics? */

%let code= <insert JobCode value here> ;
proc sql noprint;
select avg(Salary) into :mean
   from airline.payrollmaster
   where JobCode="&code";

reset print;

title1 "&code Employees Earning Above-"
       "Average Salaries";
title2 "Average Salary for &code Employees "
       "Is &mean";
select *
   from airline.payrollmaster
   where Salary > &mean and JobCode="&code";
quit;
