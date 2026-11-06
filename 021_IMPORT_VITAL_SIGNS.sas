
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 021_IMPORT_VITAL_SIGNS                    */
/* PURPOSE: Import raw Vital Signs data                */
/*====================================================*/

/* STEP 1: Define project location */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;

/* STEP 2: Import Vital Signs CSV */

proc import
    datafile="&project\01_RAW_DATA\EDC_VITAL_SIGNS.csv"
    out=RAW.VITAL_SIGNS
    dbms=csv
    replace;

    getnames=yes;
    guessingrows=max;

run;

/* STEP 3: Check dataset structure */

proc contents data=RAW.VITAL_SIGNS;
run;

/* STEP 4: Display first 10 observations */

title "RAW VITAL SIGNS DATA REVIEW";

proc print data=RAW.VITAL_SIGNS(obs=10);
run;

/* STEP 5: Count total Vital Signs records */

proc sql;
    select count(*) as TOTAL_VS_RECORDS
    from RAW.VITAL_SIGNS;
quit;

/* STEP 6: Clear report title */

title;
