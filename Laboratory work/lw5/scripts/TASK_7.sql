
--Вернуть для каждого пользователя количество последователей за последние 6 месяцев помесячно.

--количество новых друзей за последние 6 месяцев

WITH DateIntervals AS (
    SELECT DISTINCT
        DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - v.number, 0) AS StartOfMonth
    FROM 
        master..spt_values v
    WHERE 
        v.type = 'P'
        AND v.number BETWEEN 0 AND 5
),
MonthlyFollowers AS (
    SELECT
        u.UserID,
        DATEADD(MONTH, DATEDIFF(MONTH, 0, u.RegistrationDate), 0) AS Month,
        COUNT(f.FriendID) AS FollowersCount
    FROM 
        Users u
        JOIN Friends f ON u.UserID = f.FriendID
    WHERE 
        u.RegistrationDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY
        u.UserID,
        DATEADD(MONTH, DATEDIFF(MONTH, 0, u.RegistrationDate), 0)
)
SELECT
    u.UserID,
    u.Name,
    ISNULL(mf.Month, di.StartOfMonth) AS Month,
    ISNULL(mf.FollowersCount, 0) AS FollowersCount
FROM 
    Users u
    CROSS JOIN DateIntervals di
    LEFT JOIN MonthlyFollowers mf ON u.UserID = mf.UserID AND di.StartOfMonth = mf.Month
WHERE 
    u.IsActive = 1
ORDER BY 
    u.UserID,
    Month DESC;
