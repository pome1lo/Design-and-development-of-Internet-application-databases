-- Для вычисления итогов роста сегмента сети в Oracle без использования UNION ALL, можно использовать оконные функции и
-- условные агрегации. Однако, у нас нет информации о том, как определяются "удаленные пользователи" в вашей схеме данных.
-- Будем предполагать, что есть какой-то механизм для идентификации неактивных или удаленных пользователей, например,
-- столбец IsActive в таблице Users. Если такого столбца нет, вам потребуется добавить его или использовать другой
-- критерий для определения статуса пользователя.
--

ALTER TABLE Users
ADD IsActive NUMBER(1) DEFAULT 1 NOT NULL;


SELECT
  COUNT(CASE WHEN IsActive = 1 THEN UserID END) AS ActiveUsers,
  COUNT(CASE WHEN IsActive = 0 THEN UserID END) AS DeactivatedUsers,
  COUNT(UserID) AS TotalUsers,
  COUNT(CASE WHEN IsActive = 1 AND RegistrationDate >= TRUNC(SYSDATE, 'YYYY') THEN UserID END) AS NewUsers,
  ROUND(COUNT(CASE WHEN IsActive = 1 AND RegistrationDate >= TRUNC(SYSDATE, 'YYYY') THEN UserID END) / COUNT(CASE WHEN IsActive = 1 THEN UserID END) * 100, 2) AS NewUsersPercentage,
  ROUND(COUNT(CASE WHEN IsActive = 0 THEN UserID END) / COUNT(UserID) * 100, 2) AS DeactivatedUsersPercentage
FROM Users;


SELECT * FROM USERS