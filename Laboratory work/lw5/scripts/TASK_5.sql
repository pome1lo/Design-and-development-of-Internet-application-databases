--������� ������������ ROW_NUMBER() � SQL Server ��������� ����������� ���������� ������ ������� ���������� �������, 
--���������� �� ������� ����������. ��� ��������� ����������� ������� �� ��������, ����� ������������ ROW_NUMBER() 
--������ � ����� ��������� ���������� (CTE) ��� �����������. ������� �����������, ��� �� ����� ������� �� �������� ������� Users �� ���� UserID.

--���� �������� ������ �������, ������� ��������� ������ �� �������� �� 20 ����� �� ������ ��������:

--5.	����������������� ���������� ������� ������������ ROW_NUMBER() ��� ��������� ����������� ������� �� �������� (�� 20 ����� �� ������ ��������).

DECLARE @PageNumber AS INT = 3; -- �����
DECLARE @RowsPerPage AS INT = 20; -- q �����

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
