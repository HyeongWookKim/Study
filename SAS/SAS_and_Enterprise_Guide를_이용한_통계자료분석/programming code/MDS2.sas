/* MDS2.SAS 신체자료 분석  */
DATA PHYS7;
  INPUT _NAME_ $ V1 V2 V5 V6 V8 V9 V10;
  LABEL V1='신장' V2='총길이' V5='소매길이' V6='바지길이' V8='가슴둘레'
        V9='허리둘레' V10='엉덩이둘레';
  DATALINES;
 V1      1.000    0.930    0.674    0.831    0.208    0.267    0.357
 V2      0.930    1.000    0.690    0.851    0.239    0.313    0.410
 V5      0.674    0.690    1.000    0.736    0.313    0.333    0.421
 V6      0.831    0.851    0.736    1.000    0.144    0.173    0.335
 V8      0.208    0.239    0.313    0.144    1.000    0.876    0.749
 V9      0.267    0.313    0.333    0.173    0.876    1.000    0.772
 V10     0.357    0.410    0.421    0.335    0.749    0.772    1.000
;
PROC MDS DATA=PHYS7 SIMILAR LEVEL=INTERVAL PCONFIG OUT=OUT;
    ID _NAME_;
RUN;
PROC PLOT DATA=OUT;
    PLOT DIM2*DIM1='*' $ _NAME_ /VPOS=20 HPOS=50 VREF=0 HREF=0;
    WHERE _TYPE_='CONFIG'; 
RUN;   QUIT;
