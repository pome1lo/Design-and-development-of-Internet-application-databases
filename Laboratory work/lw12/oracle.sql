-- Создайте таблицу Report, содержащую два столбца – id и XML-столбец в базе данных SQL Server.
DROP TABLE Report;
DROP TABLE Users;
INSERT INTO Users (UserID, Name, Email, RegistrationDate) VALUES (1, 'John Doe', 'johndoe@example.com', SYSDATE);
INSERT INTO Users (UserID, Name, Email, RegistrationDate) VALUES (2, 'Jane Doe', 'janedoe@example.com', SYSDATE);
INSERT INTO Users (UserID, Name, Email, RegistrationDate) VALUES (3, 'Richard Roe', 'richardroe@example.com', SYSDATE);

CREATE TABLE Users (
    UserID NUMBER PRIMARY KEY,
    Name NVARCHAR2(100),
    Email NVARCHAR2(100),
    RegistrationDate DATE
);
CREATE TABLE Report
(
    id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    xml_data XMLTYPE
);

-- Создайте процедуру генерации XML. XML должен включать данные из как минимум 3 соединенных таблиц,
-- различные промежуточные итоги и штамп времени.
CREATE OR REPLACE PROCEDURE GENERATE_XML_REPORT(GeneratedXML OUT XMLTYPE) IS
BEGIN
    SELECT XMLElement("Data", XMLForest(
          XMLAgg(
              XMLElement("User",
                 XMLForest(
                     u.Name AS "Name",
                     u.Email AS "Email",
                     u.RegistrationDate AS "RegistrationDate"
                 )
              )
          ) AS "Users"
          )
       )
    INTO GeneratedXML
    FROM DUAL
             CROSS JOIN
         Users u;
END;
/


-- Создайте процедуру вставки этого XML в таблицу Report.
CREATE OR REPLACE PROCEDURE INSERT_XML_INTO_REPORT IS ReportXML XMLTYPE;
BEGIN
    GENERATE_XML_REPORT(ReportXML);
    INSERT INTO Report (xml_data) VALUES (ReportXML);
    COMMIT;
END;

BEGIN
    INSERT_XML_INTO_REPORT();
END;

SELECT x.UserName
FROM Report r,
     XMLTable('/Data/Users/User'
              PASSING r.xml_data
              COLUMNS
                  UserName VARCHAR2(100) PATH 'Name') x
WHERE r.id = 1;


SELECT * FROM REPORT;

-- Создайте индекс над XML-столбцом в таблице Report.
DROP INDEX XML_INDEX;
CREATE INDEX XML_INDEX on Report (extractvalue(XML_DATA, '/Data/Users/User[0]/Name/text()'));

SELECT * FROM REPORT WHERE EXTRACTVALUE(XML_DATA, '/Data/Users/User[0]/Name/text()') = 'John Doe';

-- Создайте процедуру извлечения значений элементов и/или
-- атрибутов из XML -столбца в таблице Report (параметр – значение атрибута или элемента).
CREATE OR REPLACE PROCEDURE GET_XML_VALUE(
    p_id IN NUMBER,
    p_xpath IN VARCHAR2,
    p_result OUT VARCHAR2
)
IS
BEGIN
    SELECT EXTRACTVALUE(xml_data, p_xpath)
    INTO p_result
    FROM Report
    WHERE id = p_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := NULL;
END GET_XML_VALUE;

DECLARE
    v_result VARCHAR2(100);
BEGIN
    GET_XML_VALUE(1, '/Data/Users/User[1]/Name/text()', v_result);
    DBMS_OUTPUT.PUT_LINE('User Name: ' || v_result);
END;
