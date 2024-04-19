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
