USE HowKteam
GO

-- Khi có nhu cầu duyệt từng Record của bảng. Với mỗi Record có kết quả xử lý riêng

-- DECLARE <Tên con trỏ> CURSOR FOR <Câu SELECT>
-- OPEN <Tên con trỏ>

-- FETCH NEXT FROM <Tên con trỏ> INTO <Danh sách các biến tương ứng kết quả truy vấn>

-- WHILE @@FETCH_STATUS = 0
-- GEGIN
-- Câu lệnh thực hiện
-- FETCH NEXT lại lần nữa
-- FETCH NEXT FROM <Tên con trỏ> INTO <Danh sách các biến tương ứng kết quả truy vấn>
-- END

-- CLOSE <Tên con trỏ>
-- DEALLOCATE <Tên con trỏ>

--------------------------------------------------------------------------------------

-- Từ tuổi của giáo viên
-- Nếu lớn hơn 40 thì cho lương là 2500
-- Nếu nhỏ hơn 40 và lớn hơn 30 thì cho lương là 2000
-- Ngược lại thì cho lương là 1500

-- Lấy ra danh sách MaGV kèm Tuổi đưa vào con trỏ có tên là GiaoVienCursor
DECLARE GiaoVienCursor CURSOR FOR SELECT MAGV, YEAR(GETDATE()) - YEAR(NGSINH) FROM dbo.GIAOVIEN

OPEN GiaoVienCursor

DECLARE @MaGV CHAR(10)
DECLARE @Tuoi INT

FETCH NEXT FROM GiaoVienCursor INTO @MaGV, @Tuoi

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @Tuoi > 40
	BEGIN
		UPDATE dbo.GIAOVIEN SET LUONG = 2500 WHERE MAGV = @MaGV
	END
	ELSE
	IF @Tuoi > 30
	BEGIN
		UPDATE dbo.GIAOVIEN SET LUONG = 2000 WHERE MAGV = @MaGV
	END
	ELSE
	BEGIN
	    UPDATE dbo.GIAOVIEN SET LUONG = 1500 WHERE MAGV = @MaGV
	END
	
	FETCH NEXT FROM GiaoVienCursor INTO @MaGV, @Tuoi

END

CLOSE GiaoVienCursor
DEALLOCATE GiaoVienCursor