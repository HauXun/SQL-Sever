USE HowKteam
GO

-- Tạo ra một bảng lưu thông tin giáo viên, tên bộ môn và lương của giáo viên đó
SELECT GV.HOTEN, BM.TENBM, GV.LUONG INTO LuongGiaoVien FROM dbo.GIAOVIEN AS GV, dbo.BOMON AS BM
WHERE GV.MABM = BM.MABM

SELECT * FROM dbo.LuongGiaoVien

UPDATE dbo.GIAOVIEN SET LUONG = 90000
WHERE MAGV = '006'

SELECT * FROM dbo.GIAOVIEN

-- View là bảng ảo
-- Cập nhập theo bảng mà view truy vấn tới mỗi khi lấy view ra xài

-- Tạo ra View TestView từ câu truy vấn
CREATE VIEW [TestView] AS
SELECT * FROM dbo.GIAOVIEN
GO

SELECT * FROM TestView

UPDATE dbo.GIAOVIEN SET LUONG = 90000
WHERE MAGV = '006'
GO

SELECT * FROM TestView

-- Xóa View
DROP VIEW TestView

-- Update View
ALTER VIEW TestView AS
SELECT HOTEN FROM dbo.GIAOVIEN

-- Tạo View có dấu
CREATE VIEW [Giáo dục miễn phí] AS
SELECT * FROM dbo.KHOA

SELECT * FROM [Giáo dục miễn phí]

DROP VIEW [Giáo dục miễn phí]