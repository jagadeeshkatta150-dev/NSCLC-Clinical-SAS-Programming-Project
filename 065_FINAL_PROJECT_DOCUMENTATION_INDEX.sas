
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 065_FINAL_PROJECT_DOCUMENTATION_INDEX     */
/* PURPOSE: Create final project documentation index */
/*====================================================*/


/* STEP 1: DEFINE DOCUMENTATION FILE */

filename FINALDOC
"C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL\08_DOCUMENTATION\FINAL_PROJECT_INDEX.txt";


/* STEP 2: WRITE FINAL PROJECT INDEX */

data _null_;

    file FINALDOC lrecl=200;

    put "====================================================";
    put "       NSCLC PHASE III CLINICAL TRIAL PROJECT";
    put "             FINAL DOCUMENTATION INDEX";
    put "====================================================";

    put " ";

    put "PROJECT ID: NSCLC001";
    put "SOFTWARE: SAS 9.4";
    put "PROJECT TYPE: SYNTHETIC TRAINING PROJECT";

    put " ";

    put "DOCUMENTATION FILES:";

    put "1. PROJECT_OVERVIEW.txt";
    put "2. SDTM_METADATA.txt";
    put "3. ADAM_METADATA.txt";
    put "4. SAS_PROGRAMMING_QC.txt";

    put " ";

    put "PROJECT DEVELOPMENT AREAS:";

    put "1. Project initialization";
    put "2. Raw clinical data import and validation";
    put "3. SDTM dataset development";
    put "4. ADaM ADSL development";
    put "5. TLF summary development";
    put "6. Independent QC activities";
    put "7. Metadata and documentation";

    put " ";

    put "IMPORTANT PROJECT LIMITATIONS:";

    put "Synthetic data only.";
    put "Initial SDTM and ADaM training implementation.";
    put "Further CDISC conformance review is required.";
    put "Additional analysis datasets and TLF outputs may be needed.";
    put "Not a validated regulatory submission package.";

    put " ";

    put "====================================================";
    put "             END OF PROJECT INDEX";
    put "====================================================";

run;


/* STEP 3: VERIFY FINAL INDEX FILE */

data _null_;

    if fexist("FINALDOC") then
        put "FINAL PROJECT DOCUMENTATION INDEX CREATED SUCCESSFULLY";

    else
        put "FINAL PROJECT DOCUMENTATION INDEX NOT CREATED";

run;


/* STEP 4: CLEAR FILE REFERENCE */

filename FINALDOC clear;
