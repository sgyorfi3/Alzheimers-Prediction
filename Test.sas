*Model under consideration;
%let var = out.model3;

* Checking the number of patients with Alz = 0 or Alz = 1;
PROC SQL;
Select count(alz), alz from &var group by alz;
Select count(alz), alz from (Select distinct STUDY_ID, alz from out.practice) group by alz;
QUIT;

* Checking for the correct number of variables for all models;
PROC CONTENTS data = &var out = out.col_names(keep=name) noprint ;
run;

PROC SQL;
Select (count(*)-2) from out.col_names;
Select count(*) from (Select distinct LINE_ICD_DGNS_CD from out.practice);   
QUIT;

* Checking Model 1 for correct number of observations;
DATA out.total;
set out.model1;
drop alz STUDY_ID;
run;

DATA out.total;
set out.total;
  total = sum(of _numeric_);
keep total;
run;

PROC SQL;
Select sum(total) from out.total;
select count(*) from out.practice;
QUIT;

* Checking Model 2 for correct number of observations;

DATA out.total;
set out.model2;
drop alz STUDY_ID;
run;

DATA out.total;
set out.total;
  total = sum(of _numeric_);
keep total;
run;

PROC SQL;
Select sum(total) from out.total;
select count(*) from (Select distinct STUDY_ID, LINE_ICD_DGNS_CD from out.practice) ;
QUIT;

*Checking Model 3 for correct number of observations;

DATA out.total;
set out.model3;
drop alz STUDY_ID;
run;

DATA out.total;
   set out.total;
   array change _numeric_;
        do over change;
            if change>1 then change=1;
        end;
	DROP _NAME_;
 run ;

DATA out.total;
set out.total;
  total = sum(of _numeric_);
keep total;
run;

PROC SQL;
Select sum(total) from out.total;
select count(*) from (Select distinct STUDY_ID, LINE_ICD_DGNS_CD from out.practice) ;
QUIT;














