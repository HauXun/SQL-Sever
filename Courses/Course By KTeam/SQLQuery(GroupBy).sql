USE HowKteam
GO

-- Xuất ra danh sách tên bộ môn và số lượng giáo viên của bộ môn đó
SELECT TENBM, COUNT(*) FROM dbo.GIAOVIEN, dbo.BOMON
WHERE dbo.BOMON.MABM = dbo.GIAOVIEN.MABM
GROUP BY TENBM

-- Lấy ra danh sách giáo viên có lương > lương trung bình của giáo viên
SELECT * FROM dbo.GIAOVIEN AS GV
WHERE GV.LUONG > (
	(SELECT SUM(LUONG) FROM dbo.GIAOVIEN) / 
	(SELECT COUNT(*) FROM dbo.GIAOVIEN)
)

-- Xuất ra tên giáo viên và số lượng đề tài giáo viên đó tham gia
SELECT GV.HOTEN, COUNT(*) FROM dbo.GIAOVIEN AS GV, dbo.THAMGIADT AS TG
WHERE GV.MAGV = TG.MAGV
GROUP BY GV.MAGV, GV.HOTEN

-- Xuất ra tên giáo viên và số lượng người thân của giáo viên đó
SELECT GV.HOTEN, COUNT(*) FROM dbo.GIAOVIEN AS GV, dbo.NGUOITHAN AS NT
WHERE GV.MAGV = NT.MAGV
GROUP BY GV.MAGV, GV.HOTEN

-- Xuất ra tên giáo viên và số lượng đề tài đã hoàn thành mà giáo viên đó đã tham gia
SELECT GV.HOTEN, COUNT(*) FROM dbo.GIAOVIEN AS GV, dbo.THAMGIADT AS TG
WHERE GV.MAGV = TG.MAGV
AND TG.KETQUA = N'Đạt'
GROUP BY GV.MAGV, GV.HOTEN

SELECT GV.HOTEN, TG.* FROM dbo.GIAOVIEN AS GV, dbo.THAMGIADT AS TG
WHERE GV.MAGV = TG.MAGV
AND TG.KETQUA = N'Đạt'

-- Xuất ra tên khoa có tổng số lượng của giáo viên trong khoa là lơn nhất
SELECT K.TENKHOA, COUNT(*) AS SL FROM dbo.KHOA AS K, dbo.BOMON AS BM, dbo.GIAOVIEN AS GV
	WHERE K.MAKHOA = BM.MAKHOA
	AND BM.MABM = GV.MABM
	GROUP BY K.TENKHOA
	HAVING COUNT(*) = (SELECT MAX(DS.SL) FROM
	(SELECT COUNT(*) AS SL FROM dbo.KHOA AS K, dbo.BOMON AS BM, dbo.GIAOVIEN AS GV
	WHERE K.MAKHOA = BM.MAKHOA
	AND BM.MABM = GV.MABM
	GROUP BY K.TENKHOA) AS DS)

SELECT * FROM dbo.GIAOVIEN
SELECT * FROM dbo.KHOA
SELECT * FROM dbo.BOMON