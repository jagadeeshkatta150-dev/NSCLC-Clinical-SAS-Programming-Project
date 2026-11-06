
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 032_CREATE_SDTM_RS                        */
/* PURPOSE: Create SDTM Response (RS) domain          */
/*====================================================*/


/* STEP 1: SORT RAW TUMOR ASSESSMENT DATA */

proc sort data=RAW.TUMOR_ASSESSMENT
          out=WORK.RS_SORTED;

    by SITE_NO PATIENT_NO SCAN_DATE VISIT_NAME;

run;


/* STEP 2: CREATE SDTM RS DATASET */

data SDTM.RS;

    length STUDYID $12
           DOMAIN $2
           USUBJID $40
           RSTESTCD $8
           RSTEST $40
           RSCAT $30
           RSORRES $40
           RSSTRESC $8
           RSDTC $10
           VISIT $40;

    set WORK.RS_SORTED;

    by SITE_NO PATIENT_NO SCAN_DATE VISIT_NAME;


    /* STEP 3: ASSIGN STUDY IDENTIFIERS */

    STUDYID = "NSCLC001";

    DOMAIN = "RS";

    SUBJID = put(PATIENT_NO, z3.);

    SITEID = put(SITE_NO, z4.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);


    /* STEP 4: GENERATE RESPONSE SEQUENCE */

    if first.PATIENT_NO then
        RSSEQ = 1;

    else
        RSSEQ + 1;


    /* STEP 5: ASSIGN RESPONSE TEST INFORMATION */

    RSTESTCD = "OVRLRESP";

    RSTEST = "Overall Response";

    RSCAT = strip(RESPONSE_CRITERIA);


    /* STEP 6: MAP ORIGINAL RESPONSE */

    RSORRES = strip(OVERALL_RESPONSE);


    /* STEP 7: MAP STANDARD RESPONSE VALUES */

    select (upcase(strip(OVERALL_RESPONSE)));

        when ("COMPLETE RESPONSE")
            RSSTRESC = "CR";

        when ("PARTIAL RESPONSE")
            RSSTRESC = "PR";

        when ("STABLE DISEASE")
            RSSTRESC = "SD";

        when ("PROGRESSIVE DISEASE")
            RSSTRESC = "PD";

        otherwise
            RSSTRESC = "";

    end;


    /* STEP 8: CONVERT ASSESSMENT DATE */

    if not missing(SCAN_DATE) then
        RSDTC = put(SCAN_DATE, yymmdd10.);


    /* STEP 9: MAP VISIT INFORMATION */

    VISIT = strip(VISIT_NAME);


    /* STEP 10: RETAIN REQUIRED VARIABLES */

    keep STUDYID DOMAIN USUBJID RSSEQ
         RSTESTCD RSTEST RSCAT
         RSORRES RSSTRESC RSDTC VISIT;

run;


/* STEP 11: REVIEW DATASET STRUCTURE */

proc contents data=SDTM.RS varnum;

run;


/* STEP 12: DISPLAY SDTM RS DATASET */

title "SDTM RS RESPONSE DOMAIN";

proc print data=SDTM.RS noobs;

run;


/* STEP 13: COUNT RESPONSE RECORDS */

proc sql;

    select count(*) as TOTAL_RS_RECORDS
    from SDTM.RS;

quit;

title;
