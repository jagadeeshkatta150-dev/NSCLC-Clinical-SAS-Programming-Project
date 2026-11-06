
/*====================================================*/
/* PROJECT: NSCLC CLINICAL TRIAL                      */
/* PROGRAM: 022_VITAL_SIGNS_DATA_VALIDATION           */
/* PURPOSE: Validate Vital Signs data                 */
/*====================================================*/

proc contents data=RAW.VITAL_SIGNS;
run;

/* Check missing required values */

data QC.VS_MISSING_REQUIRED;
    set RAW.VITAL_SIGNS;

    if missing(PATIENT_NO)
       or missing(SITE_NO)
       or missing(ASSESSMENT_DATE)
       or missing(MEASUREMENT_NAME)
       or missing(MEASUREMENT_VALUE)
       or missing(MEASUREMENT_UNIT);
run;

/* Identify duplicate records */

proc sql;
    create table QC.VS_DUPLICATE_RECORDS as
    select PATIENT_NO,
           SITE_NO,
           ASSESSMENT_DATE,
           MEASUREMENT_NAME,
           count(*) as RECORD_COUNT
    from RAW.VITAL_SIGNS
    group by PATIENT_NO,
             SITE_NO,
             ASSESSMENT_DATE,
             MEASUREMENT_NAME
    having count(*) > 1;
quit;

/* Check invalid measurements */

data QC.VS_INVALID_VALUES;
    set RAW.VITAL_SIGNS;

    if upcase(strip(MEASUREMENT_NAME)) =
       "SYSTOLIC BLOOD PRESSURE"
       and (MEASUREMENT_VALUE <= 0
       or MEASUREMENT_VALUE > 300);

    else if upcase(strip(MEASUREMENT_NAME)) =
       "DIASTOLIC BLOOD PRESSURE"
       and (MEASUREMENT_VALUE <= 0
       or MEASUREMENT_VALUE > 200);

    else if upcase(strip(MEASUREMENT_NAME)) = "PULSE"
       and (MEASUREMENT_VALUE <= 0
       or MEASUREMENT_VALUE > 250);
run;

/* Check missing assessment dates */

data QC.VS_MISSING_DATES;
    set RAW.VITAL_SIGNS;
    if missing(ASSESSMENT_DATE);
run;

/* Measurement frequency */

proc freq data=RAW.VITAL_SIGNS;
    tables MEASUREMENT_NAME MEASUREMENT_UNIT / missing;
run;

/* Measurement statistics */

proc means data=RAW.VITAL_SIGNS
           n nmiss mean min max maxdec=2;
    class MEASUREMENT_NAME;
    var MEASUREMENT_VALUE;
run;

/* Validation summary */

proc sql;
    select count(*) as TOTAL_VS_RECORDS
    from RAW.VITAL_SIGNS;

    select count(*) as MISSING_REQUIRED_RECORDS
    from QC.VS_MISSING_REQUIRED;

    select count(*) as DUPLICATE_RECORD_GROUPS
    from QC.VS_DUPLICATE_RECORDS;

    select count(*) as INVALID_MEASUREMENT_RECORDS
    from QC.VS_INVALID_VALUES;

    select count(*) as MISSING_DATE_RECORDS
    from QC.VS_MISSING_DATES;
quit;

title;
