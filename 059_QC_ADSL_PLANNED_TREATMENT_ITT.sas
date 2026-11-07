
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 059_QC_ADSL_PLANNED_TREATMENT_ITT         */
/* PURPOSE: Validate planned treatment and ITT flags  */
/*====================================================*/


/* STEP 1: PREPARE SDTM PLANNED TREATMENT */

proc sort data=SDTM.DM_UPDATED
          out=WORK.QC_DM_TREATMENT;

    by USUBJID;

run;


/* STEP 2: PREPARE ADSL */

proc sort data=ADAM.ADSL
          out=WORK.QC_ADSL_TREATMENT;

    by USUBJID;

run;


/* STEP 3: COMPARE PLANNED TREATMENT */

data QC.ADSL_PLANNED_TRT_QC;

    merge WORK.QC_DM_TREATMENT
          (in=IN_DM keep=USUBJID ARM)
          WORK.QC_ADSL_TREATMENT
          (in=IN_ADSL keep=USUBJID TRT01P ITTFL);

    by USUBJID;

    length TRT_QC $12 ITT_QC $20;

    if IN_DM and IN_ADSL then do;

        if ARM=TRT01P then TRT_QC="MATCH";
        else TRT_QC="MISMATCH";

        if missing(ITTFL) then
            ITT_QC="UNASSIGNED_AS_EXPECTED";
        else
            ITT_QC="REVIEW_REQUIRED";

    end;

    else do;

        TRT_QC="NO MATCH";
        ITT_QC="NO MATCH";

    end;

run;


/* STEP 4: REVIEW PLANNED TREATMENT QC */

title "PLANNED TREATMENT VALIDATION";

proc freq data=QC.ADSL_PLANNED_TRT_QC;

    tables TRT_QC / missing;

run;


/* STEP 5: REVIEW ITT FLAG QC */

title "ITT FLAG VALIDATION";

proc freq data=QC.ADSL_PLANNED_TRT_QC;

    tables ITT_QC / missing;

run;


/* STEP 6: DISPLAY MISMATCHES */

title "PLANNED TREATMENT MISMATCH REVIEW";

proc print data=QC.ADSL_PLANNED_TRT_QC noobs;

    where TRT_QC ne "MATCH";

    var USUBJID ARM TRT01P TRT_QC;

run;


/* STEP 7: DISPLAY FINAL SUBJECT REVIEW */

title "FINAL PLANNED TREATMENT AND ITT REVIEW";

proc print data=QC.ADSL_PLANNED_TRT_QC noobs;

    var USUBJID ARM TRT01P ITTFL TRT_QC ITT_QC;

run;

title;
