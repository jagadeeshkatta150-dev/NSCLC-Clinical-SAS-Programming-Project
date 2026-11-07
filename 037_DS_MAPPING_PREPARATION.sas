
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 037_DS_MAPPING_PREPARATION                */
/* PURPOSE: Prepare disposition and survival mapping */
/*====================================================*/


/* STEP 1: SORT SOURCE DATA */

proc sort data=RAW.DISPOSITION_SURVIVAL
          out=WORK.DS_MAPPING_REVIEW;

    by SITE_NO PATIENT_NO;

run;


/* STEP 2: CREATE SUBJECT IDENTIFIERS */

data WORK.DS_MAPPING_REVIEW;

    set WORK.DS_MAPPING_REVIEW;

    length STUDYID $12
           DOMAIN $2
           USUBJID $40
           VITAL_STATUS_STD $5
           DEATH_FLAG $1;

    STUDYID = "NSCLC001";

    SUBJID = put(PATIENT_NO, z3.);

    SITEID = put(SITE_NO, z4.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);


    /* STEP 3: STANDARDIZE VITAL STATUS */

    if upcase(strip(VITAL_STATUS)) = "ALIVE" then
        VITAL_STATUS_STD = "ALIVE";

    else if upcase(strip(VITAL_STATUS)) = "DEAD" then
        VITAL_STATUS_STD = "DEAD";


    /* STEP 4: STANDARDIZE DEATH INDICATOR */

    if upcase(strip(DEATH_INDICATOR)) = "YES" then
        DEATH_FLAG = "Y";

    else if upcase(strip(DEATH_INDICATOR)) = "NO" then
        DEATH_FLAG = "N";


    /* STEP 5: FORMAT EVENT DATE */

    if not missing(EVENT_DATE) then
        EVENT_DATE_ISO = put(EVENT_DATE, yymmdd10.);

    format TREATMENT_START_DATE
           LAST_CONTACT_DATE
           EVENT_DATE date9.;

run;


/* STEP 6: REVIEW SUBJECT-LEVEL INFORMATION */

title "DISPOSITION AND SURVIVAL SUBJECT REVIEW";

proc print data=WORK.DS_MAPPING_REVIEW noobs;

    var USUBJID TREATMENT_START_DATE
        LAST_CONTACT_DATE VITAL_STATUS
        VITAL_STATUS_STD DEATH_INDICATOR
        DEATH_FLAG EVENT_DATE EVENT_DATE_ISO;

run;


/* STEP 7: REVIEW STANDARDIZED VITAL STATUS */

title "STANDARDIZED VITAL STATUS FREQUENCY";

proc freq data=WORK.DS_MAPPING_REVIEW;

    tables VITAL_STATUS_STD;

run;


/* STEP 8: REVIEW DEATH FLAG */

title "STANDARDIZED DEATH FLAG FREQUENCY";

proc freq data=WORK.DS_MAPPING_REVIEW;

    tables DEATH_FLAG;

run;


/* STEP 9: CREATE SUBJECT-LEVEL SUMMARY */

proc sql;

    create table QC.DS_SUBJECT_SUMMARY as

    select
        SITE_NO,
        PATIENT_NO,
        VITAL_STATUS_STD,
        DEATH_FLAG,
        EVENT_DATE_ISO,
        count(*) as RECORD_COUNT

    from WORK.DS_MAPPING_REVIEW

    group by
        SITE_NO,
        PATIENT_NO,
        VITAL_STATUS_STD,
        DEATH_FLAG,
        EVENT_DATE_ISO;

quit;


/* STEP 10: DISPLAY SUBJECT SUMMARY */

title "DISPOSITION AND SURVIVAL SUBJECT SUMMARY";

proc print data=QC.DS_SUBJECT_SUMMARY noobs;

run;

title;
