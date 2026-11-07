
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 048_ADSL_FINAL_DATASET_REVIEW             */
/* PURPOSE: Perform final ADSL dataset review         */
/*====================================================*/


/* STEP 1: REVIEW ADSL STRUCTURE */

title "FINAL ADSL DATASET STRUCTURE";

proc contents data=ADAM.ADSL;

run;


/* STEP 2: CHECK TOTAL AND UNIQUE SUBJECTS */

proc sql;

    select

        count(*) as TOTAL_RECORDS,

        count(distinct USUBJID) as UNIQUE_SUBJECTS,

        sum(missing(USUBJID)) as MISSING_SUBJECT_IDS

    from ADAM.ADSL;

quit;


/* STEP 3: CHECK DUPLICATE SUBJECTS */

proc sql;

    create table QC.ADSL_FINAL_DUPLICATES as

    select

        USUBJID,

        count(*) as RECORD_COUNT

    from ADAM.ADSL

    group by USUBJID

    having count(*) > 1;

quit;


/* STEP 4: CHECK TREATMENT DATE LOGIC */

proc sql;

    select

        sum(
            not missing(TRTSDT)
            and not missing(TRTEDT)
            and TRTEDT < TRTSDT
        ) as INVALID_TREATMENT_DATES,

        sum(
            not missing(TRTSDT)
            and missing(TRTEDT)
        ) as MISSING_TREATMENT_END_DATES

    from ADAM.ADSL;

quit;


/* STEP 5: CHECK SAFETY POPULATION CONSISTENCY */

proc sql;

    select

        sum(SAFFL="Y") as SAFETY_SUBJECTS,

        sum(
            SAFFL="Y" and missing(TRTSDT)
        ) as SAFETY_FLAG_ISSUES,

        sum(
            missing(SAFFL) and not missing(TRTSDT)
        ) as MISSING_SAFETY_FLAGS

    from ADAM.ADSL;

quit;


/* STEP 6: REVIEW ANALYSIS POPULATION FLAGS */

title "ADSL ANALYSIS POPULATION FLAGS";

proc freq data=ADAM.ADSL;

    tables SAFFL ITTFL DTHFL / missing;

run;


/* STEP 7: CHECK PLANNED AND ACTUAL TREATMENT */

title "ADSL TREATMENT ASSIGNMENT REVIEW";

proc freq data=ADAM.ADSL;

    tables TRT01P TRT01A / missing;

run;


/* STEP 8: DISPLAY FINAL SUBJECT-LEVEL DATA */

title "FINAL ADSL SUBJECT-LEVEL DATA";

proc print data=ADAM.ADSL noobs;

    var STUDYID USUBJID SUBJID SITEID AGE SEX
        TRT01P TRT01A TRTSDT TRTEDT
        SAFFL ITTFL DTHFL;

run;

title;
