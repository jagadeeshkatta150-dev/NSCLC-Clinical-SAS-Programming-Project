
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 056_QC_ADSL_SUBJECT_RECONCILIATION        */
/* PURPOSE: Independently reconcile RAW demographics */
/*          against ADaM ADSL subject identifiers     */
/*====================================================*/


/* STEP 1: CREATE EXPECTED SUBJECT IDS FROM RAW DATA */

data WORK.QC_RAW_SUBJECTS;

    set RAW.DEMOGRAPHICS;

    length USUBJID $30;

    USUBJID = cats(
        "NSCLC001-",
        put(SITE_NO, z4.),
        "-",
        put(PATIENT_NO, z3.)
    );

    keep USUBJID;

run;


/* STEP 2: SORT RAW SUBJECT IDS */

proc sort data=WORK.QC_RAW_SUBJECTS;

    by USUBJID;

run;


/* STEP 3: SORT ADSL SUBJECT IDS */

proc sort data=ADAM.ADSL
          out=WORK.QC_ADSL_SUBJECTS;

    by USUBJID;

run;


/* STEP 4: IDENTIFY DUPLICATE SUBJECTS IN RAW */

proc sql;

    create table QC.RAW_SUBJECT_DUPLICATES as

    select USUBJID,
           count(*) as RECORD_COUNT

    from WORK.QC_RAW_SUBJECTS

    group by USUBJID

    having count(*) > 1;

quit;


/* STEP 5: IDENTIFY DUPLICATE SUBJECTS IN ADSL */

proc sql;

    create table QC.ADSL_SUBJECT_DUPLICATES as

    select USUBJID,
           count(*) as RECORD_COUNT

    from WORK.QC_ADSL_SUBJECTS

    group by USUBJID

    having count(*) > 1;

quit;


/* STEP 6: RECONCILE RAW AND ADSL SUBJECTS */

data QC.ADSL_SUBJECT_RECONCILIATION;

    merge WORK.QC_RAW_SUBJECTS
          (in=IN_RAW)

          WORK.QC_ADSL_SUBJECTS
          (in=IN_ADSL keep=USUBJID);

    by USUBJID;

    length QC_STATUS $20;

    if IN_RAW and IN_ADSL then
        QC_STATUS = "MATCH";

    else if IN_RAW and not IN_ADSL then
        QC_STATUS = "MISSING_IN_ADSL";

    else if IN_ADSL and not IN_RAW then
        QC_STATUS = "EXTRA_IN_ADSL";

run;


/* STEP 7: SUMMARIZE RECONCILIATION RESULTS */

title "ADSL SUBJECT RECONCILIATION RESULTS";

proc freq data=QC.ADSL_SUBJECT_RECONCILIATION;

    tables QC_STATUS / missing;

run;


/* STEP 8: REVIEW DUPLICATE COUNTS */

proc sql;

    select count(*) as RAW_DUPLICATE_GROUPS
    from QC.RAW_SUBJECT_DUPLICATES;

    select count(*) as ADSL_DUPLICATE_GROUPS
    from QC.ADSL_SUBJECT_DUPLICATES;

quit;


/* STEP 9: DISPLAY RECONCILIATION DETAILS */

title "FINAL SUBJECT RECONCILIATION";

proc print data=QC.ADSL_SUBJECT_RECONCILIATION noobs;

    var USUBJID QC_STATUS;

run;

title;
