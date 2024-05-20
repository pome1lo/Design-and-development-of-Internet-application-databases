--use PiRBDIP;
drop table report;
drop procedure GenerateXML;
drop procedure InsertXMLIntoReport;
drop procedure ExtractValueFromXML;
drop procedure ExtractXMLValue;

--1.	Создайте таблицу Report, содержащую два столбца – id и XML-столбец в базе данных SQL Server.
CREATE TABLE Report (
    id INT IDENTITY PRIMARY KEY,
    Data XML
);

--2.	Создайте процедуру генерации XML. XML должен включать данные из как минимум 3 соединенных таблиц, 
--		различные промежуточные итоги и штамп времени.
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

--3.	Создайте процедуру вставки этого XML в таблицу Report.
CREATE PROCEDURE InsertXMLIntoReport
    @xmlData XML
AS
BEGIN
    INSERT INTO Report (Data) VALUES (@xmlData);
END



--4.	Создайте индекс над XML-столбцом в таблице Report. 
CREATE PRIMARY XML INDEX IX_Report_Data ON Report(Data);



--5.	Создайте процедуру извлечения значений элементов и/или атрибутов из XML -столбца в
--		таблице Report (параметр – значение атрибута или элемента).
CREATE PROCEDURE ExtractXMLValue
    @xmlPath NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @result NVARCHAR(MAX);

    -- Извлекаем значение элемента или атрибута из XML-столбца в таблице Report
	SELECT  CONVERT(NVARCHAR(MAX), Data.query('/Users/User/Name')) FROM Report;
END;



EXEC ExtractXMLValue '/Users/User/Name/User55';









DECLARE @xmlData XML;
EXEC GenerateXML;

-- Предполагается, что @xmlData содержит XML, сгенерированный процедурой GenerateXML
EXEC InsertXMLIntoReport @xmlData;

-- Замените 1 на UserID, для которого вы хотите извлечь имя


EXEC ExtractXMLValue '/Users/User/Name/User55';


SELECT * FROM Report;
