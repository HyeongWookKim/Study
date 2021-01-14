
  /* Modify the UNDO_POLICY option value to NONE and view the results.
	Create an empty table and attempt to add invalid data */


proc sql undo_policy=<change the value here>;
   create table discount
      (Destination char(3),
	  BeginDate date label='BEGINS',
	  EndDate date label='ENDS',
	  Discount num,
       CONSTRAINT ok_discount check (Discount le .5));

	insert into discount
		values('CDG','03MAR2000'd,'10MAR2000'd,.15)
  		values('LHR','10MAR2000'd,'12MAR2000'd,.55);

select * from discount;
quit;
