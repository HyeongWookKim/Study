  /* Issue LIBNAME statement. If you unzipped the
     data to a different location, you must change
     the LIBNAME statement accordingly. The following 
	 libname points to the current working directory.
  */

libname airline '.';

  /* Other Housekeeping: Clear any titles and footnotes.
     Issue options and make sure LISTING window is open. 
  */
title;
footnote;

options nodate nonumber;
ods listing;
