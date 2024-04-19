-- TASK № 1

WITH UserGrowth AS (
    SELECT
        MONTH(RegistrationDate) AS Month,
        YEAR(RegistrationDate) AS Year,
        COUNT(UserID) AS NewUsers
    FROM Users
    GROUP BY MONTH(RegistrationDate), YEAR(RegistrationDate)
),
SegmentGrowth AS (
    SELECT
        DATEPART(QUARTER, RegistrationDate) AS Quarter,
        YEAR(RegistrationDate) AS Year,
        COUNT(UserID) AS NewUsers
    FROM Users
    GROUP BY DATEPART(QUARTER, RegistrationDate), YEAR(RegistrationDate)
),
NetworkGrowth AS (
    SELECT
        YEAR(RegistrationDate) AS Year,
        COUNT(UserID) AS NewUsers
    FROM Users
    GROUP BY YEAR(RegistrationDate)
)
SELECT
    *,
    SUM(NewUsers) OVER (ORDER BY Year, Month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MonthlyGrowth,
    SUM(NewUsers) OVER (PARTITION BY Quarter, Year ORDER BY Year, Quarter) AS QuarterlyGrowth,
    SUM(NewUsers) OVER (PARTITION BY Year ORDER BY Year) AS AnnualGrowth
FROM (
    SELECT Month, Year, NewUsers, 0 AS Quarter
    FROM UserGrowth
    
    UNION ALL
    
    SELECT 0 AS Month, Year, NewUsers, Quarter
    FROM SegmentGrowth
    
    UNION ALL
    
    SELECT 0 AS Month, Year, NewUsers, 0 AS Quarter
    FROM NetworkGrowth
) AS CombinedData
ORDER BY Year, Month;
 

-- TASK № 2

WITH SegmentData AS (
    SELECT
        YEAR(RegistrationDate) AS Year,
        MONTH(RegistrationDate) AS Month,
        COUNT(UserID) AS NewUsers,
        SUM(CASE WHEN DATEDIFF(MONTH, RegistrationDate, GETDATE()) >= 12 THEN 1 ELSE 0 END) AS DeletedUsers
    FROM Users
    GROUP BY YEAR(RegistrationDate), MONTH(RegistrationDate)
),
NetworkData AS (
    SELECT
        YEAR(RegistrationDate) AS NetworkYear,
        COUNT(UserID) AS TotalUsers
    FROM Users
    GROUP BY YEAR(RegistrationDate)
),
SegmentNetworkData AS (
    SELECT
        SD.Year,
        SD.Month,
        SD.NewUsers,
        SD.DeletedUsers,
        ND.TotalUsers,
        SUM(SD.NewUsers) OVER (ORDER BY SD.Year, SD.Month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeNewUsers,
        SUM(SD.DeletedUsers) OVER (ORDER BY SD.Year, SD.Month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeDeletedUsers,
        SUM(ND.TotalUsers) OVER (ORDER BY SD.Year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeTotalUsers
    FROM SegmentData SD
    JOIN NetworkData ND ON SD.Year = ND.NetworkYear
)
SELECT
    Year,
    Month,
    NewUsers,
    TotalUsers AS SegmentTotalUsers,
    CAST(NewUsers * 100.0 / TotalUsers AS DECIMAL(5, 2)) AS NewUsersPercentage,
    DeletedUsers,
    CAST(DeletedUsers * 100.0 / TotalUsers AS DECIMAL(5, 2)) AS DeletedUsersPercentage,
    TotalUsers AS NetworkTotalUsers,
    CAST(TotalUsers * 100.0 / CumulativeTotalUsers AS DECIMAL(5, 2)) AS NetworkTotalUsersPercentage
FROM SegmentNetworkData
ORDER BY Year, Month;



-- TASK № 3

WITH NumberedPosts AS (
    SELECT
        P.PostID,
        U.Name AS UserName,
        P.PostText,
        P.PublicationDate,
        ROW_NUMBER() OVER (ORDER BY P.PublicationDate) AS RowNum
    FROM Posts P
    JOIN Users U ON P.UserID = U.UserID
)
SELECT
    PostID,
    UserName,
    PostText,
    PublicationDate
FROM NumberedPosts
WHERE RowNum BETWEEN 1 AND 20; -- Первая страница


-- TASK № 4


-- TASK № 5

WITH NumberedUsers AS (
    SELECT
        UserID,
        Name,
        Email,
        RegistrationDate,
        ROW_NUMBER() OVER (PARTITION BY Email ORDER BY UserID) AS RowNum
    FROM Users
)
DELETE FROM NumberedUsers
WHERE RowNum > 1;
 


-- TASK № 6

WITH FollowersCount AS (
    SELECT
        U.UserID,
        U.Name,
        DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 6, 0) AS StartDate,
        DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) AS EndDate,
        COUNT(*) OVER (PARTITION BY U.UserID, DATEADD(MONTH, DATEDIFF(MONTH, 0, P.PublicationDate), 0)) AS FollowersLast6Months
    FROM Users U
    LEFT JOIN Posts P ON U.UserID = P.UserID
    LEFT JOIN Likes L ON P.PostID = L.PostID
    WHERE DATEDIFF(MONTH, P.PublicationDate, GETDATE()) <= 6
)
SELECT 
    UserID,
    Name,
    CONVERT(VARCHAR(7), DATEADD(MONTH, DATEDIFF(MONTH, 0, StartDate), 0), 126) AS MonthYear,
    FollowersLast6Months
FROM FollowersCount
GROUP BY UserID, Name, StartDate, FollowersLast6Months
ORDER BY UserID, StartDate;



-- TASK № 7

WITH LikesCount AS (
    SELECT
        UserID,
        COUNT(*) AS LikeCount,
        RANK() OVER (PARTITION BY 'Like' ORDER BY COUNT(*) DESC) AS LikeRank
    FROM Likes
    GROUP BY UserID
),
CommentsCount AS (
    SELECT
        UserID,
        COUNT(*) AS CommentCount,
        RANK() OVER (PARTITION BY 'Comment' ORDER BY COUNT(*) DESC) AS CommentRank
    FROM Comments
    GROUP BY UserID
),
OtherLikesCount AS (
    SELECT
        UserID,
        COUNT(*) AS OtherLikeCount,
        RANK() OVER (PARTITION BY 'OtherLike' ORDER BY COUNT(*) DESC) AS OtherLikeRank
    FROM OtherLikes  -- Заменить на существующую таблицу с информацией о других лайках
    GROUP BY UserID
)
SELECT 
    U.UserID,
    U.Name,
    LC.LikeCount,
    CC.CommentCount,
    OLC.OtherLikeCount
FROM Users U
LEFT JOIN LikesCount LC ON U.UserID = LC.UserID AND LC.LikeRank = 1
LEFT JOIN CommentsCount CC ON U.UserID = CC.UserID AND CC.CommentRank = 1
LEFT JOIN OtherLikesCount OLC ON U.UserID = OLC.UserID AND OLC.OtherLikeRank = 1;