
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 008_DEMOGRAPHICS_DATA_REVIEW              */
/* PURPOSE: Review raw demographics records           */
/*====================================================*/


/* STEP 1: Sort demographics by patient number */

proc sort data=RAW.DEMOGRAPHICS
          out=WORK.DEMO_REVIEW;

    by PATIENT_NO;

run;


/* STEP 2: Display all demographic records */

title "DEMOGRAPHICS SOURCE DATA REVIEW";

proc print data=WORK.DEMO_REVIEW label;

    var PATIENT_NO
        SITE_NO
        AGE_YRS
        GENDER
        RACE_DESC
        DISEASE_STAGE
        TREATMENT_GROUP
        CONSENT_DATE
        ENROLLMENT_DATE;

    format CONSENT_DATE ENROLLMENT_DATE date9.;

run;


/* STEP 3: Review age statistics */

title "DEMOGRAPHICS AGE SUMMARY";

proc means data=RAW.DEMOGRAPHICS
           n nmiss mean min max maxdec=1;

    var AGE_YRS;

run;


/* STEP 4: Review categorical demographic variables */

title "DEMOGRAPHICS CATEGORY REVIEW";

proc freq data=RAW.DEMOGRAPHICS;

    tables GENDER
           RACE_DESC
           DISEASE_STAGE
           TREATMENT_GROUP;

run;


/* STEP 5: Clear report titles */

title;
