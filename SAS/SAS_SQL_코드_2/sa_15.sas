  /* Student Activity 15 */
  /* How many rows were deleted? */

proc sql;
delete from work.payrollmaster;
where JobCode contains '1';
quit;
