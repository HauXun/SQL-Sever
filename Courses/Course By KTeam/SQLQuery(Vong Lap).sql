USE HowKteam
GO

DECLARE @i INT = 0
DECLARE @n INT = 10000

-- While (Điều kiện thực hiện) -> Khối lệnh thực hiện
WHILE (@i < @n)
BEGIN
	PRINT @i
	SET @i += 1
END

-- While (Điều kiện thực hiện) -> Khối lệnh thực hiện
WHILE (@i < @n)
BEGIN
	INSERT dbo.BOMON
	(
	    MABM,
	    TENBM,
	    PHONG,
	    DIENTHOAI,
	    TRUONGBM,
	    MAKHOA,
	    NGAYNHANCHUC
	)
	VALUES
	(   @i,      -- MABM - nchar(4)
	    @i,      -- TENBM - nchar(50)
	    'B15',       -- PHONG - char(3)
	    '0000000',       -- DIENTHOAI - char(11)
	    NULL,      -- TRUONGBM - nchar(3)
	    N'CNTT',      -- MAKHOA - nchar(4)
	    GETDATE() -- NGAYNHANCHUC - date
	    )
END