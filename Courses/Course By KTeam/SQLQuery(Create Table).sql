CREATE DATABASE SQLDBQuery
GO

-- Sử dụng DataBase SQLDBQuery
USE SQLDBQuery
GO

-- Tạo bảng GiaoVien có 2 thuộc tính
CREATE TABLE GiaoVien
(
	MaGV NVARCHAR(10),
	Name NVARCHAR(100)
)
GO

CREATE TABLE HocSinh
(
	MaHS NVARCHAR(10),
	Name NVARCHAR(100)
)
GO

-- Sửa bảng, thêm cột ngày sinh
ALTER TABLE dbo.HocSinh ADD NgaySinh DATE

-- Xóa toàn bộ dữ liệu của bảng
TRUNCATE TABLE dbo.HocSinh

-- Gỡ bảng khỏi DataBase
DROP TABLE dbo.HocSinh
GO