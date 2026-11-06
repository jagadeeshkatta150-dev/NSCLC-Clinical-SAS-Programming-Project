
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 035_IMPORT_DISPOSITION_SURVIVAL           */
/* PURPOSE: Import raw disposition and survival data */
/*====================================================*/


/* STEP 1: DEFINE PROJECT LOCATION */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;


/* STEP 2: IMPORT RAW DISPOSITION AND SURVIVAL DATA */

proc import
    datafile="&project\01_RAW_DATA\EDC_DISPOSITION_SURVIVAL.csv"
    out=RAW.DISPOSITION_SURVIVAL
    dbms=csv
    replace;

    getnames=yes;
    guessingrows=max;

run;


/* STEP 3: REVIEW DATASET STRUCTURE */

proc contents data=RAW.DISPOSITION_SURVIVAL varnum;

run;


/* STEP 4: DISPLAY FIRST 10 RECORDS */

title "RAW DISPOSITION AND SURVIVAL DATA REVIEW";

proc print data=RAW.DISPOSITION_SURVIVAL(obs=10);

run;


/* STEP 5: COUNT TOTAL RECORDS */

proc sql;

    select count(*) as TOTAL_DS_RECORDS
    from RAW.DISPOSITION_SURVIVAL;

quit;

title;
