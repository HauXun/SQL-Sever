USE HowKteam
GO

-- Kiểu dữ liệu tự định nghĩa
-- EXEC sp_addtype 'Tên kiểu dữ liệu', 'Kiểu dữ liệu thực tế', 'Not null' (có hay không đều được)
EXEC sys.sp_addtype @typename = 'NNAME', -- sysname
                    @phystype = 'nvarchar(100)', -- sysname
                    @nulltype = 'Not null',   -- varchar(8)
                    @owner = NULL     -- sysname
GO

CREATE TABLE TestType
(
	Name NNAME,
	Address NVARCHAR(500)
)
GO

EXEC sys.sp_addtype @typename = 'NADDRESS', -- sysname
                    @phystype = 'nvarchar(100)', -- sysname
                    @nulltype = 'NULL',   -- varchar(8)
                    @owner = NULL     -- sysname
GO

-- Xóa type
EXEC sys.sp_droptype 'NNAME'