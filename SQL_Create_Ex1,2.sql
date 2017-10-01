CREATE TABLE EMPLOYEE1(
ID int identity(1,1) NOT NULL,
DEPARTMENT_ID int NULL,
CHIEF_ID int NOT NULL,
NAME varchar(100) NULL,
POSITION varchar(50) NULL,
SALARY money NULL,

constraint PK_ID primary key (ID),
constraint FK_CHIEF_ID foreign key (CHIEF_ID) references EMPLOYEE1 (ID),
)

INSERT INTO EMPLOYEE1 VALUES 
(1, 1, 'Bush J.','director',250),
(1, 1, 'Cash M.','deputy director',200),
(1, 2, 'Mickey L.','manager',100),
(1, 2, 'Cash M.','office-manager',70.5),
(1, 2, 'Cash M.','office-manager',70.5),
(2, 2, 'Vicetone S.','engineer',120),
(2, 3, 'Kollin D.','employee',55.5),
(2, 3, 'Irisk K.','employee',60),
(2, 6, 'Molly H.','employee',65),
(3, 6, 'Hurtick G.','cleaner',50);

--ZADANIE 1
declare @i int
set @i=(SELECT DISTINCT MIN(DEPARTMENT_ID) FROM [dbo].[Employee1]);
WHILE @i <= (SELECT DISTINCT MAX(DEPARTMENT_ID) FROM [dbo].[Employee1]) 
	BEGIN 
	SELECT DISTINCT NAME, POSITION
		FROM [dbo].[Employee1]  WHERE dbo.Employee1.DEPARTMENT_ID = @i group by NAME, POSITION
		SET @i=@i+1;
	END

--ZADANIE 2
Declare @tbl table (RowId int identity(1,1), CHIEF_ID int)

DECLARE @CHIEF_ID int, 
     @count int, 
     @iRow int  

Insert @tbl 
  SELECT DISTINCT CHIEF_ID FROM [dbo].[Employee1] 
  SET @count = @@ROWCOUNT 
  SET @iRow = 1 

WHILE @iRow <= @count 
	BEGIN 
		SELECT DISTINCT @CHIEF_ID = CHIEF_ID FROM @tbl WHERE RowId = @iRow 
		declare @sal float
		set @sal=(SELECT AVG(SALARY) FROM [dbo].[Employee1] WHERE CHIEF_ID=@CHIEF_ID AND ID!=CHIEF_ID); 
		SELECT @sal AS 'Average salary of subordinates:'

		SELECT NAME, SALARY FROM [dbo].[Employee1]  WHERE SALARY>(2*@sal) AND ID=@CHIEF_ID
			EXCEPT (SELECT NAME, SALARY FROM [dbo].[Employee1] WHERE ID not in (SELECT CHIEF_ID from [dbo].[Employee1]))
		SET @iRow = @iRow + 1 
	END
