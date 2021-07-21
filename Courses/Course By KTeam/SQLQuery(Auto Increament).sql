USE HowKteam
GO

CREATE TABLE TestAuto
(
	ID INT PRIMARY KEY IDENTITY,	-- Tự tăng trường này, phải là số
									-- Mặc định bắt đầu từ 1 và tăng 1 đơn vị
	Name NVARCHAR(100)
)
GO

INSERT dbo.TestAuto
(
    Name
)
VALUES
(N'' -- Name - nvarchar(100)
)

INSERT dbo.TestAuto
(
    Name
)
VALUES
(N'' -- Name - nvarchar(100)
)

INSERT dbo.TestAuto
(
    Name
)
VALUES
(N'' -- Name - nvarchar(100)
)

INSERT dbo.TestAuto
(
    Name
)
VALUES
(N'' -- Name - nvarchar(100)
)
GO

SELECT * FROM dbo.TestAuto

CREATE TABLE TestAuto2
(
	ID INT PRIMARY KEY IDENTITY(5, 10),	-- Tự tăng trường này, phải là số
										-- Mặc định bắt đầu từ 5 và tăng 10 đơn vị
	Name NVARCHAR(100)
)
GO

INSERT dbo.TestAuto2
(
    Name
)
VALUES
(N'' -- Name - nvarchar(100)
)

INSERT dbo.TestAuto2
(
    Name
)
VALUES
(N'' -- Name - nvarchar(100)
)

INSERT dbo.TestAuto2
(
    Name
)
VALUES
(N'' -- Name - nvarchar(100)
)

INSERT dbo.TestAuto2
(
    Name
)
VALUES
(N'' -- Name - nvarchar(100)
)
GO

SELECT * FROM dbo.TestAuto2