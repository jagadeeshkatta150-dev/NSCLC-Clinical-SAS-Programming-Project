
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 050_T1_AGE_STATISTICS                     */
/* PURPOSE: Summarize age statistics by planned       */
/*          treatment group                           */
/*====================================================*/


/* STEP 1: CALCULATE AGE STATISTICS */

proc means data=ADAM.ADSL nway noprint;

    class TRT01P;

    var AGE;

    output out=WORK.AGE_STATISTICS
        n=AGE_N
        mean=AGE_MEAN
        std=AGE_SD
        median=AGE_MEDIAN
        min=AGE_MIN
        max=AGE_MAX;

run;


/* STEP 2: REMOVE AUTOMATIC SUMMARY VARIABLES */

data WORK.AGE_STATISTICS_FINAL;

    set WORK.AGE_STATISTICS;

    drop _TYPE_ _FREQ_;

    format AGE_MEAN AGE_SD 8.2;

run;


/* STEP 3: SAVE PERMANENT QC DATASET */

data QC.ADSL_AGE_STATISTICS;

    set WORK.AGE_STATISTICS_FINAL;

run;


/* STEP 4: DISPLAY FINAL AGE SUMMARY */

title "TABLE 1 - AGE STATISTICS BY TREATMENT GROUP";

proc print data=QC.ADSL_AGE_STATISTICS noobs;

run;

title;
