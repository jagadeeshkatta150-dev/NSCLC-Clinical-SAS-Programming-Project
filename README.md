
# NSCLC Clinical SAS Programming Project

## 1. Project Overview

This project demonstrates end-to-end clinical trial data programming using SAS 9.4 for a simulated Phase III Non-Small Cell Lung Cancer (NSCLC) clinical study.

The project covers clinical raw data processing, CDISC SDTM mapping, ADaM dataset development, statistical summaries, Tables, Listings and Figures (TLFs), quality control, and programming documentation.

## 2. Study Information

| Parameter | Description |
|---|---|
| Study Type | Phase III Clinical Trial |
| Therapeutic Area | Oncology |
| Indication | Non-Small Cell Lung Cancer |
| Programming Language | SAS 9.4 |
| Data Standard | CDISC |
| Analysis Framework | SDTM and ADaM |
| Data Type | Synthetic Clinical Trial Data |

## 3. Project Objectives

- Import and process raw clinical trial data.
- Perform source data validation and quality checks.
- Develop CDISC SDTM datasets.
- Develop analysis-ready ADaM datasets.
- Derive treatment and analysis variables.
- Generate clinical statistical summaries.
- Develop TLF outputs.
- Perform dataset reconciliation and quality control.
- Maintain programming and metadata documentation.

## 4. SDTM Dataset Development

The project includes programming activities for the following SDTM domains:

| Domain | Description |
|---|---|
| DM | Demographics |
| AE | Adverse Events |
| LB | Laboratory Tests |
| VS | Vital Signs |
| EX | Exposure |
| RS | Disease Response |
| DS | Disposition |

Activities include:
- Raw data import
- Data cleaning and validation
- Variable mapping
- Domain creation
- Dataset review
- Source-to-target traceability

## 5. ADaM Dataset Development

Analysis data programming includes:

- ADSL – Subject-Level Analysis Dataset
- Treatment date derivations
- Analysis population flags
- Demographic summaries
- Treatment group summaries
- Disposition and survival summaries
- Analysis dataset quality control

## 6. TLF Programming

The project includes clinical statistical programming activities for:

- Table 1 – Demographic and Baseline Characteristics
- Age Statistics
- Sex Distribution
- Safety Population Summary
- Treatment Exposure Summary
- Actual Treatment Summary
- ADSL Population Summary

## 7. SAS Programming Techniques

The following SAS programming techniques are covered across the project:

- DATA Step Programming
- PROC SORT
- PROC SQL
- PROC MEANS
- PROC FREQ
- PROC PRINT
- BY-Group Processing
- FIRST. and LAST. Processing
- RETAIN Statement
- Conditional Logic
- Variable Derivations
- Dataset Merging
- SAS Macro Programming
- Data Validation and QC

## 8. Quality Control and Validation

Quality control activities include:

- Raw data validation
- SDTM dataset validation
- ADaM dataset validation
- Subject-level reconciliation
- Treatment and safety flag checks
- Demographic consistency checks
- Final dataset review
- Programming documentation

## 9. Project Deliverables

The repository contains 68 SAS programming files covering:

- Project initialization and data preparation
- Clinical raw data processing
- SDTM dataset development
- ADaM dataset development
- Clinical statistical summaries
- TLF programming
- Quality control and validation
- Metadata and project documentation

## 10. Repository Structure

## 10. Repository Structure

```text
NSCLC-Clinical-SAS-Programming-Project/
│
├── 01_RAW_DATA/
│
├── 02_SDTM/
│   ├── DATASETS/
│   └── README.md
│
├── 03_ADAM/
│   ├── DATASETS/
│   └── README.md
│
├── 04_TLF/
│   ├── TABLES/
│   ├── FIGURES/
│   └── LISTINGS/
│
├── 001_PROJECT_INITIALIZATION.sas
├── 002_CREATE_SUBFOLDERS.sas
├── ...
├── 068_FINAL_TLF_GENERATION.sas
│
└── README.md
```
```

## 11. Disclaimer

All clinical trial data used in this project are synthetic and created exclusively for educational, learning, and portfolio demonstration purposes.

This project is not associated with an actual clinical trial, pharmaceutical sponsor, or regulatory submission.

## 12. Author

Clinical SAS Programming Portfolio Project

**Focus Areas:** SAS Programming | Clinical Data Management | CDISC SDTM | ADaM | TLF | Quality Control
