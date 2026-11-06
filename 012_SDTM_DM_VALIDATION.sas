
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 012_SDTM_DM_VALIDATION                    */
/* PURPOSE: Validate SDTM Demographics Domain         */
/*====================================================*/


/* STEP 1: Check SDTM DM dataset structure */

proc contents data=SDTM.DM;
run;


/* STEP 2: Identify missing required values */

data QC.DM_MISSING_REQUIRED;
    set SDTM.DM;

    if missing(STUDYID)
       or missing(DOMAIN)
       or missing(USUBJID)
       or missing(SUBJID)
       or missing(SITEID)
       or missing(SEX)
       or missing(ARMCD)
       or missing(ARM);
run;


/* STEP 3: Identify duplicate USUBJID groups */

proc sql;

    create table QC.DM_DUPLICATE_USUBJID as

    select USUBJID,
           count(*) as ID_COUNT

    from SDTM.DM

    where not missing(USUBJID)

    group by USUBJID

    having count(*) > 1;

quit;


/* STEP 4: Validate SEX values */

data QC.DM_INVALID_SEX;
    set SDTM.DM;

    if not missing(SEX)
       and SEX not in ("M", "F", "U", "UNDIFFERENTIATED");
run;


/* STEP 5: Validate AGE and AGEU */

data QC.DM_INVALID_AGE;
    set SDTM.DM;

    if not missing(AGE)
       and AGE < 0;

    if not missing(AGE)
       and AGEU ne "YEARS";

run;


/* STEP 6: Validate treatment arm combinations */

data QC.DM_INVALID_ARM;
    set SDTM.DM;

    if (ARMCD = "INV" and ARM ne "Investigational Drug")
       or
       (ARMCD = "STD" and ARM ne "Standard Care")
       or
       (ARMCD not in ("INV", "STD"))
       or
       missing(ARMCD)
       or missing(ARM);
run;


/* STEP 7: Identify missing consent dates */

data QC.DM_MISSING_CONSENT_DATE;
    set SDTM.DM;

    if missing(RFICDTC);
run;


/* STEP 8: Check total DM records */

proc sql;

    select count(*) as TOTAL_DM_RECORDS
    from SDTM.DM;

quit;


/* STEP 9: Generate validation summary */

title "SDTM DM VALIDATION SUMMARY";

proc sql;

    select count(*) as MISSING_REQUIRED_RECORDS
    from QC.DM_MISSING_REQUIRED;

    select count(*) as DUPLICATE_USUBJID_GROUPS
    from QC.DM_DUPLICATE_USUBJID;

    select count(*) as INVALID_SEX_RECORDS
    from QC.DM_INVALID_SEX;

    select count(*) as INVALID_AGE_RECORDS
    from QC.DM_INVALID_AGE;

    select count(*) as INVALID_ARM_RECORDS
    from QC.DM_INVALID_ARM;

    select count(*) as MISSING_CONSENT_DATES
    from QC.DM_MISSING_CONSENT_DATE;

quit;


/* STEP 10: Review subject-level distribution */

title "SDTM DM SUBJECT DISTRIBUTION";

proc freq data=SDTM.DM;

    tables SEX ARMCD SITEID;

run;


/* STEP 11: Clear report titles */

title;
