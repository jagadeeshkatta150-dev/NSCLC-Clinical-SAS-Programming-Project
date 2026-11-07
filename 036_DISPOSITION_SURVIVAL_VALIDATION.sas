
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 036_DISPOSITION_SURVIVAL_VALIDATION       */
/* PURPOSE: Validate disposition and survival data    */
/*====================================================*/


/* STEP 1: CHECK MISSING REQUIRED VALUES */

proc sql;

    select
        count(*) as TOTAL_RECORDS,

        sum(missing(PATIENT_NO))
            as MISSING_PATIENT_NO,

        sum(missing(SITE_NO))
            as MISSING_SITE_NO,

        sum(missing(TREATMENT_START_DATE))
            as MISSING_TREATMENT_START,

        sum(missing(LAST_CONTACT_DATE))
            as MISSING_LAST_CONTACT,

        sum(missing(VITAL_STATUS))
            as MISSING_VITAL_STATUS,

        sum(missing(DEATH_INDICATOR))
            as MISSING_DEATH_INDICATOR

    from RAW.DISPOSITION_SURVIVAL;

quit;


/* STEP 2: IDENTIFY DUPLICATE SUBJECT RECORDS */

proc sql;

    create table QC.DS_DUPLICATE_RECORDS as

    select
        PATIENT_NO,
        SITE_NO,
        count(*) as DUPLICATE_COUNT

    from RAW.DISPOSITION_SURVIVAL

    group by PATIENT_NO, SITE_NO

    having count(*) > 1;

quit;


proc sql;

    select count(*) as TOTAL_DUPLICATE_GROUPS

    from QC.DS_DUPLICATE_RECORDS;

quit;


/* STEP 3: REVIEW VITAL STATUS */

title "VITAL STATUS FREQUENCY";

proc freq data=RAW.DISPOSITION_SURVIVAL;

    tables VITAL_STATUS;

run;


/* STEP 4: REVIEW DEATH INDICATOR */

title "DEATH INDICATOR FREQUENCY";

proc freq data=RAW.DISPOSITION_SURVIVAL;

    tables DEATH_INDICATOR;

run;


/* STEP 5: CHECK INVALID VITAL STATUS VALUES */

proc sql;

    select count(*) as INVALID_VITAL_STATUS

    from RAW.DISPOSITION_SURVIVAL

    where upcase(strip(VITAL_STATUS))
          not in ("ALIVE", "DEAD");

quit;


/* STEP 6: CHECK INVALID DEATH INDICATOR VALUES */

proc sql;

    select count(*) as INVALID_DEATH_INDICATOR

    from RAW.DISPOSITION_SURVIVAL

    where upcase(strip(DEATH_INDICATOR))
          not in ("YES", "NO");

quit;


/* STEP 7: CHECK STATUS AND DEATH INDICATOR CONSISTENCY */

proc sql;

    select count(*) as STATUS_MISMATCH_RECORDS

    from RAW.DISPOSITION_SURVIVAL

    where
        (upcase(strip(VITAL_STATUS)) = "ALIVE"
         and upcase(strip(DEATH_INDICATOR)) = "YES")

        or

        (upcase(strip(VITAL_STATUS)) = "DEAD"
         and upcase(strip(DEATH_INDICATOR)) = "NO");

quit;


/* STEP 8: CHECK DATE SEQUENCE ISSUES */

proc sql;

    select count(*) as INVALID_DATE_RECORDS

    from RAW.DISPOSITION_SURVIVAL

    where
        (not missing(TREATMENT_START_DATE)
         and not missing(LAST_CONTACT_DATE)
         and LAST_CONTACT_DATE < TREATMENT_START_DATE)

        or

        (not missing(EVENT_DATE)
         and not missing(TREATMENT_START_DATE)
         and EVENT_DATE < TREATMENT_START_DATE);

quit;


/* STEP 9: REVIEW EVENT DATE AVAILABILITY */

proc sql;

    select

        count(*) as TOTAL_RECORDS,

        sum(missing(EVENT_DATE))
            as MISSING_EVENT_DATE,

        sum(not missing(EVENT_DATE))
            as AVAILABLE_EVENT_DATE

    from RAW.DISPOSITION_SURVIVAL;

quit;


/* STEP 10: REVIEW DATE SUMMARY */

title "DISPOSITION AND SURVIVAL DATE SUMMARY";

proc means data=RAW.DISPOSITION_SURVIVAL
           n nmiss min max;

    var TREATMENT_START_DATE
        LAST_CONTACT_DATE
        EVENT_DATE;

    format TREATMENT_START_DATE
           LAST_CONTACT_DATE
           EVENT_DATE date9.;

run;


/* STEP 11: RAW DATA RECORD COUNT */

proc sql;

    select count(*) as TOTAL_DS_RECORDS

    from RAW.DISPOSITION_SURVIVAL;

quit;


/* STEP 12: FINAL DATA REVIEW */

title "FINAL DISPOSITION AND SURVIVAL DATA REVIEW";

proc print data=RAW.DISPOSITION_SURVIVAL noobs;

    format TREATMENT_START_DATE
           LAST_CONTACT_DATE
           EVENT_DATE date9.;

run;

title;
