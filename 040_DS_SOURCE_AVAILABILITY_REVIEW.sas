
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 040_DS_SOURCE_AVAILABILITY_REVIEW         */
/* PURPOSE: Review disposition source availability   */
/*====================================================*/


/* STEP 1: REVIEW SOURCE DATA STRUCTURE */

proc contents data=RAW.DISPOSITION_SURVIVAL varnum;
run;


/* STEP 2: DOCUMENT AVAILABLE AND MISSING SOURCE FIELDS */

data QC.DS_SOURCE_GAP_REVIEW;

    length SOURCE_FIELD $30
           DESCRIPTION $60
           AVAILABILITY $15;

    SOURCE_FIELD = "PATIENT_NO";
    DESCRIPTION = "Patient identifier";
    AVAILABILITY = "AVAILABLE";
    output;

    SOURCE_FIELD = "SITE_NO";
    DESCRIPTION = "Site identifier";
    AVAILABILITY = "AVAILABLE";
    output;

    SOURCE_FIELD = "TREATMENT_START_DATE";
    DESCRIPTION = "Treatment start date";
    AVAILABILITY = "AVAILABLE";
    output;

    SOURCE_FIELD = "LAST_CONTACT_DATE";
    DESCRIPTION = "Last contact date";
    AVAILABILITY = "AVAILABLE";
    output;

    SOURCE_FIELD = "VITAL_STATUS";
    DESCRIPTION = "Alive or dead status";
    AVAILABILITY = "AVAILABLE";
    output;

    SOURCE_FIELD = "DEATH_INDICATOR";
    DESCRIPTION = "Death indicator";
    AVAILABILITY = "AVAILABLE";
    output;

    SOURCE_FIELD = "EVENT_DATE";
    DESCRIPTION = "Event date; meaning requires confirmation";
    AVAILABILITY = "REVIEW REQUIRED";
    output;

    SOURCE_FIELD = "DSDECOD";
    DESCRIPTION = "Standardized disposition term";
    AVAILABILITY = "NOT AVAILABLE";
    output;

    SOURCE_FIELD = "DSSTDTC";
    DESCRIPTION = "Disposition event date";
    AVAILABILITY = "NOT AVAILABLE";
    output;

    SOURCE_FIELD = "DSREASND";
    DESCRIPTION = "Reason for discontinuation";
    AVAILABILITY = "NOT AVAILABLE";
    output;

run;


/* STEP 3: DISPLAY SOURCE AVAILABILITY REVIEW */

title "SDTM DS SOURCE AVAILABILITY REVIEW";

proc print data=QC.DS_SOURCE_GAP_REVIEW noobs;
run;


/* STEP 4: SUMMARIZE SOURCE AVAILABILITY */

title "SOURCE AVAILABILITY SUMMARY";

proc freq data=QC.DS_SOURCE_GAP_REVIEW;

    tables AVAILABILITY;

run;

title;
