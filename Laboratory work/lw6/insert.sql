CREATE SEQUENCE seq_user_id START WITH 10 INCREMENT BY 1;
CREATE SEQUENCE seq_post_id START WITH 10 INCREMENT BY 1;
CREATE SEQUENCE seq_comment_id START WITH 10 INCREMENT BY 1;
DROP SEQUENCE seq_user_id;
DROP SEQUENCE seq_post_id;
DROP SEQUENCE seq_comment_id;
-- Генерация данных для таблицы Users
BEGIN
  FOR i IN 1..100 LOOP -- Генерируем 100 пользователей
    INSERT INTO Users (UserID, Name, Email, RegistrationDate, IsActive)
    VALUES (
      seq_user_id.NEXTVAL,
      'Name_' || TO_CHAR(seq_user_id.CURRVAL),
      'user_' || TO_CHAR(seq_user_id.CURRVAL) || '@example.com',
      TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 3650)),
      DBMS_RANDOM.VALUE(0, 1) -- Генерируем 0 или 1 для IsActive
    );
  END LOOP;
  COMMIT;
END;
/