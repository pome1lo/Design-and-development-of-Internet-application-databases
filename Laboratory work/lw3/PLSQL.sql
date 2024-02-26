DROP TABLE COMMENTS;
DROP TABLE LIKES;
DROP TABLE FRIENDS;
DROP TABLE POSTS;
DROP TABLE USERS;

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



-- № 1
ALTER TABLE Users ADD ParentID NUMBER REFERENCES Users(UserID);


INSERT INTO Users (UserID, Name, Email, RegistrationDate, ParentID) VALUES (1, 'John Doe', 'johndoe@example.com', SYSDATE, NULL);
INSERT INTO Users (UserID, Name, Email, RegistrationDate, ParentID) VALUES (2, 'Jane Doe', 'janedoe@example.com', SYSDATE, 1);
INSERT INTO Users (UserID, Name, Email, RegistrationDate, ParentID) VALUES (3, 'Richard Roe', 'richardroe@example.com', SYSDATE, 1);

INSERT INTO Posts (PostID, UserID, PostText, PublicationDate) VALUES (1, 1, 'This is a post by John Doe', SYSDATE);
INSERT INTO Posts (PostID, UserID, PostText, PublicationDate) VALUES (2, 2, 'This is a post by Jane Doe', SYSDATE);
INSERT INTO Posts (PostID, UserID, PostText, PublicationDate) VALUES (3, 3, 'This is a post by Richard Roe', SYSDATE);

INSERT INTO Friends (UserID, FriendID) VALUES (1, 2);
INSERT INTO Friends (UserID, FriendID) VALUES (1, 3);
INSERT INTO Friends (UserID, FriendID) VALUES (2, 3);

INSERT INTO Likes (UserID, PostID) VALUES (1, 2);
INSERT INTO Likes (UserID, PostID) VALUES (2, 3);
INSERT INTO Likes (UserID, PostID) VALUES (3, 1);

INSERT INTO Comments (CommentID, PostID, UserID, CommentText, PublicationDate) VALUES (1, 1, 2, 'Jane commented on John''s post', SYSDATE);
INSERT INTO Comments (CommentID, PostID, UserID, CommentText, PublicationDate) VALUES (2, 2, 3, 'Richard commented on Jane''s post', SYSDATE);
INSERT INTO Comments (CommentID, PostID, UserID, CommentText, PublicationDate) VALUES (3, 3, 1, 'John commented on Richard''s post', SYSDATE);


-- № 2
CREATE OR REPLACE PROCEDURE GetSubNodes(p_parent_id IN NUMBER) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('UserID' || ' - ' || 'Name' || ' - ' || 'Level');

    FOR rec IN (
        SELECT UserID, Name, LEVEL
        FROM Users
        START WITH UserID = p_parent_id
        CONNECT BY PRIOR UserID = ParentID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.UserID || ' - ' || rec.Name || ' - ' || rec.Level);
    END LOOP;
END;
/

BEGIN ADMIN_USER.GetSubNodes(1); END;


-- № 3
CREATE OR REPLACE PROCEDURE AddSubNode(p_parent_id IN NUMBER, p_user_id IN NUMBER, p_name IN NVARCHAR2, p_email IN NVARCHAR2) IS
BEGIN
    INSERT INTO Users (UserID, Name, Email, RegistrationDate, ParentID)
    VALUES (p_user_id, p_name, p_email, SYSDATE, p_parent_id);
END;
/

BEGIN AddSubNode(1, 4, 'New User', 'newuser@example.com'); END;

SELECT * FROM USERS;


-- № 4
CREATE OR REPLACE PROCEDURE MoveSubNodes(p_old_parent_id IN NUMBER, p_new_parent_id IN NUMBER) IS
BEGIN
    UPDATE Users
    SET ParentID = p_new_parent_id
    WHERE ParentID = p_old_parent_id;
END;
/

BEGIN MoveSubNodes(1, 2); END;

SELECT * FROM USERS;