-- Lưu ý. Chạy script Query trước khi chạy thử script này
USE HowKteam
GO


-- Cấu trúc truy vấn

-- Lấy hết dữ liệu trong bảng bộ môn ra
SELECT * FROM dbo.BOMON

-- Lấy mã bộ môn + tên bộ môn trong bảng bộ môn
SELECT MABM, TENBM FROM dbo.BOMON

-- Đổi tên cột khi hiển thị
SELECT MABM AS N'Có súng đây nè!', TENBM AS 'Thằng Hai Zụ á!' FROM dbo.BOMON

-- Xuất ra mã giáo viên + Tên + Tên bộ môn giáo viên đó dạy
SELECT GV.MAGV, GV.HOTEN, BM.TENBM
FROM dbo.BOMON AS BM, dbo.GIAOVIEN AS GV

-----------------
-- Truy xuất thông tin của bảng Tham gia đề tài
SELECT * FROM dbo.THAMGIADT

-- Lấy ra mã khoa và tên khoa tương ứng
SELECT MAKHOA, TENKHOA FROM dbo.KHOA

-- Lấy ra mã giáo viên, tên giáo viên và họ tên người thân tương ứng
SELECT GV.MAGV, GV.HOTEN, NT.TEN AS N'Người thân' FROM dbo.GIAOVIEN AS GV, dbo.NGUOITHAN AS NT

-- Lấy ra mã giáo viên, tên giáo viên, và tên khoa của
-- giáo viên đó đang làm việc
SELECT GV.MAGV, GV.HOTEN, K.TENKHOA FROM dbo.GIAOVIEN AS GV, dbo.BOMON AS BM, dbo.KHOA AS K