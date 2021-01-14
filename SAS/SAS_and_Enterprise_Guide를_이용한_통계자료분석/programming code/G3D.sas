/* G3D.SAS : BIVARIATE NORMAL DENSITY */
GOPTIONS CBACK=BLACK COLORS=(WHITE CYAN MAGENTA GOLD YELLOW);
DATA BNORMAL;
  rho=0.9;
  rhosqr=1-rho**2;
  sqrrho=sqrt(rhosqr);
  FORMAT Z 5.1;
  DO X=-3 TO 3 BY 0.1;
     DO Y=-3 TO 3 BY 0.1;
        Z= EXP(-(X**2 + Y**2 - 2*X*Y*rho)/(2*rhosqr))/(6.28*sqrrho);
        OUTPUT;
     END;
  END;
RUN;

PROC G3D DATA=BNORMAL;
  PLOT X*Y=Z;
  TITLE 'BIVARIATE NORRMAL DENSITY (RHO=0.9)';
RUN;   QUIT;
