USE HowKteam
GO

SELECT GV.MAGV, GV.HOTEN, NT.TEN 
FROM dbo.GIAOVIEN AS GV, dbo.NGUOITHAN AS NT
WHERE GV.MAGV = NT.MAGV

-- Lấy ra giáo viên lương lớn hơn 2000
SELECT * FROM dbo.GIAOVIEN
WHERE LUONG > 2000

-- Lấy ra giáo viên là nữ và lương lớn hơn 2000
SELECT * FROM dbo.GIAOVIEN
WHERE LUONG > 2000 AND PHAI = N'Nữ'

-- Lấy ra giáo viên nhỏ hơn 40 tuổi
-- YEAR -> Lấy ra năm của ngày
-- GETDATE -> Lấy ngày hiện tại
SELECT * FROM dbo.GIAOVIEN
WHERE YEAR(GETDATE()) - YEAR(NGSINH) > 40

-- Lấy ra họ tên giáo viên, năm sinh và tuổi của giáo viên nhỏ hơn 40 tuổi
SELECT HOTEN, NGSINH, YEAR(GETDATE()) - YEAR(NGSINH) FROM dbo.GIAOVIEN
WHERE YEAR(GETDATE()) - YEAR(NGSINH) > 40

-- Lấy ra mã giáo viên, tên giáo viên và tên khoa của giáo viên đó đang làm việc
SELECT GV.MAGV, GV.HOTEN, K.TENKHOA FROM dbo.GIAOVIEN AS GV, dbo.BOMON AS BM, dbo.KHOA AS K
WHERE GV.MABM = BM.MABM AND BM.MAKHOA = K.MAKHOA

-- Lấy ra giáo viên là trưởng bộ môn
SELECT GV.* FROM dbo.GIAOVIEN AS GV, dbo.BOMON AS BM
WHERE GV.MAGV = BM.TRUONGBM

-- Đếm số lượng giáo viên
-- COUNT(*) -> Đếm số lượng của tất cả record
-- COUNT(Tên trường) -> Đếm số lượng của trường đó
SELECT COUNT(*) AS N'Số lượng giáo viên' FROM dbo.GIAOVIEN

-- Đếm số lượng người thân của giáo viên có mãGV là 007
SELECT COUNT(*) AS N'Số lượng người thân'
-- SELECT *
FROM dbo.GIAOVIEN, dbo.NGUOITHAN
WHERE dbo.GIAOVIEN.MAGV = '007' AND dbo.GIAOVIEN.MAGV = dbo.NGUOITHAN.MAGV

-- Lấy ra tên giáo viên và tên đề tài người đó tham gia
SELECT HOTEN, TENDT FROM dbo.GIAOVIEN, dbo.THAMGIADT, dbo.DETAI
WHERE dbo.GIAOVIEN.MAGV = dbo.THAMGIADT.MAGV AND dbo.DETAI.MADT = dbo.THAMGIADT.MADT

-- Lấy ra tên giáo viên và tên đề tài người đó tham gia
-- khi mà người đó tham gia nhiều hơn 1 lần
-- Truy vấn lồng...

-- Xuất ra thông tin giáo viên và Giáo viên quản lý chủ nhiệm của người đó
SELECT GV1.HOTEN, GV2.HOTEN FROM dbo.GIAOVIEN AS GV1, dbo.GIAOVIEN AS GV2
WHERE GV2.MAGV = GV1.GVQLCM

-- Xuất ra số lượng giáo viên của khoa CNTT
SELECT COUNT(*) FROM dbo.GIAOVIEN AS GV, dbo.BOMON AS BM, dbo.KHOA AS K
WHERE GV.MABM = BM.MABM
AND BM.MAKHOA = K.MAKHOA
AND K.MAKHOA = 'CNTT'

-- Xuất ra thông tin giáo viên và đề tài người đó tham gia khi có kết quả là đạt
SELECT GV.* FROM dbo.GIAOVIEN AS GV, dbo.THAMGIADT AS TG
WHERE GV.MAGV = TG.MAGV
AND TG.KETQUA = N'Đạt'