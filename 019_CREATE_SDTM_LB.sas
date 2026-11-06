
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 019_CREATE_SDTM_LB                        */
/* PURPOSE: Create SDTM Laboratory (LB) domain       */
/*====================================================*/


/* STEP 1: Sort raw laboratory records */

proc sort data=RAW.LABORATORY
          out=WORK.LB_SORTED;

    by SITE_NO PATIENT_NO COLLECTION_DATE TEST_NAME;

run;


/* STEP 2: Create SDTM LB domain */

data SDTM.LB;

    length STUDYID $12
           DOMAIN $2
           USUBJID $40
           LBSEQ 8
           LBTESTCD $8
           LBTEST $40
           LBCAT $20
           LBORRES $40
           LBORRESU $20
           LBSTRESC $40
           LBSTRESN 8
           LBSTRESU $20
           LBNRIND $20
           LBDTC $10;

    set WORK.LB_SORTED;

    by SITE_NO PATIENT_NO COLLECTION_DATE TEST_NAME;


    /* STEP 2A: Assign study identifiers */

    STUDYID = "NSCLC001";

    DOMAIN = "LB";


    /* STEP 2B: Create unique subject identifier */

    SUBJID = put(PATIENT_NO, z3.);

    SITEID = put(SITE_NO, z4.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);


    /* STEP 2C: Generate laboratory sequence number */

    if first.PATIENT_NO then LBSEQ = 0;

    LBSEQ + 1;


    /* STEP 2D: Map laboratory test names */

    select (upcase(strip(TEST_NAME)));

        when ("HEMOGLOBIN") do;
            LBTESTCD = "HGB";
            LBTEST = "Hemoglobin";
        end;

        when ("ABSOLUTE NEUTROPHILS") do;
            LBTESTCD = "NEUT";
            LBTEST = "Absolute Neutrophils";
        end;

        when ("PLATELETS") do;
            LBTESTCD = "PLAT";
            LBTEST = "Platelets";
        end;

        otherwise do;
            LBTESTCD = "OTHER";
            LBTEST = strip(TEST_NAME);
        end;

    end;


    /* STEP 2E: Assign laboratory category */

    LBCAT = "HEMATOLOGY";


    /* STEP 2F: Map original laboratory result */

    LBORRES = strip(put(RESULT_VALUE, best32.));

    LBORRESU = strip(RESULT_UNIT);


    /* STEP 2G: Map standardized laboratory result */

    LBSTRESC = strip(put(RESULT_VALUE, best32.));

    LBSTRESN = RESULT_VALUE;

    LBSTRESU = strip(RESULT_UNIT);


    /* STEP 2H: Map laboratory normal range indicator */

    if upcase(strip(LAB_FLAG)) = "LOW" then
        LBNRIND = "LOW";

    else if upcase(strip(LAB_FLAG)) = "NORMAL" then
        LBNRIND = "NORMAL";


    /* STEP 2I: Convert collection date to ISO 8601 */

    if not missing(COLLECTION_DATE) then
        LBDTC = put(COLLECTION_DATE, yymmdd10.);


    /* STEP 2J: Retain required variables */

    keep STUDYID DOMAIN USUBJID LBSEQ
         LBTESTCD LBTEST LBCAT
         LBORRES LBORRESU
         LBSTRESC LBSTRESN LBSTRESU
         LBNRIND LBDTC;

run;


/* STEP 3: Sort final SDTM LB dataset */

proc sort data=SDTM.LB;

    by USUBJID LBSEQ;

run;


/* STEP 4: Check SDTM LB dataset structure */

proc contents data=SDTM.LB;

run;


/* STEP 5: Display SDTM LB records */

title "SDTM LB DOMAIN REVIEW";

proc print data=SDTM.LB;

run;


/* STEP 6: Count total laboratory records */

proc sql;

    select count(*) as TOTAL_SDTM_LB_RECORDS

    from SDTM.LB;

quit;


/* STEP 7: Clear report title */

title;
