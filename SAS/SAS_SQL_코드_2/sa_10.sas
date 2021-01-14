  /* This first example only accesses the staffmaster table one time */
title 'Without a Second Reference to Airline.Staffmaster';
title2 'These are the Folks Scheduled to Fly';
proc sql;
select distinct b.FirstName, b.LastName, b.empid
   from airline.flightschedule as a,
        airline.staffmaster as b,
        airline.payrollmaster as c,
        airline.supervisors as d
   where a.Date='04mar2000'd and
         a.Destination='CPH' and
         a.EmpID=b.EmpID and 
		 a.EmpID=c.EmpID and 
		 d.JobCategory=substr(c.JobCode,1,2) and 
	  	 d.State=b.State;
quit;


  /* This second example accesses staffmaster a second time to obtain 
     the supervisors name (not the employees scheduled to fly) */
title 'With a Second Reference to Airline.Staffmaster';
title2 'These are the Managers of the Folks Scheduled to Fly';
proc sql;
select distinct e.FirstName, e.LastName, e.empid
   from airline.flightschedule as a,
        airline.staffmaster as b,
        airline.payrollmaster as c,
        airline.supervisors as d,
        airline.staffmaster as e
   where a.Date='04mar2000'd and
         a.Destination='CPH' and
         a.EmpID=b.EmpID and 
		 a.EmpID=c.EmpID and 
		 d.JobCategory=substr(c.JobCode,1,2) and 
	  	 d.State=b.State and d.empid=e.empid;
quit;
