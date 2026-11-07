
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 053_T1_TREATMENT_EXPOSURE_SUMMARY         */
/* PURPOSE: Summarize treatment exposure by planned    */
/*          treatment group                           */
/*====================================================*/


/* STEP 1: SELECT SUBJECTS WITH EXPOSURE */

data WORK.EXPOSURE_SUBJECTS;

    set ADAM.ADSL;

    where not missing(TRTSDT)
      and not missing(TRTEDT);

    TREATMENT_DURATION = TRTEDT - TRTSDT + 1;

run;


/* STEP 2: SUMMARIZE EXPOSURE BY TREATMENT */

proc means data=WORK.EXPOSURE_SUBJECTS
    n mean std min max maxdec=2 nway noprint;

    class TRT01P;

    var TREATMENT_DURATION;

    output out=WORK.EXPOSURE_SUMMARY

        n=EXPOSED_SUBJECTS

        mean=MEAN_DURATION

        std=SD_DURATION

        min=MIN_DURATION

        max=MAX_DURATION;

run;


/* STEP 3: REMOVE AUTOMATIC SUMMARY VARIABLES */

data WORK.EXPOSURE_SUMMARY_FINAL;

    set WORK.EXPOSURE_SUMMARY;

    drop _TYPE_ _FREQ_;

run;


/* STEP 4: SAVE PERMANENT QC DATASET */

data QC.ADSL_EXPOSURE_SUMMARY;

    set WORK.EXPOSURE_SUMMARY_FINAL;

run;


/* STEP 5: DISPLAY FINAL EXPOSURE SUMMARY */

title "TREATMENT EXPOSURE SUMMARY BY PLANNED TREATMENT";

proc print data=QC.ADSL_EXPOSURE_SUMMARY noobs;

run;

title;
