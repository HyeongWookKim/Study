  /* Student Activity 8 */
  /* First you must create the work.fa table.  This code is covered in detail in module 7 */
libname airline 'D:\수업\DB마케팅\airline';

proc sql;
create table work.fa as
  select s.firstname, s.lastname, s.empid, substr(p.jobcode, 1, 2) as jobcategory
    from airline.payrollmaster as p, airline.staffmaster as s
    where calculated jobcategory = 'FA' and s.empid=p.empid;
quit;


  /* Next, use the NOT EXISTS operator to select those flight 
	 attendants not scheduled to fly */
  /* Submit this code a second time without using table qualifiers on 
	 the WHERE clause. */
  /* Is it necessary to qualify these columns with a two level name? */

proc sql;
   select LastName, FirstName, EmpID
      from work.fa 
      where not exists
        (select *
         from airline.flightschedule
            where EmpID= EmpID);
quit;


