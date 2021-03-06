USE [master]
GO
/****** Object:  Database [HowKteam]    Script Date: 6/30/2021 9:29:43 PM ******/
CREATE DATABASE [HowKteam]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HowKteam', FILENAME = N'D:\Document\SQL\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\HowKteam.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HowKteam_log', FILENAME = N'D:\Document\SQL\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\HowKteam_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [HowKteam] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HowKteam].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HowKteam] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HowKteam] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HowKteam] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HowKteam] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HowKteam] SET ARITHABORT OFF 
GO
ALTER DATABASE [HowKteam] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [HowKteam] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HowKteam] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HowKteam] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HowKteam] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HowKteam] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HowKteam] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HowKteam] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HowKteam] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HowKteam] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HowKteam] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HowKteam] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HowKteam] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HowKteam] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HowKteam] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HowKteam] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HowKteam] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HowKteam] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HowKteam] SET  MULTI_USER 
GO
ALTER DATABASE [HowKteam] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HowKteam] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HowKteam] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HowKteam] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HowKteam] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [HowKteam] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [HowKteam] SET QUERY_STORE = OFF
GO
USE [HowKteam]
GO
/****** Object:  Table [dbo].[BOMON]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BOMON](
	[MABM] [nchar](4) NOT NULL,
	[TENBM] [nchar](50) NULL,
	[PHONG] [char](3) NULL,
	[DIENTHOAI] [char](11) NULL,
	[TRUONGBM] [nchar](3) NULL,
	[MAKHOA] [nchar](4) NULL,
	[NGAYNHANCHUC] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[MABM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHUDE]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHUDE](
	[MACD] [nchar](4) NOT NULL,
	[TENCD] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[MACD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CONGVIEC]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONGVIEC](
	[MADT] [nchar](4) NOT NULL,
	[SOTT] [int] NOT NULL,
	[TENCV] [nvarchar](50) NULL,
	[NGAYBD] [datetime] NULL,
	[NGAYKT] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MADT] ASC,
	[SOTT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETAI]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETAI](
	[MADT] [nchar](4) NOT NULL,
	[TENDT] [nvarchar](50) NULL,
	[CAPQL] [nchar](20) NULL,
	[KINHPHI] [float] NULL,
	[NGAYBD] [date] NULL,
	[NGAYKT] [date] NULL,
	[MACD] [nchar](4) NULL,
	[GVCNDT] [nchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[MADT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GIAOVIEN]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAOVIEN](
	[MAGV] [nchar](3) NOT NULL,
	[HOTEN] [nvarchar](50) NULL,
	[LUONG] [float] NULL,
	[PHAI] [nchar](3) NULL,
	[NGSINH] [date] NULL,
	[DIACHI] [nchar](50) NULL,
	[GVQLCM] [nchar](3) NULL,
	[MABM] [nchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GV_DT]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GV_DT](
	[MAGV] [nchar](3) NOT NULL,
	[DIENTHOAI] [char](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC,
	[DIENTHOAI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHOA]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHOA](
	[MAKHOA] [nchar](4) NOT NULL,
	[TENKHOA] [nvarchar](50) NULL,
	[NAMTL] [int] NULL,
	[PHONG] [char](3) NULL,
	[DIENTHOAI] [char](10) NULL,
	[TRUONGKHOA] [nchar](3) NULL,
	[NGAYNHANCHUC] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[MAKHOA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NGUOITHAN]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NGUOITHAN](
	[MAGV] [nchar](3) NOT NULL,
	[TEN] [nchar](12) NOT NULL,
	[NGSINH] [datetime] NULL,
	[PHAI] [nchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC,
	[TEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[THAMGIADT]    Script Date: 6/30/2021 9:29:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THAMGIADT](
	[MAGV] [nchar](3) NOT NULL,
	[MADT] [nchar](4) NOT NULL,
	[STT] [int] NOT NULL,
	[PHUCAP] [float] NULL,
	[KETQUA] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC,
	[MADT] ASC,
	[STT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'CNTT', N'Công nghệ tri thức                                ', N'B15', N'0838126126 ', NULL, N'CNTT', NULL)
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'HHC ', N'Hóa hữu cơ                                        ', N'B44', N'0838222222 ', NULL, N'HH  ', NULL)
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'HL  ', N'Hóa Lý                                            ', N'B42', N'0838878787 ', NULL, N'HH  ', NULL)
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'HPT ', N'Hóa phân tích                                     ', N'B43', N'0838777777 ', N'007', N'HH  ', CAST(N'2007-10-15' AS Date))
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'HTTT', N'Hệ thống thông tin                                ', N'B13', N'0838125125 ', N'002', N'CNTT', CAST(N'2004-09-20' AS Date))
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'MMT ', N'Mạng máy tính                                     ', N'B16', N'0838676767 ', N'001', N'CNTT', CAST(N'2005-05-15' AS Date))
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'SH  ', N'Sinh hóa                                          ', N'B33', N'0838898989 ', NULL, N'SH  ', NULL)
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'VLĐT', N'Vật lý điện tử                                    ', N'B23', N'0838234234 ', NULL, N'VL  ', NULL)
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'VLUD', N'Vật lý ứng dụng                                   ', N'B24', N'0838454545 ', N'005', N'VL  ', CAST(N'2006-02-18' AS Date))
INSERT [dbo].[BOMON] ([MABM], [TENBM], [PHONG], [DIENTHOAI], [TRUONGBM], [MAKHOA], [NGAYNHANCHUC]) VALUES (N'VS  ', N'Vi Sinh                                           ', N'B32', N'0838909090 ', N'004', N'SH  ', CAST(N'2007-01-01' AS Date))
GO
INSERT [dbo].[CHUDE] ([MACD], [TENCD]) VALUES (N'NCPT', N'Nghiên cứu phát triển')
INSERT [dbo].[CHUDE] ([MACD], [TENCD]) VALUES (N'QLGD', N'Quản lý giáo dục')
INSERT [dbo].[CHUDE] ([MACD], [TENCD]) VALUES (N'UDCN', N'Ứng dụng công nghệ')
GO
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'001 ', 1, N'Khởi tạo và Lập kế hoạch', CAST(N'2007-10-20T00:00:00.000' AS DateTime), CAST(N'2008-12-20T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'001 ', 2, N'Xác định yêu cầu', CAST(N'2008-12-21T00:00:00.000' AS DateTime), CAST(N'2008-03-21T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'001 ', 3, N'Phân tích hệ thống', CAST(N'2008-03-22T00:00:00.000' AS DateTime), CAST(N'2008-05-22T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'001 ', 4, N'Thiết kế hệ thống', CAST(N'2008-05-23T00:00:00.000' AS DateTime), CAST(N'2008-06-23T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'001 ', 5, N'Cài đặt thử nghiệm', CAST(N'2008-06-24T00:00:00.000' AS DateTime), CAST(N'2008-10-20T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'002 ', 1, N'Khởi tạo và lập kế hoạch', CAST(N'2009-05-10T00:00:00.000' AS DateTime), CAST(N'2009-07-10T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'002 ', 2, N'Xác định yêu cầu', CAST(N'2009-07-11T00:00:00.000' AS DateTime), CAST(N'2009-10-11T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'002 ', 3, N'Phân tích hệ thống', CAST(N'2009-10-12T00:00:00.000' AS DateTime), CAST(N'2009-12-20T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'002 ', 4, N'Thiết kế hệ thống', CAST(N'2009-12-21T00:00:00.000' AS DateTime), CAST(N'2010-03-22T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'002 ', 5, N'Cài đặt thử nghiệm', CAST(N'2010-03-23T00:00:00.000' AS DateTime), CAST(N'2010-05-10T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'006 ', 1, N'Lấy mẫu', CAST(N'2006-10-20T00:00:00.000' AS DateTime), CAST(N'2007-02-20T00:00:00.000' AS DateTime))
INSERT [dbo].[CONGVIEC] ([MADT], [SOTT], [TENCV], [NGAYBD], [NGAYKT]) VALUES (N'006 ', 2, N'Nuôi cấy', CAST(N'2007-02-21T00:00:00.000' AS DateTime), CAST(N'2008-09-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[DETAI] ([MADT], [TENDT], [CAPQL], [KINHPHI], [NGAYBD], [NGAYKT], [MACD], [GVCNDT]) VALUES (N'001 ', N'HTTT quản lý các trường ĐH', N'ĐHQG                ', 20, CAST(N'2007-10-20' AS Date), CAST(N'2008-10-20' AS Date), N'QLGD', N'002')
INSERT [dbo].[DETAI] ([MADT], [TENDT], [CAPQL], [KINHPHI], [NGAYBD], [NGAYKT], [MACD], [GVCNDT]) VALUES (N'002 ', N'HTTT quản lý giáo vụ cho một Khoa', N'Trường              ', 20, CAST(N'2000-10-12' AS Date), CAST(N'2001-10-12' AS Date), N'QLGD', N'002')
INSERT [dbo].[DETAI] ([MADT], [TENDT], [CAPQL], [KINHPHI], [NGAYBD], [NGAYKT], [MACD], [GVCNDT]) VALUES (N'003 ', N'Nghiên cứu chế tạo sợi Nanô Platin', N'ĐHQG                ', 300, CAST(N'2008-05-15' AS Date), CAST(N'2010-05-15' AS Date), N'NCPT', N'005')
INSERT [dbo].[DETAI] ([MADT], [TENDT], [CAPQL], [KINHPHI], [NGAYBD], [NGAYKT], [MACD], [GVCNDT]) VALUES (N'004 ', N'Tạo vật liệu sinh học bằng màng ối người', N'Nhà nước            ', 100, CAST(N'2007-01-01' AS Date), CAST(N'2009-12-31' AS Date), N'NCPT', N'004')
INSERT [dbo].[DETAI] ([MADT], [TENDT], [CAPQL], [KINHPHI], [NGAYBD], [NGAYKT], [MACD], [GVCNDT]) VALUES (N'005 ', N'Ứng dụng hóa học xanh', N'Trường              ', 200, CAST(N'2003-10-10' AS Date), CAST(N'2004-12-10' AS Date), N'UDCN', N'007')
INSERT [dbo].[DETAI] ([MADT], [TENDT], [CAPQL], [KINHPHI], [NGAYBD], [NGAYKT], [MACD], [GVCNDT]) VALUES (N'006 ', N'Nghiên cứu tế bào gốc', N'Nhà nước            ', 4000, CAST(N'2006-10-12' AS Date), CAST(N'2009-10-12' AS Date), N'NCPT', N'004')
INSERT [dbo].[DETAI] ([MADT], [TENDT], [CAPQL], [KINHPHI], [NGAYBD], [NGAYKT], [MACD], [GVCNDT]) VALUES (N'007 ', N'HTTT quản lý thư viện ở các trường ĐH', N'Trường              ', 20, CAST(N'2009-05-10' AS Date), CAST(N'2010-05-10' AS Date), N'QLGD', N'001')
GO
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'001', N'Nguyễn Hoài An', 2000, N'Nam', CAST(N'1973-02-15' AS Date), N'25/3 Lạc Long Quân, Q.10,TP HCM                   ', NULL, N'MMT ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'002', N'Trần Trà Hương', 2500, N'Nữ ', CAST(N'1960-06-20' AS Date), N'125 Trần Hưng Đạo, Q.1, TP HCM                    ', NULL, N'HTTT')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'003', N'Nguyễn Ngọc Ánh', 2200, N'Nữ ', CAST(N'1975-05-11' AS Date), N'12/21 Võ Văn Ngân Thủ Đức, TP HCM                 ', N'002', N'HTTT')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'004', N'Trương Nam Sơn', 2300, N'Nam', CAST(N'1959-06-20' AS Date), N'215 Lý Thường Kiệt,TP Biên Hòa                    ', NULL, N'VS  ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'005', N'Lý Hoàng Hà', 2500, N'Nam', CAST(N'1954-10-23' AS Date), N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM              ', NULL, N'VLĐT')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'006', N'Trần Bạch Tuyết', 1500, N'Nữ ', CAST(N'1980-05-20' AS Date), N'127 Hùng Vương, TP Mỹ Tho                         ', N'004', N'VS  ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'007', N'Nguyễn An Trung', 2100, N'Nam', CAST(N'1976-06-05' AS Date), N'234 3/2, TP Biên Hòa                              ', NULL, N'HPT ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'008', N'Trần Trung Hiếu', 1800, N'Nam', CAST(N'1977-08-06' AS Date), N'22/11 Lý Thường Kiệt,TP Mỹ Tho                    ', N'007', N'HPT ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'009', N'Trần Hoàng nam', 2000, N'Nam', CAST(N'1975-11-22' AS Date), N'234 Trấn Não,An Phú, TP HCM                       ', N'001', N'MMT ')
INSERT [dbo].[GIAOVIEN] ([MAGV], [HOTEN], [LUONG], [PHAI], [NGSINH], [DIACHI], [GVQLCM], [MABM]) VALUES (N'010', N'Phạm Nam Thanh', 1500, N'Nam', CAST(N'1980-12-12' AS Date), N'221 Hùng Vương,Q.5, TP HCM                        ', N'007', N'HPT ')
GO
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'001', N'0838912112')
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'001', N'0903123123')
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'002', N'0913454545')
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'003', N'0838121212')
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'003', N'0903656565')
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'003', N'0937125125')
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'006', N'0937888888')
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'008', N'0653717171')
INSERT [dbo].[GV_DT] ([MAGV], [DIENTHOAI]) VALUES (N'008', N'0913232323')
GO
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [NAMTL], [PHONG], [DIENTHOAI], [TRUONGKHOA], [NGAYNHANCHUC]) VALUES (N'CNTT', N'Công nghệ thông tin', 1995, N'B11', N'0838123456', N'002', CAST(N'2005-02-20T00:00:00.000' AS DateTime))
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [NAMTL], [PHONG], [DIENTHOAI], [TRUONGKHOA], [NGAYNHANCHUC]) VALUES (N'HH  ', N'Hóa học', 1980, N'B41', N'0838456456', N'007', CAST(N'2001-10-15T00:00:00.000' AS DateTime))
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [NAMTL], [PHONG], [DIENTHOAI], [TRUONGKHOA], [NGAYNHANCHUC]) VALUES (N'SH  ', N'Sinh học', 1980, N'B31', N'0838454545', N'004', CAST(N'2000-10-11T00:00:00.000' AS DateTime))
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [NAMTL], [PHONG], [DIENTHOAI], [TRUONGKHOA], [NGAYNHANCHUC]) VALUES (N'VL  ', N'Vật lý', 1976, N'B21', N'0838223223', N'005', CAST(N'2003-09-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'001', N'Hùng        ', CAST(N'1990-01-14T00:00:00.000' AS DateTime), N'Nam')
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'001', N'Thủy        ', CAST(N'1994-12-08T00:00:00.000' AS DateTime), N'Nữ ')
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'003', N'Hà          ', CAST(N'1998-09-03T00:00:00.000' AS DateTime), N'Nữ ')
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'003', N'Thu         ', CAST(N'1998-09-03T00:00:00.000' AS DateTime), N'Nữ ')
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'007', N'Mai         ', CAST(N'2003-03-26T00:00:00.000' AS DateTime), N'Nữ ')
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'007', N'Vy          ', CAST(N'2000-02-14T00:00:00.000' AS DateTime), N'Nữ ')
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'008', N'Nam         ', CAST(N'1991-05-06T00:00:00.000' AS DateTime), N'Nam')
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'009', N'An          ', CAST(N'1996-08-19T00:00:00.000' AS DateTime), N'Nam')
INSERT [dbo].[NGUOITHAN] ([MAGV], [TEN], [NGSINH], [PHAI]) VALUES (N'010', N'Nguyệt      ', CAST(N'2006-01-14T00:00:00.000' AS DateTime), N'Nữ ')
GO
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'001', N'002 ', 1, 0, NULL)
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'001', N'002 ', 2, 2, NULL)
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'002', N'001 ', 4, 2, N'Đạt')
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'003', N'001 ', 1, 1, N'Đạt')
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'003', N'001 ', 2, 0, N'Đạt')
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'003', N'001 ', 4, 1, N'Đạt')
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'003', N'002 ', 2, 0, NULL)
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'004', N'006 ', 1, 0, N'Đạt')
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'004', N'006 ', 2, 1, N'Đạt')
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'006', N'006 ', 2, 1.5, N'Đạt')
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'009', N'002 ', 3, 0.5, NULL)
INSERT [dbo].[THAMGIADT] ([MAGV], [MADT], [STT], [PHUCAP], [KETQUA]) VALUES (N'009', N'002 ', 4, 1.5, NULL)
GO
ALTER TABLE [dbo].[BOMON]  WITH CHECK ADD  CONSTRAINT [FK_HG10_MAKHOA] FOREIGN KEY([MAKHOA])
REFERENCES [dbo].[KHOA] ([MAKHOA])
GO
ALTER TABLE [dbo].[BOMON] CHECK CONSTRAINT [FK_HG10_MAKHOA]
GO
ALTER TABLE [dbo].[BOMON]  WITH CHECK ADD  CONSTRAINT [FK_HG11_TRUONGBM] FOREIGN KEY([TRUONGBM])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
GO
ALTER TABLE [dbo].[BOMON] CHECK CONSTRAINT [FK_HG11_TRUONGBM]
GO
ALTER TABLE [dbo].[CONGVIEC]  WITH CHECK ADD  CONSTRAINT [FK_HG2_MADT] FOREIGN KEY([MADT])
REFERENCES [dbo].[DETAI] ([MADT])
GO
ALTER TABLE [dbo].[CONGVIEC] CHECK CONSTRAINT [FK_HG2_MADT]
GO
ALTER TABLE [dbo].[DETAI]  WITH CHECK ADD  CONSTRAINT [FK_HG3_MACD] FOREIGN KEY([MACD])
REFERENCES [dbo].[CHUDE] ([MACD])
GO
ALTER TABLE [dbo].[DETAI] CHECK CONSTRAINT [FK_HG3_MACD]
GO
ALTER TABLE [dbo].[DETAI]  WITH CHECK ADD  CONSTRAINT [FK_HG4_GVCNDT] FOREIGN KEY([GVCNDT])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
GO
ALTER TABLE [dbo].[DETAI] CHECK CONSTRAINT [FK_HG4_GVCNDT]
GO
ALTER TABLE [dbo].[GIAOVIEN]  WITH CHECK ADD  CONSTRAINT [FK_HG6_GVQLCM] FOREIGN KEY([GVQLCM])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
GO
ALTER TABLE [dbo].[GIAOVIEN] CHECK CONSTRAINT [FK_HG6_GVQLCM]
GO
ALTER TABLE [dbo].[GIAOVIEN]  WITH CHECK ADD  CONSTRAINT [FK_HG9_MABM] FOREIGN KEY([MABM])
REFERENCES [dbo].[BOMON] ([MABM])
GO
ALTER TABLE [dbo].[GIAOVIEN] CHECK CONSTRAINT [FK_HG9_MABM]
GO
ALTER TABLE [dbo].[GV_DT]  WITH CHECK ADD  CONSTRAINT [FK_HG12_MAGV] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
GO
ALTER TABLE [dbo].[GV_DT] CHECK CONSTRAINT [FK_HG12_MAGV]
GO
ALTER TABLE [dbo].[KHOA]  WITH CHECK ADD  CONSTRAINT [FK_HG7_TRUONGKHOA] FOREIGN KEY([TRUONGKHOA])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
GO
ALTER TABLE [dbo].[KHOA] CHECK CONSTRAINT [FK_HG7_TRUONGKHOA]
GO
ALTER TABLE [dbo].[NGUOITHAN]  WITH CHECK ADD  CONSTRAINT [FK_HG8_MAGV] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
GO
ALTER TABLE [dbo].[NGUOITHAN] CHECK CONSTRAINT [FK_HG8_MAGV]
GO
ALTER TABLE [dbo].[THAMGIADT]  WITH CHECK ADD  CONSTRAINT [FK_HG1_MADT] FOREIGN KEY([MADT], [STT])
REFERENCES [dbo].[CONGVIEC] ([MADT], [SOTT])
GO
ALTER TABLE [dbo].[THAMGIADT] CHECK CONSTRAINT [FK_HG1_MADT]
GO
ALTER TABLE [dbo].[THAMGIADT]  WITH CHECK ADD  CONSTRAINT [FK_HG5_MAGV] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIAOVIEN] ([MAGV])
GO
ALTER TABLE [dbo].[THAMGIADT] CHECK CONSTRAINT [FK_HG5_MAGV]
GO
USE [master]
GO
ALTER DATABASE [HowKteam] SET  READ_WRITE 
GO
