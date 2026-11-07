
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 061_PROJECT_OVERVIEW_DOCUMENTATION        */
/* PURPOSE: Generate clinical trial project overview */
/*          documentation                             */
/*====================================================*/


/* STEP 1: DEFINE DOCUMENTATION FILE */

filename DOCFILE
"C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL\08_DOCUMENTATION\PROJECT_OVERVIEW.txt";


/* STEP 2: GENERATE PROJECT OVERVIEW */

data _null_;

    file DOCFILE lrecl=200;

    put "====================================================";
    put "       NSCLC PHASE III CLINICAL TRIAL PROJECT";
    put "====================================================";

    put " ";

    put "1. PROJECT OVERVIEW";

    put "This is a synthetic oncology clinical trial";
    put "programming project developed using SAS 9.4.";

    put "The project demonstrates clinical data processing,";
    put "SDTM mapping, ADaM dataset development,";
    put "statistical summaries and quality control.";

    put " ";

    put "2. STUDY IDENTIFICATION";

    put "Study ID: NSCLC001";
    put "Study Area: Non-Small Cell Lung Cancer";
    put "Study Phase: Phase III - Training Simulation";
    put "Programming Software: SAS 9.4";

    put " ";

    put "3. RAW SOURCE DATASETS";

    put "EDC_DEMOGRAPHICS";
    put "EDC_ADVERSE_EVENTS";
    put "EDC_LABORATORY";
    put "EDC_VITAL_SIGNS";
    put "EDC_EXPOSURE";
    put "EDC_TUMOR_ASSESSMENT";
    put "EDC_DISPOSITION_SURVIVAL";

    put " ";

    put "4. SDTM DOMAINS DEVELOPED";

    put "DM - Demographics";
    put "AE - Adverse Events";
    put "LB - Laboratory";
    put "VS - Vital Signs";
    put "EX - Exposure";
    put "RS - Disease Response";

    put " ";

    put "5. ADAM DEVELOPMENT";

    put "ADSL - Subject-Level Analysis Dataset";

    put " ";

    put "6. QUALITY CONTROL";

    put "Subject reconciliation";
    put "Treatment and safety flag validation";
    put "Demographic validation";
    put "Planned treatment validation";
    put "ITT population flag review";

    put " ";

    put "7. TLF DEVELOPMENT";

    put "Demographic summaries";
    put "Age summaries";
    put "Sex distribution";
    put "Safety population summaries";
    put "Treatment exposure summaries";

    put " ";

    put "8. PROJECT LIMITATIONS";

    put "All records are synthetic training data.";
    put "The project is not a real clinical trial.";
    put "Some SDTM mappings and analysis flags are provisional.";
    put "Additional CDISC conformance and validation are required.";
    put "The current ADaM development includes ADSL.";

    put " ";

    put "9. SOFTWARE";

    put "SAS 9.4";

    put " ";

    put "====================================================";
    put "             END OF PROJECT OVERVIEW";
    put "====================================================";

run;


/* STEP 3: VERIFY DOCUMENTATION FILE */

data _null_;

    if fexist("DOCFILE") then
        put "PROJECT OVERVIEW DOCUMENT CREATED SUCCESSFULLY";

    else
        put "PROJECT OVERVIEW DOCUMENT NOT CREATED";

run;


/* STEP 4: CLEAR FILE REFERENCE */

filename DOCFILE clear;
