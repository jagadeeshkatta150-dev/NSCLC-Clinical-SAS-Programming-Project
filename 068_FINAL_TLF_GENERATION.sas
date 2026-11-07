
/*==============================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL              */
/* PROGRAM: 068_FINAL_TLF_GENERATION                             */
/* PURPOSE: Generate final training tables, listings and figures*/
/* NOTE: Training outputs only; not submission-ready TLFs.       */
/*==============================================================*/

/* STEP 1: DEFINE PROJECT PATHS AND SAS LIBRARIES */

%let project=C:\Users\admin\Desktop\sas project\ONCOLOGY_CLINICAL_TRIAL;
%let tablepath=&project\04_TLF\TABLES;
%let listingpath=&project\04_TLF\LISTINGS;
%let figurepath=&project\04_TLF\FIGURES;

libname RAW  "&project\01_RAW_DATA";
libname SDTM "&project\02_SDTM\DATASETS";
libname ADAM "&project\03_ADAM\DATASETS";
libname QC   "&project\05_QC\DATASETS";

/* STEP 2: CHECK REQUIRED DATASETS BEFORE GENERATING OUTPUTS */

%macro checkds(ds);

    %if %sysfunc(exist(&ds)) %then %do;
        %put NOTE: REQUIRED DATASET &ds EXISTS.;
    %end;
    %else %do;
        %put ERROR: REQUIRED DATASET &ds DOES NOT EXIST.;
    %end;

%mend checkds;

%checkds(ADAM.ADSL)
%checkds(SDTM.AE)
%checkds(SDTM.LB)
%checkds(SDTM.VS)
%checkds(SDTM.EX)
%checkds(SDTM.RS)

/* Stop the program if a required dataset is missing. */

%macro verify_required;

    %if not %sysfunc(exist(ADAM.ADSL)) or
        not %sysfunc(exist(SDTM.AE)) or
        not %sysfunc(exist(SDTM.LB)) or
        not %sysfunc(exist(SDTM.VS)) or
        not %sysfunc(exist(SDTM.EX)) or
        not %sysfunc(exist(SDTM.RS))
    %then %do;
        %put ERROR: TLF GENERATION STOPPED - ONE OR MORE INPUT DATASETS ARE MISSING.;
        %abort cancel;
    %end;

%mend verify_required;

%verify_required;

/* STEP 3: PREPARE ADVERSE EVENT DATA WITH PLANNED TREATMENT */

proc sql;

    create table WORK.AE_TLF as

    select
        A.USUBJID,
        A.TRT01P,
        B.AETERM,
        B.AESEV,
        B.AEREL,
        B.AESER,
        B.AEOUT,
        B.AESTDTC,
        B.AEENDTC

    from ADAM.ADSL as A

    left join SDTM.AE as B
        on A.USUBJID = B.USUBJID;

quit;

/* STEP 4: CREATE OVERALL DEMOGRAPHIC SUMMARY */

proc means data=ADAM.ADSL nway noprint;

    class TRT01P;

    var AGE;

    output out=WORK.DEMO_SUMMARY
        n=SUBJECTS_WITH_AGE
        mean=MEAN_AGE
        std=SD_AGE
        median=MEDIAN_AGE
        min=MIN_AGE
        max=MAX_AGE;

run;

/* STEP 5: CREATE SAFETY POPULATION SUMMARY */

proc sql;

    create table WORK.SAFETY_SUMMARY as

    select
        TRT01P,
        count(*) as TOTAL_SUBJECTS,
        sum(SAFFL="Y") as SAFETY_SUBJECTS

    from ADAM.ADSL

    group by TRT01P;

quit;

/* STEP 6: CREATE ADVERSE EVENT SUMMARY BY SEVERITY */

proc sql;

    create table WORK.AE_SUMMARY as

    select
        TRT01P,
        AESEV,
        count(*) as EVENT_COUNT

    from WORK.AE_TLF

    where not missing(AETERM)

    group by TRT01P, AESEV;

quit;

/* STEP 7: CREATE LABORATORY ABNORMALITY SUMMARY */

proc sql;

    create table WORK.LB_SUMMARY as

    select
        count(*) as TOTAL_LAB_RECORDS,
        sum(LBNRIND="LOW") as LOW_RESULTS,
        sum(LBNRIND="NORMAL") as NORMAL_RESULTS

    from SDTM.LB;

quit;

/* STEP 8: CREATE TUMOR RESPONSE SUMMARY */

proc sql;

    create table WORK.RS_SUMMARY as

    select
        RSSTRESC,
        count(*) as ASSESSMENT_RECORDS

    from SDTM.RS

    group by RSSTRESC;

quit;

/* STEP 9: CREATE EXPOSURE SUMMARY */

proc sql;

    create table WORK.EX_SUMMARY as

    select
        count(*) as EXPOSURE_RECORDS,
        count(distinct USUBJID) as SUBJECTS_WITH_EXPOSURE

    from SDTM.EX;

quit;

/* STEP 10: GENERATE TABLES IN RTF FORMAT */

ods rtf file="&tablepath\FINAL_CLINICAL_TABLES.rtf"
    style=journal;

/* TABLE 1: DEMOGRAPHIC AND BASELINE AGE SUMMARY */

title "TABLE 1. DEMOGRAPHIC AND BASELINE AGE SUMMARY";

proc report data=WORK.DEMO_SUMMARY nowd;

    columns TRT01P SUBJECTS_WITH_AGE
            MEAN_AGE SD_AGE MEDIAN_AGE
            MIN_AGE MAX_AGE;

    define TRT01P / group "Planned Treatment";
    define SUBJECTS_WITH_AGE / analysis "N";
    define MEAN_AGE / analysis mean "Mean Age";
    define SD_AGE / analysis mean "SD";
    define MEDIAN_AGE / analysis mean "Median";
    define MIN_AGE / analysis min "Minimum";
    define MAX_AGE / analysis max "Maximum";

run;

/* TABLE 2: SUBJECT AND SAFETY POPULATION SUMMARY */

title "TABLE 2. SUBJECT AND SAFETY POPULATION SUMMARY";

proc report data=WORK.SAFETY_SUMMARY nowd;

    columns TRT01P TOTAL_SUBJECTS SAFETY_SUBJECTS;

    define TRT01P / group "Planned Treatment";
    define TOTAL_SUBJECTS / analysis sum "Total Subjects";
    define SAFETY_SUBJECTS / analysis sum "Safety Population";

run;

/* TABLE 3: ADVERSE EVENTS BY SEVERITY */

title "TABLE 3. ADVERSE EVENTS BY SEVERITY";

proc report data=WORK.AE_SUMMARY nowd;

    columns TRT01P AESEV EVENT_COUNT;

    define TRT01P / group "Planned Treatment";
    define AESEV / group "Severity";
    define EVENT_COUNT / analysis sum "Number of Events";

run;

/* TABLE 4: LABORATORY RESULT SUMMARY */

title "TABLE 4. LABORATORY RESULT SUMMARY";

proc print data=WORK.LB_SUMMARY noobs;
run;

/* TABLE 5: TUMOR RESPONSE ASSESSMENT SUMMARY */

title "TABLE 5. TUMOR RESPONSE ASSESSMENT SUMMARY";

proc print data=WORK.RS_SUMMARY noobs;
run;

/* TABLE 6: EXPOSURE SUMMARY */

title "TABLE 6. EXPOSURE SUMMARY";

proc print data=WORK.EX_SUMMARY noobs;
run;

ods rtf close;
title;

/* STEP 11: GENERATE CLINICAL LISTINGS IN RTF FORMAT */

ods rtf file="&listingpath\FINAL_CLINICAL_LISTINGS.rtf"
    style=journal;

/* LISTING 1: DEMOGRAPHICS */

title "LISTING 1. SUBJECT DEMOGRAPHICS";

proc print data=ADAM.ADSL noobs;

    var STUDYID USUBJID SUBJID SITEID AGE SEX
        TRT01P TRT01A SAFFL ITTFL DTHFL;

run;

/* LISTING 2: ADVERSE EVENTS */

title "LISTING 2. ADVERSE EVENTS";

proc print data=SDTM.AE noobs;

    var USUBJID AESEQ AETERM AESEV AEREL
        AESER AESTDTC AEENDTC AEOUT;

run;

/* LISTING 3: LABORATORY RESULTS */

title "LISTING 3. LABORATORY RESULTS";

proc print data=SDTM.LB noobs;

    var USUBJID LBSEQ LBTESTCD LBTEST
        LBORRES LBORRESU LBSTRESN LBSTRESU
        LBNRIND LBDTC;

run;

/* LISTING 4: VITAL SIGNS */

title "LISTING 4. VITAL SIGNS";

proc print data=SDTM.VS noobs;

    var USUBJID VSSEQ VSTESTCD VSTEST
        VSORRES VSORRESU VSSTRESN VSSTRESU VSDTC;

run;

/* LISTING 5: EXPOSURE */

title "LISTING 5. EXPOSURE";

proc print data=SDTM.EX noobs;

    var USUBJID EXSEQ EXTRT EXDOSE EXDOSU
        EXROUTE EXSTDTC EXENDTC;

run;

/* LISTING 6: TUMOR RESPONSE */

title "LISTING 6. TUMOR RESPONSE";

proc print data=SDTM.RS noobs;

    var USUBJID RSSEQ RSTESTCD RSTEST
        RSORRES RSSTRESC RSDTC VISIT;

run;

/* LISTING 7: SUBJECT DISPOSITION AND SURVIVAL FLAGS */

title "LISTING 7. SUBJECT DISPOSITION AND SURVIVAL FLAGS";

proc print data=ADAM.ADSL noobs;

    var USUBJID TRT01P TRT01A SAFFL ITTFL DTHFL;

run;

ods rtf close;
title;

/* STEP 12: GENERATE FIGURES IN PNG FORMAT */

ods listing gpath="&figurepath";
ods graphics on / reset imagename="FIGURE_1_SUBJECT_DISPOSITION"
                    imagefmt=png;

/* FIGURE 1: SUBJECT DISPOSITION */

proc sgplot data=ADAM.ADSL;

    vbar DTHFL / missing
        datalabel
        categoryorder=respdesc;

    xaxis label="Death Flag (blank = not recorded as death)";
    yaxis label="Number of Subjects";

    title "FIGURE 1. SUBJECT DEATH FLAG COUNTS";

run;

ods graphics on / reset imagename="FIGURE_2_ADVERSE_EVENTS"
                    imagefmt=png;

/* FIGURE 2: ADVERSE EVENTS BY SEVERITY */

proc sgplot data=SDTM.AE;

    vbar AESEV / datalabel;

    xaxis label="Adverse Event Severity";
    yaxis label="Number of AE Records";

    title "FIGURE 2. ADVERSE EVENTS BY SEVERITY";

run;

ods graphics on / reset imagename="FIGURE_3_TUMOR_RESPONSE"
                    imagefmt=png;

/* FIGURE 3: TUMOR RESPONSE ASSESSMENT RECORDS */

proc sgplot data=SDTM.RS;

    vbar RSSTRESC / datalabel;

    xaxis label="Overall Response";
    yaxis label="Number of Assessment Records";

    title "FIGURE 3. TUMOR RESPONSE ASSESSMENTS";

run;

ods graphics off;
ods listing close;
title;

/* STEP 13: VERIFY EXPECTED OUTPUT FILES */

filename TABLEOUT "&tablepath\FINAL_CLINICAL_TABLES.rtf";
filename LISTOUT  "&listingpath\FINAL_CLINICAL_LISTINGS.rtf";
filename FIG1      "&figurepath\FIGURE_1_SUBJECT_DISPOSITION.png";
filename FIG2      "&figurepath\FIGURE_2_ADVERSE_EVENTS.png";
filename FIG3      "&figurepath\FIGURE_3_TUMOR_RESPONSE.png";

data WORK.TLF_FILE_CHECK;

    length OUTPUT_FILE $200 STATUS $20;

    OUTPUT_FILE = "FINAL_CLINICAL_TABLES.rtf";
    if fexist("TABLEOUT") then STATUS = "FOUND";
    else STATUS = "NOT FOUND";
    output;

    OUTPUT_FILE = "FINAL_CLINICAL_LISTINGS.rtf";
    if fexist("LISTOUT") then STATUS = "FOUND";
    else STATUS = "NOT FOUND";
    output;

    OUTPUT_FILE = "FIGURE_1_SUBJECT_DISPOSITION.png";
    if fexist("FIG1") then STATUS = "FOUND";
    else STATUS = "NOT FOUND";
    output;

    OUTPUT_FILE = "FIGURE_2_ADVERSE_EVENTS.png";
    if fexist("FIG2") then STATUS = "FOUND";
    else STATUS = "NOT FOUND";
    output;

    OUTPUT_FILE = "FIGURE_3_TUMOR_RESPONSE.png";
    if fexist("FIG3") then STATUS = "FOUND";
    else STATUS = "NOT FOUND";
    output;

run;

title "FINAL TLF OUTPUT FILE VERIFICATION";

proc print data=WORK.TLF_FILE_CHECK noobs;
run;

filename TABLEOUT clear;
filename LISTOUT clear;
filename FIG1 clear;
filename FIG2 clear;
filename FIG3 clear;

title;

/* END OF PROGRAM 068 */
