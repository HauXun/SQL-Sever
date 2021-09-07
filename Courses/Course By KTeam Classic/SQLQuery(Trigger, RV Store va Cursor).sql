-- PROCEDURE
-- CREATE PROC
CREATE PROC usp_XuatTTTheoMaGV
@MaHV NCHAR(10)
AS
BEGIN
    DECLARE @HoTen NVARCHAR(100)
	DECLARE @MaLop VARCHAR(50)

	-- Gán giá trị vào
	SELECT @HoTen = TenHocVien, @MaLop = MaLop FROM dbo.HOCVIEN

	PRINT N'**Họ tên: ' + @HoTen
	PRINT N'**Bộ môn: ' + @MaLop
	PRINT N'**Kết quả: '

	-- Khai báo
	DECLARE cur CURSOR
	FOR
	SELECT HV.TenHocVien, MH.TenMonHoc, MH.SoChi, KQ.Diem
	FROM dbo.HOCVIEN HV JOIN dbo.KETQUA KQ
	ON KQ.MaHV = HV.MaHocVien
	JOIN dbo.MONHOC MH
	ON MH.MaMonHoc = KQ.MaMonHoc
	WHERE HV.MaHocVien = @MaHV
	AND KQ.LanThi >= ALL (	SELECT KQ2.LanThi FROM dbo.KETQUA KQ2
							WHERE KQ2.MaHV = HV.MaHocVien
							AND KQ2.MaMonHoc = MH.MaMonHoc)

	-- Open
	OPEN cur

	-- Khai báo biến
	DECLARE @STT INT
	DECLARE @TenMH NVARCHAR(100)
	DECLARE @SoChi INT
	DECLARE @Diem FLOAT

	--
	-- STT, Môn học, Số tín chỉ, Điểm
	PRINT 'STT' + SPACE(5) + 'Môn học' + SPACE(20) + 'Số chỉ' + SPACE(10) + 'Điểm'
	FETCH NEXT FROM cur INTO @TenMH, @SoChi, @Diem
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	    PRINT CAST(@STT AS VARCHAR) + SPACE(5) + @TenMH + SPACE(10) + CAST(@SoChi AS VARCHAR) + SPACE(10) + CAST(@Diem AS VARCHAR)
		FETCH NEXT FROM cur INTO @TenMH, @SoChi, @Diem
		SET @STT += 1
	END

	-- Close
	CLOSE cur

	-- Hủy
	DEALLOCATE cur
END
EXEC dbo.usp_XuatTTTheoMaGV @MaHV = N'HV00001' -- nchar(10)
GO

-- Trigger
-- Cột tình trạng trong bảng học viên nếu có giá trị thì chỉ có thể là
-- 'đang học', 'đã tốt nghiệp', 'buộc thôi học'
CREATE TRIGGER tg_TinhTrangHocVien ON HOCVIEN
FOR INSERT, UPDATE
AS
BEGIN
	IF UPDATE(TinhTrang)
    IF EXISTS (	SELECT * FROM inserted i
				WHERE i.TinhTrang NOT IN (	N'đang học',
											N'đã tốt nghiệp',
											N'buộc thôi học'))
	
	BEGIN
	    RAISERROR (N'Sai tình trạng học viên', 16, 1)
		ROLLBACK TRAN
	END
END
GO

-- Viết trigger update cho bảng đơn hàng
CREATE TRIGGER tg_DonHang ON DONHANG
FOR UPDATE
AS
BEGIN
    IF UPDATE(NgayDatHang)
	BEGIN
	    IF EXISTS (	SELECT * FROM inserted i JOIN PhieuGH P
					ON i.MaDH = P.MaDH
					WHERE DATEDIFF(MM, i.NgayDatHang, P.NgayGiaoHang) < 1)
		BEGIN
		    RAISERROR (N'Ngày giao phải sau ngày đặt một tháng', 16, 1)
			ROLLBACK TRAN
		END
	END
END
GO

CREATE TRIGGER tg_XoaHV ON HOCVIEN
FOR DELETE
AS
BEGIN
    IF EXISTS (	SELECT * FROM Deleted d
				WHERE DATEDIFF(yyyy, d.NgaySinh, GETDATE()) > 20)
	BEGIN
	    RAISERROR (N'Không được xóa trên 20 tuổi', 16, 1)
		ROLLBACK
	END
END