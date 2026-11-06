
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 023_CREATE_SDTM_VS                        */
/* PURPOSE: Create SDTM Vital Signs (VS) domain       */
/*====================================================*/

/* STEP 1: Sort raw Vital Signs records */

proc sort data=RAW.VITAL_SIGNS
          out=WORK.VS_SORTED;
    by SITE_NO PATIENT_NO ASSESSMENT_DATE MEASUREMENT_NAME;
run;


/* STEP 2: Create SDTM VS domain */

data SDTM.VS;

    length STUDYID $12
           DOMAIN $2
           USUBJID $40
           VSSEQ 8
           VSTESTCD $8
           VSTEST $40
           VSCAT $20
           VSORRES $40
           VSORRESU $20
           VSSTRESC $40
           VSSTRESN 8
           VSSTRESU $20
           VSDTC $10;

    set WORK.VS_SORTED;

    by SITE_NO PATIENT_NO ASSESSMENT_DATE MEASUREMENT_NAME;

    STUDYID = "NSCLC001";
    DOMAIN = "VS";

    /* Create subject identifier */

    SUBJID = put(PATIENT_NO, z3.);
    SITEID = put(SITE_NO, z4.);
    USUBJID = catx("-", STUDYID, SITEID, SUBJID);

    /* Generate sequence number */

    if first.PATIENT_NO then VSSEQ = 0;
    VSSEQ + 1;

    /* Map vital signs test names */

    select (upcase(strip(MEASUREMENT_NAME)));

        when ("SYSTOLIC BLOOD PRESSURE") do;
            VSTESTCD = "SYSBP";
            VSTEST = "Systolic Blood Pressure";
        end;

        when ("DIASTOLIC BLOOD PRESSURE") do;
            VSTESTCD = "DIABP";
            VSTEST = "Diastolic Blood Pressure";
        end;

        when ("PULSE") do;
            VSTESTCD = "PULSE";
            VSTEST = "Pulse";
        end;

        otherwise do;
            VSTESTCD = "OTHER";
            VSTEST = strip(MEASUREMENT_NAME);
        end;

    end;

    /* Assign category */

    VSCAT = "VITAL SIGNS";

    /* Original results */

    VSORRES = strip(put(MEASUREMENT_VALUE, best32.));
    VSORRESU = strip(MEASUREMENT_UNIT);

    /* Standardized results */

    VSSTRESC = strip(put(MEASUREMENT_VALUE, best32.));
    VSSTRESN = MEASUREMENT_VALUE;
    VSSTRESU = strip(MEASUREMENT_UNIT);

    /* Convert assessment date */

    if not missing(ASSESSMENT_DATE) then
        VSDTC = put(ASSESSMENT_DATE, yymmdd10.);

    keep STUDYID DOMAIN USUBJID VSSEQ
         VSTESTCD VSTEST VSCAT
         VSORRES VSORRESU
         VSSTRESC VSSTRESN VSSTRESU
         VSDTC;

run;


/* STEP 3: Sort final SDTM VS dataset */

proc sort data=SDTM.VS;
    by USUBJID VSSEQ;
run;


/* STEP 4: Check dataset structure */

proc contents data=SDTM.VS;
run;


/* STEP 5: Display SDTM VS records */

title "SDTM VS DOMAIN REVIEW";

proc print data=SDTM.VS;
run;


/* STEP 6: Count total records */

proc sql;
    select count(*) as TOTAL_SDTM_VS_RECORDS
    from SDTM.VS;
quit;

title;
