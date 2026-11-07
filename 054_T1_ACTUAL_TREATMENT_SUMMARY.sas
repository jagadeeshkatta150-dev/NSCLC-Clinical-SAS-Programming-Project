
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 054_T1_ACTUAL_TREATMENT_SUMMARY           */
/* PURPOSE: Summarize subjects by actual treatment    */
/*          received                                  */
/*====================================================*/


/* STEP 1: REVIEW ACTUAL TREATMENT DISTRIBUTION */

title "ACTUAL TREATMENT FREQUENCY";

proc freq data=ADAM.ADSL;

    tables TRT01A / missing;

run;


/* STEP 2: COUNT SUBJECTS BY ACTUAL TREATMENT */

proc sql;

    create table WORK.ACTUAL_TREATMENT_COUNTS as

    select

        TRT01A,

        count(*) as SUBJECT_COUNT

    from ADAM.ADSL

    group by TRT01A;

quit;


/* STEP 3: CALCULATE TOTAL SUBJECT COUNT */

proc sql;

    create table WORK.ACTUAL_TREATMENT_TOTAL as

    select

        count(*) as TOTAL_SUBJECTS

    from ADAM.ADSL;

quit;


/* STEP 4: CALCULATE PERCENTAGES */

data WORK.ACTUAL_TREATMENT_SUMMARY;

    if _N_ = 1 then
        set WORK.ACTUAL_TREATMENT_TOTAL;

    set WORK.ACTUAL_TREATMENT_COUNTS;

    PERCENTAGE =
        (SUBJECT_COUNT / TOTAL_SUBJECTS) * 100;

    format PERCENTAGE 6.2;

run;


/* STEP 5: SAVE PERMANENT QC DATASET */

data QC.ADSL_ACTUAL_TREATMENT_SUMMARY;

    set WORK.ACTUAL_TREATMENT_SUMMARY;

run;


/* STEP 6: DISPLAY FINAL SUMMARY */

title "ACTUAL TREATMENT SUMMARY";

proc print data=QC.ADSL_ACTUAL_TREATMENT_SUMMARY noobs;

    var TRT01A SUBJECT_COUNT TOTAL_SUBJECTS PERCENTAGE;

run;

title;
