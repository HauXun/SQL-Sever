USE HowKteam
GO

-- Xuất ra số lượng giáo viên trong từng bộ môn mà số giáo viên > 2
-- Having -> như Where của Select nhưng dành cho Group by
SELECT dbo.BOMON.MABM, COUNT(*) FROM dbo.GIAOVIEN, dbo.BOMON
WHERE dbo.BOMON.MABM = dbo.GIAOVIEN.MABM
GROUP BY dbo.BOMON.MABM
HAVING COUNT(*) > 1

-- Xuất ra mức lương và tổng tuổi của giáo viên nhận mức lương đó
-- và có người thân, và tuổi phải lớn hơn tuổi trung bình
SELECT GV.LUONG, SUM(YEAR(GETDATE()) - YEAR(GV.NGSINH)) FROM dbo.GIAOVIEN AS GV, dbo.NGUOITHAN AS NT
WHERE GV.MAGV = NT.MAGV
AND GV.MAGV IN (
	SELECT MAGV FROM dbo.NGUOITHAN
)
GROUP BY GV.LUONG, GV.NGSINH
HAVING YEAR(GETDATE() - YEAR(GV.NGSINH)) > (
	(SELECT SUM(YEAR(GETDATE()) - YEAR(GV.NGSINH)) FROM dbo.GIAOVIEN) / 
	(SELECT COUNT(*) FROM dbo.GIAOVIEN)
)