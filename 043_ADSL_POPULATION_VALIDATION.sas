
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 043_ADSL_POPULATION_VALIDATION            */
/* PURPOSE: Validate ADSL population and treatment    */
/*====================================================*/


/* STEP 1: REVIEW TOTAL SUBJECTS */

proc sql;

    select count(*) as TOTAL_SUBJECTS
    from ADAM.ADSL;

quit;


/* STEP 2: CHECK DUPLICATE SUBJECTS */

proc sql;

    create table QC.ADSL_DUPLICATES as

    select USUBJID,
           count(*) as RECORD_COUNT

    from ADAM.ADSL

    group by USUBJID

    having count(*) > 1;

quit;


proc sql;

    select count(*) as DUPLICATE_SUBJECT_GROUPS
    from QC.ADSL_DUPLICATES;

quit;


/* STEP 3: REVIEW SAFETY POPULATION */

title "ADSL SAFETY POPULATION";

proc freq data=ADAM.ADSL;

    tables SAFFL / missing;

run;


/* STEP 4: REVIEW ITT POPULATION FLAG */

title "ADSL ITT POPULATION";

proc freq data=ADAM.ADSL;

    tables ITTFL / missing;

run;


/* STEP 5: CHECK TREATMENT DATE CONSISTENCY */

proc sql;

    select count(*) as INVALID_TREATMENT_DATES

    from ADAM.ADSL

    where not missing(TRTSDT)
      and not missing(TRTEDT)
      and TRTEDT < TRTSDT;

quit;


/* STEP 6: CHECK SAFETY FLAG AND EXPOSURE DATE */

proc sql;

    select count(*) as SAFETY_FLAG_ISSUES

    from ADAM.ADSL

    where
        (SAFFL = "Y" and missing(TRTSDT))

        or

        (missing(SAFFL) and not missing(TRTSDT));

quit;


/* STEP 7: REVIEW PLANNED TREATMENT */

title "PLANNED TREATMENT FREQUENCY";

proc freq data=ADAM.ADSL;

    tables TRT01P;

run;


/* STEP 8: REVIEW ACTUAL TREATMENT */

title "ACTUAL TREATMENT FREQUENCY";

proc freq data=ADAM.ADSL;

    tables TRT01A / missing;

run;


/* STEP 9: FINAL ADSL SUBJECT SUMMARY */

proc sql;

    select

        count(*) as TOTAL_SUBJECTS,

        count(distinct USUBJID)
            as UNIQUE_SUBJECTS,

        sum(SAFFL = "Y")
            as SAFETY_SUBJECTS,

        sum(missing(SAFFL))
            as SUBJECTS_NOT_IN_SAFETY

    from ADAM.ADSL;

quit;
