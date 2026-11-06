
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 028_SDTM_EX_VALIDATION                    */
/* PURPOSE: Validate SDTM Exposure (EX) domain        */
/*====================================================*/


/* STEP 1: CHECK TOTAL RECORDS AND MISSING VALUES */

proc sql;

    select
        count(*) as TOTAL_EX_RECORDS,

        sum(missing(STUDYID))
            as MISSING_STUDYID,

        sum(missing(DOMAIN))
            as MISSING_DOMAIN,

        sum(missing(USUBJID))
            as MISSING_USUBJID,

        sum(missing(EXSEQ))
            as MISSING_EXSEQ,

        sum(missing(EXTRT))
            as MISSING_EXTRT,

        sum(missing(EXDOSE))
            as MISSING_EXDOSE,

        sum(missing(EXDOSU))
            as MISSING_EXDOSU,

        sum(missing(EXROUTE))
            as MISSING_EXROUTE,

        sum(missing(EXSTDTC))
            as MISSING_EXSTDTC,

        sum(missing(EXENDTC))
            as MISSING_EXENDTC

    from SDTM.EX;

quit;


/* STEP 2: CHECK DUPLICATE SUBJECT AND SEQUENCE */

proc sql;

    create table QC.EX_DUPLICATES as

    select
        USUBJID,
        EXSEQ,
        count(*) as DUPLICATE_COUNT

    from SDTM.EX

    group by USUBJID, EXSEQ

    having count(*) > 1;

quit;


proc sql;

    select count(*) as TOTAL_DUPLICATE_GROUPS
    from QC.EX_DUPLICATES;

quit;


/* STEP 3: CHECK INVALID DOSE VALUES */

proc sql;

    select count(*) as INVALID_DOSE_RECORDS

    from SDTM.EX

    where EXDOSE <= 0;

quit;


/* STEP 4: CHECK INVALID EXPOSURE DATES */

proc sql;

    select count(*) as INVALID_DATE_RECORDS

    from SDTM.EX

    where input(EXENDTC, yymmdd10.)
        < input(EXSTDTC, yymmdd10.);

quit;


/* STEP 5: CHECK DOMAIN VALUE */

proc sql;

    select count(*) as INVALID_DOMAIN_RECORDS

    from SDTM.EX

    where DOMAIN ne "EX";

quit;


/* STEP 6: REVIEW EXPOSURE TREATMENTS */

title "SDTM EX TREATMENT FREQUENCY";

proc freq data=SDTM.EX;

    tables EXTRT;

run;


/* STEP 7: REVIEW EXPOSURE ROUTES */

title "SDTM EX ROUTE FREQUENCY";

proc freq data=SDTM.EX;

    tables EXROUTE;

run;


/* STEP 8: RAW TO SDTM RECORD RECONCILIATION */

proc sql;

    select
        (select count(*) from RAW.EXPOSURE)
            as RAW_EX_RECORDS,

        (select count(*) from SDTM.EX)
            as SDTM_EX_RECORDS;

quit;


/* STEP 9: FINAL EX DATASET REVIEW */

title "FINAL SDTM EX DATASET";

proc print data=SDTM.EX noobs;

run;

title;
