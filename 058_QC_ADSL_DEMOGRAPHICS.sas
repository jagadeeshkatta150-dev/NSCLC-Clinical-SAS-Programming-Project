
*====================================================*/
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

    length SEX_EXPECTED $1;

    SITE_NO = input(substr(USUBJID, 10, 4), 4.);
    PATIENT_NO = input(substr(USUBJID, 15, 3), 3.);

    if SEX="M" then SEX_EXPECTED="M";
    else if SEX="F" then SEX_EXPECTED="F";

run;

proc sort data=WORK.QC_ADSL_DEMOGRAPHICS;

    by SITE_NO PATIENT_NO;

run;


/* STEP 3: COMPARE RAW AND ADSL DEMOGRAPHICS */

data QC.ADSL_DEMOGRAPHIC_QC;

    merge WORK.QC_RAW_DEMOGRAPHICS(in=IN_RAW)
          WORK.QC_ADSL_DEMOGRAPHICS(in=IN_ADSL);

    by SITE_NO PATIENT_NO;

    length AGE_QC SEX_QC SITE_QC $12;

    if IN_RAW and IN_ADSL then do;

        if AGE_YRS=AGE then AGE_QC="MATCH";
        else AGE_QC="MISMATCH";

        if upcase(strip(GENDER))="MALE" and SEX="M" then
    SEX_QC="MATCH";

else if upcase(strip(GENDER))="FEMALE" and SEX="F" then
    SEX_QC="MATCH";

else
    SEX_QC="MISMATCH";
        if SITE_NO=input(substr(USUBJID,10,4),4.)
            then SITE_QC="MATCH";
        else SITE_QC="MISMATCH";

    end;

    else do;

        AGE_QC="NO MATCH";
        SEX_QC="NO MATCH";
        SITE_QC="NO MATCH";

    end;

run;


/* STEP 4: REVIEW AGE VALIDATION */

title "AGE VALIDATION";

proc freq data=QC.ADSL_DEMOGRAPHIC_QC;

    tables AGE_QC / missing;

run;


/* STEP 5: REVIEW SEX VALIDATION */

title "SEX VALIDATION";

proc freq data=QC.ADSL_DEMOGRAPHIC_QC;

    tables SEX_QC / missing;

run;


/* STEP 6: REVIEW SITE VALIDATION */

title "SITE VALIDATION";

proc freq data=QC.ADSL_DEMOGRAPHIC_QC;

    tables SITE_QC / missing;

run;


/* STEP 7: DISPLAY MISMATCH RECORDS */

title "ADSL DEMOGRAPHIC QC MISMATCH REVIEW";

proc print data=QC.ADSL_DEMOGRAPHIC_QC noobs;

    where AGE_QC ne "MATCH"
       or SEX_QC ne "MATCH"
       or SITE_QC ne "MATCH";

    var USUBJID AGE_YRS AGE GENDER SEX
        SITE_NO AGE_QC SEX_QC SITE_QC;

run;

title;
