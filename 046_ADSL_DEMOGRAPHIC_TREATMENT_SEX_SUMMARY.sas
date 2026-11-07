
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 046_ADSL_DEMOGRAPHIC_TREATMENT_SEX_SUMMARY*/
/* PURPOSE: Summarize subject counts by treatment     */
/*          group and sex                             */
/*====================================================*/


/* STEP 1: COUNT SUBJECTS BY TREATMENT AND SEX */

proc sql;

    create table WORK.SEX_COUNTS as

    select

        TRT01P,

        SEX,

        count(*) as SUBJECT_COUNT

    from ADAM.ADSL

    group by TRT01P, SEX;

quit;


/* STEP 2: CALCULATE TOTAL SUBJECTS BY TREATMENT */

proc sql;

    create table WORK.TREATMENT_TOTALS as

    select

        TRT01P,

        count(*) as TOTAL_SUBJECTS

    from ADAM.ADSL

    group by TRT01P;

quit;


/* STEP 3: MERGE COUNTS WITH TREATMENT TOTALS */

proc sort data=WORK.SEX_COUNTS;
    by TRT01P;
run;

proc sort data=WORK.TREATMENT_TOTALS;
    by TRT01P;
run;

data WORK.SEX_SUMMARY;

    merge WORK.SEX_COUNTS
          WORK.TREATMENT_TOTALS;

    by TRT01P;

    PERCENTAGE =
        (SUBJECT_COUNT / TOTAL_SUBJECTS) * 100;

    format PERCENTAGE 6.2;

run;


/* STEP 4: CREATE PERMANENT QC SUMMARY */

data QC.ADSL_SEX_SUMMARY;

    set WORK.SEX_SUMMARY;

run;


/* STEP 5: DISPLAY FINAL SUMMARY */

title "DEMOGRAPHIC SUMMARY BY TREATMENT AND SEX";

proc print data=QC.ADSL_SEX_SUMMARY noobs;

    var TRT01P SEX SUBJECT_COUNT
        TOTAL_SUBJECTS PERCENTAGE;

run;

title;
