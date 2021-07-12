USE HowKteam
GO

-- Join
SELECT * FROM dbo.GIAOVIEN JOIN dbo.BOMON
ON BOMON.MABM = GIAOVIEN.MABM

-- Left Join
-- Bảng bên phải nhập vào bảng bên trái
-- Record nào bảng bên phải không có thì sẽ để null
-- Record nào bảng bên trái không có thì không điền vào
SELECT * FROM dbo.GIAOVIEN LEFT JOIN dbo.BOMON
ON BOMON.MABM = GIAOVIEN.MABM

-- Right Join
SELECT * FROM dbo.GIAOVIEN RIGHT JOIN dbo.BOMON
ON BOMON.MABM = GIAOVIEN.MABM