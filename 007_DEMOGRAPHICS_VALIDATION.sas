
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 007_DEMOGRAPHICS_VALIDATION               */
/* PURPOSE: Perform demographics data quality checks */
/*====================================================*/


/* STEP 1: Check dataset structure */

proc contents data=RAW.DEMOGRAPHICS;
run;


/* STEP 2: Count total patient records */

proc sql;
    select count(*) as TOTAL_PATIENTS
    from RAW.DEMOGRAPHICS;
quit;


/* STEP 3: Identify missing patient IDs */

data QC.DEMO_MISSING_ID;
    set RAW.DEMOGRAPHICS;

    if missing(PATIENT_NO);
run;


/* STEP 4: Identify duplicate patient ID groups */

proc sql;
    create table QC.DEMO_DUPLICATE_IDS as
    select
        PATIENT_NO,
        count(*) as ID_COUNT
    from RAW.DEMOGRAPHICS
    where not missing(PATIENT_NO)
    group by PATIENT_NO
    having count(*) > 1;
quit;


/* STEP 5: Identify missing or unusual ages */

data QC.DEMO_AGE_ISSUES;
    set RAW.DEMOGRAPHICS;

    if missing(AGE_YRS)
       or AGE_YRS < 18
       or AGE_YRS > 100;
run;


/* STEP 6: Check gender distribution */

proc freq data=RAW.DEMOGRAPHICS;
    tables GENDER / missing;
run;


/* STEP 7: Check treatment group distribution */

proc freq data=RAW.DEMOGRAPHICS;
    tables TREATMENT_GROUP / missing;
run;


/* STEP 8: Identify consent and enrollment date issues */

data QC.DEMO_DATE_ISSUES;
    set RAW.DEMOGRAPHICS;

    if missing(CONSENT_DATE)
       or missing(ENROLLMENT_DATE)
       or ENROLLMENT_DATE < CONSENT_DATE;
run;


/* STEP 9: Generate validation counts */

title "DEMOGRAPHICS VALIDATION SUMMARY";

proc sql;

    select count(*) as TOTAL_RECORDS
    from RAW.DEMOGRAPHICS;

    select count(*) as MISSING_IDS
    from QC.DEMO_MISSING_ID;

    select count(*) as DUPLICATE_ID_GROUPS
    from QC.DEMO_DUPLICATE_IDS;

    select count(*) as AGE_ISSUES
    from QC.DEMO_AGE_ISSUES;

    select count(*) as DATE_ISSUES
    from QC.DEMO_DATE_ISSUES;

quit;

title;
