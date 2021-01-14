  /* This program consists of 2 steps. 
     Consider the output from the first step.
     Then run Step 2 and review the SAS LISTING and 
     LOG. Answer the following questions:
     1) How many rows were created by the query 
        in the first step?
     2) How may rows were created by the query 
        in the second step?
     3) Is the average column different 
        for every JobCode in the second query? 
  */

  /* Step 1 */
proc sql;
  select 'The Average Salary is:', avg(Salary)
    from airline.payrollmaster;
quit;


  /* Step 2 */
proc sql;
  select JobCode, avg(Salary) as average
    from airline.payrollmaster;
quit;
