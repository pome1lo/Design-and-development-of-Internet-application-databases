--Функция ранжирования ROW_NUMBER() в SQL Server позволяет присваивать уникальные номера строкам результата запроса, 
--основанные на порядке сортировки. Для разбиения результатов запроса на страницы, можно использовать ROW_NUMBER() 
--вместе с общим табличным выражением (CTE) или подзапросом. Давайте предположим, что мы хотим разбить на страницы таблицу Users по полю UserID.

--Ниже приведен пример запроса, который разбивает данные на страницы по 20 строк на каждую страницу:

--5.	Продемонстрируйте применение функции ранжирования ROW_NUMBER() для разбиения результатов запроса на страницы (по 20 строк на каждую страницу).

DECLARE @PageNumber AS INT = 3; -- старт
DECLARE @RowsPerPage AS INT = 20; -- q строк

WITH NumberedUsers AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY UserID) AS RowNum,
        UserID,
        Name,
        Email,
        RegistrationDate
    FROM 
        Users
)
SELECT 
    UserID,
    Name,
    Email,
    RegistrationDate
FROM 
    NumberedUsers
WHERE 
    RowNum > (@PageNumber - 1) * @RowsPerPage
    AND RowNum <= @PageNumber * @RowsPerPage
ORDER BY 
    UserID;
