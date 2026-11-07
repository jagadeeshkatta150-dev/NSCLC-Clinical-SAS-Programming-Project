
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 062_SDTM_METADATA_DOCUMENTATION           */
/* PURPOSE: Document SDTM domain metadata             */
/*====================================================*/


/* STEP 1: DEFINE DOCUMENTATION FILE */

filename SDTMFILE
"C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL\08_DOCUMENTATION\SDTM_METADATA.txt";


/* STEP 2: WRITE SDTM METADATA */

data _null_;

    file SDTMFILE lrecl=200;

    put "====================================================";
    put "             SDTM METADATA DOCUMENTATION";
    put "====================================================";

    put " ";

    put "STUDY ID: NSCLC001";
    put "SOFTWARE: SAS 9.4";
    put "DATA TYPE: SYNTHETIC TRAINING DATA";

    put " ";

    put "DOMAIN 1: DM - DEMOGRAPHICS";
    put "Purpose: Subject demographic information.";
    put "Dataset: SDTM.DM_UPDATED";

    put " ";

    put "DOMAIN 2: AE - ADVERSE EVENTS";
    put "Purpose: Adverse event information.";
    put "Dataset: SDTM.AE";

    put " ";

    put "DOMAIN 3: LB - LABORATORY";
    put "Purpose: Laboratory test results.";
    put "Dataset: SDTM.LB";

    put " ";

    put "DOMAIN 4: VS - VITAL SIGNS";
    put "Purpose: Vital signs measurements.";
    put "Dataset: SDTM.VS";

    put " ";

    put "DOMAIN 5: EX - EXPOSURE";
    put "Purpose: Study treatment exposure.";
    put "Dataset: SDTM.EX";

    put " ";

    put "DOMAIN 6: RS - DISEASE RESPONSE";
    put "Purpose: Disease response assessments.";
    put "Dataset: SDTM.RS";

    put " ";

    put "IMPORTANT LIMITATIONS:";
    put "These are initial training mappings.";
    put "Controlled terminology requires further review.";
    put "Complete SDTM IG conformance is not yet established.";
    put "Define-XML metadata and validation remain pending.";

    put " ";

    put "====================================================";
    put "             END OF SDTM METADATA";
    put "====================================================";

run;


/* STEP 3: VERIFY FILE */

data _null_;

    if fexist("SDTMFILE") then
        put "SDTM METADATA DOCUMENT CREATED SUCCESSFULLY";

    else
        put "SDTM METADATA DOCUMENT NOT CREATED";

run;


/* STEP 4: CLEAR FILE REFERENCE */

filename SDTMFILE clear;
