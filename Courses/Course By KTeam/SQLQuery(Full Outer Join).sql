USE HowKteam
GO

SELECT * FROM dbo.GIAOVIEN INNER JOIN dbo.BOMON
ON BOMON.MABM = GIAOVIEN.MABM

-- Full Outer Join
-- Gom 2 bảng lại và có điều kiện
-- Bên nào không có dữ liệu thì để null
SELECT * FROM dbo.GIAOVIEN FULL OUTER JOIN dbo.BOMON
ON BOMON.MABM = GIAOVIEN.MABM

-- Cross Join là tổ hợp mỗi record của bảng A với all record của bảng B
SELECT * FROM dbo.GIAOVIEN CROSS JOIN dbo.BOMON