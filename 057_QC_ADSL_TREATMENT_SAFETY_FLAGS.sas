
*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 057_QC_ADSL_TREATMENT_SAFETY_FLAGS        */
/* PURPOSE: Independently validate ADSL treatment and */
/*          safety population flags                   */
/*====================================================*/


/* STEP 1: DERIVE EXPECTED EXPOSURE SUBJECTS */

proc sql;

    create table WORK.QC_EXPECTED_EXPOSURE as

    select

        cats(
            "NSCLC001-",
            put(SITE_NO, z4.),
            "-",
            put(PATIENT_NO, z3.)
        ) as USUBJID length=30,

        max(DRUG_NAME) as EXPECTED_TRT01A length=100,

        count(*) as EXPOSURE_RECORDS

    from RAW.EXPOSURE

    group by SITE_NO, PATIENT_NO;

quit;


/* STEP 2: DERIVE EXPECTED PLANNED TREATMENT */

proc sort data=SDTM.DM_UPDATED
          out=WORK.QC_DM_SORTED;

    by USUBJID;

run;


/* STEP 3: SORT EXPOSURE SUMMARY */

proc sort data=WORK.QC_EXPECTED_EXPOSURE;

    by USUBJID;

run;


/* STEP 4: MERGE EXPECTED DATA WITH ADSL */

proc sort data=ADAM.ADSL
          out=WORK.QC_ADSL_SORTED;

    by USUBJID;

run;


data WORK.QC_TREATMENT_COMPARE;

    merge WORK.QC_ADSL_SORTED(in=IN_ADSL)

          WORK.QC_EXPECTED_EXPOSURE(in=IN_EXPOSURE);

    by USUBJID;

    length SAFETY_QC $12
           ACTUAL_TRT_QC $12;

    if IN_ADSL then do;

        if IN_EXPOSURE and SAFFL="Y" then
            SAFETY_QC="MATCH";

        else if not IN_EXPOSURE and missing(SAFFL) then
            SAFETY_QC="MATCH";

        else
            SAFETY_QC="MISMATCH";

        if IN_EXPOSURE and TRT01A=EXPECTED_TRT01A then
            ACTUAL_TRT_QC="MATCH";

        else if not IN_EXPOSURE and missing(TRT01A) then
            ACTUAL_TRT_QC="MATCH";

        else
            ACTUAL_TRT_QC="MISMATCH";

    end;

    if IN_ADSL;

run;


/* STEP 5: CREATE FINAL QC DATASET */

data QC.ADSL_TREATMENT_SAFETY_QC;

    set WORK.QC_TREATMENT_COMPARE;

run;


/* STEP 6: REVIEW SAFETY FLAG RESULTS */

title "INDEPENDENT SAFETY FLAG QC";

proc freq data=QC.ADSL_TREATMENT_SAFETY_QC;

    tables SAFETY_QC / missing;

run;


/* STEP 7: REVIEW ACTUAL TREATMENT RESULTS */

title "INDEPENDENT ACTUAL TREATMENT QC";

proc freq data=QC.ADSL_TREATMENT_SAFETY_QC;

    tables ACTUAL_TRT_QC / missing;

run;


/* STEP 8: DISPLAY MISMATCHES */

title "TREATMENT AND SAFETY QC MISMATCH REVIEW";

proc print data=QC.ADSL_TREATMENT_SAFETY_QC noobs;

    where SAFETY_QC="MISMATCH"
       or ACTUAL_TRT_QC="MISMATCH";

    var USUBJID SAFFL TRT01A EXPECTED_TRT01A
        SAFETY_QC ACTUAL_TRT_QC;

run;

title;
