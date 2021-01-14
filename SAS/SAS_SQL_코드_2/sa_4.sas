  /* Submit the program and review the SAS Log. 
     How are the column names represented 
     in the expanded log?
	Choices:
	The column names are preceded by the table name.
	The column names are preceded by the library reference.
	The column names are preceded by WORK.
  */

  proc sql feedback;  
     select *
        from airline.payrollmaster;
  quit;
