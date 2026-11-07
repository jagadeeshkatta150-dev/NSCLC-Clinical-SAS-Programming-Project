
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 045_ADSL_TREATMENT_GROUP_SUMMARY          */
/* PURPOSE: Summarize demographics by planned         */
/*          treatment group                           */
/*====================================================*/


/* STEP 1: SORT ADSL BY PLANNED TREATMENT */

proc sort data=ADAM.ADSL
          out=WORK.ADSL_SORTED;

    by TRT01P;

run;


/* STEP 2: REVIEW SUBJECT COUNTS BY TREATMENT */

title "SUBJECT COUNTS BY PLANNED TREATMENT";

proc freq data=WORK.ADSL_SORTED;

    tables TRT01P / missing;

run;


/* STEP 3: SUMMARIZE AGE BY TREATMENT */

title "AGE SUMMARY BY PLANNED TREATMENT";

proc means data=WORK.ADSL_SORTED
    n mean std median min max maxdec=2;

    class TRT01P;

    var AGE;

run;


/* STEP 4: SUMMARIZE SEX BY TREATMENT */

title "SEX DISTRIBUTION BY PLANNED TREATMENT";

proc freq data=WORK.ADSL_SORTED;

    tables TRT01P*SEX / missing;

run;


/* STEP 5: CREATE TREATMENT GROUP SUMMARY */

proc sql;

    create table QC.ADSL_TREATMENT_SUMMARY as

    select

        TRT01P,

        count(*) as TOTAL_SUBJECTS,

        mean(AGE) as MEAN_AGE format=8.2,

        median(AGE) as MEDIAN_AGE,

        min(AGE) as MINIMUM_AGE,

        max(AGE) as MAXIMUM_AGE,

        sum(SEX="M") as MALE_SUBJECTS,

        sum(SEX="F") as FEMALE_SUBJECTS,

        sum(SAFFL="Y") as SAFETY_SUBJECTS

    from ADAM.ADSL

    group by TRT01P;

quit;


/* STEP 6: DISPLAY FINAL SUMMARY */

title "FINAL TREATMENT GROUP DEMOGRAPHIC SUMMARY";

proc print data=QC.ADSL_TREATMENT_SUMMARY
    noobs;

run;
