USE master;
GO

CREATE DATABASE QuanLySinhVien;
GO

USE QuanLySinhVien;
GO

CREATE TABLE dbo.MonHoc
(
    MaMon CHAR(7) NOT NULL,
    TenMon NVARCHAR(35) NOT NULL,
    PRIMARY KEY (MaMon)
);
GO
INSERT INTO dbo.MonHoc
(
    MaMon,
    TenMon
)
VALUES
(   'DHU2021',   -- MaMon - char(7)
    N'Môn học 1' -- TenMon - nvarchar(35)
    );
INSERT INTO dbo.MonHoc
(
    MaMon,
    TenMon
)
VALUES
(   'ASU2021',   -- MaMon - char(7)
    N'Môn học 2' -- TenMon - nvarchar(35)
    );
INSERT INTO dbo.MonHoc
(
    MaMon,
    TenMon
)
VALUES
(   'KBB2021',   -- MaMon - char(7)
    N'Môn học 3' -- TenMon - nvarchar(35)
    );

CREATE TABLE dbo.GiaoVien
(
    MaGV CHAR(3) NOT NULL,
    TenGV NVARCHAR(15) NOT NULL,
    PRIMARY KEY (MaGV)
);
GO
INSERT INTO dbo.GiaoVien
(
    MaGV,
    TenGV
)
VALUES
(   '001',   -- MaGV - char(3)
    N'Hoàng' -- TenGV - nvarchar(15)
    );

INSERT INTO dbo.GiaoVien
(
    MaGV,
    TenGV
)
VALUES
(   '002',  -- MaGV - char(3)
    N'Thùy' -- TenGV - nvarchar(15)
    );

INSERT INTO dbo.GiaoVien
(
    MaGV,
    TenGV
)
VALUES
(   '003',  -- MaGV - char(3)
    N'Wang' -- TenGV - nvarchar(15)
    );

CREATE TABLE dbo.SinhVien
(
    MaSV CHAR(7),
    TenSV NVARCHAR(7),
    PRIMARY KEY (MaSV)
);
GO
INSERT INTO dbo.SinhVien
(
    MaSV,
    TenSV
)
VALUES
(   '1234567', -- MaSV - char(7)
    N'Hiếu'    -- TenSV - nvarchar(7)
    );

INSERT INTO dbo.SinhVien
(
    MaSV,
    TenSV
)
VALUES
(   '7654321', -- MaSV - char(7)
    N'Sơn'     -- TenSV - nvarchar(7)
    );

INSERT INTO dbo.SinhVien
(
    MaSV,
    TenSV
)
VALUES
(   '1345762', -- MaSV - char(7)
    N'Trang'   -- TenSV - nvarchar(7)
    );
GO

CREATE TABLE Day
(
    MaGV CHAR(3)
        REFERENCES dbo.GiaoVien (MaGV),
    MaMon CHAR(7)
        REFERENCES dbo.MonHoc (MaMon)
);
GO
INSERT INTO dbo.Day
(
    MaGV,
    MaMon
)
VALUES
(   '002',    -- MaGV - char(3)
    'ASU2021' -- MaMon - char(7)
    );

INSERT INTO dbo.Day
(
    MaGV,
    MaMon
)
VALUES
(   '001',    -- MaGV - char(3)
    'KBB2021' -- MaMon - char(7)
    );


INSERT INTO dbo.Day
(
    MaGV,
    MaMon
)
VALUES
(   '003',    -- MaGV - char(3)
    'DHU2021' -- MaMon - char(7)
    );


CREATE TABLE Hoc
(
    Diem TINYINT,
    MaSV CHAR(7)
        REFERENCES dbo.SinhVien (MaSV),
    MaMon CHAR(7)
        REFERENCES dbo.MonHoc (MaMon)
);
GO
INSERT INTO dbo.Hoc
(
    Diem,
    MaSV,
    MaMon
)
VALUES
(   6,  -- Diem - tinyint
    '1345762', -- MaSV - char(7)
    'KBB2021'  -- MaMon - char(7)
    )
	
INSERT INTO dbo.Hoc
(
    Diem,
    MaSV,
    MaMon
)
VALUES
(   6,  -- Diem - tinyint
    '7654321', -- MaSV - char(7)
    'DHU2021'  -- MaMon - char(7)
    )
	
INSERT INTO dbo.Hoc
(
    Diem,
    MaSV,
    MaMon
)
VALUES
(   6,  -- Diem - tinyint
    '1234567', -- MaSV - char(7)
    'ASU2021'  -- MaMon - char(7)
    )

INSERT INTO dbo.Hoc
(
    Diem,
    MaSV,
    MaMon
)
VALUES
(   8,  -- Diem - tinyint
    '1234567', -- MaSV - char(7)
    'ASU2021'  -- MaMon - char(7)
    )
GO

-- Xuất ra thông tin sinh viên học môn học nào
SELECT SV.MaSV, MH.TenMon FROM dbo.SinhVien AS SV, dbo.Hoc AS H, dbo.MonHoc AS MH
WHERE SV.MaSV = H.MaSV AND MH.MaMon = H.MaMon

SELECT SV.MaSV, MH.TenMon
FROM dbo.SinhVien AS SV INNER JOIN dbo.Hoc AS H
ON H.MaSV = SV.MaSV
JOIN dbo.MonHoc AS MH
ON MH.MaMon = H.MaMon
GO

SELECT * FROM dbo.Hoc

UPDATE dbo.Hoc SET Diem = 10 WHERE MaSV = '1234567'
AND MaMon = 'ASU2021'
GO

-- Xuất số lượng sinh viên học môn học
SELECT MH.TenMon AS N'Tên môn học', COUNT(*) AS N'Số lượng' FROM dbo.SinhVien AS SV, dbo.Hoc AS H, dbo.MonHoc AS MH
WHERE SV.MaSV = H.MaSV
AND H.MaMon = MH.MaMon
GROUP BY MH.MaMon, MH.TenMon

CREATE PROC proc_Select_Cau1
as
-- Xuất số lượng giáo viên dạy môn học
SELECT MH.TenMon AS N'Tên môn học', COUNT(*) AS N'Số lượng GV Dạy' FROM dbo.GiaoVien AS GV, dbo.Day AS D, dbo.MonHoc AS MH
WHERE GV.MaGV = D.MaGV
AND D.MaMon = MH.MaMon
GROUP BY MH.MaMon, MH.TenMon

EXEC proc_select_cau1