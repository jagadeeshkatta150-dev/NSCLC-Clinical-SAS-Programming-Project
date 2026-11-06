
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 024_SDTM_VS_VALIDATION                    */
/* PURPOSE: Validate SDTM Vital Signs domain          */
/*====================================================*/

/* STEP 1: Check dataset structure */

proc contents data=SDTM.VS;
run;


/* STEP 2: Check missing required variables */

data QC.VS_MISSING_REQUIRED;
    set SDTM.VS;

    if missing(STUDYID)
       or missing(DOMAIN)
       or missing(USUBJID)
       or missing(VSSEQ)
       or missing(VSTESTCD)
       or missing(VSTEST)
       or missing(VSORRES)
       or missing(VSDTC);
run;


/* STEP 3: Identify duplicate subject and sequence keys */

proc sql;
    create table QC.VS_DUPLICATE_KEYS as
    select USUBJID,
           VSSEQ,
           count(*) as RECORD_COUNT
    from SDTM.VS
    group by USUBJID, VSSEQ
    having count(*) > 1;
quit;


/* STEP 4: Check invalid vital signs test codes */

data QC.VS_INVALID_TEST_CODES;
    set SDTM.VS;

    if VSTESTCD not in ("SYSBP", "DIABP", "PULSE");
run;


/* STEP 5: Check missing original results */

data QC.VS_MISSING_ORIGINAL_RESULTS;
    set SDTM.VS;

    if missing(VSORRES);
run;


/* STEP 6: Check missing standardized results */

data QC.VS_MISSING_STANDARD_RESULTS;
    set SDTM.VS;

    if missing(VSSTRESC) or missing(VSSTRESN);
run;


/* STEP 7: Check missing measurement units */

data QC.VS_MISSING_UNITS;
    set SDTM.VS;

    if missing(VSORRESU) or missing(VSSTRESU);
run;


/* STEP 8: Check assessment dates */

data QC.VS_DATE_ISSUES;
    set SDTM.VS;

    if missing(VSDTC)
       or input(VSDTC, yymmdd10.) = .;
run;


/* STEP 9: Review vital signs test distribution */

title "SDTM VS TEST FREQUENCY";

proc freq data=SDTM.VS;
    tables VSTESTCD / missing;
run;


/* STEP 10: Review vital signs measurement units */

title "SDTM VS UNIT FREQUENCY";

proc freq data=SDTM.VS;
    tables VSSTRESU / missing;
run;


/* STEP 11: Review vital signs statistics */

title "SDTM VS RESULT SUMMARY";

proc means data=SDTM.VS
           n nmiss mean min max maxdec=2;
    class VSTESTCD;
    var VSSTRESN;
run;


/* STEP 12: Reconcile RAW and SDTM record counts */

proc sql;
    select count(*) as RAW_VS_RECORDS
    from RAW.VITAL_SIGNS;

    select count(*) as SDTM_VS_RECORDS
    from SDTM.VS;
quit;


/* STEP 13: Generate validation summary */

title "SDTM VS VALIDATION SUMMARY";

proc sql;
    select count(*) as TOTAL_VS_RECORDS
    from SDTM.VS;

    select count(*) as MISSING_REQUIRED_RECORDS
    from QC.VS_MISSING_REQUIRED;

    select count(*) as DUPLICATE_KEY_GROUPS
    from QC.VS_DUPLICATE_KEYS;

    select count(*) as INVALID_TEST_CODES
    from QC.VS_INVALID_TEST_CODES;

    select count(*) as MISSING_ORIGINAL_RESULTS
    from QC.VS_MISSING_ORIGINAL_RESULTS;

    select count(*) as MISSING_STANDARD_RESULTS
    from QC.VS_MISSING_STANDARD_RESULTS;

    select count(*) as MISSING_UNITS
    from QC.VS_MISSING_UNITS;

    select count(*) as DATE_ISSUES
    from QC.VS_DATE_ISSUES;
quit;


/* STEP 14: Clear report title */

title;
