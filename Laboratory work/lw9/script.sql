CREATE TABLE Users (
    UserID NUMBER PRIMARY KEY,
    Name NVARCHAR2(100),
    Email NVARCHAR2(100),
    RegistrationDate DATE
);

CREATE TABLE Posts (
    PostID NUMBER PRIMARY KEY,
    UserID NUMBER,
    PostText NVARCHAR2(400),
    PublicationDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Friends (
    UserID NUMBER,
    FriendID NUMBER,
    PRIMARY KEY (UserID, FriendID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (FriendID) REFERENCES Users(UserID)
);

CREATE TABLE Likes (
    UserID NUMBER,
    PostID NUMBER,
    PRIMARY KEY (UserID, PostID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PostID) REFERENCES Posts(PostID)
);

CREATE TABLE Comments (
    CommentID NUMBER PRIMARY KEY,
    PostID NUMBER,
    UserID NUMBER,
    CommentText NVARCHAR2(400),
    PublicationDate DATE,
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);






DROP VIEW PostsView;
DROP VIEW UsersView;
DROP table PostsObj;
DROP table UsersObj;
DROP TYPE PostT;
DROP TYPE UserT;


CREATE TYPE UserT AS OBJECT (
    UserID NUMBER,
    Name NVARCHAR2(100),
    Email NVARCHAR2(100),
    RegistrationDate DATE,
    MAP MEMBER FUNCTION getID RETURN NUMBER,
    MEMBER FUNCTION getEmail RETURN NVARCHAR2,
    MEMBER PROCEDURE printUser
);

CREATE TYPE PostT AS OBJECT (
    PostID NUMBER,
    UserID NUMBER,
    PostText NVARCHAR2(400),
    PublicationDate DATE,
    MAP MEMBER FUNCTION getID RETURN NUMBER,
    MEMBER FUNCTION getText RETURN NVARCHAR2,
    MEMBER PROCEDURE printPost
);

-- Реализация методов для типа
CREATE TYPE BODY UserT AS
    MAP MEMBER FUNCTION getID RETURN NUMBER IS
    BEGIN
        RETURN UserID;
    END;

    MEMBER FUNCTION getEmail RETURN NVARCHAR2 IS
    BEGIN
        RETURN Email;
    END;

    MEMBER PROCEDURE printUser IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('UserID: ' || UserID || ', Name: ' || Name || ', Email: ' || Email);
    END;
END;

-- Реализация методов для типа
CREATE TYPE BODY PostT AS
    MAP MEMBER FUNCTION getID RETURN NUMBER IS
    BEGIN
        RETURN PostID;
    END;

    MEMBER FUNCTION getText RETURN NVARCHAR2 IS
    BEGIN
        RETURN PostText;
    END;

    MEMBER PROCEDURE printPost IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('PostID: ' || PostID || ', UserID: ' || UserID || ', Text: ' || PostText);
    END;
END;

-- объектне табл
CREATE TABLE UsersObj OF UserT;
CREATE TABLE PostsObj OF PostT;

-- копирование данных
INSERT INTO UsersObj SELECT * FROM Users;
INSERT INTO PostsObj SELECT * FROM Posts;

select * from  UsersObj;

-- объект представления
CREATE VIEW UsersView AS SELECT VALUE(u) val FROM UsersObj u;

-- объект представления
CREATE VIEW PostsView AS SELECT VALUE(p) val FROM PostsObj p;


SELECT * FROM UsersView;
SELECT * FROM PostsView;

-- индекс для атрибута
CREATE INDEX idx_user_email ON UsersObj (Email);

-- индекс для метода
CREATE INDEX idx_post_text ON PostsObj (PostText) INDEXTYPE IS ctxsys.context;


SELECT * FROM UsersObj where email = 'user_70@example.com';


























drop table SocialNetworkTab;
drop type SocialNetwork;
drop type PostsTab;
drop type UsersTab;

-- t1 социальная сеть
-- t2 пользователи сообщения

-- Создание типа коллекции для пользователей и сообщений
CREATE TYPE UsersTab IS TABLE OF UserT;
CREATE TYPE PostsTab IS TABLE OF PostT;

-- Создание типа объекта с вложенной коллекцией
CREATE TYPE SocialNetwork AS OBJECT (
  Users UsersTab,
  Posts PostsTab
);

-- Создание таблицы для хранения объектов типа SocialNetwork
CREATE TABLE SocialNetworkTab OF SocialNetwork -- вложенные
  NESTED TABLE Users STORE AS UsersNestedTable
  NESTED TABLE Posts STORE AS PostsNestedTable;

-- Вставка данных в таблицу
DECLARE
  users UsersTab := UsersTab(); -- коллекции
  posts PostsTab := PostsTab();
BEGIN
  users.EXTEND;
  users(users.COUNT) := UserT(1, 'Иван', 'ivan@example.com', TO_DATE('2022-01-01', 'YYYY-MM-DD'));
  users.EXTEND;
  users(users.COUNT) := UserT(2, 'Анна', 'anna@example.com', TO_DATE('2022-02-01', 'YYYY-MM-DD'));

  posts.EXTEND;
  posts(posts.COUNT) := PostT(1, 1, 'hello', TO_DATE('2022-01-02', 'YYYY-MM-DD'));
  posts.EXTEND;
  posts(posts.COUNT) := PostT(2, 2, 'world', TO_DATE('2022-02-02', 'YYYY-MM-DD'));

  -- Вставка тестовых данных в таблицу SocialNetworkTab
  INSERT INTO SocialNetworkTab VALUES (SocialNetwork(users, posts));
END;
/


-- Проверка, является ли членом коллекции какой-то произвольный элемент
DECLARE
  user_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO user_exists FROM TABLE(SELECT t.Users FROM SocialNetworkTab t) WHERE UserID = 1;
  IF user_exists > 0 THEN
    DBMS_OUTPUT.PUT_LINE('✅ User with ID 1 exists in the collection.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('❌ User with ID 1 does not exist in the collection.');
  END IF;
END;
/

-- пустые
SELECT * FROM SocialNetworkTab WHERE Users IS EMPTY OR Posts IS EMPTY;

-- преобразование
SELECT * FROM TABLE(SELECT t.Users FROM SocialNetworkTab t);
SELECT * FROM TABLE(SELECT t.Posts FROM SocialNetworkTab t);

-- BULK
DECLARE
  TYPE UsersArray IS TABLE OF UserT;
  users UsersArray;
BEGIN
  SELECT VALUE(u) BULK COLLECT INTO users FROM UsersObj u;
  FORALL i IN users.FIRST..users.LAST
    INSERT INTO UsersObj VALUES users(i);
  COMMIT;
END;
/
