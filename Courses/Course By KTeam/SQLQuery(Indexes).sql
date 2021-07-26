USE HowKteam
GO

DECLARE @i INT = 1
WHILE (@i < 10000000)
BEGIN
INSERT dbo.NGUOITHAN
(
    MAGV,
    TEN,
    NGSINH,
    PHAI
)
VALUES
(   N'001',       -- MAGV - nchar(3)
    N'Test' + CAST(@i AS NCHAR(12)),       -- TEN - nchar(12)
    GETDATE(), -- NGSINH - datetime
    N'Nam'        -- PHAI - nchar(3)
)
SET @i += 1
END
GO

-- Tạo index trên bảng giáo viên
-- Tăng tốc độ tìm kiếm nhưng chậm tốc độ Thêm, Xóa, Sửa

-- Cho phép các trường trùng nhau
CREATE INDEX IndexName ON dbo.NGUOITHAN(MAGV)

-- Không cho phép các trường trùng nhau
CREATE UNIQUE INDEX IndexNameUnique ON dbo.GIAOVIEN(MAGV)

SELECT * FROM dbo.NGUOITHAN
WHERE MAGV = '001' AND TEN = 'Test999999'