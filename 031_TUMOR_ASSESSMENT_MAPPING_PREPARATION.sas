
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 031_TUMOR_ASSESSMENT_MAPPING_PREPARATION  */
/* PURPOSE: Prepare tumor assessment SDTM mapping    */
/*====================================================*/


/* STEP 1: SORT SOURCE DATA */

proc sort data=RAW.TUMOR_ASSESSMENT
          out=WORK.TU_MAPPING_REVIEW;

    by SITE_NO PATIENT_NO SCAN_DATE VISIT_NAME;

run;


/* STEP 2: REVIEW SOURCE VARIABLES */

proc contents data=WORK.TU_MAPPING_REVIEW varnum;

run;


/* STEP 3: REVIEW SUBJECT AND VISIT DETAILS */

title "TUMOR ASSESSMENT SUBJECT AND VISIT REVIEW";

proc print data=WORK.TU_MAPPING_REVIEW noobs;

    var PATIENT_NO SITE_NO SCAN_DATE
        VISIT_NAME LESION_CATEGORY
        OVERALL_RESPONSE RESPONSE_CRITERIA;

    format SCAN_DATE date9.;

run;


/* STEP 4: REVIEW RESPONSE CATEGORIES */

title "OVERALL RESPONSE MAPPING REVIEW";

proc freq data=WORK.TU_MAPPING_REVIEW;

    tables OVERALL_RESPONSE;

run;


/* STEP 5: REVIEW LESION CATEGORIES */

title "LESION CATEGORY MAPPING REVIEW";

proc freq data=WORK.TU_MAPPING_REVIEW;

    tables LESION_CATEGORY;

run;


/* STEP 6: REVIEW VISIT CATEGORIES */

title "VISIT MAPPING REVIEW";

proc freq data=WORK.TU_MAPPING_REVIEW;

    tables VISIT_NAME;

run;


/* STEP 7: REVIEW RESPONSE CRITERIA */

title "RESPONSE CRITERIA REVIEW";

proc freq data=WORK.TU_MAPPING_REVIEW;

    tables RESPONSE_CRITERIA;

run;


/* STEP 8: CHECK SUBJECT AND VISIT COMBINATIONS */

proc sql;

    create table QC.TUMOR_SUBJECT_VISIT_SUMMARY as

    select
        PATIENT_NO,
        SITE_NO,
        VISIT_NAME,
        count(*) as TOTAL_ASSESSMENTS

    from WORK.TU_MAPPING_REVIEW

    group by
        PATIENT_NO,
        SITE_NO,
        VISIT_NAME

    order by
        SITE_NO,
        PATIENT_NO,
        VISIT_NAME;

quit;


/* STEP 9: DISPLAY SUBJECT AND VISIT SUMMARY */

title "TUMOR SUBJECT VISIT SUMMARY";

proc print data=QC.TUMOR_SUBJECT_VISIT_SUMMARY noobs;

run;

title;
