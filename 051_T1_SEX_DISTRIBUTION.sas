
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 051_T1_SEX_DISTRIBUTION                   */
/* PURPOSE: Summarize sex distribution by planned     */
/*          treatment group                           */
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


/* STEP 2: CALCULATE TREATMENT GROUP TOTALS */

proc sql;

    create table WORK.TREATMENT_TOTALS as

    select

        TRT01P,
        count(*) as TOTAL_SUBJECTS

    from ADAM.ADSL

    group by TRT01P;

quit;


/* STEP 3: SORT DATASETS */

proc sort data=WORK.SEX_COUNTS;
    by TRT01P;
run;

proc sort data=WORK.TREATMENT_TOTALS;
    by TRT01P;
run;


/* STEP 4: CALCULATE SEX PERCENTAGES */

data WORK.SEX_DISTRIBUTION;

    merge WORK.SEX_COUNTS
          WORK.TREATMENT_TOTALS;

    by TRT01P;

    PERCENTAGE =
        (SUBJECT_COUNT / TOTAL_SUBJECTS) * 100;

    format PERCENTAGE 6.2;

run;


/* STEP 5: SAVE PERMANENT QC DATASET */

data QC.ADSL_SEX_DISTRIBUTION;

    set WORK.SEX_DISTRIBUTION;

run;


/* STEP 6: DISPLAY FINAL TABLE */

title "TABLE 1 - SEX DISTRIBUTION BY TREATMENT GROUP";

proc print data=QC.ADSL_SEX_DISTRIBUTION noobs;

    var TRT01P SEX SUBJECT_COUNT
        TOTAL_SUBJECTS PERCENTAGE;

run;

title;
