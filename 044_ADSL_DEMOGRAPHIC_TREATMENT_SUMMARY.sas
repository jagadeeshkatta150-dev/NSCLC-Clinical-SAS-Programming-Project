
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 044_ADSL_DEMOGRAPHIC_TREATMENT_SUMMARY    */
/* PURPOSE: Summarize subject demographics and        */
/*          treatment information                    */
/*====================================================*/


/* STEP 1: REVIEW ADSL DATA */

title "ADSL SUBJECT-LEVEL DATA";

proc print data=ADAM.ADSL;
run;


/* STEP 2: SUMMARIZE AGE */

title "AGE SUMMARY";

proc means data=ADAM.ADSL
    n mean std median min max maxdec=2;

    var AGE;

run;


/* STEP 3: SUMMARIZE SEX */

title "SEX DISTRIBUTION";

proc freq data=ADAM.ADSL;

    tables SEX / missing;

run;


/* STEP 4: SUMMARIZE PLANNED TREATMENT */

title "PLANNED TREATMENT DISTRIBUTION";

proc freq data=ADAM.ADSL;

    tables TRT01P / missing;

run;


/* STEP 5: SUMMARIZE ACTUAL TREATMENT */

title "ACTUAL TREATMENT DISTRIBUTION";

proc freq data=ADAM.ADSL;

    tables TRT01A / missing;

run;


/* STEP 6: SUMMARIZE SAFETY POPULATION */

title "SAFETY POPULATION DISTRIBUTION";

proc freq data=ADAM.ADSL;

    tables SAFFL / missing;

run;


/* STEP 7: CREATE DEMOGRAPHIC SUMMARY DATASET */

proc sql;

    create table QC.ADSL_DEMOGRAPHIC_SUMMARY as

    select

        count(*) as TOTAL_SUBJECTS,

        mean(AGE) as MEAN_AGE format=8.2,

        median(AGE) as MEDIAN_AGE,

        min(AGE) as MINIMUM_AGE,

        max(AGE) as MAXIMUM_AGE,

        sum(SEX="M") as MALE_SUBJECTS,

        sum(SEX="F") as FEMALE_SUBJECTS,

        sum(SAFFL="Y") as SAFETY_SUBJECTS

    from ADAM.ADSL;

quit;


/* STEP 8: REVIEW FINAL SUMMARY */

title "FINAL DEMOGRAPHIC SUMMARY";

proc print data=QC.ADSL_DEMOGRAPHIC_SUMMARY
    noobs;

run;

title;
