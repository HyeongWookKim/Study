  /* This program consists of 3 steps. 
     Highlight the first 2 steps, submit the code and
     review the log. Which step generated errors?
     -- Step 1 generated errors.
     -- Step 2 generated errors
     What was the error message generated.

     Then run Step 3 and review the SAS LOG, 
     what does the VALIDATE keyword do?
  */


  /* Step 1 */
proc sql;
   select EmpID, JobCode, Salary
      from airline.payrollmaster
      where JobCode = 'FA1'
      order by EmpID;
quit;

  /* Step 2 */
proc sql;
   from airline.payrollmaster
   select EmpID, JobCode, Salary
      where JobCode = 'FA1'
      order by EmpID;
quit;

  /* Step 3 */
proc sql;
   validate
   from airline.payrollmaster
   select EmpID, JobCode, Salary
      where JobCode = 'FA1'
      order by EmpID;
quit;




