
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 064_SAS_PROGRAMMING_QC_DOCUMENTATION      */
/* PURPOSE: Document SAS programming and QC workflow  */
/*====================================================*/


/* STEP 1: DEFINE DOCUMENTATION FILE */

filename QCDOC
"C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL\08_DOCUMENTATION\SAS_PROGRAMMING_QC.txt";


/* STEP 2: WRITE PROGRAMMING DOCUMENTATION */

data _null_;

    file QCDOC lrecl=200;

    put "====================================================";
    put "       SAS PROGRAMMING AND QC DOCUMENTATION";
    put "====================================================";

    put " ";

    put "1. SOFTWARE";

    put "SAS Version: SAS 9.4";
    put "Project Type: Clinical SAS Training Project";

    put " ";

    put "2. PROGRAMMING WORKFLOW";

    put "Project initialization and library assignment";
    put "Raw clinical data import";
    put "Raw data validation";
    put "SDTM dataset development";
    put "ADaM dataset development";
    put "TLF summary development";
    put "Independent QC activities";
    put "Metadata and documentation";

    put " ";

    put "3. SDTM PROGRAMMING";

    put "DM - Demographics";
    put "AE - Adverse Events";
    put "LB - Laboratory";
    put "VS - Vital Signs";
    put "EX - Exposure";
    put "RS - Disease Response";

    put " ";

    put "4. ADAM PROGRAMMING";

    put "ADSL - Subject-Level Analysis Dataset";
    put "Population flags and treatment variables";
    put "Demographic summaries";

    put " ";

    put "5. QUALITY CONTROL ACTIVITIES";

    put "Subject-level reconciliation";
    put "Duplicate subject checks";
    put "Demographic validation";
    put "Treatment flag validation";
    put "Safety population validation";
    put "Planned treatment validation";
    put "ITT flag review";

    put " ";

    put "6. TLF ACTIVITIES";

    put "Demographic summaries";
    put "Age statistics";
    put "Sex distribution";
    put "Safety population summaries";
    put "Treatment exposure summaries";

    put " ";

    put "7. PROGRAMMING PRACTICES";

    put "Separate SAS programs for individual activities";
    put "Library-based permanent datasets";
    put "WORK library for temporary datasets";
    put "SAS Log review after program execution";
    put "QC output review";

    put " ";

    put "8. PROJECT LIMITATIONS";

    put "Synthetic training data only.";
    put "Independent QC is limited to implemented checks.";
    put "Full regulatory validation is not completed.";
    put "Additional TLF outputs and metadata are required.";

    put " ";

    put "====================================================";
    put "          END OF PROGRAMMING AND QC DOCUMENTATION";
    put "====================================================";

run;


/* STEP 3: VERIFY DOCUMENTATION FILE */

data _null_;

    if fexist("QCDOC") then
        put "PROGRAMMING QC DOCUMENT CREATED SUCCESSFULLY";

    else
        put "PROGRAMMING QC DOCUMENT NOT CREATED";

run;


/* STEP 4: CLEAR FILE REFERENCE */

filename QCDOC clear;
