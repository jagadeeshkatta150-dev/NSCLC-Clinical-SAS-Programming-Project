
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 030_TUMOR_ASSESSMENT_VALIDATION           */
/* PURPOSE: Validate raw tumor assessment data        */
/*====================================================*/


/* STEP 1: CHECK MISSING REQUIRED VALUES */

proc sql;

    select
        count(*) as TOTAL_RECORDS,

        sum(missing(PATIENT_NO))
            as MISSING_PATIENT_NO,

        sum(missing(SITE_NO))
            as MISSING_SITE_NO,

        sum(missing(SCAN_DATE))
            as MISSING_SCAN_DATE,

        sum(missing(VISIT_NAME))
            as MISSING_VISIT_NAME,

        sum(missing(LESION_CATEGORY))
            as MISSING_LESION_CATEGORY,

        sum(missing(OVERALL_RESPONSE))
            as MISSING_RESPONSE,

        sum(missing(RESPONSE_CRITERIA))
            as MISSING_CRITERIA

    from RAW.TUMOR_ASSESSMENT;

quit;


/* STEP 2: IDENTIFY DUPLICATE ASSESSMENTS */

proc sql;

    create table QC.TU_DUPLICATE_RECORDS as

    select
        PATIENT_NO,
        SITE_NO,
        SCAN_DATE,
        LESION_CATEGORY,
        count(*) as DUPLICATE_COUNT

    from RAW.TUMOR_ASSESSMENT

    group by
        PATIENT_NO,
        SITE_NO,
        SCAN_DATE,
        LESION_CATEGORY

    having count(*) > 1;

quit;


proc sql;

    select count(*) as TOTAL_DUPLICATE_GROUPS

    from QC.TU_DUPLICATE_RECORDS;

quit;


/* STEP 3: CHECK RESPONSE CATEGORIES */

title "TUMOR OVERALL RESPONSE FREQUENCY";

proc freq data=RAW.TUMOR_ASSESSMENT;

    tables OVERALL_RESPONSE;

run;


/* STEP 4: CHECK RESPONSE CRITERIA */

title "TUMOR RESPONSE CRITERIA FREQUENCY";

proc freq data=RAW.TUMOR_ASSESSMENT;

    tables RESPONSE_CRITERIA;

run;


/* STEP 5: CHECK INVALID RESPONSE VALUES */

proc sql;

    select count(*) as INVALID_RESPONSE_RECORDS

    from RAW.TUMOR_ASSESSMENT

    where upcase(strip(OVERALL_RESPONSE))
          not in
          (
              "COMPLETE RESPONSE",
              "PARTIAL RESPONSE",
              "STABLE DISEASE",
              "PROGRESSIVE DISEASE"
          );

quit;


/* STEP 6: CHECK MISSING OR INVALID ASSESSMENT DATES */

proc sql;

    select count(*) as MISSING_SCAN_DATES

    from RAW.TUMOR_ASSESSMENT

    where missing(SCAN_DATE);

quit;


/* STEP 7: REVIEW VISIT FREQUENCIES */

title "TUMOR ASSESSMENT VISIT FREQUENCY";

proc freq data=RAW.TUMOR_ASSESSMENT;

    tables VISIT_NAME;

run;


/* STEP 8: RAW RECORD COUNT */

proc sql;

    select count(*) as TOTAL_TUMOR_RECORDS

    from RAW.TUMOR_ASSESSMENT;

quit;


/* STEP 9: FINAL SOURCE DATA REVIEW */

title "FINAL TUMOR ASSESSMENT DATA REVIEW";

proc print data=RAW.TUMOR_ASSESSMENT noobs;

run;

title;
