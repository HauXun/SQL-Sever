USE HowKteam
GO

-- Trigger sẽ được gọi mỗi khi có thao tác thay đổi
-- Inserted: Chứa những trường đã insert hay update vào bảng
-- Deleted: Chứa những trường trường đã bị xóa khỏi bảng

CREATE TRIGGER UTG_InsertGiaoVien
ON dbo.GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
	ROLLBACK TRAN	-- Hủy bỏ thay đổi cập nhập bảng
	PRINT 'Trigger2'
END
GO

INSERT dbo.GIAOVIEN
(
    MAGV,
    HOTEN,
    LUONG,
    PHAI,
    NGSINH,
    DIACHI,
    GVQLCM,
    MABM
)
VALUES
(   N'011',       -- MAGV - nchar(3)
    N'Trần Dần',       -- HOTEN - nvarchar(50)
    2000,       -- LUONG - float
    N'Nam',       -- PHAI - nchar(3)
    12122012, -- NGSINH - date
    N'Phao sần pa lây',       -- DIACHI - nchar(50)
    NULL,       -- GVQLCM - nchar(3)
    N'SH'        -- MABM - nchar(4)
)
GO

SELECT * FROM dbo.GIAOVIEN
GO

---------------------------------------------------------------------------------

-- Không cho phép xóa thông tin của giáo viên có tuổi lớn hơn 40
CREATE TRIGGER UTG_AbortOlderThan40
ON dbo.GIAOVIEN
FOR DELETE
AS
BEGIN
    DECLARE @Count INT = 0

	SELECT @Count = COUNT(*) FROM Deleted AS D
	WHERE YEAR(GETDATE()) - YEAR(D.NGSINH) < 40

	IF (@Count > 0)
	BEGIN
	    PRINT N'Không được xóa những người hơn 40 tuổi'
		ROLLBACK TRAN
	END
END
GO