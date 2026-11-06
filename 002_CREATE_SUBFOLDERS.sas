
/* Define master project directory */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;

/* Display project location in SAS Log */

%put ========================================;
%put PROJECT INITIALIZATION STARTED;
%put PROJECT LOCATION = &project;
%put PROJECT INITIALIZATION COMPLETED;
%put ========================================;
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 002_CREATE_SUBFOLDERS                     */
/* PURPOSE: Create project folder structure           */
/*====================================================*/

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;

data _null_;

    /* RAW DATA */
    rc=dcreate("01_RAW_DATA","&project");

    /* SDTM */
    rc=dcreate("02_SDTM","&project");
    rc=dcreate("PROGRAMS","&project\02_SDTM");
    rc=dcreate("DATASETS","&project\02_SDTM");

    /* ADaM */
    rc=dcreate("03_ADAM","&project");
    rc=dcreate("PROGRAMS","&project\03_ADAM");
    rc=dcreate("DATASETS","&project\03_ADAM");

    /* TLF */
    rc=dcreate("04_TLF","&project");
    rc=dcreate("TABLES","&project\04_TLF");
    rc=dcreate("LISTINGS","&project\04_TLF");
    rc=dcreate("FIGURES","&project\04_TLF");

    /* QC */
    rc=dcreate("05_QC","&project");
    rc=dcreate("PROGRAMS","&project\05_QC");
    rc=dcreate("DATASETS","&project\05_QC");

    /* OTHER PROJECT FOLDERS */
    rc=dcreate("06_MACROS","&project");
    rc=dcreate("07_METADATA","&project");
    rc=dcreate("08_DOCUMENTATION","&project");

run;
