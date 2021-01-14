
title 'airline.payrollmaster';
proc sql;
   select *
      from airline.payrollmaster;
quit;

title 'airline.staffmaster';
proc sql;
   select *
      from airline.staffmaster;
quit;

title 'airline.supervisors';
proc sql;
   select *
      from airline.supervisors;
quit;

title 'airline.flightschedule';
proc sql;
   select *
      from airline.flightschedule;
quit;

title 'airline.marchflights';
proc sql;
   select *
      from airline.marchflights;
quit;

title 'airline.flightdelays';
proc sql;
   select *
      from airline.flightdelays;
quit;

title 'airline.frequentflyers';
proc sql;
   select *
      from airline.frequentflyers;
quit;

title 'airline.internationalflights';
proc sql;
   select *
      from airline.internationalflights;
quit;
