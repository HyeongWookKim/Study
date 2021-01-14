  /* Change the <tablename> in the FROM clause
     below to be one of the following tables:

     airline.payrollmaster   airline.staffmaster
     airline.supervisors     airline.flightschedule
     airline.marchflights    airline.flightdelays
     airline.frequentflyers  airline.internationalflights

     Then submit the code and review the results.
     Select another table name and resubmit the code.
     Continue investigating the tables in this manner.
     Then review the output and answer the following 
     questions:     
     1) Do any of the tables have the column, EmpID
        in common? If so, which ones?
     2) Is the Date column in more than one table?
        If so, which ones?
  */

proc sql;
   select *
      from <tablename> ;
quit;

title;
