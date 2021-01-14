  /* Submit this program and then answer the 
     following questions after reviewing the output:
     1) What is the name of the SAS data 
        set being used for input?
     2) What are the names of the columns 
        that appear in the LISTING output?
     3) Do the names of the columns appear 
        in the SELECT statement?
  */

proc sql;
   select *
      from airline.payrollmaster;
quit;
