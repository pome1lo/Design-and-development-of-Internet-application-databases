
SELECT
  UserID,
  LikesCount,
  RANK() OVER (ORDER BY LikesCount DESC) as Rank
FROM (
  SELECT
    UserID,
    COUNT(*) as LikesCount
  FROM
    Likes
  GROUP BY
    UserID
)
WHERE
  Rank = 1;

--
-- ######


WITH RankedLikes AS (
  SELECT
    UserID,
    COUNT(*) as LikesCount,
    RANK() OVER (ORDER BY COUNT(*) DESC) as Rank
  FROM
    Likes
  GROUP BY
    UserID
)
SELECT
  UserID,
  LikesCount
FROM
  RankedLikes
WHERE
  Rank = 1;

