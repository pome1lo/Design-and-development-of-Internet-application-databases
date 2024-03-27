-- ���������� ������ ����� �������� ���� ���������, �� �������, �� �������, �� ���.

-- ���� �������� ���� === ���������� ����������� ����� ������������� 

SELECT
  DATEPART(YEAR, RegistrationDate) AS Year,
  DATEPART(QUARTER, RegistrationDate) AS Quarter,
  DATEPART(MONTH, RegistrationDate) AS Month,
  COUNT(*) AS MonthlyRegistrations,
  COUNT(*) OVER (PARTITION BY DATEPART(YEAR, RegistrationDate), DATEPART(QUARTER, RegistrationDate)) AS QuarterlyRegistrations,
  COUNT(*) OVER (PARTITION BY DATEPART(YEAR, RegistrationDate), DATEPART(MONTH, RegistrationDate) - DATEPART(MONTH, RegistrationDate) % 6) AS SemiAnnualRegistrations,
  COUNT(*) OVER (PARTITION BY DATEPART(YEAR, RegistrationDate)) AS AnnualRegistrations
FROM Users
GROUP BY
  DATEPART(YEAR, RegistrationDate),
  DATEPART(QUARTER, RegistrationDate),
  DATEPART(MONTH, RegistrationDate)
ORDER BY
  Year,
  Quarter,
  Month;
	 
SELECT * FROM USERS;
