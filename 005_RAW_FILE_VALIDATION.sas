
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 005_RAW_FILE_VALIDATION                   */
/* PURPOSE: Validate availability of raw CSV files   */
/*====================================================*/

/* STEP 1: Define project location */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;

%let rawpath=&project\01_RAW_DATA;


/* STEP 2: Assign file references */

filename DEMO "&rawpath\EDC_DEMOGRAPHICS.csv";
filename AE "&rawpath\EDC_ADVERSE_EVENTS.csv";
filename LAB "&rawpath\EDC_LABORATORY.csv";
filename VS "&rawpath\EDC_VITAL_SIGNS.csv";
filename EX "&rawpath\EDC_EXPOSURE.csv";
filename TUMOR "&rawpath\EDC_TUMOR_ASSESSMENT.csv";
filename DISPO "&rawpath\EDC_DISPOSITION_SURVIVAL.csv";


/* STEP 3: Validate source files */

data _null_;

    put "======================================";
    put "RAW SOURCE FILE VALIDATION STARTED";
    put "======================================";

    if fexist("DEMO") then
        put "SUCCESS: EDC_DEMOGRAPHICS.csv FOUND";
    else
        put "ERROR: EDC_DEMOGRAPHICS.csv NOT FOUND";

    if fexist("AE") then
        put "SUCCESS: EDC_ADVERSE_EVENTS.csv FOUND";
    else
        put "ERROR: EDC_ADVERSE_EVENTS.csv NOT FOUND";

    if fexist("LAB") then
        put "SUCCESS: EDC_LABORATORY.csv FOUND";
    else
        put "ERROR: EDC_LABORATORY.csv NOT FOUND";

    if fexist("VS") then
        put "SUCCESS: EDC_VITAL_SIGNS.csv FOUND";
    else
        put "ERROR: EDC_VITAL_SIGNS.csv NOT FOUND";

    if fexist("EX") then
        put "SUCCESS: EDC_EXPOSURE.csv FOUND";
    else
        put "ERROR: EDC_EXPOSURE.csv NOT FOUND";

    if fexist("TUMOR") then
        put "SUCCESS: EDC_TUMOR_ASSESSMENT.csv FOUND";
    else
        put "ERROR: EDC_TUMOR_ASSESSMENT.csv NOT FOUND";

    if fexist("DISPO") then
        put "SUCCESS: EDC_DISPOSITION_SURVIVAL.csv FOUND";
    else
        put "ERROR: EDC_DISPOSITION_SURVIVAL.csv NOT FOUND";

    put "======================================";
    put "RAW SOURCE FILE VALIDATION COMPLETED";
    put "======================================";

run;


/* STEP 4: Clear temporary file references */

filename DEMO clear;
filename AE clear;
filename LAB clear;
filename VS clear;
filename EX clear;
filename TUMOR clear;
filename DISPO clear;
