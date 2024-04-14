-- Для выполнения вашего задания, сначала нам нужно создать таблицы с данными, которые позволят нам выполнить анализ с
-- использованием конструкций MODEL и MATCH_RECOGNIZE. Давайте начнем с создания дополнительных таблиц и заполнения их
-- тестовыми данными.

-- 1.	Постройте при помощи конструкции MODEL запросы, которые разрабатывают план:
--  расширения охвата потенциальных пользователей на следующий год помесячно,
--  учитывая изменение количества клиентов и виды контента.

CREATE TABLE UserActivity ( -- которая отслеживает активность пользователей в социальной сети
    ActivityID NUMBER PRIMARY KEY,
    UserID NUMBER,
    ActivityDate DATE,
    ActivityType NVARCHAR2(100),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE ContentTypes ( -- содержит информацию о видах контента
    ContentTypeID NUMBER PRIMARY KEY,
    ContentName NVARCHAR2(100)
);

INSERT INTO UserActivity (ActivityID, UserID, ActivityDate, ActivityType) VALUES (1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'Login');
INSERT INTO UserActivity (ActivityID, UserID, ActivityDate, ActivityType) VALUES (2, 2, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'Post');
INSERT INTO ContentTypes (ContentTypeID, ContentName) VALUES (1, 'Blog Post');
INSERT INTO ContentTypes (ContentTypeID, ContentName) VALUES (2, 'Video');


-- коэф роста 10%

SELECT ActivityMonth, UsersCount, ForecastUsers
FROM (
  SELECT
    ActivityMonth,
    UsersCount,
    LEAD(UsersCount, 1) OVER (ORDER BY ActivityMonth) AS NextMonthUsersCount -- Получаем количество пользователей следующего месяца
  FROM (
    SELECT
      TO_CHAR(ActivityDate, 'YYYY-MM') AS ActivityMonth,
      COUNT(DISTINCT UserID) AS UsersCount
    FROM UserActivity
    GROUP BY TO_CHAR(ActivityDate, 'YYYY-MM')
  )
)
MODEL -- для прогнозирования числа пользователей каждого месяца, основываясь на исторических данных.
  DIMENSION BY (ActivityMonth)
  MEASURES (UsersCount, NextMonthUsersCount, 0 AS ForecastUsers)
  RULES (
    ForecastUsers[ANY] = COALESCE(NextMonthUsersCount[CV()], UsersCount[CV()] * 1.1)
  )
ORDER BY ActivityMonth;




-- 2.	Найдите при помощи конструкции MATCH_RECOGNIZE() данные, которые соответствуют шаблону:

--	Падение, рост, падение количества пользователей для каждого сектора социальной сети

SELECT *
FROM UserActivityCount
MATCH_RECOGNIZE (
  ORDER BY ActivityDate
  MEASURES
    MATCH_NUMBER() AS match_num,
    CLASSIFIER() AS pattern_match
  ALL ROWS PER MATCH
  PATTERN (DOWN UP DOWN)
  DEFINE
    DOWN AS DOWN.UsersCount < PREV(DOWN.UsersCount),
    UP AS UP.UsersCount > PREV(UP.UsersCount)
);



CREATE VIEW UserActivityCount AS
SELECT ActivityDate, COUNT(DISTINCT UserID) AS UsersCount
FROM UserActivity
GROUP BY ActivityDate;

Drop view UserActivityCount

