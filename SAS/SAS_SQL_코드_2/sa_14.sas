  /* Student activity 13 */

  /* Submit each of the following queries and review the results. */
  /*If an index is used, there will be a note printed in your log */

options msglevel=i;
proc sql;
 create unique index daily
  on airline.marchflights(FlightNumber,Date);

  select *
  from airline.marchflights
  where date between '01MAR2000'd and '15MAR2000'd;

  select * 
  from airline.marchflights
  where Flightnumber = '982';

  select * 
  from airline.marchflights
  where flightnumber = '982' and 
		Date between '01MAR2000'd and '15MAR2000'd;
quit;
