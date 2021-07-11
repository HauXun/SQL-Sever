USE HowKteam
GO

-- Inner Join kiểu cũ -> có thể sau này không còn được hổ trợ
-- Mọi Join cần điều kiện
SELECT * FROM dbo.GIAOVIEN, dbo.BOMON
WHERE dbo.BOMON.MABM = dbo.GIAOVIEN.MABM

-- Inner Join kiểu mới đúng chuẩn
SELECT * FROM dbo.GIAOVIEN INNER JOIN dbo.BOMON
ON BOMON.MABM = GIAOVIEN.MABM
AND dbo.BOMON.TRUONGBM = ''
GO

-- Có thể viết tắt Inner Join -> Join
SELECT * FROM dbo.KHOA JOIN dbo.BOMON
ON BOMON.MAKHOA = KHOA.MAKHOA