
*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 066_FINAL_DATASET_INVENTORY               */
/* PURPOSE: Inventory permanent SDTM, ADaM and QC     */
/*          datasets                                  */
/*====================================================*/


/* STEP 1: IDENTIFY PERMANENT DATASETS */

proc sql;

    create table QC.FINAL_DATASET_INVENTORY as

    select

        libname as LIBRARY,

        memname as DATASET_NAME,

        nobs as OBSERVATIONS,

        nvar as VARIABLES,

        datepart(crdate) as CREATED_DATE format=date9.,

        datepart(modate) as MODIFIED_DATE format=date9.

    from dictionary.tables

    where libname in ("SDTM", "ADAM", "QC")

      and memtype = "DATA"

    order by libname, memname;

quit;


/* STEP 2: DISPLAY FINAL INVENTORY */

title "FINAL SDTM ADAM AND QC DATASET INVENTORY";

proc print data=QC.FINAL_DATASET_INVENTORY noobs;

run;


/* STEP 3: SUMMARIZE DATASETS BY LIBRARY */

title "DATASET COUNTS BY LIBRARY";

proc freq data=QC.FINAL_DATASET_INVENTORY;

    tables LIBRARY;

run;


/* STEP 4: CALCULATE TOTAL DATASET COUNTS */

proc sql;

    select

        count(*) as TOTAL_DATASETS,

        sum(LIBRARY="SDTM") as SDTM_DATASETS,

        sum(LIBRARY="ADAM") as ADAM_DATASETS,

        sum(LIBRARY="QC") as QC_DATASETS

    from QC.FINAL_DATASET_INVENTORY;

quit;

title;
