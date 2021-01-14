  /* In the table, AIRLINE.FREQUENTFLYERS, the name
     field follows the form:
       LASTNAME, FIRSTNAME

     In the code below, modify the SELECT statement 
     to select the names and frequent flyer IDs of 
     customers whose first names begin with 
     the letter 'N'.
  */

proc sql;
   select Name, FFID
      from airline.frequentflyers
      where <insert where clause here>
      ;
quit;
