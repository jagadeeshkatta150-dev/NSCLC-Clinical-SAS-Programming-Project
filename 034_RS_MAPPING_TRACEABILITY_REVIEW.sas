
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 034_RS_MAPPING_TRACEABILITY_REVIEW        */
/* PURPOSE: Review SDTM RS mapping and traceability   */
/*====================================================*/


/* STEP 1: SORT RAW RESPONSE DATA */

proc sort data=RAW.TUMOR_ASSESSMENT
          out=WORK.RAW_RS_REVIEW;

    by SITE_NO PATIENT_NO SCAN_DATE VISIT_NAME;

run;


/* STEP 2: SORT SDTM RESPONSE DATA */

proc sort data=SDTM.RS
          out=WORK.SDTM_RS_REVIEW;

    by USUBJID RSDTC VISIT;

run;


/* STEP 3: CREATE SUBJECT IDENTIFIERS IN RAW DATA */

data WORK.RAW_RS_REVIEW;

    set WORK.RAW_RS_REVIEW;

    length STUDYID $12
           SITEID $4
           SUBJID $3
           USUBJID $40;

    STUDYID = "NSCLC001";

    SITEID = put(SITE_NO, z4.);

    SUBJID = put(PATIENT_NO, z3.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);

    RSDTC = put(SCAN_DATE, yymmdd10.);

    VISIT = strip(VISIT_NAME);

run;


/* STEP 4: MERGE RAW AND SDTM RESPONSE DATA */

data QC.RS_TRACEABILITY;

    merge WORK.RAW_RS_REVIEW
          WORK.SDTM_RS_REVIEW;

    by USUBJID RSDTC VISIT;

    length EXPECTED_RSSTRESC $8
           MAPPING_STATUS $12;

    select (upcase(strip(OVERALL_RESPONSE)));

        when ("COMPLETE RESPONSE")
            EXPECTED_RSSTRESC = "CR";

        when ("PARTIAL RESPONSE")
            EXPECTED_RSSTRESC = "PR";

        when ("STABLE DISEASE")
            EXPECTED_RSSTRESC = "SD";

        when ("PROGRESSIVE DISEASE")
            EXPECTED_RSSTRESC = "PD";

        otherwise
            EXPECTED_RSSTRESC = "";

    end;


    if missing(USUBJID) then
        MAPPING_STATUS = "NO MATCH";

    else if EXPECTED_RSSTRESC = RSSTRESC then
        MAPPING_STATUS = "MATCH";

    else
        MAPPING_STATUS = "MISMATCH";

run;


/* STEP 5: REVIEW TRACEABILITY RESULTS */

title "SDTM RS MAPPING TRACEABILITY";

proc print data=QC.RS_TRACEABILITY noobs;

    var USUBJID VISIT OVERALL_RESPONSE
        EXPECTED_RSSTRESC RSORRES
        RSSTRESC MAPPING_STATUS;

run;


/* STEP 6: COUNT MAPPING DISCREPANCIES */

title "RS MAPPING STATUS FREQUENCY";

proc freq data=QC.RS_TRACEABILITY;

    tables MAPPING_STATUS;

run;


/* STEP 7: FINAL MAPPING SUMMARY */

proc sql;

    select
        count(*) as TOTAL_REVIEW_RECORDS,

        sum(MAPPING_STATUS = "MATCH")
            as MATCHED_RECORDS,

        sum(MAPPING_STATUS = "MISMATCH")
            as MISMATCHED_RECORDS,

        sum(MAPPING_STATUS = "NO MATCH")
            as UNMATCHED_RECORDS

    from QC.RS_TRACEABILITY;

quit;

title;
