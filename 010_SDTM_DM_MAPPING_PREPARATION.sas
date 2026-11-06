
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 010_SDTM_DM_MAPPING_PREPARATION           */
/* PURPOSE: Review source variables for SDTM DM       */
/*====================================================*/


/* STEP 1: Display source demographics structure */

proc contents data=RAW.DEMOGRAPHICS;
run;


/* STEP 2: Display source variables required for DM */

title "SDTM DM SOURCE VARIABLE REVIEW";

proc print data=RAW.DEMOGRAPHICS;

    var PATIENT_NO
        SITE_NO
        AGE_YRS
        GENDER
        RACE_DESC
        TREATMENT_GROUP
        CONSENT_DATE
        ENROLLMENT_DATE;

    format CONSENT_DATE ENROLLMENT_DATE date9.;

run;


/* STEP 3: Sort and review unique patient IDs */

proc sort data=RAW.DEMOGRAPHICS
          out=WORK.DM_SUBJECT_REVIEW
          nodupkey;

    by PATIENT_NO;

run;


/* STEP 4: Count unique patient IDs */

proc sql;

    select count(*) as UNIQUE_SUBJECT_IDS
    from WORK.DM_SUBJECT_REVIEW;

quit;


/* STEP 5: Review treatment groups */

proc freq data=RAW.DEMOGRAPHICS;

    tables TREATMENT_GROUP;

run;


/* STEP 6: Clear report title */

title;
