
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 016_SDTM_AE_VALIDATION                    */
/* PURPOSE: Validate SDTM Adverse Events domain       */
/*====================================================*/


/* STEP 1: Check SDTM AE dataset structure */

proc contents data=SDTM.AE;
run;


/* STEP 2: Check missing required variables */

data QC.AE_MISSING_REQUIRED;

    set SDTM.AE;

    if missing(STUDYID)
       or missing(DOMAIN)
       or missing(USUBJID)
       or missing(AESEQ)
       or missing(AETERM)
       or missing(AESTDTC);

run;


/* STEP 3: Identify duplicate subject and sequence keys */

proc sql;

    create table QC.AE_DUPLICATE_KEYS as

    select USUBJID,
           AESEQ,
           count(*) as RECORD_COUNT

    from SDTM.AE

    group by USUBJID, AESEQ

    having count(*) > 1;

quit;


/* STEP 4: Check invalid severity values */

data QC.AE_INVALID_SEVERITY;

    set SDTM.AE;

    if missing(AESEV)
       or AESEV not in
       ("MILD", "MODERATE", "SEVERE");

run;


/* STEP 5: Check invalid serious event values */

data QC.AE_INVALID_SERIOUS;

    set SDTM.AE;

    if missing(AESER)
       or AESER not in ("Y", "N");

run;


/* STEP 6: Check missing adverse event terms */

data QC.AE_MISSING_TERM;

    set SDTM.AE;

    if missing(AETERM);

run;


/* STEP 7: Check date inconsistencies */

data QC.AE_DATE_ISSUES;

    set SDTM.AE;

    if missing(AESTDTC)
       or
       (
         not missing(AEENDTC)
         and input(AEENDTC, yymmdd10.)
             < input(AESTDTC, yymmdd10.)
       );

run;


/* STEP 8: Check relatedness values */

proc freq data=SDTM.AE;

    tables AEREL / missing;

run;


/* STEP 9: Check outcome values */

proc freq data=SDTM.AE;

    tables AEOUT / missing;

run;


/* STEP 10: Reconcile RAW and SDTM record counts */

proc sql;

    select count(*) as RAW_AE_RECORDS
    from RAW.ADVERSE_EVENTS;

    select count(*) as SDTM_AE_RECORDS
    from SDTM.AE;

quit;


/* STEP 11: Generate validation summary */

title "SDTM AE VALIDATION SUMMARY";

proc sql;

    select count(*) as TOTAL_AE_RECORDS
    from SDTM.AE;

    select count(*) as MISSING_REQUIRED_RECORDS
    from QC.AE_MISSING_REQUIRED;

    select count(*) as DUPLICATE_KEY_GROUPS
    from QC.AE_DUPLICATE_KEYS;

    select count(*) as INVALID_SEVERITY_RECORDS
    from QC.AE_INVALID_SEVERITY;

    select count(*) as INVALID_SERIOUS_RECORDS
    from QC.AE_INVALID_SERIOUS;

    select count(*) as MISSING_TERM_RECORDS
    from QC.AE_MISSING_TERM;

    select count(*) as DATE_ISSUE_RECORDS
    from QC.AE_DATE_ISSUES;

quit;


/* STEP 12: Clear report title */

title;
