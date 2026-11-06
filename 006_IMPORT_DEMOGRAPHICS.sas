
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 006_IMPORT_DEMOGRAPHICS                   */
/* PURPOSE: Import demographics source CSV into SAS   */
/*====================================================*/


/* STEP 1: Define project location */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;


/* STEP 2: Import demographics CSV */

proc import
    datafile="&project\01_RAW_DATA\EDC_DEMOGRAPHICS.csv"
    out=RAW.DEMOGRAPHICS
    dbms=csv
    replace;

    getnames=yes;
    guessingrows=max;

run;


/* STEP 3: Check dataset structure */

proc contents data=RAW.DEMOGRAPHICS;
run;


/* STEP 4: Display first 10 observations */

proc print data=RAW.DEMOGRAPHICS(obs=10);
run;


/* STEP 5: Check number of observations and variables */

proc sql;
    select count(*) as Total_Observations
    from RAW.DEMOGRAPHICS;
quit;
