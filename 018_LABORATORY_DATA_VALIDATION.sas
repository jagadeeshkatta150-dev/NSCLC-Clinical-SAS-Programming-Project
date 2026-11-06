
*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 018_LABORATORY_DATA_VALIDATION            */
/* PURPOSE: Inspect raw laboratory data structure    */
/*====================================================*/


/* STEP 1: Check laboratory dataset structure */

proc contents data=RAW.LABORATORY;
run;


/* STEP 2: Display first 10 laboratory records */

title "RAW LABORATORY DATA REVIEW";

proc print data=RAW.LABORATORY(obs=10);
run;


/* STEP 3: Count total laboratory records */

proc sql;

    select count(*) as TOTAL_LAB_RECORDS
    from RAW.LABORATORY;

quit;


/* STEP 4: Clear report title */

title;
