
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 015_CREATE_SDTM_AE                        */
/* PURPOSE: Create SDTM Adverse Events (AE) domain    */
/*====================================================*/


/* STEP 1: Sort raw AE records */

proc sort data=RAW.ADVERSE_EVENTS
          out=WORK.AE_SORTED;
    by SITE_NO PATIENT_NO EVENT_NO;
run;


/* STEP 2: Create SDTM AE domain */

data SDTM.AE;

    length STUDYID $12
           DOMAIN $2
           USUBJID $40
           AESEQ 8
           AETERM $200
           AESEV $8
           AEREL $20
           AESER $1
           AESTDTC $10
           AEENDTC $10
           AEOUT $40;

    set WORK.AE_SORTED;

    by SITE_NO PATIENT_NO EVENT_NO;

    STUDYID = "NSCLC001";
    DOMAIN = "AE";

    /* Create unique subject identifier */

    SUBJID = put(PATIENT_NO, z3.);
    SITEID = put(SITE_NO, z4.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);

    /* Generate sequence number */

    if first.PATIENT_NO then AESEQ = 0;
    AESEQ + 1;

    /* Map adverse event term */

    AETERM = strip(EVENT_DESCRIPTION);

    /* Map severity */

    AESEV = upcase(strip(SEVERITY));

    /* Map relatedness */

    if upcase(strip(RELATEDNESS)) = "RELATED" then
        AEREL = "RELATED";
    else if upcase(strip(RELATEDNESS)) = "NOT RELATED" then
        AEREL = "NOT RELATED";

    /* Map serious event */

    if upcase(strip(SERIOUS_EVENT)) = "YES" then
        AESER = "Y";
    else if upcase(strip(SERIOUS_EVENT)) = "NO" then
        AESER = "N";

    /* Convert start date */

    if not missing(START_DATE) then
        AESTDTC = put(START_DATE, yymmdd10.);

    /* Convert end date */

    if not missing(END_DATE) then
        AEENDTC = put(END_DATE, yymmdd10.);

    /* Map outcome */

    select (upcase(strip(OUTCOME)));

        when ("RECOVERED")
            AEOUT = "RECOVERED/RESOLVED";

        when ("NOT RECOVERED")
            AEOUT = "NOT RECOVERED/NOT RESOLVED";

        when ("ONGOING")
            AEOUT = "NOT RECOVERED/NOT RESOLVED";

        otherwise AEOUT = "UNKNOWN";

    end;

    keep STUDYID DOMAIN USUBJID AESEQ
         AETERM AESEV AEREL AESER
         AESTDTC AEENDTC AEOUT;

run;


/* STEP 3: Sort final SDTM AE dataset */

proc sort data=SDTM.AE;
    by USUBJID AESEQ;
run;


/* STEP 4: Check dataset structure */

proc contents data=SDTM.AE;
run;


/* STEP 5: Display SDTM AE records */

title "SDTM AE DOMAIN REVIEW";

proc print data=SDTM.AE;
run;


/* STEP 6: Count total AE records */

proc sql;

    select count(*) as TOTAL_SDTM_AE_RECORDS
    from SDTM.AE;

quit;


/* STEP 7: Clear report title */

title;
