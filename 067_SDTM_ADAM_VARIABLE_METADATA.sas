
/*==============================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL              */
/* PROGRAM: 067_SDTM_ADAM_VARIABLE_METADATA                     */
/* PURPOSE: Create a combined SDTM and ADaM variable inventory   */
/* NOTE: This is a SAS metadata inventory, NOT Define-XML.       */
/*==============================================================*/

/* STEP 1: ASSIGN PROJECT ROOT AND LIBRARIES */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;

libname SDTM "&project\02_SDTM\DATASETS";
libname ADAM "&project\03_ADAM\DATASETS";
libname QC   "&project\05_QC\DATASETS";

/* STEP 2: EXTRACT VARIABLE METADATA FROM ALL SDTM DATASETS */

proc contents data=SDTM._ALL_
    out=WORK.SDTM_METADATA
    noprint;
run;

/* STEP 3: EXTRACT VARIABLE METADATA FROM ALL ADaM DATASETS */

proc contents data=ADAM._ALL_
    out=WORK.ADAM_METADATA
    noprint;
run;

/* STEP 4: COMBINE SDTM AND ADaM METADATA */

data QC.FINAL_VARIABLE_METADATA;

    set WORK.SDTM_METADATA
        WORK.ADAM_METADATA;

    /* Keep the metadata fields needed for review/documentation */

    keep LIBNAME MEMNAME NAME TYPE LENGTH
         LABEL FORMAT INFORMAT VARNUM;

run;

/* STEP 5: SORT METADATA BY LIBRARY, DATASET AND VARIABLE ORDER */

proc sort data=QC.FINAL_VARIABLE_METADATA;

    by LIBNAME MEMNAME VARNUM;

run;

/* STEP 6: DISPLAY COMPLETE VARIABLE METADATA */

title "FINAL SDTM AND ADaM VARIABLE METADATA";

proc print data=QC.FINAL_VARIABLE_METADATA noobs;

    var LIBNAME MEMNAME NAME TYPE LENGTH
        LABEL FORMAT INFORMAT VARNUM;

run;

/* STEP 7: SUMMARIZE DATASET METADATA COVERAGE */

title "VARIABLE METADATA COUNT BY LIBRARY AND DATASET";

proc freq data=QC.FINAL_VARIABLE_METADATA;

    tables LIBNAME*MEMNAME / list missing;

run;

/* STEP 8: COUNT TOTAL METADATA RECORDS */

proc sql;

    select
        count(*) as TOTAL_VARIABLES,
        sum(LIBNAME="SDTM") as SDTM_VARIABLES,
        sum(LIBNAME="ADAM") as ADAM_VARIABLES
    from QC.FINAL_VARIABLE_METADATA;

quit;

/* STEP 9: CHECK FOR MISSING VARIABLE LABELS */

proc sql;

    create table QC.MISSING_VARIABLE_LABELS as

    select
        LIBNAME,
        MEMNAME,
        NAME,
        TYPE,
        LENGTH,
        VARNUM

    from QC.FINAL_VARIABLE_METADATA

    where missing(LABEL)

    order by LIBNAME, MEMNAME, VARNUM;

quit;

title "VARIABLES WITH MISSING LABELS";

proc print data=QC.MISSING_VARIABLE_LABELS noobs;
run;

/* STEP 10: CLEAR TITLES */

title;
