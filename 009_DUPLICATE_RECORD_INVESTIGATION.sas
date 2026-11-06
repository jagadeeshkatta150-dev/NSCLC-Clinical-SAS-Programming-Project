
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 009_DUPLICATE_RECORD_INVESTIGATION        */
/* PURPOSE: Extract and review duplicate patient IDs  */
/*====================================================*/


/* STEP 1: Extract complete duplicate source records */

proc sql;

    create table QC.DEMO_DUPLICATE_RECORDS as

    select *
    from RAW.DEMOGRAPHICS

    where PATIENT_NO in
    (
        select PATIENT_NO
        from QC.DEMO_DUPLICATE_IDS
    );

quit;


/* STEP 2: Display duplicate source records */

title "DUPLICATE PATIENT RECORD INVESTIGATION";

proc print data=QC.DEMO_DUPLICATE_RECORDS;

run;


/* STEP 3: Count extracted duplicate records */

proc sql;

    select count(*) as TOTAL_DUPLICATE_RECORDS
    from QC.DEMO_DUPLICATE_RECORDS;

quit;


/* STEP 4: Display duplicate ID investigation summary */

title "DUPLICATE PATIENT ID SUMMARY";

proc print data=QC.DEMO_DUPLICATE_IDS;

run;


/* STEP 5: Clear report titles */

title;
