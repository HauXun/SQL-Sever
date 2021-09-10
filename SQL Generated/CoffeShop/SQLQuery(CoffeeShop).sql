USE master
GO

CREATE DATABASE CoffeeShop
GO

USE CoffeeShop
GO

-- Food
-- Table
-- FoodCategory
-- Account
-- Bill
-- BillInfo

CREATE TABLE TableFood
(
	ID INT PRIMARY KEY IDENTITY,
	NAME NVARCHAR(100) NOT NULL DEFAULT N'Unknown',
	STATUS NVARCHAR(100) NOT NULL DEFAULT N'Trống'	-- Trống || Có người
)
GO

CREATE TABLE Account
(
	UserName NVARCHAR(100) PRIMARY KEY,
	DisplayName NVARCHAR(100) NOT NULL DEFAULT N'Unknown',
	PassWord NVARCHAR(1000) NOT NULL,
	Type INT NOT NULL DEFAULT 0		-- 0: Staff || 1: Admin
)
GO

CREATE TABLE FoodCategory
(
	ID INT PRIMARY KEY IDENTITY,
	NAME NVARCHAR(100) NOT NULL DEFAULT N'Unknown'
)
GO

CREATE TABLE Food
(
	ID INT PRIMARY KEY IDENTITY,
	NAME NVARCHAR(100) NOT NULL DEFAULT N'Unknown',
	IDCategory INT NOT NULL,
	Price FLOAT NOT NULL DEFAULT 0

	FOREIGN KEY (IDCategory) REFERENCES dbo.FoodCategory (ID)
)
GO

CREATE TABLE Bill
(
	ID INT PRIMARY KEY IDENTITY,
	DateCheckIn DATE,
	DateCheckOut DATE,
	IDTable INT NOT NULL,
	Status INT NOT NULL	DEFAULT 0	-- 0: Chưa TT || 1: Đã TT
	
	FOREIGN KEY (IDTable) REFERENCES dbo.TableFood (ID)
)
GO

CREATE TABLE BillInfo
(
	ID INT PRIMARY KEY IDENTITY,
	IDBill INT NOT NULL,
	IDFood INT NOT NULL,
	Count INT NOT NULL DEFAULT 0
	
	FOREIGN KEY (IDBill) REFERENCES dbo.Bill (ID),
	FOREIGN KEY (IDFood) REFERENCES dbo.Food (ID)
)
GO

INSERT INTO dbo.Account
(
    UserName,
    DisplayName,
    PassWord,
    Type
)
VALUES
(   N'Admin', -- UserName - nvarchar(100)
    N'Admin', -- DisplayName - nvarchar(100)
    N'Admin', -- PassWord - nvarchar(1000)
    1    -- Type - int
)
GO

INSERT INTO dbo.Account
(
    UserName,
    DisplayName,
    PassWord,
    Type
)
VALUES
(   N'Trời trên', -- UserName - nvarchar(100)
    N'Trời ở trên', -- DisplayName - nvarchar(100)
    N'123123', -- PassWord - nvarchar(1000)
    0    -- Type - int
)
GO

CREATE PROC USE_GetAccountByUsername
@userName NVARCHAR(100)
AS
BEGIN
    SELECT * FROM dbo.Account
	WHERE UserName = @userName
END
GO

EXEC dbo.USE_GetAccountByUsername @userName = N'Trời trên' -- nvarchar(100)
GO

CREATE PROC USE_Login
@userName NVARCHAR(100), @passWord NVARCHAR(100)
AS
BEGIN
    SELECT * FROM dbo.Account
	WHERE UserName = @userName
	AND PassWord = @passWord
END
GO
TRUNCATE TABLE dbo.TableFood

-- Thêm bàn
DECLARE @i INT = 1

WHILE @i <= 10
BEGIN
    INSERT dbo.TableFood
    (
        NAME
    )
    VALUES
    (   N'Bàn ' + CAST(@i AS NVARCHAR)
    )
	SET @i += 1
END
GO

CREATE PROC USP_GetTableList
AS SELECT * FROM dbo.TableFood
GO

EXEC dbo.USP_GetTableList

-- Thêm category
INSERT INTO dbo.FoodCategory
( NAME ) VALUES (N'Lâm sản')

INSERT INTO dbo.FoodCategory
( NAME ) VALUES (N'Hải sản')

INSERT INTO dbo.FoodCategory
( NAME ) VALUES (N'Đặc sản')

INSERT INTO dbo.FoodCategory
( NAME ) VALUES (N'Đồ chay')

INSERT INTO dbo.FoodCategory
( NAME ) VALUES (N'Đồ uống')

-- Thêm món ăn

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Bò lúc lắc lúc không',
	6,
	100000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Heo rừng không lối thoát',
	6,
	99000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Mực nhiều nắng không nướng gì hết',
	7,
	120000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Cá lóc ôm chuối ôm cây chụ điện',
	7,
	130000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Cá mương nướng không có lửa',
	8,
	70000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Cá mương chiên không có dầu',
	8,
	85000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Cơm chiên trứng nhưng không có trứng',
	9,
	15000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Ngủ quả nhưng chỉ có 4 quả :(',
	9,
	35000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Bia không cồn nhưng có 90acl',
	10,
	24000
)

INSERT dbo.Food
( NAME,  IDCategory, Price )
VALUES
(   N'Trà xanh nhiều độ*',
	10,
	12000
)

-- Thêm bill
INSERT dbo.Bill
(
    DateCheckIn,
    DateCheckOut,
    IDTable,
    Status
)
VALUES
(   GETDATE(), -- DateCheckIn - date
    NULL, -- DateCheckOut - date
    24,         -- IDTable - int
    0          -- Status - int
)

INSERT dbo.Bill
(
    DateCheckIn,
    DateCheckOut,
    IDTable,
    Status
)
VALUES
(   GETDATE(), -- DateCheckIn - date
    NULL, -- DateCheckOut - date
    24,         -- IDTable - int
    0          -- Status - int
)

INSERT dbo.Bill
(
    DateCheckIn,
    DateCheckOut,
    IDTable,
    Status
)
VALUES
(   GETDATE(), -- DateCheckIn - date
    GETDATE(), -- DateCheckOut - date
    25,         -- IDTable - int
    1          -- Status - int
)

-- Thêm billInfo
INSERT dbo.BillInfo
(
    IDBill,
    IDFood,
    Count
)
VALUES
(   10, -- IDBill - int
    21, -- IDFood - int
    2  -- Count - int
)

INSERT dbo.BillInfo
(
    IDBill,
    IDFood,
    Count
)
VALUES
(   12, -- IDBill - int
    21, -- IDFood - int
    4  -- Count - int
)

INSERT dbo.BillInfo
(
    IDBill,
    IDFood,
    Count
)
VALUES
(   11, -- IDBill - int
    25, -- IDFood - int
    1  -- Count - int
)

INSERT dbo.BillInfo
(
    IDBill,
    IDFood,
    Count
)
VALUES
(   12, -- IDBill - int
    21, -- IDFood - int
    2  -- Count - int
)

INSERT dbo.BillInfo
(
    IDBill,
    IDFood,
    Count
)
VALUES
(   11, -- IDBill - int
    26, -- IDFood - int
    2  -- Count - int
)

INSERT dbo.BillInfo
(
    IDBill,
    IDFood,
    Count
)
VALUES
(   10, -- IDBill - int
    28, -- IDFood - int
    2  -- Count - int
)
GO

CREATE PROC USP_InsertBill
@idTable INT
AS
BEGIN
    INSERT dbo.Bill
    (
        DateCheckIn,
        DateCheckOut,
        IDTable,
        Status,
		Discount
    )
    VALUES
    (   GETDATE(), -- DateCheckIn - date
        NULL, -- DateCheckOut - date
        @idTable,         -- IDTable - int
        0,          -- Status - int
		0
    )
END
GO

CREATE PROC USP_InsertBillInfo
@idBill INT, @idFood INT, @count INT
AS
BEGIN
	DECLARE @isExistBillInfo INT
	DECLARE @foodCount INT = 1

	SELECT @isExistBillInfo = ID, @foodCount = Count FROM dbo.BillInfo
	WHERE IDBill = @idBill AND IDFood = @idFood

	IF (@isExistBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF (@newCount > 0)
			UPDATE dbo.BillInfo SET Count = @foodCount + @count
			WHERE IDFood = @idFood
		ELSE
			DELETE dbo.BillInfo 
			WHERE IDBill = @idBill AND IDFood = @idFood
	END
	ELSE
	BEGIN
	    INSERT dbo.BillInfo
		(
        IDBill,
        IDFood,
        Count
		)
    VALUES
		(   
		@idBill, -- IDBill - int
        @idFood, -- IDFood - int
        @count  -- Count - int
		)
	END
END
GO

CREATE TRIGGER UTG_UpdateBillInfo
ON dbo.BillInfo FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @idBill INT
	SELECT @idBill = Inserted.IDBill FROM Inserted

	DECLARE @idTable INT
	SELECT @idTable = IDTable FROM dbo.Bill
	WHERE ID = @idBill AND Status = 0

	UPDATE dbo.TableFood SET STATUS = N'Có người'
	WHERE ID = @idTable
END
GO

CREATE TRIGGER UTG_UpdateBill
ON dbo.Bill FOR UPDATE
AS
BEGIN
    DECLARE @idBill INT
	SELECT @idBill = Inserted.ID FROM Inserted

	DECLARE @idTable INT
	SELECT @idTable = IDTable FROM dbo.Bill
	WHERE ID = @idBill

	DECLARE @count INT = 0
	SELECT @count = COUNT(*) FROM dbo.Bill
	WHERE IDTable = @idTable AND Status = 0

	IF (@count = 0)
	UPDATE dbo.TableFood SET STATUS = N'Trống'
	WHERE ID = @idTable 
END
GO

CREATE PROC USP_SwitchTable
@idTable1 INT, @idTable2 INT
AS
BEGIN
    DECLARE @idFirstBill INT
	DECLARE @idSecondBill INT

	DECLARE @isFirstTableEmpty INT = 1
	DECLARE @isSecondTableEmpty INT = 1

	SELECT @idFirstBill = ID FROM dbo.Bill
	WHERE IDTable = @idTable1 AND Status = 0

	SELECT @idSecondBill = ID FROM dbo.Bill
	WHERE IDTable = @idTable2 AND Status = 0

	IF (@idFirstBill IS NULL)
	BEGIN
	    INSERT INTO dbo.Bill
	    (
	        DateCheckIn,
	        DateCheckOut,
	        IDTable,
	        Status
	    )
	    VALUES
	    (   GETDATE(), -- DateCheckIn - date
	        GETDATE(), -- DateCheckOut - date
	        @idTable1,         -- IDTable - int
	        0          -- Status - int
	    )
		SELECT @idFirstBill = MAX(ID) FROM dbo.Bill
		WHERE IDTable = @idTable1 AND Status = 0
	END

	SELECT @isFirstTableEmpty = COUNT(*) FROM dbo.BillInfo
	WHERE IDBill = @idFirstBill

	IF (@idSecondBill IS NULL)
	BEGIN
	    INSERT INTO dbo.Bill
	    (
	        DateCheckIn,
	        DateCheckOut,
	        IDTable,
	        Status
	    )
	    VALUES
	    (   GETDATE(), -- DateCheckIn - date
	        GETDATE(), -- DateCheckOut - date
	        @idTable2,         -- IDTable - int
	        0          -- Status - int
	    )
		SELECT @idSecondBill = MAX(ID) FROM dbo.Bill
		WHERE IDTable = @idTable2 AND Status = 0
	END

	SELECT @isSecondTableEmpty = COUNT(*) FROM dbo.BillInfo
	WHERE IDBill = @idSecondBill

	SELECT ID INTO IDBillInfoTable FROM dbo.BillInfo
	WHERE IDBill = @idSecondBill

	UPDATE dbo.BillInfo SET IDBill = @idSecondBill
	WHERE IDBill = @idFirstBill

	UPDATE dbo.BillInfo SET IDBill = @idFirstBill
	WHERE ID IN (SELECT * FROM dbo.IDBillInfoTable)

	DROP TABLE dbo.IDBillInfoTable

	IF (@isFirstTableEmpty = 0)
		UPDATE dbo.TableFood SET STATUS = N'Trống' WHERE ID = @idTable2

	IF (@isSecondTableEmpty = 0)
		UPDATE dbo.TableFood SET STATUS = N'Trống' WHERE ID = @idTable1
END
GO

CREATE PROC USP_GetListBillByDate
@dateCheckIn DATE, @dateCheckOut DATE
AS
BEGIN
    SELECT T.NAME, B.TotalPrice, B.DateCheckIn, B.DateCheckOut, Discount FROM dbo.Bill AS B, dbo.TableFood AS T
	WHERE B.DateCheckIn >= @dateCheckIn AND B.DateCheckOut <= @dateCheckOut
	AND B.Status = 1 AND T.ID = B.IDTable
END
GO

CREATE PROC USP_GetListBillByDateAndPage
@dateCheckIn DATE, @dateCheckOut DATE, @page INT
AS
BEGIN
	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT = @pageRows
	DECLARE @exceptRows	INT = (@page - 1) * @pageRows

    ;WITH BillShow AS ( SELECT B.ID, T.NAME, B.TotalPrice, B.DateCheckIn, B.DateCheckOut, Discount FROM dbo.Bill AS B, dbo.TableFood AS T
	WHERE B.DateCheckIn >= @dateCheckIn AND B.DateCheckOut <= @dateCheckOut
	AND B.Status = 1 AND T.ID = B.IDTable )

	SELECT TOP (@selectRows) * FROM BillShow
	WHERE ID NOT IN ( SELECT TOP (@exceptRows) ID FROM BillShow )
END
GO

CREATE PROC USP_UpdateAccount
@username NVARCHAR(100), @displayname NVARCHAR(100), @password NVARCHAR(100), @newpassword NVARCHAR(100)
AS
BEGIN
    DECLARE @isRightPass INT = 0
	SELECT @isRightPass = COUNT(*) FROM dbo.Account
	WHERE UserName = @username AND PassWord = @password

	IF (@isRightPass = 1)
	BEGIN
	    IF (@newpassword IS NULL OR @newpassword = '')
		BEGIN
		    UPDATE dbo.Account SET DisplayName = @displayname
			WHERE UserName = @username
		END
		ELSE
		BEGIN
		    UPDATE dbo.Account SET DisplayName = @displayname, PassWord = @newpassword
			WHERE UserName = @username
		END
	END
END
GO

CREATE TRIGGER UTG_DeleteBillInfo
ON dbo.BillInfo FOR DELETE
AS
BEGIN
	DECLARE @idBillInfo INT
	DECLARE @idBill INT
	SELECT @idBillInfo = ID, @idBill = Deleted.IDBill FROM Deleted

	DECLARE @idTable INT
	SELECT @idTable = IDTable FROM dbo.Bill
	WHERE ID = @idBill

	DECLARE @count INT = 0
	SELECT @count = COUNT(*) FROM dbo.BillInfo AS BIF, dbo.Bill AS B
	WHERE B.ID = BIF.IDBill AND B.ID = @idBill AND B.Status = 0

	IF (@count = 0)
		UPDATE dbo.TableFood SET STATUS = N'Trống'
		WHERE ID = @idTable
END
GO

CREATE FUNCTION [dbo].[fuConvertToUnsign] 
( @strInput NVARCHAR(4000) ) 
RETURNS
NVARCHAR(4000) 
AS
BEGIN 
	IF (@strInput IS NULL)
	RETURN @strInput 
	
	IF (@strInput = '')
	RETURN @strInput 
	
	DECLARE @RT NVARCHAR(4000)
	DECLARE @SIGN_CHARS NCHAR(136) 
	DECLARE @UNSIGN_CHARS NCHAR (136) 
	
	SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272) + NCHAR(208)
	SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'

	DECLARE @COUNTER INT 
	DECLARE @COUNTER1 INT

	SET @COUNTER = 1 
	WHILE (@COUNTER <= LEN(@strInput)) 
	BEGIN 
		SET @COUNTER1 = 1 
		WHILE (@COUNTER1 <= LEN(@SIGN_CHARS) + 1) 
		BEGIN 
			IF (UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1, 1)) = UNICODE(SUBSTRING(@strInput, @COUNTER, 1) )) 
			BEGIN 
				IF (@COUNTER = 1)
					SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1, 1) + SUBSTRING(@strInput, @COUNTER + 1, LEN(@strInput) - 1) 
				ELSE 
					SET @strInput = SUBSTRING(@strInput, 1, @COUNTER - 1) + SUBSTRING(@UNSIGN_CHARS, @COUNTER1, 1) + SUBSTRING(@strInput, @COUNTER + 1, LEN(@strInput) - @COUNTER)
					BREAK
			END 
			SET @COUNTER1 += 1 
		END 
		SET @COUNTER += 1 
	END
	SET @strInput = REPLACE(@strInput, ' ', '-') 
	RETURN @strInput 
END
GO

