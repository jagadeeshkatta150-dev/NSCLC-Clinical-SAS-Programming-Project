
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 013_IMPORT_ADVERSE_EVENTS                 */
/* PURPOSE: Import raw adverse events data            */
/*====================================================*/


/* STEP 1: Define project location */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;


/* STEP 2: Import adverse events CSV */

proc import
    datafile="&project\01_RAW_DATA\EDC_ADVERSE_EVENTS.csv"
    out=RAW.ADVERSE_EVENTS
    dbms=csv
    replace;

    getnames=yes;
    guessingrows=max;

run;


/* STEP 3: Check dataset structure */

proc contents data=RAW.ADVERSE_EVENTS;
run;


/* STEP 4: Display first 10 observations */

title "RAW ADVERSE EVENTS DATA REVIEW";

proc print data=RAW.ADVERSE_EVENTS(obs=10);
run;


/* STEP 5: Count total adverse event records */

proc sql;

    select count(*) as TOTAL_AE_RECORDS
    from RAW.ADVERSE_EVENTS;

quit;


/* STEP 6: Clear report title */

title;
