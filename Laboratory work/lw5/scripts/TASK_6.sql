
--Пример запроса для удаления дубликатов:

SELECT * FROM USERS;
--6.	Продемонстрируйте применение функции ранжирования ROW_NUMBER() для удаления дубликатов.
INSERT INTO Users(UserID,Name, Email) VALUES (1002,'User1000','user1000@example.com');

WITH CTE_Duplicates AS (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY Name, Email ORDER BY UserID) AS RowNumber,
        UserID
    FROM 
        Users
)
DELETE FROM CTE_Duplicates WHERE RowNumber > 1;