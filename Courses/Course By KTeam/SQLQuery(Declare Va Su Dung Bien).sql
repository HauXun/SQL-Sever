USE HowKteam
GO

-- Tìm ra mã giáo viên có lương cao nhất
SELECT MAGV FROM dbo.GIAOVIEN
WHERE LUONG = (
	SELECT MAX(LUONG) FROM dbo.GIAOVIEN
)
GO

-- Lấy ra tuổi của giáo viên với MAGV = '001'
SELECT YEAR(GETDATE()) - YEAR(NGSINH) FROM dbo.GIAOVIEN WHERE MAGV = '001'
GO

---------------------------------------------------------------------------

-- Tạo ra một biến kiểu char lưu mã giáo viên lương thấp nhất
DECLARE @MaxSalaryMaGV CHAR(10)

SELECT @MaxSalaryMaGV = MAGV FROM dbo.GIAOVIEN
WHERE LUONG = (
	SELECT MAX(LUONG) FROM dbo.GIAOVIEN
)

SELECT YEAR(GETDATE()) - YEAR(NGSINH) FROM dbo.GIAOVIEN
WHERE MAGV = @MaxSalaryMaGV
GO

---------------------------------------------------------------------------

-- Biến bắt đầu bằng ký hiệu '@'

-- Khởi tạo với kiểu dữ liệu
DECLARE @i INT

-- Khởi tạo với giá trị mặc định
DECLARE @j INT = 0

-- SET dữ liệu cho biến
SET @i = @i + 1
SET @i += 1
SET @j *= @i

-- SET thông qua câu select
DECLARE @MaxLuong INT
SELECT @MaxLuong = MAX(LUONG) FROM dbo.GIAOVIEN

---------------------------------------------------------------------------

-- Xuất ra số lượng người thân của giáo viên '001'
-- Lưu mã giáo viên '001' lại
-- Tìm ra số lượng người thân tương ứng mã giáo viên
DECLARE @MaGV CHAR(10) = '001'
SELECT COUNT(*) FROM dbo.NGUOITHAN
WHERE MAGV = @MaGV

-- Xuất ra tên của giáo viên có lương thấp nhất
DECLARE @MinLuong INT = (SELECT MIN(LUONG) FROM dbo.GIAOVIEN)

DECLARE @TenGV NVARCHAR(100)
SELECT @TenGV = HOTEN FROM dbo.GIAOVIEN
WHERE LUONG = @MinLuong

-- Xuất giá trị đơn ra màn hình
PRINT @TenGV