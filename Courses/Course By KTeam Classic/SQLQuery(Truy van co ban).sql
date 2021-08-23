SELECT HOTEN + CAST(LUONG AS VARCHAR) 
FROM dbo.GIAOVIEN

SELECT * 
FROM dbo.DETAI
WHERE DATEDIFF(d,NGAYBD, '20020430') > 0

SELECT * FROM dbo.GIAOVIEN
EXCEPT
SELECT * FROM dbo.GIAOVIEN
WHERE PHAI = 'Nam'

SELECT * FROM dbo.GIAOVIEN AS GV JOIN dbo.BOMON AS BM
ON GV.MABM = BM.MABM

-- Với những đề tài thuộc cấp quản lý 'ĐHQG'
-- cho biết mã đề tài, đề tài thuộc chủ đề nào,
-- họ tên người chủ nhiệm đề tài cùng với ngày sinh và địa chỉ của người ấy
SELECT DT.MADT, CD.TENCD, GV.HOTEN, GV.NGAYSINH, GV.DIACHI
FROM dbo.DETAI DT JOIN dbo.CHUDE CD
ON DT.MACD = CD.MACD
JOIN dbo.GIAOVIEN GV
ON GV.MAGV = DT.GVCNDT
WHERE DT.CAPQL = N'ĐHQG'