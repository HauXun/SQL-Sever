-- Unique: là duy nhất trong toàn bộ bảng.
-- Trường nào có từ khóa Unique thì không thể có 2 giá trị trùng nhau
-- Not Null: Trường đó không được phép null
-- Default: Giá trị mặc định của trường đó nếu không gán giá trị khi insert

CREATE TABLE PrimaryKey
(
	ID INT UNIQUE NOT NULL,
	Name NVARCHAR(100) DEFAULT N'Có súng đây nè!'
)
GO

INSERT dbo.PrimaryKey
(
    ID
)
VALUES
(   0  -- ID - int
)
Go

INSERT dbo.PrimaryKey
(
    ID
)
VALUES
(   1  -- ID - int
)
GO

INSERT dbo.PrimaryKey
(
    ID
)
VALUES
(   2  -- ID - int
)
GO

-- Khi đã tạo bảng. Muốn sửa cột thành PrimaryKey thì
ALTER TABLE dbo.PrimaryKey ADD PRIMARY KEY (ID)

-- Tạo PrimaryKey trong bảng ngay khi khởi tao
CREATE TABLE  CreatePrimaryKey
(
	ID INT NOT NULL,
	Name NVARCHAR(100) DEFAULT N'Có súng đây nè!'

	PRIMARY KEY (ID)
)
GO

-- Tạo PrimaryKey ngay trong bảng và đặt tên cho key đó
CREATE TABLE NameOnTablePK
(
	ID INT NOT NULL,
	Name NVARCHAR(100) DEFAULT N'Có súng đây nè!'

	CONSTRAINT PK	-- Xác định tên trước để phục vụ các thao tác (Xóa,...)
	PRIMARY KEY (ID)
)
GO

-- Tạo PrimaryKey sau khi tạo bảng và đặt tên cho key đó
CREATE TABLE NameOutTablePK
(
	ID INT NOT NULL,
	Name NVARCHAR(100) DEFAULT N'Có súng đây nè!'
)
GO

ALTER TABLE dbo.NameOutTablePK
ADD CONSTRAINT PK	-- Xác định tên trước để phục vụ các thao tác (Xóa,...)
	PRIMARY KEY (ID)
GO

-- Tạo khóa chính có 2 trường
CREATE TABLE DoublePrimaryKey
(
	ID1 INT NOT NULL,
	ID2 INT NOT NULL,
	Name NVARCHAR(100) DEFAULT N'Có súng đây nè!'

	PRIMARY KEY (ID1, ID2)
)
GO