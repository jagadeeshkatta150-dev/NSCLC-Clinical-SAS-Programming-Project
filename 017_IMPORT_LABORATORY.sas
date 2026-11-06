
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 017_IMPORT_LABORATORY                     */
/* PURPOSE: Import raw laboratory data                */
/*====================================================*/


/* STEP 1: Define project location */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;


/* STEP 2: Import laboratory CSV */

proc import
    datafile="&project\01_RAW_DATA\EDC_LABORATORY.csv"
    out=RAW.LABORATORY
    dbms=csv
    replace;

    getnames=yes;
    guessingrows=max;

run;


/* STEP 3: Check dataset structure */

proc contents data=RAW.LABORATORY;
run;


/* STEP 4: Display first 10 observations */

title "RAW LABORATORY DATA REVIEW";

proc print data=RAW.LABORATORY(obs=10);
run;


/* STEP 5: Count total laboratory records */

proc sql;

    select count(*) as TOTAL_LAB_RECORDS
    from RAW.LABORATORY;

quit;


/* STEP 6: Clear report title */

title;
