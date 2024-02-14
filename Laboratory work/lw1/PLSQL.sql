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




CREATE SEQUENCE seq_users;
CREATE TRIGGER trg_users
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
  SELECT seq_users.nextval INTO :new.UserID FROM dual;
END;
/

CREATE SEQUENCE seq_posts;
CREATE TRIGGER trg_posts
BEFORE INSERT ON Posts
FOR EACH ROW
BEGIN
  SELECT seq_posts.nextval INTO :new.PostID FROM dual;
END;
/

CREATE SEQUENCE seq_comments;
CREATE TRIGGER trg_comments
BEFORE INSERT ON Comments
FOR EACH ROW
BEGIN
  SELECT seq_comments.nextval INTO :new.CommentID FROM dual;
END;
/







CREATE OR REPLACE PROCEDURE add_user(p_name NVARCHAR2, p_email NVARCHAR2, p_date DATE) AS
BEGIN
  INSERT INTO Users (Name, Email, RegistrationDate) VALUES (p_name, p_email, p_date);
END;
/


CREATE OR REPLACE PROCEDURE add_post(p_userID NUMBER, p_postText NVARCHAR2, p_date DATE) AS
BEGIN
  INSERT INTO Posts (UserID, PostText, PublicationDate) VALUES (p_userID, p_postText, p_date);
END;
/


CREATE OR REPLACE PROCEDURE add_comment(p_postID NUMBER, p_userID NUMBER, p_commentText NVARCHAR2, p_date DATE) AS
BEGIN
  INSERT INTO Comments (PostID, UserID, CommentText, PublicationDate) VALUES (p_postID, p_userID, p_commentText, p_date);
END;
/


