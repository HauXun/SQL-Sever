USE HowKteam
GO

-- Insert Into Select -> Copy dữ liệu vào bảng đã tồn tại
SELECT * INTO CloneGV
FROM dbo.GIAOVIEN
WHERE 1 = 0

INSERT INTO CloneGV
SELECT * FROM dbo.GIAOVIEN

SELECT * FROM dbo.CloneGV