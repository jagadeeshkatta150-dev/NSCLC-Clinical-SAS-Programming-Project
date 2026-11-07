
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 049_T1_DEMOGRAPHIC_BASELINE_CHARACTERISTICS*/
/* PURPOSE: Create Table 1 - Demographic and Baseline */
/*          Characteristics by Planned Treatment     */
/*====================================================*/


/* STEP 1: CREATE AGE SUMMARY BY TREATMENT */

proc means data=ADAM.ADSL nway noprint;

    class TRT01P;

    var AGE;

    output out=WORK.AGE_SUMMARY
        n=AGE_N
        mean=AGE_MEAN
        std=AGE_SD
        median=AGE_MEDIAN
        min=AGE_MIN
        max=AGE_MAX;

run;


/* STEP 2: CREATE SEX SUMMARY BY TREATMENT */

proc sql;

    create table WORK.SEX_SUMMARY as

    select

        TRT01P,

        sum(SEX="M") as MALE_N,

        sum(SEX="F") as FEMALE_N

    from ADAM.ADSL

    group by TRT01P;

quit;


/* STEP 3: CREATE SUBJECT COUNT BY TREATMENT */

proc sql;

    create table WORK.SUBJECT_SUMMARY as

    select

        TRT01P,

        count(*) as TOTAL_N,

        sum(SAFFL="Y") as SAFETY_N

    from ADAM.ADSL

    group by TRT01P;

quit;


/* STEP 4: COMBINE SUMMARY DATASETS */

proc sort data=WORK.AGE_SUMMARY;
    by TRT01P;
run;

proc sort data=WORK.SEX_SUMMARY;
    by TRT01P;
run;

proc sort data=WORK.SUBJECT_SUMMARY;
    by TRT01P;
run;

data WORK.TABLE1;

    merge WORK.AGE_SUMMARY
          WORK.SEX_SUMMARY
          WORK.SUBJECT_SUMMARY;

    by TRT01P;

run;


/* STEP 5: DISPLAY TABLE 1 */

title "TABLE 1: DEMOGRAPHIC AND BASELINE CHARACTERISTICS";

proc print data=WORK.TABLE1 noobs;

    var TRT01P TOTAL_N SAFETY_N
        AGE_N AGE_MEAN AGE_SD
        AGE_MEDIAN AGE_MIN AGE_MAX
        MALE_N FEMALE_N;

run;

title;
