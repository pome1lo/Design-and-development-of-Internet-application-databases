SELECT
  TO_CHAR(RegistrationDate, 'YYYY') AS Year,
  TO_CHAR(RegistrationDate, 'Q') AS Quarter,
  TO_CHAR(RegistrationDate, 'MM') AS Month,
  COUNT(*) AS MonthlyRegistrations,
  COUNT(*) OVER (PARTITION BY TO_CHAR(RegistrationDate, 'YYYY'), TO_CHAR(RegistrationDate, 'Q')) AS QuarterlyRegistrations,
  COUNT(*) OVER (PARTITION BY TO_CHAR(RegistrationDate, 'YYYY'), CEIL(TO_CHAR(RegistrationDate, 'MM') / 6)) AS SemiAnnualRegistrations,
  COUNT(*) OVER (PARTITION BY TO_CHAR(RegistrationDate, 'YYYY')) AS AnnualRegistrations
FROM Users
WHERE IsActive = 1
GROUP BY
  TO_CHAR(RegistrationDate, 'YYYY'),
  TO_CHAR(RegistrationDate, 'Q'),
  TO_CHAR(RegistrationDate, 'MM')
ORDER BY
  Year,
  Quarter,
  Month;
