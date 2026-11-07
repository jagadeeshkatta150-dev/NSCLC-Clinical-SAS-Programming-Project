
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 063_ADAM_METADATA_DOCUMENTATION           */
/* PURPOSE: Document ADaM dataset metadata             */
/*====================================================*/


/* STEP 1: DEFINE DOCUMENTATION FILE */

filename ADAMFILE
"C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL\08_DOCUMENTATION\ADAM_METADATA.txt";


/* STEP 2: WRITE ADAM METADATA */

data _null_;

    file ADAMFILE lrecl=200;

    put "====================================================";
    put "             ADAM METADATA DOCUMENTATION";
    put "====================================================";

    put " ";

    put "STUDY ID: NSCLC001";
    put "SOFTWARE: SAS 9.4";
    put "DATA TYPE: SYNTHETIC TRAINING DATA";

    put " ";

    put "DATASET: ADSL";
    put "DATASET LABEL: SUBJECT LEVEL ANALYSIS DATASET";

    put " ";

    put "PURPOSE:";
    put "Contains one record per study subject.";
    put "Supports demographic and population summaries.";

    put " ";

    put "VARIABLES:";

    put "STUDYID - Study Identifier";
    put "USUBJID - Unique Subject Identifier";
    put "SUBJID - Subject Identifier";
    put "SITEID - Study Site Identifier";
    put "AGE - Subject Age";
    put "SEX - Subject Sex";
    put "SAFFL - Safety Population Flag";
    put "ITTFL - Intent-to-Treat Population Flag";
    put "TRT01P - Planned Treatment";
    put "TRT01A - Actual Treatment";
    put "TRTSDT - Treatment Start Date";
    put "TRTEDT - Treatment End Date";
    put "DTHFL - Death Flag";

    put " ";

    put "DERIVATION NOTES:";
    put "SAFFL is based on available exposure records.";
    put "TRT01A is derived from exposure information.";
    put "TRTSDT is derived from exposure start dates.";
    put "TRTEDT is derived from exposure end dates.";
    put "ITTFL remains unassigned pending source evidence.";
    put "DTHFL is derived from the updated DM dataset.";

    put " ";

    put "IMPORTANT LIMITATIONS:";
    put "This is an initial training ADSL dataset.";
    put "Complete ADaM conformance requires further review.";
    put "Variable attributes and metadata need finalization.";
    put "Additional analysis datasets remain to be developed.";

    put " ";

    put "====================================================";
    put "             END OF ADAM METADATA";
    put "====================================================";

run;


/* STEP 3: VERIFY FILE */

data _null_;

    if fexist("ADAMFILE") then
        put "ADAM METADATA DOCUMENT CREATED SUCCESSFULLY";

    else
        put "ADAM METADATA DOCUMENT NOT CREATED";

run;


/* STEP 4: CLEAR FILE REFERENCE */

filename ADAMFILE clear;
