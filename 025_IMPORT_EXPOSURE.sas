
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 025_IMPORT_EXPOSURE                       */
/* PURPOSE: Import raw exposure data                  */
/*====================================================*/

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;


/* STEP 1: IMPORT RAW EXPOSURE DATA */

proc import
    datafile="&project\01_RAW_DATA\EDC_EXPOSURE.csv"
    out=RAW.EXPOSURE
    dbms=csv
    replace;

    getnames=yes;
    guessingrows=max;

run;


/* STEP 2: REVIEW DATASET STRUCTURE */

proc contents data=RAW.EXPOSURE;
run;


/* STEP 3: REVIEW FIRST 10 RECORDS */

title "RAW EXPOSURE DATA REVIEW";

proc print data=RAW.EXPOSURE(obs=10);
run;


/* STEP 4: COUNT TOTAL EXPOSURE RECORDS */

proc sql;

    select count(*) as TOTAL_EX_RECORDS
    from RAW.EXPOSURE;

quit;

title;
