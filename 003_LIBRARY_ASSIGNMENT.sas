
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 003_LIBRARY_ASSIGNMENT                    */
/* PURPOSE: Assign SAS libraries to project folders   */
/*====================================================*/

/* Define project root directory */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;

/* Assign RAW library */

libname RAW "&project\01_RAW_DATA";

/* Assign SDTM library */

libname SDTM "&project\02_SDTM\DATASETS";

/* Assign ADaM library */

libname ADAM "&project\03_ADAM\DATASETS";

/* Assign QC library */

libname QC "&project\05_QC\DATASETS";

/* Configure SAS autocall macro folder */

options sasautos=("&project\06_MACROS",sasautos);
