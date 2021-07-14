USE HowKteam
GO

-- Xuất ra thông tin giáo viên tên bắt đầu bằng chữ 'l'
SELECT * FROM dbo.GIAOVIEN
WHERE HOTEN LIKE 'l%'

-- Xuất ra thông tin giáo viên kết thúc bằng chữ 'n'
SELECT * FROM dbo.GIAOVIEN
WHERE HOTEN LIKE '%n'

-- Xuất ra thông tin giáo viên có tồn tại chữ 'n'
SELECT * FROM dbo.GIAOVIEN
WHERE HOTEN LIKE '%n%'

-- Xuất ra thông tin giáo viên có tồn tại chữ 'ế'
SELECT * FROM dbo.GIAOVIEN
WHERE HOTEN LIKE N'%ế%'