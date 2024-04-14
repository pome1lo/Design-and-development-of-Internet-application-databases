
SELECT
  u.UserID,
  TO_CHAR(ADD_MONTHS(CURRENT_DATE, -lvl), 'YYYY-MM') AS Month,
  COUNT(f.FriendID) OVER (PARTITION BY u.UserID, TO_CHAR(ADD_MONTHS(CURRENT_DATE, -lvl), 'YYYY-MM')) AS FollowersCount
FROM
  Users u
  LEFT JOIN Friends f ON u.UserID = f.UserID
  CROSS JOIN (SELECT LEVEL as lvl FROM DUAL CONNECT BY LEVEL <= 6) m
ORDER BY
  u.UserID,
  Month DESC;
