SELECT COUNT(MAGV) AS SOLUONGGV FROM dbo.GIAOVIEN
WHERE MABM = 'HTTT'

-- Tính số lượng giáo viên có người quản lý về mặt chuyên môn
SELECT COUNT(HOTEN) FROM dbo.GIAOVIEN
WHERE GVQLCM IS NOT NULL

SELECT COUNT(HOTEN) FROM dbo.GIAOVIEN
WHERE GVQLCM IN (SELECT GV2.GVQLCM FROM dbo.GIAOVIEN AS GV2)

--

SELECT COUNT(DISTINCT(GVQLCM)) AS SOLUONGGV FROM dbo.GIAOVIEN
WHERE MABM = 'HTTT'

SELECT ROUND(AVG(LUONG), 2) FROM dbo.GIAOVIEN

-- GR BY
SELECT BM.MABM, COUNT(GV.MAGV) AS SLGIAOVIEN FROM dbo.BOMON AS BM JOIN dbo.GIAOVIEN GV
ON GV.MABM = BM.MABM
GROUP BY BM.MABM

-- HAVING
SELECT MABM FROM dbo.GIAOVIEN
WHERE LUONG >= 2000
GROUP BY MABM
HAVING COUNT(MAGV) >= 3

-- Truy vấn lồng
SELECT YEAR(NGAYBD), COUNT(MADT) FROM dbo.DETAI
GROUP BY YEAR(NGAYBD)

SELECT BM.TENBM, (SELECT COUNT(GV.MAGV) FROM dbo.GIAOVIEN GV
				  WHERE GV.MABM = BM.MABM)
FROM dbo.BOMON BM

SELECT * FROM (
				SELECT HOTEN, LUONG FROM dbo.GIAOVIEN
				WHERE MABM = 'HTTT'
				) KQ

SELECT MAGV, HOTEN, LUONG FROM dbo.GIAOVIEN
WHERE LUONG > ( SELECT GV2.LUONG FROM dbo.GIAOVIEN GV2
				WHERE GV2.MAGV = '001' )

SELECT MAGV, HOTEN, LUONG FROM dbo.GIAOVIEN
WHERE LUONG >= ALL ( SELECT GV2.LUONG FROM dbo.GIAOVIEN GV2 )

SELECT MAGV, HOTEN, LUONG FROM dbo.GIAOVIEN
WHERE LUONG = ( SELECT MAX(GV2.LUONG) FROM dbo.GIAOVIEN GV2 )

SELECT MAGV, HOTEN, LUONG FROM dbo.GIAOVIEN
WHERE MABM = 'HTTT' AND LUONG = ( SELECT MAX(GV2.LUONG) FROM dbo.GIAOVIEN GV2 )

SELECT MAGV, HOTEN FROM dbo.GIAOVIEN
WHERE MAGV = ANY ( SELECT TG.MAGV
				   FROM dbo.THAMGIADT TG)

SELECT GV.MAGV, GV.HOTEN FROM dbo.GIAOVIEN GV
WHERE EXISTS ( SELECT TG.MAGV FROM dbo.THAMGIADT TG
			   WHERE TG.MAGV = GV.MAGV)