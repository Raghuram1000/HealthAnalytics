-- Step 1: Create a temporary staging table and copy data
CREATE TABLE Patientstaging
LIKE ocd_patient_dataset;

INSERT INTO Patientstaging
SELECT *
FROM ocd_patient_dataset;

-- Step 2: Check if the data has been copied correctly
SELECT *
FROM Patientstaging;

-- Step 3: Check for duplicate Patient IDs
SELECT `Patient ID`, COUNT(`Patient ID`) AS count
FROM Patientstaging
GROUP BY `Patient ID`
HAVING COUNT(`Patient ID`) > 1
ORDER BY count DESC;

-- Step 4: Create a table to store problematic records
CREATE TABLE ProblematicRecords AS
SELECT *
FROM Patientstaging
WHERE `Patient ID` IN (
    SELECT `Patient ID`
    FROM Patientstaging
    GROUP BY `Patient ID`
    HAVING COUNT(`Patient ID`) > 1
);
SELECT *
FROM ProblematicRecords;
SET SQL_SAFE_UPDATES = 0;
-- Step 5: Delete problematic records from the staging table
DELETE FROM Patientstaging
WHERE `Patient ID` IN (
    SELECT `Patient ID`
    FROM ProblematicRecords
);
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN `Patient ID` IS NULL THEN 1 ELSE 0 END) AS null_count_column1,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS null_count_column2,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_count_column3,
    SUM(CASE WHEN Ethnicity IS NULL THEN 1 ELSE 0 END) AS null_count_column4,
    SUM(CASE WHEN `Marital Status` IS NULL THEN 1 ELSE 0 END) AS null_count_column5,
    SUM(CASE WHEN `Education Level` IS NULL THEN 1 ELSE 0 END) AS null_count_column6,
    SUM(CASE WHEN `OCD Diagnosis Date` IS NULL THEN 1 ELSE 0 END) AS null_count_column7,
    SUM(CASE WHEN `Duration of Symptoms (months)` IS NULL THEN 1 ELSE 0 END) AS null_count_column8,
    SUM(CASE WHEN `Previous Diagnoses` IS NULL THEN 1 ELSE 0 END) AS null_count_column9,
    SUM(CASE WHEN `Family History of OCD` IS NULL THEN 1 ELSE 0 END) AS null_count_column10,
    SUM(CASE WHEN `Obsession Type` IS NULL THEN 1 ELSE 0 END) AS null_count_column11,
    SUM(CASE WHEN `Compulsion Type` IS NULL THEN 1 ELSE 0 END) AS null_count_column12,
    SUM(CASE WHEN `Y-BOCS Score (Obsessions)` IS NULL THEN 1 ELSE 0 END) AS null_count_column13,
    SUM(CASE WHEN `Y-BOCS Score (Compulsions)` IS NULL THEN 1 ELSE 0 END) AS null_count_column14,
    SUM(CASE WHEN `Depression Diagnosis` is  NULL THEN 1 ELSE 0 END) AS null_count_column15,
    SUM(CASE WHEN `Anxiety Diagnosis` IS NULL THEN 1 ELSE 0 END) AS null_count_column16,
    SUM(CASE WHEN Medications IS NULL THEN 1 ELSE 0 END) AS null_count_column17
    
FROM patientstaging;
-- Null values

Select Gender, count(`Patient ID`) AS patinetcount,
round(avg(`Y-BOCS Score (Obsessions)`),2) AS avgobsscore
From patientstaging
Group BY 1
Order By 2;
Select Gender, count(`Patient ID`) AS patinetcount,
round(avg(`Y-BOCS Score (Compulsions)`),2) AS avgobsscore
From patientstaging
Group BY 1
Order By 2;
select 
Ethnicity,
count(`Patient ID`) AS patinetcount,
avg(`Y-BOCS Score (Obsessions)`) as obsscore
FROM patientstaging
Group BY 1 
Order BY 2;
select 
Ethnicity,
count(`Patient ID`) AS patinetcount,
avg(`Y-BOCS Score (Compulsions)`) as compscore
FROM patientstaging
Group BY 1 
Order BY 2;

Alter Table patientstaging
Modify `OCD Diagnosis Date` date;
Select
Date_format(`OCD Diagnosis Date`,'%Y-%m-01 00:00:00') AS month,
 count(`Patient ID`) AS patinetcount
FROm patientstaging
Group BY 1 
 Order BY 1;
 SELECT `Obsession Type`,
 count(`Patient ID`) AS patinetcount,
 round(avg(`Y-BOCS Score (Obsessions)`),2) AS obsscore
 FROM patientstaging
 Group BY 1 
 Order BY 2;
  SELECT `Compulsion Type`,
 count(`Patient ID`) AS patinetcount,
 round(avg(`Y-BOCS Score (Compulsions)`),2) AS compscore
 FROM patientstaging
 Group BY 1 
 Order BY 2;