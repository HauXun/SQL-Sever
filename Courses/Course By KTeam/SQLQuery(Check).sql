﻿USE HowKteam
GO

-- Có thể tạo check như tạo khóa chính
CREATE TABLE TestCheck
(
	ID INT PRIMARY KEY IDENTITY,
	LUONG INT CHECK(LUONG > 3000 AND LUONG < 9000)
)
GO

INSERT dbo.TestCheck
(
    LUONG
)
VALUES
(
3001  -- LUONG - int
)
GO

CREATE TABLE TestCheck2
(
	ID INT PRIMARY KEY IDENTITY,
	LUONG INT,
	CHECK(LUONG > 3000 AND LUONG < 9000)
)
GO

CREATE TABLE TestCheck3
(
	ID INT PRIMARY KEY IDENTITY,
	LUONG INT,
	CONSTRAINT CK_Luong CHECK(LUONG > 3000 AND LUONG < 9000)
)
GO

CREATE TABLE TestCheck4
(
	ID INT PRIMARY KEY IDENTITY,
	LUONG INT
)
GO

ALTER TABLE dbo.TestCheck4 ADD CONSTRAINT CK_Luong
CHECK(LUONG > 3000 AND LUONG < 9000)