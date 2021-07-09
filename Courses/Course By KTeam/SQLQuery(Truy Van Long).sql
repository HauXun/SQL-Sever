USE HowKteam
GO

-- Kiểm tra xem giáo viên 001 có phải là giáo viên quản lý chuyên môn hay không
-- Lấy ra danh sách các mã giáo viên quản lý chuyên môn
-- Kiểm tra mã giáo viên tồn tại trong danh sách đó
SELECT * FROM dbo.GIAOVIEN
--WHERE MAGV = '001'
-- 001 phải tồn tại trong danh sách
WHERE MAGV /*NOT*/ IN
(
	SELECT GVQLCM FROM dbo.GIAOVIEN
)

-- Truy vấn lồng trong Form
SELECT * FROM
dbo.GIAOVIEN, (SELECT * FROM dbo.DETAI) AS DT


-- Xuất ra danh sách giáo viên tham gia nhiều hơn một đề tài

-- Lấy ra tất cả thông tin của giáo viên
SELECT * FROM dbo.GIAOVIEN AS GV
-- Khi mà số lượng đề tài giáo viên đó tham gia > 1
WHERE 1 < (
	SELECT COUNT(*) FROM dbo.THAMGIADT
	WHERE MAGV = GV.MAGV
)

	SELECT GV.MAGV, COUNT(TG.MADT) AS SL FROM dbo.THAMGIADT TG, dbo.GIAOVIEN GV
	WHERE TG.MAGV = GV.MAGV
	GROUP BY GV.MAGV, TG.MADT
	HAVING COUNT(*) > 1


-- Lấy ra thông tin của khoa có nhiều hơn 2 giáo viên
-- Lấy danh sách bộ môn nằm trong khoa hiện tại
SELECT * FROM dbo.KHOA AS K
WHERE 2 < (
	SELECT COUNT(*) FROM dbo.BOMON AS BM, dbo.GIAOVIEN AS GV
	WHERE BM.MAKHOA = K.MAKHOA
	AND BM.MABM = GV.MABM
)

/*SELECT * FROM dbo.KHOA AS K, dbo.BOMON AS BM, dbo.GIAOVIEN AS GV
WHERE BM.MAKHOA = K.MAKHOA
AND BM.MABM = GV.MABM*/


-- Xuất ra danh sách giáo viên có hơn 2 người thân
SELECT * FROM dbo.GIAOVIEN AS GV
WHERE 1 < (
	SELECT COUNT(*) FROM dbo.NGUOITHAN AS NT
	WHERE GV.MAGV = NT.MAGV
)

/*Xuất ra danh sách giáo viên lớn tuổi hơn ít nhất 5 giáo viên trong trường
- Lấy ra danh sách (MaGV, Tuoi) AS GVT
- Sắp xếp giảm dần
- Lấy ra danh sách GVT2 với số lượng phần tử = 5
- Kiểm tra mã giáo viên tồn tại trong GVT2 là đúng*/