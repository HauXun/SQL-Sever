USE master
GO

CREATE DATABASE EntityDemo
GO

USE EntityDemo
GO

CREATE TABLE LOP
(
	ID INT IDENTITY PRIMARY KEY,
	NAME NVARCHAR(100) DEFAULT N'Lớp gì cũng được'
)
GO

CREATE TABLE SINHVEN
(
	ID INT IDENTITY PRIMARY KEY,
	NAME NVARCHAR(100) DEFAULT N'Tên gì cũng được',
	IDClass INT NOT NULL,
	FOREIGN KEY (IDClass) REFERENCES dbo.LOP(ID)
)
GO

INSERT INTO dbo.LOP
(
    NAME
)
VALUES
(N'Class 1' -- NAME - nvarchar(100)
)

INSERT INTO dbo.LOP
(
    NAME
)
VALUES
(N'Class 2' -- NAME - nvarchar(100)
)

INSERT INTO dbo.LOP
(
    NAME
)
VALUES
(N'Class 3' -- NAME - nvarchar(100)
)

INSERT INTO dbo.LOP
(
    NAME
)
VALUES
(N'Class 4' -- NAME - nvarchar(100)
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV1', -- NAME - nvarchar(100)
    1    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV2', -- NAME - nvarchar(100)
    1    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV3', -- NAME - nvarchar(100)
    1    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV4', -- NAME - nvarchar(100)
    1    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV1', -- NAME - nvarchar(100)
    2    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV2', -- NAME - nvarchar(100)
    2    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV3', -- NAME - nvarchar(100)
    2    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV4', -- NAME - nvarchar(100)
    2    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV1', -- NAME - nvarchar(100)
    3    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV2', -- NAME - nvarchar(100)
    3    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV3', -- NAME - nvarchar(100)
    3    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV4', -- NAME - nvarchar(100)
    3    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV1', -- NAME - nvarchar(100)
    4    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV2', -- NAME - nvarchar(100)
    4    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV3', -- NAME - nvarchar(100)
    4    -- IDClass - int
)

INSERT INTO dbo.SINHVEN
(
    NAME,
    IDClass
)
VALUES
(   N'SV4', -- NAME - nvarchar(100)
    4    -- IDClass - int
)

SELECT * FROM dbo.SINHVEN