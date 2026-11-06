
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 020_SDTM_LB_VALIDATION                    */
/* PURPOSE: Validate SDTM Laboratory (LB) domain     */
/*====================================================*/


/* STEP 1: Check SDTM LB dataset structure */

proc contents data=SDTM.LB;
run;


/* STEP 2: Check missing required variables */

data QC.LB_MISSING_REQUIRED;

    set SDTM.LB;

    if missing(STUDYID)
       or missing(DOMAIN)
       or missing(USUBJID)
       or missing(LBSEQ)
       or missing(LBTESTCD)
       or missing(LBTEST)
       or missing(LBORRES)
       or missing(LBDTC);

run;


/* STEP 3: Identify duplicate subject and sequence keys */

proc sql;

    create table QC.LB_DUPLICATE_KEYS as

    select USUBJID,
           LBSEQ,
           count(*) as RECORD_COUNT

    from SDTM.LB

    group by USUBJID, LBSEQ

    having count(*) > 1;

quit;


/* STEP 4: Check invalid laboratory test codes */

data QC.LB_INVALID_TEST_CODES;

    set SDTM.LB;

    if LBTESTCD not in ("HGB", "NEUT", "PLAT");

run;


/* STEP 5: Check missing original results */

data QC.LB_MISSING_ORIGINAL_RESULTS;

    set SDTM.LB;

    if missing(LBORRES);

run;


/* STEP 6: Check missing standardized results */

data QC.LB_MISSING_STANDARD_RESULTS;

    set SDTM.LB;

    if missing(LBSTRESC)
       or missing(LBSTRESN);

run;


/* STEP 7: Check missing laboratory units */

data QC.LB_MISSING_UNITS;

    set SDTM.LB;

    if missing(LBORRESU)
       or missing(LBSTRESU);

run;


/* STEP 8: Check invalid normal range indicators */

data QC.LB_INVALID_FLAGS;

    set SDTM.LB;

    if LBNRIND not in ("LOW", "NORMAL");

run;


/* STEP 9: Check laboratory collection dates */

data QC.LB_DATE_ISSUES;

    set SDTM.LB;

    if missing(LBDTC)
       or input(LBDTC, yymmdd10.) = .;

run;


/* STEP 10: Review laboratory test distribution */

title "SDTM LB TEST FREQUENCY";

proc freq data=SDTM.LB;

    tables LBTESTCD / missing;

run;


/* STEP 11: Review normal range indicators */

title "SDTM LB NORMAL RANGE INDICATOR";

proc freq data=SDTM.LB;

    tables LBNRIND / missing;

run;


/* STEP 12: Reconcile RAW and SDTM record counts */

proc sql;

    select count(*) as RAW_LAB_RECORDS
    from RAW.LABORATORY;

    select count(*) as SDTM_LB_RECORDS
    from SDTM.LB;

quit;


/* STEP 13: Generate SDTM LB validation summary */

title "SDTM LB VALIDATION SUMMARY";

proc sql;

    select count(*) as TOTAL_LB_RECORDS
    from SDTM.LB;

    select count(*) as MISSING_REQUIRED_RECORDS
    from QC.LB_MISSING_REQUIRED;

    select count(*) as DUPLICATE_KEY_GROUPS
    from QC.LB_DUPLICATE_KEYS;

    select count(*) as INVALID_TEST_CODES
    from QC.LB_INVALID_TEST_CODES;

    select count(*) as MISSING_ORIGINAL_RESULTS
    from QC.LB_MISSING_ORIGINAL_RESULTS;

    select count(*) as MISSING_STANDARD_RESULTS
    from QC.LB_MISSING_STANDARD_RESULTS;

    select count(*) as MISSING_UNITS
    from QC.LB_MISSING_UNITS;

    select count(*) as INVALID_FLAGS
    from QC.LB_INVALID_FLAGS;

    select count(*) as DATE_ISSUES
    from QC.LB_DATE_ISSUES;

quit;


/* STEP 14: Clear report title */

title;
