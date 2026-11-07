
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 047_ADSL_DISPOSITION_SURVIVAL_SUMMARY     */
/* PURPOSE: Summarize subject vital status and        */
/*          death flag by planned treatment           */
/*====================================================*/


/* STEP 1: REVIEW ADSL SURVIVAL VARIABLES */

title "ADSL SURVIVAL VARIABLE REVIEW";

proc print data=ADAM.ADSL noobs;

    var USUBJID TRT01P DTHFL;

run;


/* STEP 2: SUMMARIZE DEATH FLAG */

title "OVERALL DEATH FLAG DISTRIBUTION";

proc freq data=ADAM.ADSL;

    tables DTHFL / missing;

run;


/* STEP 3: SUMMARIZE DEATH FLAG BY TREATMENT */

title "DEATH FLAG BY PLANNED TREATMENT";

proc freq data=ADAM.ADSL;

    tables TRT01P*DTHFL / missing;

run;


/* STEP 4: CREATE OVERALL SURVIVAL SUMMARY */

proc sql;

    create table QC.ADSL_SURVIVAL_SUMMARY as

    select

        count(*) as TOTAL_SUBJECTS,

        sum(DTHFL="Y") as DEATH_SUBJECTS,

        sum(missing(DTHFL)) as SUBJECTS_WITHOUT_DEATH_FLAG,

        calculated DEATH_SUBJECTS /
        count(*) * 100 as DEATH_PERCENTAGE format=6.2

    from ADAM.ADSL;

quit;


/* STEP 5: CREATE TREATMENT-WISE SURVIVAL SUMMARY */

proc sql;

    create table QC.ADSL_SURVIVAL_BY_TREATMENT as

    select

        TRT01P,

        count(*) as TOTAL_SUBJECTS,

        sum(DTHFL="Y") as DEATH_SUBJECTS,

        sum(missing(DTHFL)) as SUBJECTS_WITHOUT_DEATH_FLAG,

        calculated DEATH_SUBJECTS /
        count(*) * 100 as DEATH_PERCENTAGE format=6.2

    from ADAM.ADSL

    group by TRT01P;

quit;


/* STEP 6: DISPLAY OVERALL SUMMARY */

title "OVERALL SURVIVAL SUMMARY";

proc print data=QC.ADSL_SURVIVAL_SUMMARY noobs;

run;


/* STEP 7: DISPLAY TREATMENT-WISE SUMMARY */

title "SURVIVAL SUMMARY BY PLANNED TREATMENT";

proc print data=QC.ADSL_SURVIVAL_BY_TREATMENT noobs;

run;

title;
