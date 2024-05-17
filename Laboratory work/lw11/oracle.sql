CREATE OR REPLACE FUNCTION get_users_between_dates(start_date IN DATE, end_date IN DATE)
RETURN SYS_REFCURSOR
IS
    my_cursor SYS_REFCURSOR;
BEGIN
    OPEN my_cursor FOR
        SELECT *
        FROM Users
        WHERE RegistrationDate BETWEEN start_date AND end_date;
    RETURN my_cursor;
END;
/



select * from users;



SPOOL C:\test\user_data_export.txt

SELECT * FROM TABLE(get_users_between_dates(TO_DATE('01-JAN-2020', 'DD-MON-YYYY'), TO_DATE('31-DEC-2024', 'DD-MON-YYYY')));


SPOOL OFF


CREATE TABLE Users_from (
    UserID NUMBER PRIMARY KEY,
    Name NVARCHAR2(100),
    Email NVARCHAR2(100),
    RegistrationDate DATE
);
