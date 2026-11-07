
*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 039_SDTM_DM_DEATH_DATE_REVIEW             */
/* PURPOSE: Review source death date information      */
/*====================================================*/


/* STEP 1: IDENTIFY DECEASED SUBJECTS */

data WORK.DS_DEATH_REVIEW;

    set RAW.DISPOSITION_SURVIVAL;

    where upcase(strip(VITAL_STATUS)) = "DEAD";

    length STUDYID $12
           SITEID $4
           SUBJID $3
           USUBJID $40
           DATE_REVIEW_STATUS $30;

    STUDYID = "NSCLC001";

    SITEID = put(SITE_NO, z4.);

    SUBJID = put(PATIENT_NO, z3.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);


    /* STEP 2: COMPARE EVENT DATE WITH LAST CONTACT DATE */

    if missing(EVENT_DATE) then
        DATE_REVIEW_STATUS = "EVENT DATE MISSING";

    else if EVENT_DATE = LAST_CONTACT_DATE then
        DATE_REVIEW_STATUS = "SAME AS LAST CONTACT";

    else
        DATE_REVIEW_STATUS = "DIFFERENT FROM CONTACT";

    format TREATMENT_START_DATE
           LAST_CONTACT_DATE
           EVENT_DATE date9.;

run;


/* STEP 3: DISPLAY DECEASED SUBJECT DATE REVIEW */

title "DECEASED SUBJECT DATE REVIEW";

proc print data=WORK.DS_DEATH_REVIEW noobs;

    var USUBJID TREATMENT_START_DATE
        LAST_CONTACT_DATE EVENT_DATE
        DATE_REVIEW_STATUS;

run;


/* STEP 4: REVIEW DATE COMPARISON FREQUENCY */

title "DEATH DATE REVIEW STATUS";

proc freq data=WORK.DS_DEATH_REVIEW;

    tables DATE_REVIEW_STATUS / missing;

run;


/* STEP 5: CHECK DEATH DATE AVAILABILITY */

proc sql;

    select

        count(*) as TOTAL_DECEASED_SUBJECTS,

        sum(missing(EVENT_DATE))
            as MISSING_EVENT_DATES,

        sum(not missing(EVENT_DATE))
            as AVAILABLE_EVENT_DATES,

        sum(EVENT_DATE = LAST_CONTACT_DATE)
            as EVENT_EQUALS_LAST_CONTACT

    from WORK.DS_DEATH_REVIEW;

quit;


/* STEP 6: CHECK EVENT DATE CHRONOLOGY */

proc sql;

    select count(*) as EVENT_BEFORE_TREATMENT

    from WORK.DS_DEATH_REVIEW

    where not missing(EVENT_DATE)
      and not missing(TREATMENT_START_DATE)
      and EVENT_DATE < TREATMENT_START_DATE;

quit;


/* STEP 7: DISPLAY SOURCE DATE SUMMARY */

title "DEATH DATE SOURCE SUMMARY";

proc means data=WORK.DS_DEATH_REVIEW
           n nmiss min max;

    var TREATMENT_START_DATE
        LAST_CONTACT_DATE
        EVENT_DATE;

    format TREATMENT_START_DATE
           LAST_CONTACT_DATE
           EVENT_DATE date9.;

run;

title;
