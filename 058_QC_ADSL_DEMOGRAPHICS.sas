
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 058_QC_ADSL_DEMOGRAPHICS                  */
/* PURPOSE: Independently validate ADSL demographic   */
/*          variables against raw source data         */
/*====================================================*/


/* STEP 1: PREPARE RAW DEMOGRAPHIC DATA */

proc sort data=RAW.DEMOGRAPHICS
          out=WORK.QC_RAW_DEMOGRAPHICS;

    by SITE_NO PATIENT_NO;

run;


/* STEP 2: PREPARE ADSL DATA */

data WORK.QC_ADSL_DEMOGRAPHICS;

    set ADAM.ADSL;

    /* Derive source reconciliation keys */

    SITE_NO = input(strip(SITEID), 4.);
    PATIENT_NO = input(strip(SUBJID), 3.);

run;


/* STEP 3: SORT ADSL DATA */

proc sort data=WORK.QC_ADSL_DEMOGRAPHICS;

    by SITE_NO PATIENT_NO;

run;


/* STEP 4: COMPARE RAW AND ADSL DEMOGRAPHICS */

data QC.ADSL_DEMOGRAPHIC_QC;

    merge WORK.QC_RAW_DEMOGRAPHICS(in=IN_RAW)
          WORK.QC_ADSL_DEMOGRAPHICS(in=IN_ADSL);

    by SITE_NO PATIENT_NO;

    length AGE_QC SEX_QC SITE_QC $12;

    if IN_RAW and IN_ADSL then do;

        /* AGE VALIDATION */

        if AGE_YRS = AGE then
            AGE_QC = "MATCH";
        else
            AGE_QC = "MISMATCH";


        /* SEX VALIDATION */

        if upcase(strip(GENDER)) = "MALE"
           and SEX = "M" then
            SEX_QC = "MATCH";

        else if upcase(strip(GENDER)) = "FEMALE"
                and SEX = "F" then
            SEX_QC = "MATCH";

        else
            SEX_QC = "MISMATCH";


        /* SITE VALIDATION */

        if SITE_NO = input(strip(SITEID), 4.) then
            SITE_QC = "MATCH";
        else
            SITE_QC = "MISMATCH";

    end;

    else do;

        AGE_QC = "NO MATCH";
        SEX_QC = "NO MATCH";
        SITE_QC = "NO MATCH";

    end;

run;


/* STEP 5: REVIEW AGE VALIDATION */

title "AGE VALIDATION";

proc freq data=QC.ADSL_DEMOGRAPHIC_QC;

    tables AGE_QC / missing;

run;


/* STEP 6: REVIEW SEX VALIDATION */

title "SEX VALIDATION";

proc freq data=QC.ADSL_DEMOGRAPHIC_QC;

    tables SEX_QC / missing;

run;


/* STEP 7: REVIEW SITE VALIDATION */

title "SITE VALIDATION";

proc freq data=QC.ADSL_DEMOGRAPHIC_QC;

    tables SITE_QC / missing;

run;


/* STEP 8: DISPLAY MISMATCH RECORDS */

title "ADSL DEMOGRAPHIC QC MISMATCH REVIEW";

proc print data=QC.ADSL_DEMOGRAPHIC_QC noobs;

    where AGE_QC ne "MATCH"
       or SEX_QC ne "MATCH"
       or SITE_QC ne "MATCH";

    var USUBJID AGE_YRS AGE GENDER SEX
        SITE_NO SITEID AGE_QC SEX_QC SITE_QC;

run;


/* STEP 9: FINAL QC SUMMARY */

title "FINAL ADSL DEMOGRAPHIC QC SUMMARY";

proc sql;

    select count(*) as TOTAL_QC_RECORDS
    from QC.ADSL_DEMOGRAPHIC_QC;

    select count(*) as AGE_MISMATCHES
    from QC.ADSL_DEMOGRAPHIC_QC
    where AGE_QC = "MISMATCH";

    select count(*) as SEX_MISMATCHES
    from QC.ADSL_DEMOGRAPHIC_QC
    where SEX_QC = "MISMATCH";

    select count(*) as SITE_MISMATCHES
    from QC.ADSL_DEMOGRAPHIC_QC
    where SITE_QC = "MISMATCH";

quit;


/* STEP 10: CLEAR TITLES */

title;


   

  

        

