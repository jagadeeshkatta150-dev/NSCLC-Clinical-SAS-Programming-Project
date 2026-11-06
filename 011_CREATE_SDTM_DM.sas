
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 011_CREATE_SDTM_DM                        */
/* PURPOSE: Create SDTM Demographics Domain            */
/*====================================================*/


/* STEP 1: Create SDTM DM dataset */

data SDTM.DM;

    /* Define target variable lengths */

    length STUDYID $12
           DOMAIN $2
           USUBJID $40
           SUBJID $3
           SITEID $4
           AGE 8
           AGEU $5
           SEX $1
           RACE $40
           ARMCD $3
           ARM $30
           RFICDTC $10;

    /* Read raw demographics data */

    set RAW.DEMOGRAPHICS;


    /* STEP 2: Derive study identifiers */

    STUDYID = "NSCLC001";

    DOMAIN = "DM";

    SUBJID = put(PATIENT_NO, z3.);

    SITEID = put(SITE_NO, z4.);

    USUBJID = catx("-", STUDYID, SITEID, SUBJID);


    /* STEP 3: Map age */

    AGE = AGE_YRS;

    AGEU = "YEARS";


    /* STEP 4: Map sex */

    if upcase(strip(GENDER)) = "MALE" then
        SEX = "M";

    else if upcase(strip(GENDER)) = "FEMALE" then
        SEX = "F";


    /* STEP 5: Map race */

    select (upcase(strip(RACE_DESC)));

        when ("ASIAN")
            RACE = "ASIAN";

        when ("WHITE")
            RACE = "WHITE";

        when ("BLACK OR AFRICAN AMERICAN")
            RACE = "BLACK OR AFRICAN AMERICAN";

        otherwise
            RACE = strip(RACE_DESC);

    end;


    /* STEP 6: Map planned treatment arm */

    if strip(TREATMENT_GROUP) = "Investigational Drug" then do;

        ARMCD = "INV";
        ARM = "Investigational Drug";

    end;

    else if strip(TREATMENT_GROUP) = "Standard Care" then do;

        ARMCD = "STD";
        ARM = "Standard Care";

    end;


    /* STEP 7: Convert consent date to ISO 8601 */

    if not missing(CONSENT_DATE) then
        RFICDTC = put(CONSENT_DATE, yymmdd10.);


    /* STEP 8: Retain only SDTM DM variables */

    keep STUDYID DOMAIN USUBJID SUBJID SITEID
         AGE AGEU SEX RACE ARMCD ARM RFICDTC;

run;


/* STEP 9: Review SDTM DM structure */

proc contents data=SDTM.DM;
run;


/* STEP 10: Display SDTM DM records */

title "SDTM DM DOMAIN";

proc print data=SDTM.DM;
run;


/* STEP 11: Count subjects */

proc sql;

    select count(*) as TOTAL_DM_RECORDS
    from SDTM.DM;

quit;


/* STEP 12: Clear report title */

title;
