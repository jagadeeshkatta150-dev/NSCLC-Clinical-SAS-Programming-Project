
/*====================================================*/
/* PROJECT: NSCLC PHASE III ONCOLOGY CLINICAL TRIAL   */
/* PROGRAM: 004_LIBRARY_VERIFICATION                  */
/* PURPOSE: Verify SAS library assignments            */
/*====================================================*/

/* Step 1: Verify RAW library */

data _null_;

    if libref("RAW") = 0 then
        put "RAW LIBRARY SUCCESSFULLY ASSIGNED";
    else
        put "RAW LIBRARY NOT ASSIGNED";


    /* Step 2: Verify SDTM library */

    if libref("SDTM") = 0 then
        put "SDTM LIBRARY SUCCESSFULLY ASSIGNED";
    else
        put "SDTM LIBRARY NOT ASSIGNED";


    /* Step 3: Verify ADaM library */

    if libref("ADAM") = 0 then
        put "ADAM LIBRARY SUCCESSFULLY ASSIGNED";
    else
        put "ADAM LIBRARY NOT ASSIGNED";


    /* Step 4: Verify QC library */

    if libref("QC") = 0 then
        put "QC LIBRARY SUCCESSFULLY ASSIGNED";
    else
        put "QC LIBRARY NOT ASSIGNED";

run;


/* Step 5: Display all assigned libraries */

libname _all_ list;
