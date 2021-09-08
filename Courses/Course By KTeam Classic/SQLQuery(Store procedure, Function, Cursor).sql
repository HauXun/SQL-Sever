-- CREAT PROCEDURE usp_TinhTong
-- Tính tổng 2 số nguyên
CREATE PROC usp_TinhTong
@a INT,
@b INT
AS
BEGIN
    DECLARE @Result INT
	SET @Result = @a + @b
	PRINT N'Tổng 2 số ' + CAST(@a AS VARCHAR) + ' và ' + CAST(@b AS VARCHAR) + ' là ' + CAST(@Result AS VARCHAR)
END
EXEC dbo.usp_TinhTong @a = 6, -- int
                      @b = 9  -- int
GO

-- Output
CREATE PROC usp_TinhTongOut
@a INT,
@b INT,
@result INT OUT
AS
BEGIN
	SET @Result = @a + @b
	PRINT N'Tổng 2 số ' + CAST(@a AS VARCHAR) + ' và ' + CAST(@b AS VARCHAR) + ' là ' + CAST(@Result AS VARCHAR)
END
GO
DECLARE @result INT
DECLARE @a INT = 6, @b INT = 9
EXEC dbo.usp_TinhTongOut 6, -- int
						 9,  -- int
						 @result OUT
GO

-- RETURN
CREATE PROC usp_TinhTongRETURN
@a INT,
@b INT
AS
BEGIN
	DECLARE @Result INT
	SET @Result = @a + @b
	RETURN @Result
END
GO
DECLARE @Result INT
EXEC @Result = dbo.usp_TinhTongRETURN @a = 6, -- int
                                      @b = 9  -- int
PRINT @Result
GO

-- Init
CREATE PROC usp_TinhTongInitParam
@a INT = 6,
@b INT = 9
AS
BEGIN
    DECLARE @result INT
	SET @result = @a + @b
	PRINT @result
END
GO
EXEC dbo.usp_TinhTongInitParam @a = 10, -- int
                               @b = 10  -- int
GO

CREATE PROC usp_XemThongTinGV
@MaGV NCHAR(10) = NULL
AS
BEGIN
    IF (@MaGV IS NULL)
		PRINT N'Mã GV không đúng'
	ELSE
		SELECT * FROM dbo.GIAOVIEN WHERE MAGV = @MaGV
END
EXEC dbo.usp_XemThongTinGV @MaGV = 'GV0001' -- nchar(10)
GO

-- Mã tự tăng store
CREATE PROC usp_TimMaGVTiepTheo
AS
BEGIN
    -- Declare
	DECLARE @MaGV NCHAR(10) = 'GV00001'
	DECLARE @Idx INT
	SET @Idx = 1

	WHILE EXISTS (SELECT MaGV FROM dbo.GIAOVIEN WHERE MAGV = @MaGV)
	BEGIN
	    SET @Idx += 1
		SET @MaGV = 'GV' + REPLICATE('0', 5 - LEN(CAST(@Idx AS VARCHAR)) + CAST(@Idx AS VARCHAR))
	END
	PRINT @MaGV
END
EXEC dbo.usp_TimMaGVTiepTheo
GO

-- Table
CREATE PROC usp_StoreTable
AS
BEGIN
	DECLARE @table TABLE (	MaGV NCHAR(10),
							HoTen NVARCHAR(50))
	INSERT @table (MaGV, HoTen) SELECT MaGV, HOTEN FROM dbo.GIAOVIEN

	SELECT * FROM @table
END
GO

-- Function
CREATE FUNCTION func_TinhTong (	@a INT, @b INT )
RETURNS INT
AS
BEGIN
    DECLARE @result INT
	SET @result = @a + @b
	RETURN @result
END
GO
SELECT dbo.func_TinhTong(6, 9)
GO

-- Nhập vào tên của một giáo viên và cho biết tuổi của giáo viên này
CREATE FUNCTION func_TinhTuoiGiaoVien (@Ten NVARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Tuoi INT
	SELECT @Tuoi = DATEDIFF(yyyy, NGSINH, GETDATE()) FROM dbo.GIAOVIEN
	WHERE HOTEN = @Ten
	RETURN @Tuoi
END
GO
PRINT dbo.func_TinhTuoiGiaoVien(N'Condilonnay')

-- Cursor
-- C1
DECLARE @curGiaoVien CURSOR
SET @curGiaoVien = CURSOR
FOR	SELECT MAGV, HOTEN FROM dbo.GIAOVIEN
GO

-- Khai báo con trỏ
-- C2
DECLARE curGiaoVien CURSOR
FOR SELECT MAGV, HOTEN FROM dbo.GIAOVIEN

-- Khai báo biến lưu trữ
DECLARE @MaGV NCHAR(10)
DECLARE @HoTen NVARCHAR(50)
PRINT N'Danh sách giáo viên: '

-- Open con trỏ
OPEN curGiaoVien
FETCH NEXT FROM curGiaoVien INTO @MaGV, @HoTen
WHILE (@@FETCH_STATUS = 0) -- Khi trỏ thành công
BEGIN
    PRINT @MaGV + ' : ' + @HoTen
	PRINT '---------------------'
	FETCH NEXT FROM curGiaoVien INTO @MaGV, @HoTen
END

-- Đóng con trỏ
CLOSE curGiaoVien

-- Hủy con trỏ
DEALLOCATE curGiaoVien