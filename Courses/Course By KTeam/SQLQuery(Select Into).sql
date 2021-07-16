USE HowKteam
GO

-- Lấy hết dữ liệu của bảng Giáo viên đưa vào bảng mới tên là TableA
-- Bảng này có các record tương ứng như bảng Giáo viên
SELECT * INTO TabelA
FROM dbo.GIAOVIEN

-- Tạo ra một bảng TableB mới. Có một cột dữ liệu là họ tên tương ứng như bảng Giáo viên
-- Dữ liệu của bảng TableB lấy từ bảng Giáo viên ra
SELECT HoTen INTO TableB
FROM dbo.GIAOVIEN

-- Tạo ra một bảng TableC mới. Có một cột dữ liệu là họ tên tương ứng như bảng Giáo viên
-- Với điều kiện Lương > 2000
-- Dữ liệu của bảng TableC lấy từ bảng Giáo viên ra
SELECT HoTen INTO TableC
FROM dbo.GIAOVIEN
WHERE LUONG > 2000

-- Tạo ra một bảng mới từ nhiều bảng
SELECT MAGV, HOTEN, TENBM INTO TableD
FROM dbo.GIAOVIEN JOIN dbo.BOMON
ON BOMON.MABM = GIAOVIEN.MABM

-- Tạo ra một bảng TableE từ bảng Giáo viên nhưng không có dữ liệu
SELECT * INTO TabelE
FROM dbo.GIAOVIEN
WHERE 6 > 9