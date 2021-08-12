USE HowKteam
GO

-- Tạo function không có parameter
CREATE FUNCTION UF_SelectAllGiaoVien()
RETURNS TABLE
AS RETURN SELECT * FROM dbo.GIAOVIEN
GO

-- Sử dụng không kèm dbo
SELECT * FROM UF_SelectAllGiaoVien()
GO

-- Tạo function với parameter
CREATE FUNCTION UF_SelectLuongGiaoVien(@MaGV CHAR(10))
RETURNS INT
AS
BEGIN
    RETURN (SELECT LUONG FROM dbo.GIAOVIEN WHERE @MaGV = MAGV)
END
GO

-- Sử dụng kèm dbo
SELECT dbo.UF_SelectLuongGiaoVien(MAGV) FROM dbo.GIAOVIEN
GO

-- Sửa function
ALTER FUNCTION UF_SelectLuongGiaoVien(@MaGV CHAR(10))
RETURNS INT
AS
BEGIN
    RETURN (SELECT LUONG FROM dbo.GIAOVIEN WHERE @MaGV = MAGV)
END
GO

-- Hủy Store
-- DROP PROC (YOURPROCEDURE)

-- Hủy Function
DROP FUNCTION dbo.UF_SelectLuongGiaoVien
GO

---------------------------------------------------------------------------------

-- Tạo function tính một số truyền vào phải là số chẵn hay không
CREATE FUNCTION UF_IsOdd(@Num INT)
RETURNS NVARCHAR(20)
AS
BEGIN
	IF (@Num % 2 = 0)
		RETURN N'Số chẵn'
	ELSE
		RETURN N'Số lẻ'
	RETURN N'Không xác định'
END
GO

CREATE FUNCTION UF_AgeOfYear(@Year INT)
RETURNS INT
AS
BEGIN
	RETURN YEAR(GETDATE()) - YEAR(@Year)
END
GO

SELECT dbo.UF_AgeOfYear(NGSINH), dbo.UF_IsOdd(dbo.UF_AgeOfYear(NGSINH)) FROM dbo.GIAOVIEN