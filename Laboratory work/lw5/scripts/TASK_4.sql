

--���������� ������ ����� �������� ���� �� ������������ ������:
--�	���������� ����� ������������� ��������;		--���������� ����� ������������� �� ������������ ������ � �������� ��� � ����� ����������� ������������� 
--�	��������� � ����� ����������� ������������� �������� (� %);
--�	���������� ��������� ������������� �������� (� %);
--�	��������� � ����� ����������� ������������� ���� (� %).

SELECT * FROM USERS;

DECLARE @StartDate DATETIME = DATEADD(YEAR, -1, GETDATE()); -- ���� ��� �����
DECLARE @EndDate DATETIME = GETDATE(); -- �������

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
