
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 060_QC_ADSL_FINAL_QC_SUMMARY              */
/* PURPOSE: Consolidate final ADSL QC results         */
/*====================================================*/


/* STEP 1: COUNT SUBJECT RECONCILIATION RESULTS */

proc sql;

    create table WORK.QC_SUBJECT_COUNTS as

    select

        count(*) as TOTAL_SUBJECTS,

        sum(QC_STATUS="MATCH") as MATCHED_SUBJECTS,

        sum(QC_STATUS="MISSING_IN_ADSL")
            as MISSING_SUBJECTS,

        sum(QC_STATUS="EXTRA_IN_ADSL")
            as EXTRA_SUBJECTS

    from QC.ADSL_SUBJECT_RECONCILIATION;

quit;


/* STEP 2: COUNT TREATMENT AND SAFETY QC RESULTS */

proc sql;

    create table WORK.QC_TREATMENT_COUNTS as

    select

        sum(SAFETY_QC="MATCH") as SAFETY_MATCHES,

        sum(SAFETY_QC="MISMATCH") as SAFETY_MISMATCHES,

        sum(ACTUAL_TRT_QC="MATCH") as TREATMENT_MATCHES,

        sum(ACTUAL_TRT_QC="MISMATCH") as TREATMENT_MISMATCHES

    from QC.ADSL_TREATMENT_SAFETY_QC;

quit;


/* STEP 3: COUNT DEMOGRAPHIC QC RESULTS */

proc sql;

    create table WORK.QC_DEMOGRAPHIC_COUNTS as

    select

        sum(AGE_QC="MATCH") as AGE_MATCHES,

        sum(AGE_QC="MISMATCH") as AGE_MISMATCHES,

        sum(SEX_QC="MATCH") as SEX_MATCHES,

        sum(SEX_QC="MISMATCH") as SEX_MISMATCHES,

        sum(SITE_QC="MATCH") as SITE_MATCHES,

        sum(SITE_QC="MISMATCH") as SITE_MISMATCHES

    from QC.ADSL_DEMOGRAPHIC_QC;

quit;


/* STEP 4: COUNT PLANNED TREATMENT AND ITT QC RESULTS */

proc sql;

    create table WORK.QC_PLANNED_COUNTS as

    select

        sum(TRT_QC="MATCH") as PLANNED_TRT_MATCHES,

        sum(TRT_QC="MISMATCH") as PLANNED_TRT_MISMATCHES,

        sum(ITT_QC="UNASSIGNED_AS_EXPECTED")
            as ITT_UNASSIGNED,

        sum(ITT_QC="REVIEW_REQUIRED")
            as ITT_REVIEW_REQUIRED

    from QC.ADSL_PLANNED_TRT_QC;

quit;


/* STEP 5: COMBINE ALL QC RESULTS */

data QC.ADSL_FINAL_QC_SUMMARY;

    merge WORK.QC_SUBJECT_COUNTS
          WORK.QC_TREATMENT_COUNTS
          WORK.QC_DEMOGRAPHIC_COUNTS
          WORK.QC_PLANNED_COUNTS;

run;


/* STEP 6: DISPLAY FINAL QC SUMMARY */

title "FINAL ADSL INDEPENDENT QC SUMMARY";

proc print data=QC.ADSL_FINAL_QC_SUMMARY noobs;

run;

title;
