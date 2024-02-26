
/*

ПИРБДИП 3

1. **Как осуществляется хранение иерархических данных?**
   Хранение иерархических данных в реляционных структурах является довольно нетривиальной задачей¹. Один из подходов - использование иерархического типа данных, который оптимизирован для представления деревьев¹⁵. Также существует технология Hierarchical Storage Management (HSM), которая позволяет автоматически распределять данные между быстрыми (дорогими) и медленными (дешёвыми) накопителями⁴.

2. **Какие типичные задачи решаются при хранении иерархических данных?**
   Иерархические структуры данных используются для решения различных задач, включая классификацию и рубрикацию информации²². Кроме того, они позволяют управлять иерархическими структурами данных¹⁴.

3. **Для чего предназначен иерархический тип данных?**
   Иерархический тип данных предназначен для упрощения хранения и запроса иерархических данных¹⁵. Он оптимизирован для представления древовидных структур, которые являются наиболее распространенным типом иерархических данных¹⁵.

4. **Перечислите известные вам свойства и методы иерархического типа данных.**
  В Oracle и SQL Server используются различные подходы к работе с иерархическими данными.

    **Oracle**:
    - Oracle поддерживает иерархические запросы².
    - Однако, конкретные свойства и методы иерархического типа данных в Oracle не были найдены в доступных источниках¹³.

    **SQL Server**:
    - SQL Server предлагает встроенный тип данных `hierarchyid` для упрощения хранения и запроса иерархических данных⁵.
    - `hierarchyid` оптимизирован для представления деревьев, которые являются наиболее распространенным типом иерархических данных⁵.
    - Используйте функции `hierarchyid` в Transact-SQL для запроса иерархических данных и управления ими⁵.
    - Основные свойства типа `hierarchyid`⁵:
        - Исключительная компактность.
        - Сравнение проводится в порядке приоритета глубины.
        - Поддержка произвольных вставок и удалений.
    - Примеры иерархических данных, которые обычно хранятся в базах данных, включают следующее⁵:
        - Организационная структура.
        - Файловая система.
        - Группа задач в проекте.
        - Классификация языковых терминов.
        - Диаграмма связей между веб-страницами.


5. **Поясните секции иерархических запросов в Oracle.**
   Иерархические запросы в Oracle обычно состоят из следующих секций:

    1. **START WITH**: Эта секция определяет корневой узел (или узлы) иерархии¹³.
    2. **CONNECT BY**: Эта секция определяет отношение между родительскими и дочерними строками иерархии¹³.
    3. **PRIOR**: Это унарный оператор, который оценивает непосредственно следующее выражение для родительской строки текущей строки в иерархическом запросе¹.
    4. **NOCYCLE**: Этот параметр указывает Oracle Database возвращать строки из запроса, даже если в данных существует цикл `CONNECT BY`¹.
    5. **CONNECT_BY_ROOT**: Этот оператор возвращает корневые узлы, связанные с текущей строкой².
    6. **CONNECT_BY_ISLEAF**: Эта псевдоколонка указывает, является ли текущая строка листовым узлом².
    7. **LEVEL**: Эта псевдоколонка возвращает позицию в иерархии текущей строки относительно корневого узла².

    Oracle обрабатывает иерархические запросы следующим образом³:
    - Сначала выполняется соединение, если оно присутствует, независимо от того, указано ли соединение в секции `FROM` или с помощью предикатов секции `WHERE`.
    - Затем оценивается условие `CONNECT BY`.
    - Наконец, оцениваются оставшиеся предикаты секции `WHERE`.

6. **Перечислите известные вам псевдофункции иерархических запросов в Oracle.**
    В Oracle для иерархических запросов используются следующие псевдоколонки:
    1. **CONNECT_BY_ISCYCLE**: Эта псевдоколонка возвращает 1, если текущая строка имеет потомка, который также является ее предком. В противном случае возвращает 0¹³.
    2. **CONNECT_BY_ISLEAF**: Эта псевдоколонка возвращает 1, если текущая строка является листом дерева, определенного условием `CONNECT BY`. В противном случае возвращает 0¹³.
    3. **LEVEL**: Для каждой строки, возвращаемой иерархическим запросом, псевдоколонка `LEVEL` возвращает 1 для корневой строки, 2 для потомка корня и так далее¹³.
    Эти псевдоколонки действительны только в иерархических запросах. Для определения иерархической связи в запросе вы должны использовать условие `CONNECT BY`¹.

*/


-- START

DROP PROCEDURE dbo.MoveSubNodes
DROP PROCEDURE dbo.AddSubNode
DROP PROCEDURE dbo.GetSubNodes
DROP TABLE Comments;
DROP TABLE Likes;
DROP TABLE Friends;
DROP TABLE Posts;
DROP TABLE Users;


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

 
-- № 1
ALTER TABLE Users ADD HierarchyID hierarchyid;

INSERT INTO Users (UserID, Name, Email, RegistrationDate, HierarchyID)
VALUES (1, N'John Doe', N'johndoe@example.com', GETDATE(), hierarchyid::Parse('/1/')),
       (2, N'Jane Doe', N'janedoe@example.com', GETDATE(), hierarchyid::Parse('/1/1/')),
       (3, N'Richard Roe', N'richardroe@example.com', GETDATE(), hierarchyid::Parse('/1/2/')),
	   (4, N'new', N'jadfsfnedoe@example.com', GETDATE(), hierarchyid::Parse('/2/')),
	   (5, N'new2', N'jadfasdsfnedoe@example.com', GETDATE(), hierarchyid::Parse('/2/1/')),
	   (6, N'new3', N'jadfsfnasdaedoe@example.com', GETDATE(), hierarchyid::Parse('/2/2/'));

INSERT INTO Posts (PostID, UserID, PostText, PublicationDate)
VALUES (1, 1, N'This is a post by John Doe', GETDATE()),
       (2, 2, N'This is a post by Jane Doe', GETDATE()),
       (3, 3, N'This is a post by Richard Roe', GETDATE());
	    
INSERT INTO Friends (UserID, FriendID)
VALUES (1, 2), (1, 3), (2, 3);
 
INSERT INTO Likes (UserID, PostID)
VALUES (1, 2), (2, 3), (3, 1);
 
INSERT INTO Comments (CommentID, PostID, UserID, CommentText, PublicationDate)
VALUES (1, 1, 2, N'Jane commented on John\', GETDATE()),
       (2, 2, 3, N'Richard commented on Jane\', GETDATE()),
       (3, 3, 1, N'John commented on Richard\', GETDATE());


SELECT * FROM USErs;




-- № 2
CREATE PROCEDURE dbo.GetSubNodes
    @Node hierarchyid
AS
BEGIN
    ;WITH Hierarchy AS (
        SELECT UserID, Name, HierarchyID, HierarchyID.GetLevel() AS Level FROM Users
			WHERE HierarchyID = @Node
			UNION ALL
			SELECT U.UserID, U.Name, U.HierarchyID, U.HierarchyID.GetLevel() AS Level
			FROM Users U
			INNER JOIN Hierarchy H ON U.HierarchyID.GetAncestor(1) = H.HierarchyID
    )
    SELECT UserID, Name, HierarchyID.ToString() AS Hierarchy, Level
    FROM Hierarchy
    ORDER BY Level, UserID;
END;


EXEC dbo.GetSubNodes '/2/';



-- № 3
CREATE PROCEDURE dbo.AddSubNode
    @ParentNode hierarchyid,
    @UserID INT,
    @Name NVARCHAR(100),
    @Email NVARCHAR(100)
AS
BEGIN
    DECLARE @ChildNode hierarchyid;

    -- Находим максимальный дочерний узел для данного родительского узла
    SELECT @ChildNode = MAX(HierarchyID)
    FROM Users
    WHERE HierarchyID.GetAncestor(1) = @ParentNode;

    -- Если дочерних узлов нет, создаем первый дочерний узел
    IF @ChildNode IS NULL
        SET @ChildNode = @ParentNode.GetDescendant(NULL, NULL);
    -- В противном случае создаем следующий дочерний узел
    ELSE
        SET @ChildNode = @ParentNode.GetDescendant(@ChildNode, NULL);

    -- Добавляем нового пользователя с указанным дочерним узлом
    INSERT INTO Users (UserID, Name, Email, RegistrationDate, HierarchyID)
    VALUES (@UserID, @Name, @Email, GETDATE(), @ChildNode);
END;



EXEC dbo.AddSubNode '/2/', 5, N'New User', N'newuser@example.com';

EXEC dbo.GetSubNodes '/2/';



-- № 4
CREATE PROCEDURE dbo.MoveSubNodes
    @OldParentNode hierarchyid,
    @NewParentNode hierarchyid
AS
BEGIN
    DECLARE @MaxChild hierarchyid;

    -- Находим максимальный дочерний узел для нового родительского узла
    SELECT @MaxChild = MAX(HierarchyID)
    FROM Users
    WHERE HierarchyID.GetAncestor(1) = @NewParentNode;

    -- Если дочерних узлов нет, создаем первый дочерний узел
    IF @MaxChild IS NULL
        SET @MaxChild = @NewParentNode.GetDescendant(NULL, NULL);
    -- В противном случае создаем следующий дочерний узел
    ELSE
        SET @MaxChild = @NewParentNode.GetDescendant(@MaxChild, NULL);

    -- Перемещаем всех подчиненных от старого родительского узла к новому
    UPDATE Users
    SET HierarchyID = HierarchyID.GetReparentedValue(@OldParentNode, @MaxChild)
    WHERE HierarchyID.IsDescendantOf(@OldParentNode) = 1;
END;


EXEC dbo.MoveSubNodes '/1/', '/2/';
 

SELECT * FROM USERS;   