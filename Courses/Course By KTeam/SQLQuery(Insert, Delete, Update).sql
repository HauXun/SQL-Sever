CREATE TABLE Test
(
	MaSo INT,
	Ten NVARCHAR(10),
	NgaySinh DATE,
	Nam BIT,
	DiaChi NCHAR(20),
	TienLuong FLOAT
)
GO

-- Thêm dữ liệu theo thứ tự của bảng
INSERT INTO dbo.Test
(
    MaSo,
    Ten,
    NgaySinh,
    Nam,
    DiaChi,
    TienLuong
)
VALUES
(   10,         -- MaSo - int
    N'Hậu',       -- Ten - nvarchar(10)
    '20020705', -- NgaySinh - date
    1,      -- Nam - bit
    N'Trên Mây',       -- DiaChi - nchar(20)
    100000.0        -- TienLuong - float
    )
GO

-- Thêm dữ liệu
INSERT INTO dbo.Test
(
    MaSo,
    Ten,
    NgaySinh,
    Nam,
    DiaChi,
    TienLuong
)
VALUES
(   11,         -- MaSo - int
    N'Hậu Đậu',       -- Ten - nvarchar(10)
    '20020507', -- NgaySinh - date
    1,      -- Nam - bit
    N'Trên Mây',       -- DiaChi - nchar(20)
    100000.0        -- TienLuong - float
    )
GO

-- Thêm dữ liệu
INSERT INTO dbo.Test
(
    MaSo,
    Ten,
    NgaySinh,
    Nam,
    DiaChi,
    TienLuong
)
VALUES
(   12,         -- MaSo - int
    N'Hậu Xún',       -- Ten - nvarchar(10)
    '20020705', -- NgaySinh - date
    1,      -- Nam - bit
    N'Trên Mây',       -- DiaChi - nchar(20)
    100000.0        -- TienLuong - float
    )
GO

-- Xóa toàn bộ bảng
DELETE dbo.Test

-- Xóa dữ liệu với 1 hơn nhiều điều kiện
DELETE dbo.Test WHERE TienLuong > 50000 AND MaSo < 11

-- Update dữ liệu 1 hoặc hơn nhiều dữ liệu
UPDATE dbo.Test SET TienLuong = 150000, DiaChi = 'PhaoSaunPalay'

-- Update dữ liệu của trường với điều kiện mong muốn
UPDATE dbo.Test SET TienLuong = 120000 WHERE Nam = 0