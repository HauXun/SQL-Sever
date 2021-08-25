SELECT MAGV, HOTEN FROM dbo.GIAOVIEN
EXCEPT
SELECT	TG.MAGV, GV.HOTEN FROM dbo.THAMGIADT TG JOIN dbo.GIAOVIEN GV
ON GV.MAGV = TG.MAGV

SELECT GV.MAGV, GV.HOTEN FROM dbo.GIAOVIEN GV
WHERE NOT EXISTS (	SELECT * FROM dbo.THAMGIADT TG
					WHERE TG.MAGV = GV.MAGV)

SELECT GV.MAGV, GV.HOTEN FROM dbo.GIAOVIEN GV
WHERE GV.MAGV NOT IN (	SELECT TG.MAGV FROM dbo.THAMGIADT TG)

--

SELECT DISTINCT TG.MAGV FROM dbo.THAMGIADT TG
INTERSECT
SELECT BM.TRUONGBM FROM dbo.BOMON BM

SELECT GV.MAGV AS N'Mã giáo viên', GV.HOTEN FROM dbo.GIAOVIEN GV
WHERE GV.MAGV IN (	SELECT TG.MAGV FROM dbo.THAMGIADT TG )
	  AND
	  GV.MAGV IN (	SELECT BM.TRUONGBM FROM dbo.BOMON BM )

SELECT GV.MAGV FROM dbo.GIAOVIEN GV
UNION
SELECT GV2.MAGV FROM dbo.GIAOVIEN GV2

--

-- Tìm các giáo viên (MAGV) mà tham gia tất cả các đề tài

-- Tìm các giáo viên
-- mà không có đề tài nào
-- mà đề tài đó không được phân công giáo viên đó làm

-- Tập bị chia: THAMGIADT (MAGV, MADT)
-- Tập chia: DETAI (MADT)
-- Tập kết  quả: KQ (MAGV)
SELECT DISTINCT(TG.MAGV) FROM dbo.THAMGIADT TG
WHERE NOT EXISTS (	SELECT * FROM dbo.DETAI DT
					WHERE NOT EXISTS (	SELECT * FROM dbo.THAMGIADT TG2
										WHERE TG2.MAGV = TG.MAGV AND TG2.MADT = DT.MADT))

-- Tìm tên các giáo viên 'HTTT' mà tham gia tất cả các đề tài thuộc chủ đề 'QLGD'

-- Tìm tên các giáo viên BM 'HTTT'
-- mà không có đề tài của chủ đề QLGD nào
-- mà đề tài QLGD đó không có giáo viên trên tham gia

-- Tập bị chia (Chứa kết quả): (TGDT)
-- Tập chia: DETAI
-- KQ (MAGV, HOTEN) => TGDT, GIAOVIEN
SELECT TG.MAGV, GV.HOTEN
FROM dbo.GIAOVIEN GV JOIN dbo.THAMGIADT TG
ON GV.MAGV = TG.MAGV
WHERE GV.MABM = 'HTTT'
AND NOT EXISTS (	SELECT * FROM dbo.DETAI DT
					WHERE DT.MADT = 'QLGD'
					AND NOT EXISTS (	SELECT * FROM dbo.THAMGIADT TG2
										WHERE TG2.MADT = DT.MADT
										AND TG2.MAGV = TG.MAGV))

-- Khai báo
DECLARE @SoNguyen INT
DECLARE @SoThuc FLOAT
DECLARE @ChuoiDongU NVARCHAR(10)
DECLARE @ChuoiThuong CHAR(10)
-- Variable

SET @SoNguyen = 100

SELECT @SoNguyen AS N'Số'
PRINT @SoNguyen

-- Ép kiểu
SET @ChuoiDongU = CAST(@SoNguyen AS NVARCHAR)

SELECT @ChuoiDongU = CAST(@SoNguyen AS NVARCHAR)

SELECT @ChuoiDongU = N'Chuỗi mới select'
PRINT @ChuoiDongU

SELECT @SoNguyen = LEN(@ChuoiDongU)
PRINT @SoNguyen

--

IF (@SoNguyen = 17)
BEGIN
    PRINT 'HELLO'
END
ELSE
	PRINT 'HELLO'

SET @SoNguyen = 1
WHILE @SoNguyen <= 100
BEGIN
	SET @SoNguyen += 1
	IF @SoNguyen % 2 = 0
		CONTINUE
    PRINT @SoNguyen
END

-- Viết lệnh xác định một mã sinh viên mới theo quy định:
-- Mã sinh viên tăng dần,
-- nếu có chổ trống thì mã mới xác định sẽ chèn vào chổ trống đó
DECLARE @Idx INT = 1
WHILE EXISTS (	SELECT MAGV FROM dbo.GIAOVIEN WHERE MAGV = @Idx)
BEGIN
    SET @Idx += 1
END
PRINT @Idx
GO

DECLARE @Idx INT = 1
DECLARE @MaSoSanh VARCHAR(10) = 'GV0001'
WHILE EXISTS (	SELECT MAGV FROM dbo.GIAOVIEN WHERE MAGV = @MaSoSanh)
BEGIN
    SET @Idx += 1
	SET @MaSoSanh = 'GV' + REPLICATE('0', 4 - LEN(CAST(@Idx AS VARCHAR)) + CAST(@Idx AS VARCHAR))
END
PRINT @MaSoSanh