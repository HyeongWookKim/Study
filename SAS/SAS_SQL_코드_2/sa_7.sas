
  /* Student Activity 7 */
  /* Change the comparison operator to an equal sign (=), 
     submit the program and review the results */

proc sql;
   select LastName, FirstName, City, State
   from airline.staffmaster
   where EmpID in
     (select EmpID
      from airline.payrollmaster
      where month(DateOfBirth)=2);
quit;
