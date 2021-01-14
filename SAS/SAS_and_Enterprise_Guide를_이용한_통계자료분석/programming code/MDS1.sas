/* MDS1.SAS : 2002 FIFA 월드컵 개최도시간 거리 분석 */
DATA CITY;
  INPUT Seoul Incheon Suwon Daejeon Jeonju Gwangju Daegu Ulsan Busan    
        Seogwipo;
DATALINES;
 0.0  40.2  41.3  154.0 232.1 320.4 297.0 407.5 432.0 574.0 
  .    0.0  54.5  174.0 253.3 351.6 317.6 447.0 453.0 614.0
  .     .    0.0  132.6 189.4 299.6 268.1 356.0 390.7 532.7
  .     .      .    0.0  96.9 185.2 148.7 259.1 283.4 440.0
  .     .      .     .    0.0 105.9 219.7 331.1 322.9 361.0
  .     .      .     .     .    0.0 219.3 329.9 268.0 264.0
  .     .      .     .     .     .    0.0 111.1 135.5 453.0
  .     .      .     .     .     .     .    0.0  52.9 410.0
  .     .      .     .     .     .     .     .    0.0 357.0
  .     .      .     .     .     .     .     .     .    0.0
;
RUN;
PROC MDS DATA=CITY LEVEL=ABSOLUTE PCONFIG OUT=GRAPH;
RUN;
PROC PLOT DATA=GRAPH VTOH=1.7;
  PLOT DIM2 * DIM1= '*' $ _NAME_ /
    HAXIS=BY 100 VAXIS=BY 100 HREF=0 VREF=0 BOX
    HPOS=50 VPOS=20;
  WHERE _TYPE_='CONFIG'; 
RUN;  QUIT;
