CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    RegistrationDate DATETIME
);

CREATE TABLE Posts (
    PostID INT PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PostText NVARCHAR(MAX),
    PublicationDate DATETIME
);

CREATE TABLE Friends (
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    FriendID INT FOREIGN KEY REFERENCES Users(UserID),
    PRIMARY KEY (UserID, FriendID)
);

CREATE TABLE Likes (
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PostID INT FOREIGN KEY REFERENCES Posts(PostID),
    PRIMARY KEY (UserID, PostID)
);

CREATE TABLE Comments (
    CommentID INT PRIMARY KEY,
    PostID INT FOREIGN KEY REFERENCES Posts(PostID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CommentText NVARCHAR(MAX),
    PublicationDate DATETIME
);



CREATE SEQUENCE seq_users AS INT START WITH 1 INCREMENT BY 1;
GO
CREATE TRIGGER trg_users
ON Users
AFTER INSERT
AS
BEGIN
  UPDATE Users
  SET UserID = NEXT VALUE FOR seq_users
  FROM inserted
  WHERE Users.UserID = inserted.UserID;
END;
GO

CREATE SEQUENCE seq_posts AS INT START WITH 1 INCREMENT BY 1;
GO
CREATE TRIGGER trg_posts
ON Posts
AFTER INSERT
AS
BEGIN
  UPDATE Posts
  SET PostID = NEXT VALUE FOR seq_posts
  FROM inserted
  WHERE Posts.PostID = inserted.PostID;
END;
GO

CREATE SEQUENCE seq_comments AS INT START WITH 1 INCREMENT BY 1;
GO
CREATE TRIGGER trg_comments
ON Comments
AFTER INSERT
AS
BEGIN
  UPDATE Comments
  SET CommentID = NEXT VALUE FOR seq_comments
  FROM inserted
  WHERE Comments.CommentID = inserted.CommentID;
END;
GO





CREATE PROCEDURE add_user @p_name NVARCHAR(100), @p_email NVARCHAR(100), @p_date DATETIME
AS
BEGIN
  INSERT INTO Users (Name, Email, RegistrationDate) VALUES (@p_name, @p_email, @p_date);
END;
GO


CREATE PROCEDURE add_post @p_userID INT, @p_postText NVARCHAR(MAX), @p_date DATETIME
AS
BEGIN
  INSERT INTO Posts (UserID, PostText, PublicationDate) VALUES (@p_userID, @p_postText, @p_date);
END;
GO


CREATE PROCEDURE add_comment @p_postID INT, @p_userID INT, @p_commentText NVARCHAR(MAX), @p_date DATETIME
AS
BEGIN
  INSERT INTO Comments (PostID, UserID, CommentText, PublicationDate) VALUES (@p_postID, @p_userID, @p_commentText, @p_date);
END;
GO


