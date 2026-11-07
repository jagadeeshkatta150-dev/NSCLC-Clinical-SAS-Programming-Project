
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 042_ADSL_TREATMENT_DATE_DERIVATION        */
/* PURPOSE: Derive ADSL treatment dates and flags     */
/*====================================================*/


/* STEP 1: PREPARE SUBJECT-LEVEL DEMOGRAPHICS */

data WORK.ADSL_BASE;

    set SDTM.DM_UPDATED;

    length SAFFL $1
           ITTFL $1
           TRT01P $30
           TRT01A $30;

    TRT01P = ARM;

    /* ITT STATUS REQUIRES RANDOMIZATION CONFIRMATION */

    ITTFL = "";

    keep STUDYID USUBJID SUBJID SITEID
         AGE SEX ARM DTHFL TRT01P ITTFL;

run;


/* STEP 2: PREPARE RAW EXPOSURE DATA */

data WORK.EX_SUBJECT;

    set RAW.EXPOSURE;

    length STUDYID $12
           SITEID $4
           SUBJID $3
           USUBJID $40;

    STUDYID = "NSCLC001";

    SITEID = put(SITE_NO, z4.);

    SUBJID = put(PATIENT_NO, z3.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);

run;


/* STEP 3: SUMMARIZE EXPOSURE BY SUBJECT */

proc sql;

    create table WORK.EX_SUMMARY as

    select
        USUBJID,

        min(DOSE_START_DATE) as TRTSDT,

        max(DOSE_END_DATE) as TRTEDT,

        max(DRUG_NAME) as ACTUAL_TREATMENT
            length=30,

        count(*) as EXPOSURE_RECORDS,

        count(distinct DRUG_NAME)
            as DISTINCT_TREATMENTS

    from WORK.EX_SUBJECT

    group by USUBJID;

quit;


/* STEP 4: IDENTIFY TREATMENT INCONSISTENCIES */

data QC.EX_TREATMENT_INCONSISTENCY;

    set WORK.EX_SUMMARY;

    if DISTINCT_TREATMENTS > 1;

run;


/* STEP 5: SORT SUBJECT-LEVEL DATASETS */

proc sort data=WORK.ADSL_BASE;
    by USUBJID;
run;

proc sort data=WORK.EX_SUMMARY;
    by USUBJID;
run;


/* STEP 6: MERGE EXPOSURE INFORMATION INTO ADSL */

data ADAM.ADSL;

    length SAFFL $1
           ITTFL $1
           TRT01A $30;

    merge WORK.ADSL_BASE(in=A)
          WORK.EX_SUMMARY(in=E);

    by USUBJID;

    if A;

    /* SAFETY POPULATION FLAG */

    if E then SAFFL = "Y";
    else SAFFL = "";


    /* ACTUAL TREATMENT */

    if E and DISTINCT_TREATMENTS = 1 then
        TRT01A = ACTUAL_TREATMENT;

    else
        TRT01A = "";


    /* TREATMENT START AND END DATES */

    if E then do;

        TRTSDT = TRTSDT;
        TRTEDT = TRTEDT;

    end;

    format TRTSDT TRTEDT date9.;


    drop ACTUAL_TREATMENT
         EXPOSURE_RECORDS
         DISTINCT_TREATMENTS;

run;


/* STEP 7: REVIEW FINAL ADSL STRUCTURE */

proc contents data=ADAM.ADSL varnum;
run;


/* STEP 8: REVIEW SUBJECT-LEVEL TREATMENT */

title "ADSL TREATMENT DATE REVIEW";

proc print data=ADAM.ADSL noobs;

    var USUBJID TRT01P TRT01A
        TRTSDT TRTEDT SAFFL ITTFL;

run;


/* STEP 9: REVIEW SAFETY FLAG FREQUENCY */

title "ADSL SAFETY POPULATION FREQUENCY";

proc freq data=ADAM.ADSL;

    tables SAFFL / missing;

run;


/* STEP 10: REVIEW PLANNED AND ACTUAL TREATMENT */

title "ADSL PLANNED TREATMENT";

proc freq data=ADAM.ADSL;

    tables TRT01P;

run;

title "ADSL ACTUAL TREATMENT";

proc freq data=ADAM.ADSL;

    tables TRT01A / missing;

run;


/* STEP 11: COUNT SUBJECTS AND EXPOSURE RECORDS */

proc sql;

    select
        count(*) as TOTAL_ADSL_SUBJECTS,

        sum(not missing(SAFFL))
            as SUBJECTS_WITH_EXPOSURE,

        sum(missing(SAFFL))
            as SUBJECTS_WITHOUT_EXPOSURE

    from ADAM.ADSL;

quit;


/* STEP 12: REVIEW TREATMENT INCONSISTENCIES */

title "EXPOSURE TREATMENT INCONSISTENCY REVIEW";

proc print data=QC.EX_TREATMENT_INCONSISTENCY noobs;
run;

title;
