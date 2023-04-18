Site: https://www.sql-practice.com/

Q:Show first name, last name, and gender of patients who's gender is 'M'
Query:
SELECT first_name,last_name, gender
FROM patients
WHERE gender = 'M'

Q:Show first name and last name of patients who does not have allergies. (null)
Query:
SELECT first_name,last_name
FROM patients
WHERE allergies is NULL

Q:Show first name of patients that start with the letter 'C'
Query:
SELECT first_name
FROM patients
WHERE first_name LIKE 'c%'

Q:Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
Query:
SELECT first_name,last_name
FROM patients
WHERE weight between 100 and 120

Q:Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
Query:
UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL

Q:Show first name and last name concatenated into one column to show their full name.
Query:
SELECT CONCAT(first_name,' ',last_name)
FROM patients

Q:Show first name, last name, and the full province name of each patient.
Example: 'Ontario' instead of 'ON'
Query:
SELECT p.first_name,p.last_name, pr.province_name
FROM patients p 
	JOIN province_names pr ON p.province_id = pr.province_id

Q:Show how many patients have a birth_date with 2010 as the birth year.
Query:
SELECT COUNT(patient_id) 
FROM patients
where YEAR(birth_date) = 2010

Q:Show the first_name, last_name, and height of the patient with the greatest height.
Query:
SELECT first_name,last_name, MAX(height)
FROM patients

Q:Show all columns for patients who have one of the following patient_ids:
1,45,534,879,1000
Query:
SELECT *
FROM patients
WHERE patient_id IN (1,45,534,879,1000)

Q:Show the total number of admissions
Query:
SELECT COUNT(patient_id)
FROM admissions

Q:Show all the columns from admissions where the patient was admitted and discharged on the same day.
Query:
SELECT *
FROM admissions
WHERE admission_date = discharge_date

Q:Show the patient id and the total number of admissions for patient_id 579.
Query:
SELECT patient_id, count(admission_date)
FROM admissions
WHERE patient_id = 579

Q:Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
Query:
SELECT DISTINCT p.city
FROM patients p
	JOIN province_names pr ON p.province_id = pr.province_id
WHERE p.province_id = 'NS'

Q:Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70
Query:
SELECT first_name,last_name,birth_date
FROM patients
WHERE height > 160 and weight > 70

Q:Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null
Query:
SELECT first_name,last_name,allergies
FROM patients
WHERE city = 'Hamilton' and allergies NOT null

Q:Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city.
Query:
SELECT DISTINCT City
FROM patients
WHERE (City LIKE 'A%') or 
       (City LIKE 'E%') or 
       (City LIKE 'I%') or 
       (City LIKE 'O%') OR
       (City LIKE 'U%')
ORDER BY City

Q:Show unique birth years from patients and order them by ascending.
Query:
SELECT distinct YEAR(birth_date)
FROM patients
ORDER BY birth_date

Q:Show unique first names from the patients table which only occurs once in the list.
For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
Query:
SELECT DISTINCT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1

Q:Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
Query:
SELECT patient_id,first_name
FROM patients
WHERE LENGTH(first_name) > 5 AND first_name LIKE 's%' and first_name LIKE '%s'
Q:Show patient_id, first_name, last_name from patients whose diagnosis is 'Dementia'.
Primary diagnosis is stored in the admissions table.
Query:
SELECT p.patient_id, p.first_name, p.last_name
FROM patients p
	JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia'

Q:Display every patient's first_name.
Order the list by the length of each name and then by alphabetically
Query:
SELECT first_name
FROM patients
ORDER BY Len(first_name), first_name

Q:Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row.
Query:
SELECT COUNT(patient_id) as male_count,
 (SELECT COUNT(patient_id) as female_count
  FROM patients
  WHERE gender = 'M')
FROM patients
WHERE gender = 'F'

Q:Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
Query:
SELECT first_name, last_name, allergies
FROM patients
WHERE allergies IN ('Penicillin','Morphine')
ORDER By allergies,first_name,last_name

Q:Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
Query:
SELECT patient_id,diagnosis
FROM admissions
GROUP BY patient_id,diagnosis 
HAVING COUNT(*) > 1


Q:Show the city and the total number of patients in the city.
Order from most to least patients and then by city name ascending.
Query:
select City, COUNT(patient_id) as total_number
from patients
group by City
order by total_number DESC, City

Q:Show first name, last name and role of every person that is either patient or doctor.
The roles are either "Patient" or "Doctor"
Query:
SELECT first_name,last_name, 'Patient' as role 
FROM patients
UNION ALL 
SELECT first_name,last_name,'Doctor' as role 
FROM doctors

Q:Show all allergies ordered by popularity. Remove NULL values from the query.
Query:
SELECT allergies, COUNT(patient_id) AS total_diag
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diag DESC

Q:Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
Query:
SELECT first_name,last_name,birth_date
FROM patients
WHERE birth_date BETWEEN '1970-01-01' AND '1979-12-31'
ORDER BY birth_date

Q:We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in descending order
EX: SMITH,jane
Query:
SELECT
  CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
FROM patients
ORDER BY first_name DESC;


Q:Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
Query:
SELECT province_id, SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING sum_height >= 7000

Q:Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
Query:
SELECT MAX(weight) - MIN(weight) as DIFF
FROM patients
WHERE last_name = 'Maroni'

Q:Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
Query:
SELECT DAY(admission_date) as Date, COUNT(admission_date) as admissions_occ
FROM admissions
GROUP BY Date
ORDER BY admissions_occ DESC

Q:Show all columns for patient_id 542's most recent admission_date.
Query:
SELECT *
FROM admissions
WHERE patient_id = '542'
GROUP BY patient_id
HAVING MAX(admission_date)

Q:Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
Query:
SELECT patient_id, attending_doctor_id,diagnosis
FROM admissions
WHERE (attending_doctor_id IN (1,5,19) and patient_id %2 != 0)
	OR 	(attending_doctor_id LIKE '%2%' and LEN(patient_id) = 3)

Q:Show first_name, last_name, and the total number of admissions attended for each doctor.
Every admission has been attended by a doctor.
Query:
SELECT d.first_name,d.last_name, count(a.admission_date) as total
FROM doctors d 
	JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY d.first_name

Q:For each doctor, display their id, full name, and the first and last admission date they attended.
Query:
SELECT d.doctor_id, CONCAT(d.first_name,' ',d.last_name), min(a.admission_date) as first_adm, MAX(a.admission_date) as last_adm
FROM doctors d 
	JOIN admissions a ON d.doctor_id = a.attending_doctor_id
GROUP BY a.attending_doctor_id

Q:Display the total amount of patients for each province. Order by descending.
Query:
SELECT province_name,COUNT(patient_id) as patient_count
FROM patients p 
	JOIN province_names pr
    ON p.province_id = pr.province_id
GROUP BY pr.province_name
ORDER BY patient_count desc

Q:For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
Query:
SELECT CONCAT(p.first_name,' ', p.last_name) as patient_name, a.diagnosis,
	   CONCAT (d.first_name,' ',d.last_name) as doctors_name
FROM patients p 
    JOIN admissions a ON a.patient_id = p.patient_id 
    JOIN doctors d ON d.doctor_id = a.attending_doctor_id

Q:Display the number of duplicate patients based on their first_name and last_name.
Query:
SELECT first_name, last_name, count(*) as num_of
FROM patients
GROUP BY first_name, last_name
HAVING COUNT(*) > 1

Q:Display patient's full name,
height in the units feet rounded to 1 decimal,
weight in the unit pounds rounded to 0 decimals,
birth_date,
gender non abbreviated.

Convert CM to feet by dividing by 30.48.
Convert KG to pounds by multiplying by 2.205.
Query:
SELECT
    CONCAT(first_name, ' ', last_name) AS 'patient_name', 
    ROUND(height / 30.48, 1) as 'height "Feet"', 
    ROUND(weight * 2.205, 0) AS 'weight "Pounds"', birth_date,
CASE
	WHEN gender = 'M' THEN 'MALE' 
  ELSE 'FEMALE' 
END AS 'gender_type'
FROM patients
