
*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 038_SDTM_DM_DEATH_UPDATE                  */
/* PURPOSE: Update SDTM DM with death information     */
/*====================================================*/


/* STEP 1: PREPARE DEATH INFORMATION */

data WORK.DS_DEATH;

    set RAW.DISPOSITION_SURVIVAL;

    length STUDYID $12
           SITEID $4
           SUBJID $3
           USUBJID $40
           DTHFL $1;

    STUDYID = "NSCLC001";

    SITEID = put(SITE_NO, z4.);

    SUBJID = put(PATIENT_NO, z3.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);

    if upcase(strip(DEATH_INDICATOR)) = "YES" then
        DTHFL = "Y";

    else
        DTHFL = "";

    keep USUBJID DTHFL;

run;


/* STEP 2: SORT EXISTING DM DATA */

proc sort data=SDTM.DM
          out=WORK.DM_SORTED;

    by USUBJID;

run;


/* STEP 3: SORT DEATH INFORMATION */

proc sort data=WORK.DS_DEATH;

    by USUBJID;

run;


/* STEP 4: MERGE DEATH INFORMATION WITH DM */

data SDTM.DM_UPDATED;

    length DTHFL $1;

    merge WORK.DM_SORTED(in=A)
          WORK.DS_DEATH(in=B);

    by USUBJID;

    if A;

run;


/* STEP 5: REVIEW UPDATED DM STRUCTURE */

proc contents data=SDTM.DM_UPDATED varnum;

run;


/* STEP 6: REVIEW DEATH FLAG FREQUENCY */

title "SDTM DM DEATH FLAG FREQUENCY";

proc freq data=SDTM.DM_UPDATED;

    tables DTHFL / missing;

run;


/* STEP 7: DISPLAY UPDATED DM DATA */

title "UPDATED SDTM DM DATASET";

proc print data=SDTM.DM_UPDATED noobs;

    var USUBJID AGE SEX RACE ARM
        RFICDTC DTHFL;

run;


/* STEP 8: COUNT UPDATED DM RECORDS */

proc sql;

    select count(*) as TOTAL_DM_RECORDS
    from SDTM.DM_UPDATED;

quit;

title;
