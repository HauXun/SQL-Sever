USE master
GO

CREATE DATABASE ADOTest
GO

USE ADOTest
GO

CREATE TABLE THONGTIN
(
	ID VARCHAR(10) PRIMARY KEY,
	NAME NVARCHAR(100),
	DOB DATE,
	INFO NVARCHAR(500),
	SEX BIT
)
GO

INSERT INTO dbo.THONGTIN
(
    ID,
    NAME,
    DOB,
    INFO,
    SEX
)
VALUES
(   '1',        -- ID - varchar(10)
    N'Trần Dần',       -- NAME - nvarchar(100)
    '19581022', -- DOB - date
    N'Có súng!',       -- INFO - nvarchar(500)
    1       -- SEX - bit
)
GO

INSERT INTO dbo.THONGTIN
(
    ID,
    NAME,
    DOB,
    INFO,
    SEX
)
VALUES
(   '2',        -- ID - varchar(10)
    N'Hai Zụ',       -- NAME - nvarchar(100)
    '19610212', -- DOB - date
    N'Chửi thề',       -- INFO - nvarchar(500)
    1       -- SEX - bit
)
GO

INSERT INTO dbo.THONGTIN
(
    ID,
    NAME,
    DOB,
    INFO,
    SEX
)
VALUES
(   '3',        -- ID - varchar(10)
    N'Đức lục sắc',       -- NAME - nvarchar(100)
    '19000101', -- DOB - date
    N'Phù hộ',       -- INFO - nvarchar(500)
    1       -- SEX - bit
)
GO

CREATE TABLE TIEUSU
(
	ID VARCHAR(10) PRIMARY KEY,
	IDInfo VARCHAR(10),
	INFO NVARCHAR(1000),
	FOREIGN KEY (IDInfo) REFERENCES dbo.THONGTIN(ID)
)
GO

INSERT INTO dbo.TIEUSU
(
    ID,
    IDInfo,
    INFO
)
VALUES
(   '1', -- ID - varchar(10)
    '1', -- IDInfo - varchar(10)
    N'Có súng đây nè! Ở đây ai cũng có súng hết á' -- INFO - nvarchar(1000)
)
GO

INSERT INTO dbo.TIEUSU
(
    ID,
    IDInfo,
    INFO
)
VALUES
(   '2', -- ID - varchar(10)
    '3', -- IDInfo - varchar(10)
    N'Chửi thề căng cực, tấu hài cực xung' -- INFO - nvarchar(1000)
)
GO

SELECT * FROM dbo.THONGTIN