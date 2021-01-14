  /* Student Activity 16 */

  /* set outobs and number options */
proc sql outobs=2 number;
    select * from airline.payrollmaster;

  /* specify that row numbers be supressed */
reset nonumber;
	select * from airline.payrollmaster;

  /* alter the number of output observations */
reset outobs=10;
    select * from airline.payrollmaster;
 
quit;
