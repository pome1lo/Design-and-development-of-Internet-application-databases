
--����� ������������ �������� ���������� ���������� ������ ������������� ����? ������� ��� ���� �����.

--������ ���� �������� ������� ������ ����, �� ����� ����� ������������, ������� �������� ���������� ���������� ������

WITH LikeCounts AS (
    SELECT
        L.UserID,
        COUNT(*) AS NumberOfLikes,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank
    FROM Likes L
    INNER JOIN Users U ON L.UserID = U.UserID
    WHERE U.IsActive = 1
    GROUP BY L.UserID
)
SELECT
    LC.UserID,
    U.Name,
    LC.NumberOfLikes
FROM LikeCounts LC
INNER JOIN Users U ON LC.UserID = U.UserID
WHERE LC.Rank = 1;