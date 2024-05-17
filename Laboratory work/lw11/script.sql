CREATE FUNCTION dbo.GetPostsByDateRange
(
    @StartDate DATETIME,
    @EndDate DATETIME
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Posts
    WHERE PublicationDate BETWEEN @StartDate AND @EndDate
);

SELECT * FROM POSTS;

delete from posts;

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;

SET @StartDate = CONVERT(DATETIME, '2024-02-26T08:52:09.460', 126); -- ISO 8601 format
SET @EndDate = CONVERT(DATETIME, '2024-02-26T08:52:09.460', 126); -- ISO 8601 format

-- Ваш запрос здесь


-- Вызываем функцию и выбираем данные из возвращаемой таблицы
SELECT *
FROM dbo.GetPostsByDateRange(@StartDate, @EndDate) AS PostsInRange;
