SELECT
  EXTRACT(YEAR FROM RegistrationDate) AS номер_года,
  TO_CHAR(RegistrationDate, 'Q') AS номер_квартала,
  EXTRACT(MONTH FROM RegistrationDate) AS всего_за_месяц,
  (SELECT COUNT(*) FROM Users u2 WHERE EXTRACT(YEAR FROM u2.RegistrationDate) = EXTRACT(YEAR FROM u1.RegistrationDate) AND EXTRACT(MONTH FROM u2.RegistrationDate) = EXTRACT(MONTH FROM u1.RegistrationDate)) AS месяц,
  (SELECT COUNT(*) FROM Users u2 WHERE EXTRACT(YEAR FROM u2.RegistrationDate) = EXTRACT(YEAR FROM u1.RegistrationDate) AND TO_CHAR(u2.RegistrationDate, 'Q') = TO_CHAR(u1.RegistrationDate, 'Q')) AS квартал,
  (SELECT COUNT(*) FROM Users u2 WHERE EXTRACT(YEAR FROM u2.RegistrationDate) = EXTRACT(YEAR FROM u1.RegistrationDate) AND TRUNC(EXTRACT(MONTH FROM u2.RegistrationDate)/6) = TRUNC(EXTRACT(MONTH FROM u1.RegistrationDate)/6)) AS пол_года,
  (SELECT COUNT(*) FROM Users u2 WHERE EXTRACT(YEAR FROM u2.RegistrationDate) = EXTRACT(YEAR FROM u1.RegistrationDate)) AS год
FROM Users u1
GROUP BY
  EXTRACT(YEAR FROM RegistrationDate),
  TO_CHAR(RegistrationDate, 'Q'),
  EXTRACT(MONTH FROM RegistrationDate)
ORDER BY
  номер_года,
  номер_квартала,
  всего_за_месяц;





SELECT * FROM USERS;