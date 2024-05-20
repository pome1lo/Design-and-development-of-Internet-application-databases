--use PiRBDIP;
drop table report;
drop procedure GenerateXML;
drop procedure InsertXMLIntoReport;
drop procedure ExtractValueFromXML;
drop procedure ExtractXMLValue;

--1.	�������� ������� Report, ���������� ��� ������� � id � XML-������� � ���� ������ SQL Server.
CREATE TABLE Report (
    id INT IDENTITY PRIMARY KEY,
    Data XML
);

--2.	�������� ��������� ��������� XML. XML ������ �������� ������ �� ��� ������� 3 ����������� ������, 
--		��������� ������������� ����� � ����� �������.
CREATE PROCEDURE GenerateXML
AS
BEGIN
    DECLARE @result XML;
    SET @result = (
        SELECT 
            u.UserID,
            u.Name,
            u.Email,
            u.RegistrationDate,
            (SELECT PostID, PostText, PublicationDate FROM Posts WHERE Posts.UserID = u.UserID FOR XML PATH('Post'), TYPE),
            (SELECT FriendID FROM Friends WHERE Friends.UserID = u.UserID FOR XML PATH('Friend'), TYPE),
            (SELECT PostID FROM Likes WHERE Likes.UserID = u.UserID FOR XML PATH('Like'), TYPE),
            (SELECT CommentID, CommentText, PublicationDate FROM Comments WHERE Comments.UserID = u.UserID FOR XML PATH('Comment'), TYPE)
        FROM 
            Users u
        FOR XML PATH('User'), ROOT('Users'), ELEMENTS
    );
    SELECT @result;
END

--3.	�������� ��������� ������� ����� XML � ������� Report.
CREATE PROCEDURE InsertXMLIntoReport
    @xmlData XML
AS
BEGIN
    INSERT INTO Report (Data) VALUES (@xmlData);
END



--4.	�������� ������ ��� XML-�������� � ������� Report. 
CREATE PRIMARY XML INDEX IX_Report_Data ON Report(Data);



--5.	�������� ��������� ���������� �������� ��������� �/��� ��������� �� XML -������� �
--		������� Report (�������� � �������� �������� ��� ��������).
CREATE PROCEDURE ExtractXMLValue
    @xmlPath NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @result NVARCHAR(MAX);

    -- ��������� �������� �������� ��� �������� �� XML-������� � ������� Report
	SELECT  CONVERT(NVARCHAR(MAX), Data.query('/Users/User/Name')) FROM Report;
END;



EXEC ExtractXMLValue '/Users/User/Name/User55';









DECLARE @xmlData XML;
EXEC GenerateXML;

-- ��������������, ��� @xmlData �������� XML, ��������������� ���������� GenerateXML
EXEC InsertXMLIntoReport @xmlData;

-- �������� 1 �� UserID, ��� �������� �� ������ ������� ���


EXEC ExtractXMLValue '/Users/User/Name/User55';


SELECT * FROM Report;
