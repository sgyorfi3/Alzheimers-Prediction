libname in "P:\H47.2020.DH_Alz\dat\Matched"; *Tell SAS where to find our data;
libname out "C:\Users\sgyorfi3\Documents\My SAS Files";   *Tell SAS where to output our data;

DATA out.practice; *Creating temporary file of master data set;
	set in.export_matched_patients ;
run;

PROC SQL; *Modifying temporary data set by ensuring all Line codes are the same length (3 digits) and zip codes are short form;
UPDATE out.practice SET LINE_ICD_DGNS_CD = substr(LINE_ICD_DGNS_CD,1,4) WHERE length(LINE_ICD_DGNS_CD) > 4;
UPDATE out.practice SET LINE_ICD_DGNS_CD = cats(LINE_ICD_DGNS_CD,'0') WHERE length(LINE_ICD_DGNS_CD)= 3;
UPDATE out.practice SET LINE_ICD_DGNS_CD = cats(LINE_ICD_DGNS_CD,'00') WHERE length(LINE_ICD_DGNS_CD)= 2;
UPDATE out.practice SET LINE_ICD_DGNS_CD = cats(LINE_ICD_DGNS_CD,'000') WHERE length(LINE_ICD_DGNS_CD)=1;

UPDATE out.practice SET PRVDR_ZIP = substr(PRVDR_ZIP,1,5)WHERE PRVDR_ZIP <> "1";
 
*These lines of code are excluding medical claims data from after 2012 and those containing ICD-9 diagnois codes related to Dementia;
DELETE from out.practice where LINE_1ST_EXPNS_DT >= '01JAN2012'D;
DELETE from out.practice where LINE_ICD_DGNS_CD in ('0000','XX00','2942', '2912', '2904','2901','2952','3190','2909','2959','2949','2939','2928','2941','3311','2951','2991','2900','2990','3318','9410','9440','9040','2953','2950','2903','2902','2948');

QUIT;

* This section is focused on creating a model base for models 1 and 2;

PROC SQL;
CREATE TABLE out.modelbase as
select DISTINCT alz as Alz,STUDY_ID,LINE_ICD_DGNS_CD,count(LINE_ICD_DGNS_CD) as Line_Number 
from out.practice 
group by STUDY_ID, LINE_ICD_DGNS_CD
order by STUDY_ID, LINE_ICD_DGNS_CD;

QUIT;

* This section is focused on recreating Data Modeling Approach 1;

PROC TRANSPOSE DATA = out.modelbase OUT = out.model1  ;
BY STUDY_ID alz ;
ID LINE_ICD_DGNS_CD;
run;

DATA out.model1; * This block of code replaces Null Values with Zeros;
   set out.model1;
   array change _numeric_;
        do over change;
            if change=. then change=0;
        end;
	DROP _NAME_;
 run ;

PROC CONTENTS data = out.model1 out = col_names(keep=name) noprint ; *These two blocks of code help to order the Columns Alphanumerically;
run;


DATA _null_;
 set col_names;
 by name;
 retain sorted_cols;
 length sorted_cols $30000.;

 if _n_ = 1 then sorted_cols = name;
 else sorted_cols = catx(' ', sorted_cols, name);
 call symput('sorted_cols', sorted_cols);
run;

DATA out.Model1;
 retain STUDY_ID Alz &sorted_cols;
 set out.Model1;
run;  

*This section is focused on recreating Data Modeling Approach 2;

 PROC SQL;
 CREATE TABLE out.model2 as
 select * from out.modelbase;

 UPDATE out.model2 SET Line_Number=1 WHERE Line_Number>1;
 
 QUIT;

PROC TRANSPOSE DATA = out.model2 OUT= out.model2;
BY STUDY_ID alz ;
ID LINE_ICD_DGNS_CD;
run;

DATA out.model2;
   set out.model2;
   array change _numeric_;
        do over change;
            if change=. then change=0;
        end;
	DROP _NAME_;
 run ;

PROC CONTENTS data = out.model2 out = col_names(keep=name) noprint ;
run;

DATA _null_;
 set col_names;
 by name;
 retain sorted_cols;
 length sorted_cols $30000.;

 if _n_ = 1 then sorted_cols = name;
 else sorted_cols = catx(' ', sorted_cols, name);
 call symput('sorted_cols', sorted_cols);
run;

DATA out.Model2;
 retain STUDY_ID Alz &sorted_cols;
 set out.Model2;
run; 

 *This section is focused on recreating Data Modeling Approach 3;

 PROC SQL; 

 CREATE TABLE out.model3 as
 select DISTINCT alz as Alz,STUDY_ID, min(LINE_1ST_EXPNS_DT),LINE_ICD_DGNS_CD from out.practice
 GROUP BY STUDY_ID,LINE_ICD_DGNS_CD 
 ORDER BY STUDY_ID, LINE_ICD_DGNS_CD;

 QUIT;


DATA out.model3;
set out.model3;

Time_Mark = '01JAN2012'D;
Time_Since = Time_Mark - _TEMG001;

IF Time_Since <= 0 THEN Time_Since = 0;
ELSE Time_Since = max(INT(Time_Since/365),1);

DROP _TEMG001 Time_Mark;

run;

PROC TRANSPOSE DATA = out.model3 OUT= out.model3;
BY STUDY_ID alz ;
ID LINE_ICD_DGNS_CD;
run;

DATA out.model3;
   set out.model3;
   array change _numeric_;
        do over change;
            if change=. then change=0;
        end;
	DROP _NAME_;
 run ;

PROC CONTENTS data = out.model3 out = col_names(keep=name) noprint ;
run;

DATA _null_;
 set col_names;
 by name;
 retain sorted_cols;
 length sorted_cols $30000.;

 if _n_ = 1 then sorted_cols = name;
 else sorted_cols = catx(' ', sorted_cols, name);
 call symput('sorted_cols', sorted_cols);
run;

DATA out.Model3;
 retain STUDY_ID Alz &sorted_cols;
 set out.Model3;
run;
