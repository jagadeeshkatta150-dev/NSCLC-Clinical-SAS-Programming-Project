
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 033_SDTM_RS_VALIDATION                    */
/* PURPOSE: Validate SDTM Response (RS) domain        */
/*====================================================*/


/* STEP 1: CHECK MISSING REQUIRED VALUES */

proc sql;

    select
        count(*) as TOTAL_RS_RECORDS,

        sum(missing(STUDYID)) as MISSING_STUDYID,
        sum(missing(DOMAIN)) as MISSING_DOMAIN,
        sum(missing(USUBJID)) as MISSING_USUBJID,
        sum(missing(RSSEQ)) as MISSING_RSSEQ,
        sum(missing(RSTESTCD)) as MISSING_RSTESTCD,
        sum(missing(RSTEST)) as MISSING_RSTEST,
        sum(missing(RSORRES)) as MISSING_RSORRES,
        sum(missing(RSSTRESC)) as MISSING_RSSTRESC,
        sum(missing(RSDTC)) as MISSING_RSDTC,
        sum(missing(VISIT)) as MISSING_VISIT

    from SDTM.RS;

quit;


/* STEP 2: CHECK DUPLICATE SUBJECT SEQUENCES */

proc sql;

    create table QC.RS_DUPLICATES as

    select
        USUBJID,
        RSSEQ,
        count(*) as DUPLICATE_COUNT

    from SDTM.RS

    group by USUBJID, RSSEQ

    having count(*) > 1;

quit;


proc sql;

    select count(*) as TOTAL_DUPLICATE_GROUPS
    from QC.RS_DUPLICATES;

quit;


/* STEP 3: CHECK RESPONSE STANDARD VALUES */

proc sql;

    select count(*) as INVALID_RESPONSE_RECORDS

    from SDTM.RS

    where RSSTRESC not in ("CR", "PR", "SD", "PD");

quit;


/* STEP 4: CHECK DOMAIN VALUES */

proc sql;

    select count(*) as INVALID_DOMAIN_RECORDS

    from SDTM.RS

    where DOMAIN ne "RS";

quit;


/* STEP 5: CHECK RESPONSE TEST CODE */

proc sql;

    select count(*) as INVALID_TEST_CODE_RECORDS

    from SDTM.RS

    where RSTESTCD ne "OVRLRESP";

quit;


/* STEP 6: REVIEW RESPONSE FREQUENCIES */

title "SDTM RS STANDARD RESPONSE FREQUENCY";

proc freq data=SDTM.RS;

    tables RSSTRESC;

run;


/* STEP 7: REVIEW ORIGINAL RESPONSE VALUES */

title "SDTM RS ORIGINAL RESPONSE FREQUENCY";

proc freq data=SDTM.RS;

    tables RSORRES;

run;


/* STEP 8: RAW TO SDTM RECONCILIATION */

proc sql;

    select
        (select count(*) from RAW.TUMOR_ASSESSMENT)
            as RAW_RECORDS,

        (select count(*) from SDTM.RS)
            as SDTM_RS_RECORDS;

quit;


/* STEP 9: FINAL DATASET REVIEW */

title "FINAL SDTM RS VALIDATION REVIEW";

proc print data=SDTM.RS noobs;

run;

title;
