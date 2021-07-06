CREATE DATABASE ForeignPrimaryKey
GO

USE ForeignPrimaryKey
GO

CREATE TABLE BoMon
(
	MaBM CHAR(10) PRIMARY KEY,
	NAME NVARCHAR(100) DEFAULT N'Tên bộ môn'
)
GO

CREATE TABLE Lop
(
	MaLop CHAR(10) NOT NULL,
	Name NVARCHAR(100) DEFAULT N'Tên lớp'

	PRIMARY KEY (MaLop)
)
GO

-- Điều kiện để tạo khóa ngoại
-- Tham chiếu tới khóa chính (Unique, Not Null)
-- Cùng kiểu dữ liệu
-- Cùng số lượng trường có sắp xếp

-- Lợi ích:
-- Đảm bảo toàn vẹn dữ liệu.
-- Không có trường hợp tham chiếu tới dữ liệu không tồn tại
CREATE TABLE GiaoVien
(
	MaGV CHAR(10) NOT NULL,
	Name NVARCHAR(100) DEFAULT N'Tên giáo viên',
	DiaChi NVARCHAR(100) DEFAULT N'Địa chỉ giáo viên',
	NgaySinh DATE,
	Gender BIT,
	MaBM CHAR(10),

	-- Tạo khóa ngoại ngay khi tạo bảng
	FOREIGN KEY (MaBM) REFERENCES dbo.BoMon (MaBM)
)
GO

ALTER TABLE dbo.GiaoVien ADD PRIMARY KEY (MaGV)

CREATE TABLE HocSinh
(
	MaHS CHAR(10) PRIMARY KEY,
	Name NVARCHAR(100),
	MaLop CHAR(10)
)
GO

-- Tạo khóa ngoại sau khi tạo bảng
ALTER TABLE dbo.HocSinh ADD CONSTRAINT FK_HS FOREIGN KEY (MaLop) REFERENCES dbo.Lop (MaLop)

-- Hủy tên khóa chính hoặc khóa ngoại
ALTER TABLE dbo.HocSinh DROP CONSTRAINT FK_HS

-- Thêm dữ liệu vào bảng bộ môn
INSERT INTO dbo.BoMon
(
    MaBM,
    NAME
)
VALUES
(   'BM01', -- MaBM - char(10)
    N'Bộ môn 1' -- NAME - nvarchar(100)
)
GO

INSERT INTO dbo.BoMon
(
    MaBM,
    NAME
)
VALUES
(   'BM02', -- MaBM - char(10)
    N'Bộ môn 2' -- NAME - nvarchar(100)
)
GO

INSERT INTO dbo.BoMon
(
    MaBM,
    NAME
)
VALUES
(   'BM03', -- MaBM - char(10)
    N'Bộ môn 3' -- NAME - nvarchar(100)
)
GO

-- Thêm dữ liệu vào bảng giáo viên
INSERT INTO dbo.GiaoVien
(
    MaGV,
    Name,
    DiaChi,
    NgaySinh,
    Gender,
    MaBM
)
VALUES
(   'GV01',        -- MaGV - char(10)
    N'GV 1',       -- Name - nvarchar(100)
    N'DC 1',       -- DiaChi - nvarchar(100)
    GETDATE(), -- NgaySinh - date
    0,      -- Gender - bit
    'BM03'         -- MaBM - char(10)
)
GO

INSERT INTO dbo.GiaoVien
(
    MaGV,
    Name,
    DiaChi,
    NgaySinh,
    Gender,
    MaBM
)
VALUES
(   'GV02',        -- MaGV - char(10)
    N'GV 1',       -- Name - nvarchar(100)
    N'DC 1',       -- DiaChi - nvarchar(100)
    GETDATE(), -- NgaySinh - date
    0,      -- Gender - bit
    'BM01'         -- MaBM - char(10)
)
GO