
*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 041_CREATE_ADAM_ADSL                      */
/* PURPOSE: Create ADaM Subject-Level Dataset         */
/*====================================================*/


/* STEP 1: PREPARE DEMOGRAPHICS */

data WORK.ADSL_DEMO;

    set SDTM.DM_UPDATED;

    length SAFFL $1
           ITTFL $1
           TRT01P $30
           TRT01A $30;

    /* SAFETY POPULATION FLAG */

    SAFFL = "Y";

    /* INTENT-TO-TREAT POPULATION FLAG */

    ITTFL = "Y";

    /* PLANNED TREATMENT */

    TRT01P = ARM;

    /* ACTUAL TREATMENT */

    TRT01A = ARM;

    keep STUDYID USUBJID SUBJID SITEID
         AGE SEX SAFFL ITTFL
         TRT01P TRT01A DTHFL;

run;


/* STEP 2: REVIEW ADSL DATASET */

proc contents data=WORK.ADSL_DEMO varnum;

run;


/* STEP 3: DISPLAY ADSL RECORDS */

title "INITIAL ADAM ADSL DATASET";

proc print data=WORK.ADSL_DEMO noobs;

run;


/* STEP 4: CHECK SUBJECT COUNT */

proc sql;

    select count(*) as TOTAL_ADSL_RECORDS
    from WORK.ADSL_DEMO;

quit;


/* STEP 5: CHECK UNIQUE SUBJECT COUNT */

proc sql;

    select count(distinct USUBJID)
           as UNIQUE_SUBJECTS

    from WORK.ADSL_DEMO;

quit;

title;
