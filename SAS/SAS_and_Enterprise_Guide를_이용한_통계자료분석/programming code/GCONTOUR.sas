/* GCONTOUR.SAS : GCONTOUR PROCEDURE */
DATA CONTOURS;
  FORMAT Z 5.1;
  DO X=0 TO 400 BY 5;
     DO Y=0 TO 350 BY 10;
        Z= 46.2+0.09*X-0.0005*X**2+0.1*Y-0.0005*Y**2+0.0004*X*Y;
        OUTPUT;
     END;
  END;
RUN;
PROC GCONTOUR;
  PLOT Y*X=Z;
TITLE 'CONOTUR PLOT OF X VS Y';
TITLE2 'CONTOURS ARE Z';
RUN;
QUIT;