
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 026_EXPOSURE_DATA_VALIDATION              */
/* PURPOSE: Validate raw exposure data                */
/*====================================================*/


/* STEP 1: CHECK MISSING REQUIRED VALUES */

proc sql;

    select
        count(*) as TOTAL_RECORDS,

        sum(missing(PATIENT_NO))
            as MISSING_PATIENT_NO,

        sum(missing(SITE_NO))
            as MISSING_SITE_NO,

        sum(missing(DOSE_START_DATE))
            as MISSING_START_DATE,

        sum(missing(DOSE_END_DATE))
            as MISSING_END_DATE,

        sum(missing(DRUG_NAME))
            as MISSING_DRUG_NAME,

        sum(missing(DOSE_AMOUNT))
            as MISSING_DOSE_AMOUNT,

        sum(missing(DOSE_UNIT))
            as MISSING_DOSE_UNIT,

        sum(missing(ROUTE))
            as MISSING_ROUTE

    from RAW.EXPOSURE;

quit;


/* STEP 2: IDENTIFY DUPLICATE EXPOSURE RECORDS */

proc sql;

    create table QC.EX_DUPLICATE_RECORDS as

    select
        PATIENT_NO,
        SITE_NO,
        DOSE_START_DATE,
        DRUG_NAME,
        count(*) as DUPLICATE_COUNT

    from RAW.EXPOSURE

    group by
        PATIENT_NO,
        SITE_NO,
        DOSE_START_DATE,
        DRUG_NAME

    having count(*) > 1;

quit;


proc sql;

    select count(*) as TOTAL_DUPLICATE_GROUPS
    from QC.EX_DUPLICATE_RECORDS;

quit;


/* STEP 3: CHECK INVALID EXPOSURE DATES */

proc sql;

    select count(*) as INVALID_DATE_RECORDS

    from RAW.EXPOSURE

    where DOSE_START_DATE ne .
      and DOSE_END_DATE ne .
      and DOSE_END_DATE < DOSE_START_DATE;

quit;


/* STEP 4: CHECK INVALID DOSE AMOUNTS */

proc sql;

    select count(*) as INVALID_DOSE_RECORDS

    from RAW.EXPOSURE

    where DOSE_AMOUNT <= 0;

quit;


/* STEP 5: REVIEW DRUG FREQUENCIES */

title "EXPOSURE DRUG FREQUENCY";

proc freq data=RAW.EXPOSURE;

    tables DRUG_NAME;

run;


/* STEP 6: REVIEW DOSE ROUTES */

title "EXPOSURE ROUTE FREQUENCY";

proc freq data=RAW.EXPOSURE;

    tables ROUTE;

run;


/* STEP 7: REVIEW DOSE AMOUNTS */

title "EXPOSURE DOSE SUMMARY";

proc means data=RAW.EXPOSURE
           n nmiss mean min max maxdec=2;

    class DRUG_NAME;

    var DOSE_AMOUNT;

run;


/* STEP 8: RAW EXPOSURE RECORD COUNT */

proc sql;

    select count(*) as RAW_EX_RECORDS
    from RAW.EXPOSURE;

quit;


title;
