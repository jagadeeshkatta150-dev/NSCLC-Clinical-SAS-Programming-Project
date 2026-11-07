
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 052_T1_SAFETY_POPULATION_SUMMARY          */
/* PURPOSE: Summarize safety population by planned    */
/*          treatment group                           */
/*====================================================*/


/* STEP 1: COUNT SUBJECTS BY PLANNED TREATMENT */

proc sql;

    create table WORK.TREATMENT_TOTALS as

    select

        TRT01P,

        count(*) as TOTAL_SUBJECTS

    from ADAM.ADSL

    group by TRT01P;

quit;


/* STEP 2: COUNT SAFETY SUBJECTS BY TREATMENT */

proc sql;

    create table WORK.SAFETY_COUNTS as

    select

        TRT01P,

        count(*) as SAFETY_SUBJECTS

    from ADAM.ADSL

    where SAFFL = "Y"

    group by TRT01P;

quit;


/* STEP 3: SORT BOTH DATASETS */

proc sort data=WORK.TREATMENT_TOTALS;
    by TRT01P;
run;

proc sort data=WORK.SAFETY_COUNTS;
    by TRT01P;
run;


/* STEP 4: MERGE TREATMENT AND SAFETY COUNTS */

data WORK.SAFETY_SUMMARY;

    merge WORK.TREATMENT_TOTALS
          WORK.SAFETY_COUNTS;

    by TRT01P;

    if missing(SAFETY_SUBJECTS) then
        SAFETY_SUBJECTS = 0;

    SAFETY_PERCENTAGE =
        (SAFETY_SUBJECTS / TOTAL_SUBJECTS) * 100;

    format SAFETY_PERCENTAGE 6.2;

run;


/* STEP 5: SAVE PERMANENT QC DATASET */

data QC.ADSL_SAFETY_SUMMARY;

    set WORK.SAFETY_SUMMARY;

run;


/* STEP 6: DISPLAY FINAL SUMMARY */

title "SAFETY POPULATION SUMMARY BY TREATMENT GROUP";

proc print data=QC.ADSL_SAFETY_SUMMARY noobs;

    var TRT01P TOTAL_SUBJECTS
        SAFETY_SUBJECTS SAFETY_PERCENTAGE;

run;
