
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 029_IMPORT_TUMOR_ASSESSMENT               */
/* PURPOSE: Import raw tumor assessment data          */
/*====================================================*/


/* STEP 1: IMPORT RAW TUMOR ASSESSMENT DATA */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;

proc import
    datafile="&project\01_RAW_DATA\EDC_TUMOR_ASSESSMENT.csv"
    out=RAW.TUMOR_ASSESSMENT
    dbms=csv
    replace;

    getnames=yes;
    guessingrows=max;

run;


/* STEP 2: REVIEW DATASET STRUCTURE */

proc contents data=RAW.TUMOR_ASSESSMENT varnum;
run;


/* STEP 3: DISPLAY FIRST 10 RECORDS */

title "RAW TUMOR ASSESSMENT DATA REVIEW";

proc print data=RAW.TUMOR_ASSESSMENT(obs=10);
run;


/* STEP 4: COUNT TOTAL RECORDS */

proc sql;

    select count(*) as TOTAL_TUMOR_RECORDS
    from RAW.TUMOR_ASSESSMENT;

quit;

title;
