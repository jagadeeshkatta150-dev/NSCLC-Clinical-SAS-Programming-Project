
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 055_T1_ADSL_POPULATION_SUMMARY            */
/* PURPOSE: Create overall ADSL population summary    */
/*====================================================*/


/* STEP 1: CREATE OVERALL POPULATION SUMMARY */

proc sql;

    create table QC.ADSL_POPULATION_SUMMARY as

    select

        count(*) as TOTAL_SUBJECTS,

        sum(SAFFL="Y") as SAFETY_SUBJECTS,

        sum(not missing(TRT01A))
            as SUBJECTS_WITH_ACTUAL_TREATMENT,

        sum(DTHFL="Y") as DEATH_SUBJECTS,

        sum(missing(ITTFL)) as SUBJECTS_WITHOUT_ITT_FLAG

    from ADAM.ADSL;

quit;


/* STEP 2: DISPLAY POPULATION SUMMARY */

title "OVERALL ADSL POPULATION SUMMARY";

proc print data=QC.ADSL_POPULATION_SUMMARY noobs;

run;


/* STEP 3: REVIEW POPULATION FLAGS */

title "ADSL POPULATION FLAG FREQUENCIES";

proc freq data=ADAM.ADSL;

    tables SAFFL ITTFL DTHFL / missing;

run;


/* STEP 4: REVIEW TREATMENT ASSIGNMENTS */

title "PLANNED AND ACTUAL TREATMENT REVIEW";

proc freq data=ADAM.ADSL;

    tables TRT01P TRT01A / missing;

run;

title;
