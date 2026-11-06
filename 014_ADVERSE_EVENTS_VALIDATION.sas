
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 014_ADVERSE_EVENTS_VALIDATION             */
/* PURPOSE: Validate raw adverse events data          */
/*====================================================*/

/* STEP 1: Check source dataset structure */

proc contents data=RAW.ADVERSE_EVENTS;
run;


/* STEP 2: Identify missing patient IDs */

data QC.AE_MISSING_PATIENT_ID;
    set RAW.ADVERSE_EVENTS;

    if missing(PATIENT_NO);
run;


/* STEP 3: Identify missing event numbers */

data QC.AE_MISSING_EVENT_NO;
    set RAW.ADVERSE_EVENTS;

    if missing(EVENT_NO);
run;


/* STEP 4: Identify duplicate patient and event combinations */

proc sql;
    create table QC.AE_DUPLICATE_RECORDS as
    select PATIENT_NO,
           EVENT_NO,
           count(*) as RECORD_COUNT
    from RAW.ADVERSE_EVENTS
    group by PATIENT_NO, EVENT_NO
    having count(*) > 1;
quit;


/* STEP 5: Check missing event descriptions */

data QC.AE_MISSING_DESCRIPTION;
    set RAW.ADVERSE_EVENTS;

    if missing(EVENT_DESCRIPTION);
run;


/* STEP 6: Check severity values */

proc freq data=RAW.ADVERSE_EVENTS;
    tables SEVERITY / missing;
run;


/* STEP 7: Check relatedness values */

proc freq data=RAW.ADVERSE_EVENTS;
    tables RELATEDNESS / missing;
run;


/* STEP 8: Check serious event values */

proc freq data=RAW.ADVERSE_EVENTS;
    tables SERIOUS_EVENT / missing;
run;


/* STEP 9: Check date inconsistencies */

data QC.AE_DATE_ISSUES;
    set RAW.ADVERSE_EVENTS;

    if missing(START_DATE)
       or (not missing(END_DATE)
       and END_DATE < START_DATE);
run;


/* STEP 10: Check ongoing events */

data QC.AE_ONGOING_EVENTS;
    set RAW.ADVERSE_EVENTS;

    if upcase(strip(OUTCOME)) = "ONGOING";
run;


/* STEP 11: Generate validation summary */

title "ADVERSE EVENTS VALIDATION SUMMARY";

proc sql;

    select count(*) as TOTAL_AE_RECORDS
    from RAW.ADVERSE_EVENTS;

    select count(*) as MISSING_PATIENT_IDS
    from QC.AE_MISSING_PATIENT_ID;

    select count(*) as MISSING_EVENT_NUMBERS
    from QC.AE_MISSING_EVENT_NO;

    select count(*) as DUPLICATE_EVENT_GROUPS
    from QC.AE_DUPLICATE_RECORDS;

    select count(*) as MISSING_DESCRIPTIONS
    from QC.AE_MISSING_DESCRIPTION;

    select count(*) as DATE_ISSUES
    from QC.AE_DATE_ISSUES;

    select count(*) as ONGOING_EVENTS
    from QC.AE_ONGOING_EVENTS;

quit;

title;
