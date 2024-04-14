

delete from comments;
delete from Likes;
delete from Friends;
delete from Posts;
delete from UserActivity;
delete from Users;
delete from ContentTypes;

drop table comments;
drop table Likes;
drop table Friends;
drop table Posts;
drop table UserActivity;
drop table Users;
drop table ContentTypes;

select * from comments;
select * from Likes;
select * from Friends;
select * from Posts;
select * from UserActivity;
select * from Users;
select * from ContentTypes;





BEGIN
  -- Заполнение таблицы Users
  FOR i IN 1..300 LOOP
    INSERT INTO Users (UserID, Name, Email, RegistrationDate)
    VALUES (i, 'User_' || TO_CHAR(i), 'user_' || TO_CHAR(i) || '@example.com', TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 365)));
  END LOOP;

  COMMIT; -- Добавляем COMMIT для сохранения изменений после заполнения каждой таблицы
end;


BEGIN
  -- Заполнение таблицы Friends
  FOR i IN 1..300 LOOP
    -- Генерация случайных UserID и FriendID
    DECLARE
      v_UserID NUMBER;
      v_FriendID NUMBER;
    BEGIN
      v_UserID := TRUNC(DBMS_RANDOM.VALUE(1, 300));
      -- Повторять попытку, пока не будет найдено уникальное сочетание UserID и FriendID
      LOOP
        v_FriendID := TRUNC(DBMS_RANDOM.VALUE(1, 300));
        EXIT WHEN v_UserID != v_FriendID; -- Исключаем случай, когда пользователь является другом самому себе
      END LOOP;

      INSERT INTO Friends (UserID, FriendID)
      VALUES (v_UserID, v_FriendID);
    END;
  END LOOP;

  COMMIT;
END;
/
BEGIN
  -- Заполнение таблицы Posts
  FOR i IN 1..300 LOOP
    INSERT INTO Posts (PostID, UserID, PostText, PublicationDate)
    VALUES (i, TRUNC(DBMS_RANDOM.VALUE(1, 300)), 'This is a post by user ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 300))), TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 365)));
  END LOOP;

  COMMIT;
END;
/

BEGIN
  -- Заполнение таблицы Likes
  FOR i IN 1..300 LOOP
    INSERT INTO Likes (UserID, PostID)
    VALUES (TRUNC(DBMS_RANDOM.VALUE(1, 300)), TRUNC(DBMS_RANDOM.VALUE(1, 300)));
  END LOOP;

  COMMIT;
END;
/

BEGIN
  -- Заполнение таблицы Comments
  FOR i IN 1..300 LOOP
    INSERT INTO Comments (CommentID, PostID, UserID, CommentText, PublicationDate)
    VALUES (i, TRUNC(DBMS_RANDOM.VALUE(1, 300)), TRUNC(DBMS_RANDOM.VALUE(1, 300)), 'This is a comment by user ' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 300))), TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 365)));
  END LOOP;

  COMMIT;
END;
/

BEGIN
  -- Заполнение таблицы UserActivity
  FOR i IN 1..1000 LOOP
    INSERT INTO UserActivity (ActivityID, UserID, ActivityDate, ActivityType)
    VALUES (i, TRUNC(DBMS_RANDOM.VALUE(1, 300)), TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 365)), 'ActivityType_' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 5))));
  END LOOP;

  COMMIT;
END;
/

BEGIN
  -- Заполнение таблицы ContentTypes
  INSERT INTO ContentTypes (ContentTypeID, ContentName) VALUES (1, 'Blog Post');
  INSERT INTO ContentTypes (ContentTypeID, ContentName) VALUES (2, 'Photo');
  INSERT INTO ContentTypes (ContentTypeID, ContentName) VALUES (3, 'Video');
  INSERT INTO ContentTypes (ContentTypeID, ContentName) VALUES (4, 'Comment');
  INSERT INTO ContentTypes (ContentTypeID, ContentName) VALUES (5, 'Like');
  -- Добавьте больше типов контента по аналогии, если необходимо

  COMMIT;
END;
/

BEGIN
  -- Заполнение таблицы UserActivity
  FOR i IN 4..1000 LOOP -- Генерируем 1000 записей активности
    INSERT INTO UserActivity (ActivityID, UserID, ActivityDate, ActivityType)
    VALUES (i, TRUNC(DBMS_RANDOM.VALUE(1, 300)), TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 365)), 'ActivityType_' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 5))));
  END LOOP;

  COMMIT;
END;
/
