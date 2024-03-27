

--Вычисление итогов роста сегмента сети за определенный период:
--•	количество новых пользователей сегмента;		--количество новых пользователей за определенный период и сравнить это с общим количеством пользователей 
--•	сравнение с общим количеством пользователей сегмента (в %);
--•	количество удаленных пользователей сегмента (в %);
--•	сравнение с общим количеством пользователей сети (в %).

SELECT * FROM USERS;

DECLARE @StartDate DATETIME = DATEADD(YEAR, -1, GETDATE()); -- Один год назад
DECLARE @EndDate DATETIME = GETDATE(); -- Сегодня

WITH UserCounts AS (
    SELECT
        SUM(CASE WHEN RegistrationDate BETWEEN @StartDate AND @EndDate THEN 1 ELSE 0 END) AS NewUsers,
        SUM(CASE WHEN IsActive = 0 AND RegistrationDate < @EndDate THEN 1 ELSE 0 END) AS DeactivatedUsers,
        COUNT(*) AS TotalUsers
    FROM Users
)
SELECT
    NewUsers,
    CAST(NewUsers AS FLOAT) / TotalUsers * 100 AS NewUsersPercentage,
    DeactivatedUsers,
    CAST(DeactivatedUsers AS FLOAT) / TotalUsers * 100 AS DeactivatedUsersPercentage
FROM UserCounts;
