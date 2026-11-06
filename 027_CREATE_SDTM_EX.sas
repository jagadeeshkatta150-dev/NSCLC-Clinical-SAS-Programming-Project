
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 027_CREATE_SDTM_EX                        */
/* PURPOSE: Create SDTM Exposure (EX) domain          */
/*====================================================*/


/* STEP 1: SORT RAW EXPOSURE DATA */

proc sort data=RAW.EXPOSURE
          out=WORK.EX_SORTED;

    by SITE_NO PATIENT_NO DOSE_START_DATE;

run;


/* STEP 2: CREATE SDTM EX DATASET */

data SDTM.EX;

    length STUDYID $12
           DOMAIN $2
           USUBJID $40
           EXTRT $100
           EXDOSU $20
           EXROUTE $30
           EXSTDTC $10
           EXENDTC $10;

    set WORK.EX_SORTED;

    by SITE_NO PATIENT_NO DOSE_START_DATE;


    /* STEP 3: ASSIGN STUDY IDENTIFIERS */

    STUDYID = "NSCLC001";

    DOMAIN = "EX";

    SUBJID = put(PATIENT_NO, z3.);

    SITEID = put(SITE_NO, z4.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);


    /* STEP 4: GENERATE EXPOSURE SEQUENCE */

    if first.PATIENT_NO then
        EXSEQ = 1;

    else
        EXSEQ + 1;


    /* STEP 5: MAP EXPOSURE VARIABLES */

    EXTRT = strip(DRUG_NAME);

    EXDOSE = DOSE_AMOUNT;

    EXDOSU = strip(DOSE_UNIT);

    EXROUTE = upcase(strip(ROUTE));


    /* STEP 6: CONVERT EXPOSURE DATES */

    if not missing(DOSE_START_DATE) then
        EXSTDTC = put(DOSE_START_DATE, yymmdd10.);

    if not missing(DOSE_END_DATE) then
        EXENDTC = put(DOSE_END_DATE, yymmdd10.);


    /* STEP 7: RETAIN REQUIRED SDTM VARIABLES */

    keep STUDYID DOMAIN USUBJID EXSEQ
         EXTRT EXDOSE EXDOSU EXROUTE
         EXSTDTC EXENDTC;

run;


/* STEP 8: REVIEW SDTM EX STRUCTURE */

proc contents data=SDTM.EX varnum;

run;


/* STEP 9: DISPLAY SDTM EX RECORDS */

title "SDTM EX DOMAIN";

proc print data=SDTM.EX noobs;

run;


/* STEP 10: COUNT SDTM EX RECORDS */

proc sql;

    select count(*) as TOTAL_EX_RECORDS
    from SDTM.EX;

quit;

title;
