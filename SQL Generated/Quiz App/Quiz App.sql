USE [master]
GO
/****** Object:  Database [TestProjectDB]    Script Date: 12/2/2021 3:00:26 PM ******/
CREATE DATABASE [TestProjectDB]
GO
ALTER DATABASE [TestProjectDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TestProjectDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TestProjectDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TestProjectDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TestProjectDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TestProjectDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TestProjectDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TestProjectDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [TestProjectDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TestProjectDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TestProjectDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TestProjectDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TestProjectDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TestProjectDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TestProjectDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TestProjectDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TestProjectDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TestProjectDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TestProjectDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TestProjectDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TestProjectDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TestProjectDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TestProjectDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TestProjectDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TestProjectDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TestProjectDB] SET  MULTI_USER 
GO
ALTER DATABASE [TestProjectDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TestProjectDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TestProjectDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TestProjectDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TestProjectDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TestProjectDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [TestProjectDB] SET QUERY_STORE = OFF
GO
USE [TestProjectDB]
GO
/****** Object:  UserDefinedFunction [dbo].[fuConvertToUnsign]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fuConvertToUnsign] 
( @strInput NVARCHAR(4000) ) 
RETURNS
NVARCHAR(4000) 
AS
BEGIN 
	IF (@strInput IS NULL)
	RETURN @strInput 
	
	IF (@strInput = '')
	RETURN @strInput 
	
	DECLARE @RT NVARCHAR(4000)
	DECLARE @SIGN_CHARS NCHAR(136) 
	DECLARE @UNSIGN_CHARS NCHAR (136) 
	
	SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272) + NCHAR(208)
	SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'

	DECLARE @COUNTER INT 
	DECLARE @COUNTER1 INT

	SET @COUNTER = 1 
	WHILE (@COUNTER <= LEN(@strInput)) 
	BEGIN 
		SET @COUNTER1 = 1 
		WHILE (@COUNTER1 <= LEN(@SIGN_CHARS) + 1) 
		BEGIN 
			IF (UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1, 1)) = UNICODE(SUBSTRING(@strInput, @COUNTER, 1) )) 
			BEGIN 
				IF (@COUNTER = 1)
					SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1, 1) + SUBSTRING(@strInput, @COUNTER + 1, LEN(@strInput) - 1) 
				ELSE 
					SET @strInput = SUBSTRING(@strInput, 1, @COUNTER - 1) + SUBSTRING(@UNSIGN_CHARS, @COUNTER1, 1) + SUBSTRING(@strInput, @COUNTER + 1, LEN(@strInput) - @COUNTER)
					BREAK
			END 
			SET @COUNTER1 += 1 
		END 
		SET @COUNTER += 1 
	END
	SET @strInput = REPLACE(@strInput, ' ', '-') 
	RETURN @strInput 
END
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GetEduProgIDMissing]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FUNC_GetEduProgIDMissing] (@EduProgID INT)
RETURNS INT
AS
BEGIN
	WHILE EXISTS (	SELECT EProgID FROM dbo.EduProg WHERE EProgID = @EduProgID)
	BEGIN
	    SET @EduProgID += 1
	END
	RETURN @EduProgID
END
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GetTestHistoryIDMissing]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FUNC_GetTestHistoryIDMissing] (@TestID INT)
RETURNS INT
AS
BEGIN
	WHILE EXISTS (	SELECT TestID FROM dbo.TestHistory WHERE TestID = @TestID)
	BEGIN
	    SET @TestID += 1
	END
	RETURN @TestID
END
GO
/****** Object:  Table [dbo].[CourseOrder]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseOrder](
	[CourseID] [varchar](50) NOT NULL,
	[FacultyID] [varchar](50) NOT NULL,
	[TrainingID] [varchar](50) NULL,
	[Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_CourseOrder] PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC,
	[FacultyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EduProg]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EduProg](
	[EProgID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[CourseID] [varchar](50) NOT NULL,
	[FacultyID] [varchar](50) NOT NULL,
	[SemesterID] [tinyint] NOT NULL,
	[SubjectID] [varchar](50) NOT NULL,
	[TotalMark] [float] NULL,
	[Success] [bit] NULL,
 CONSTRAINT [PK_EduProg_1] PRIMARY KEY CLUSTERED 
(
	[EProgID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EP_TFMark]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EP_TFMark](
	[UserID] [int] NOT NULL,
	[SubjectID] [varchar](50) NOT NULL,
	[TestFormID] [varchar](50) NOT NULL,
	[Mark] [float] NULL,
 CONSTRAINT [PK_EP_TFMark] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[SubjectID] ASC,
	[TestFormID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exam]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exam](
	[ExamID] [varchar](50) NOT NULL,
	[SubjectID] [varchar](50) NOT NULL,
	[TestFormID] [varchar](50) NULL,
	[PercentMark] [tinyint] NULL,
	[ExamRole] [varchar](50) NULL,
	[ExamTime] [tinyint] NULL,
	[QCount] [smallint] NULL,
	[QCurrentCount] [smallint] NULL,
	[QuizTimes] [tinyint] NULL,
	[Status] [bit] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedAt] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedAt] [datetime] NULL,
 CONSTRAINT [PK_Exam] PRIMARY KEY CLUSTERED 
(
	[ExamID] ASC,
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExamRole]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExamRole](
	[RoleID] [varchar](50) NOT NULL,
	[RoleName] [nvarchar](50) NULL,
	[Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_ExamRole] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Faculty]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculty](
	[FacultyID] [varchar](50) NOT NULL,
	[FacultyName] [nvarchar](200) NULL,
	[FoundingDate] [date] NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_Faculty] PRIMARY KEY CLUSTERED 
(
	[FacultyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Question]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[ExamID] [varchar](50) NULL,
	[SubjectID] [varchar](50) NULL,
	[QContent] [nvarchar](500) NULL,
	[OptionA] [nvarchar](500) NULL,
	[OptionB] [nvarchar](500) NULL,
	[OptionC] [nvarchar](500) NULL,
	[OptionD] [nvarchar](500) NULL,
	[Answer] [nvarchar](500) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedAt] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedAt] [datetime] NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Semester]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Semester](
	[SemesterID] [tinyint] IDENTITY(1,1) NOT NULL,
	[SemesterName] [nvarchar](50) NULL,
 CONSTRAINT [PK_Semester] PRIMARY KEY CLUSTERED 
(
	[SemesterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subject]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subject](
	[SubjectID] [varchar](50) NOT NULL,
	[SubjectRole] [varchar](50) NOT NULL,
	[CourseID] [varchar](50) NOT NULL,
	[FacultyID] [varchar](50) NOT NULL,
	[SemesterID] [tinyint] NOT NULL,
	[SubjectName] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedAt] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedAt] [datetime] NULL,
 CONSTRAINT [PK_Subject_1] PRIMARY KEY CLUSTERED 
(
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubjectRole]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectRole](
	[RoleID] [varchar](50) NOT NULL,
	[RoleName] [nvarchar](100) NULL,
	[Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_SubjectRole] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestForm]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestForm](
	[TestFormID] [varchar](50) NOT NULL,
	[TestFormName] [nvarchar](100) NULL,
	[Description] [nvarchar](100) NULL,
 CONSTRAINT [PK_TestForm] PRIMARY KEY CLUSTERED 
(
	[TestFormID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestHistory]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestHistory](
	[TestID] [int] IDENTITY(1,1) NOT NULL,
	[ExamID] [varchar](50) NULL,
	[SubjectID] [varchar](50) NULL,
	[SemesterID] [tinyint] NOT NULL,
	[UserID] [int] NULL,
	[CorrectAnswer] [smallint] NULL,
	[TotalQuestion] [smallint] NULL,
	[Mark] [float] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedAt] [datetime] NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[ModifiedAt] [datetime] NULL,
 CONSTRAINT [PK_TestHistory_1] PRIMARY KEY CLUSTERED 
(
	[TestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrainingRole]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingRole](
	[TrainingID] [varchar](50) NOT NULL,
	[TrainingName] [nvarchar](50) NULL,
	[Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_TrainingRole] PRIMARY KEY CLUSTERED 
(
	[TrainingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_QuizTimes]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_QuizTimes](
	[UserID] [int] NOT NULL,
	[ExamID] [varchar](50) NOT NULL,
	[SubjectID] [varchar](50) NOT NULL,
	[QuizTimes] [tinyint] NULL,
 CONSTRAINT [PK_User_QuizTimes] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ExamID] ASC,
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccount]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccount](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserRole] [varchar](50) NOT NULL,
	[ClassID] [varchar](50) NULL,
	[Username] [varchar](100) NULL,
	[Password] [varchar](200) NULL,
	[FullName] [nvarchar](100) NULL,
	[Email] [varchar](100) NULL,
	[PhoneNumber] [varchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Birthday] [date] NULL,
	[Note] [nvarchar](200) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedAt] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedAt] [datetime] NULL,
 CONSTRAINT [PK_UserAccount] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserClass]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserClass](
	[ClassID] [varchar](50) NOT NULL,
	[CourseID] [varchar](50) NOT NULL,
	[FacultyID] [varchar](50) NOT NULL,
	[AdmissionYear] [smallint] NULL,
	[NofTrainingSemester] [tinyint] NULL,
	[Description] [nvarchar](200) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedAt] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedAt] [datetime] NULL,
 CONSTRAINT [PK_UserClass] PRIMARY KEY CLUSTERED 
(
	[ClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[RoleID] [varchar](50) NOT NULL,
	[RoleName] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[CourseOrder] ([CourseID], [FacultyID], [TrainingID], [Description]) VALUES (N'K44', N'kcntt', N'fulltime', N'Sinh viên K44 khóa 2020 - 2024 ngành Công nghệ thông tin, hệ đào tạo chính quy')
INSERT [dbo].[CourseOrder] ([CourseID], [FacultyID], [TrainingID], [Description]) VALUES (N'K44', N'khhmt', N'fulltime', N'Sinh viên K44 khóa 2020-2024  ngành Khoa học và môi trường, hệ đào tạo chính quy')
INSERT [dbo].[CourseOrder] ([CourseID], [FacultyID], [TrainingID], [Description]) VALUES (N'K44', N'klh', N'fulltime', N'Sinh viên K44 khóa 2020-2024  ngành Luật, hệ đào tạo chính quy')
INSERT [dbo].[CourseOrder] ([CourseID], [FacultyID], [TrainingID], [Description]) VALUES (N'K45', N'kcntt', N'fulltime', N'Sinh viên K45 khóa 2020 - 2024 ngành Công nghệ thông tin, hệ đào tạo chính quy')
INSERT [dbo].[CourseOrder] ([CourseID], [FacultyID], [TrainingID], [Description]) VALUES (N'K45', N'khhmt', N'fulltime', N'Sinh viên K45 khóa 2020-2024  ngành Khoa học và môi trường, hệ đào tạo chính quy')
GO
SET IDENTITY_INSERT [dbo].[EduProg] ON 

INSERT [dbo].[EduProg] ([EProgID], [UserID], [CourseID], [FacultyID], [SemesterID], [SubjectID], [TotalMark], [Success]) VALUES (1, 3, N'K44', N'kcntt', 1, N'20CT1101', NULL, NULL)
INSERT [dbo].[EduProg] ([EProgID], [UserID], [CourseID], [FacultyID], [SemesterID], [SubjectID], [TotalMark], [Success]) VALUES (2, 3, N'K44', N'kcntt', 1, N'20CT1102', NULL, NULL)
INSERT [dbo].[EduProg] ([EProgID], [UserID], [CourseID], [FacultyID], [SemesterID], [SubjectID], [TotalMark], [Success]) VALUES (3, 3, N'K44', N'kcntt', 1, N'20CT1103', NULL, NULL)
INSERT [dbo].[EduProg] ([EProgID], [UserID], [CourseID], [FacultyID], [SemesterID], [SubjectID], [TotalMark], [Success]) VALUES (4, 3, N'K44', N'kcntt', 1, N'20CT1201', NULL, NULL)
INSERT [dbo].[EduProg] ([EProgID], [UserID], [CourseID], [FacultyID], [SemesterID], [SubjectID], [TotalMark], [Success]) VALUES (5, 3, N'K44', N'kcntt', 1, N'20CT1202', 5.56, 1)
INSERT [dbo].[EduProg] ([EProgID], [UserID], [CourseID], [FacultyID], [SemesterID], [SubjectID], [TotalMark], [Success]) VALUES (6, 3, N'K44', N'kcntt', 1, N'20CT1203', NULL, NULL)
INSERT [dbo].[EduProg] ([EProgID], [UserID], [CourseID], [FacultyID], [SemesterID], [SubjectID], [TotalMark], [Success]) VALUES (7, 3, N'K44', N'kcntt', 2, N'20TN2102', NULL, NULL)
INSERT [dbo].[EduProg] ([EProgID], [UserID], [CourseID], [FacultyID], [SemesterID], [SubjectID], [TotalMark], [Success]) VALUES (8, 3, N'K44', N'kcntt', 2, N'TN1008D', NULL, NULL)
SET IDENTITY_INSERT [dbo].[EduProg] OFF
GO
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1101', N'BT1', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1101', N'BT2', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1101', N'CK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1101', N'GK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1101', N'Other', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1102', N'BT1', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1102', N'BT2', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1102', N'CK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1102', N'GK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1102', N'Other', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1103', N'BT1', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1103', N'BT2', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1103', N'CK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1103', N'GK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1103', N'Other', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1201', N'BT1', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1201', N'BT2', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1201', N'CK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1201', N'GK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1201', N'Other', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1202', N'BT1', 9)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1202', N'BT2', 5)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1202', N'CK', 1.25)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1202', N'GK', 7)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1202', N'Other', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1203', N'BT1', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1203', N'BT2', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1203', N'CK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1203', N'GK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20CT1203', N'Other', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20TN2102', N'BT1', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20TN2102', N'BT2', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20TN2102', N'CK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20TN2102', N'GK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'20TN2102', N'Other', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'TN1008D', N'BT1', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'TN1008D', N'BT2', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'TN1008D', N'CK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'TN1008D', N'GK', NULL)
INSERT [dbo].[EP_TFMark] ([UserID], [SubjectID], [TestFormID], [Mark]) VALUES (3, N'TN1008D', N'Other', NULL)
GO
INSERT [dbo].[Exam] ([ExamID], [SubjectID], [TestFormID], [PercentMark], [ExamRole], [ExamTime], [QCount], [QCurrentCount], [QuizTimes], [Status], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'KF5', N'20CT1202', NULL, NULL, N'mock-test', 35, 15, 2, 3, 1, N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:16:17.233' AS DateTime), N'Teacher - DLUIT', CAST(N'2021-10-03T09:39:34.480' AS DateTime))
INSERT [dbo].[Exam] ([ExamID], [SubjectID], [TestFormID], [PercentMark], [ExamRole], [ExamTime], [QCount], [QCurrentCount], [QuizTimes], [Status], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'MH1', N'20CT1103', N'BT1', 15, N'actual-test', 15, 20, 1, 10, 1, N'Teacher - DLUIT', CAST(N'2021-11-25T07:44:45.960' AS DateTime), N'Teacher - DLUIT', CAST(N'2021-11-25T09:02:38.090' AS DateTime))
INSERT [dbo].[Exam] ([ExamID], [SubjectID], [TestFormID], [PercentMark], [ExamRole], [ExamTime], [QCount], [QCurrentCount], [QuizTimes], [Status], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'MH1', N'20CT1202', N'CK', 50, N'actual-test', 3, 20, 20, 3, 1, N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:15:41.313' AS DateTime), N'Teacher - DLUIT', CAST(N'2021-11-25T08:52:16.750' AS DateTime))
GO
INSERT [dbo].[ExamRole] ([RoleID], [RoleName], [Description]) VALUES (N'actual-test', N'Thi thật', N'Đánh dấu đề thi mang tính chất thi thực tế')
INSERT [dbo].[ExamRole] ([RoleID], [RoleName], [Description]) VALUES (N'mock-test', N'Thi thử', N'Đánh dấu đề thi mang tính chất thi thử hoặc luyện tập')
GO
INSERT [dbo].[Faculty] ([FacultyID], [FacultyName], [FoundingDate], [Description]) VALUES (N'kcntt', N'Công nghệ thông tin', CAST(N'2003-07-01' AS Date), N'Khoa công nghệ thông tin - ITDLU')
INSERT [dbo].[Faculty] ([FacultyID], [FacultyName], [FoundingDate], [Description]) VALUES (N'khhmt', N'Hóa học và môi trường', CAST(N'2019-11-01' AS Date), N'Khoa hóa học và môi trường')
INSERT [dbo].[Faculty] ([FacultyID], [FacultyName], [FoundingDate], [Description]) VALUES (N'klh', N'Luật', CAST(N'2003-07-07' AS Date), N'Khoa luật học')
INSERT [dbo].[Faculty] ([FacultyID], [FacultyName], [FoundingDate], [Description]) VALUES (N'kqth', N'Quốc tế học', CAST(N'1995-07-29' AS Date), N'Khoa quốc tế học')
GO
SET IDENTITY_INSERT [dbo].[Question] ON 

INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (1, N'MH1', N'20CT1202', N'Programming languages such as C#, Java, and Visual Basic are _____________________ languages.', N'machine', N'high-level', N'low-level', N'uninterpreted', N'high-level', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:37:34.497' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:52:56.010' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (2, N'MH1', N'20CT1202', N'A program that translates high-level programs into intermediate or machine code is a(n) _____________________ .', N'mangler', N'compactor', N'analyst', N'compiler', N'compiler', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:38:32.473' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:38:32.473' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (3, N'MH1', N'20CT1202', N'The grammar and spelling rules of a programming language constitute its _____________________.', N'logic', N'variables', N'class', N'syntax', N'syntax', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:39:17.097' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:39:17.097' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (4, N'MH1', N'20CT1202', N'Variables are _____________________ .', N'named memory locations', N'unexpected results', N'grammar rules', N'operations', N'named memory locations', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:40:01.080' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:40:01.080' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (5, N'MH1', N'20CT1202', N'Programs in which you create and use objects that have attributes similar to their realworld counterparts are known as _____________________ programs.', N'procedural', N'logical', N'object-oriented', N'authentic', N'object-oriented', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:41:19.110' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:41:19.110' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (6, N'MH1', N'20CT1202', N'Which of the following pairs is an example of a class and an object, in that order?', N'University and Yale', N'Chair and desk', N'Clydesdale and horse', N'Maple and tree', N'University and Yale', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:41:55.393' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:41:55.393' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (7, N'MH1', N'20CT1202', N'The technique of packaging an object’s attributes into a cohesive unit that can be used as an undivided entity is _____________________ .', N'inheritance', N'encapsulation', N'polymorphism', N'interfacing', N'encapsulation', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:42:54.983' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:42:54.983' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (8, N'MH1', N'20CT1202', N'Of the following languages, which is least similar to C#?', N'Java', N'Visual Basic', N'C++', N'machine language', N'machine language', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:44:24.260' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:44:24.260' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (9, N'MH1', N'20CT1202', N'A series of characters that appears within double quotation marks is a(n) _____________________ .', N'method', N'interface', N'argument', N'literal string', N'literal string', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:45:44.027' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:45:44.027' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (10, N'MH1', N'20CT1202', N'The C# method that produces a line of output on the screen and then positions the cursor on the next line is _____________________ .', N'WriteLine()', N'PrintLine()', N'DisplayLine()', N'OutLine()', N'WriteLine()', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:46:33.483' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:46:33.483' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (11, N'MH1', N'20CT1202', N'Which of the following is a class?', N'System', N'Console', N'void', N'WriteLine()', N'Console', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:47:13.013' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:47:13.013' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (12, N'MH1', N'20CT1202', N'In C#, a container that groups similar classes is a(n) _____________________ .', N'superclass', N'method', N'namespace', N'identifier', N'namespace', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:47:50.530' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:47:50.530' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (13, N'MH1', N'20CT1202', N'Every method in C# contains a _____________________ .', N'header and a body', N'header and a footer', N'variable and a class', N'class and an object', N'header and a body', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:48:51.560' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:48:51.560' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (14, N'MH1', N'20CT1202', N'Which of the following is a method?', N'namespace', N'class', N'Main()', N'static', N'Main()', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:49:25.717' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:49:25.717' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (15, N'MH1', N'20CT1202', N'In C#, an identifier _____________________ .', N'must begin with an underscore', N'can contain digits', N'must be no more than 16 characters', N'can contain only lowercase letters', N'can contain digits', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:50:09.600' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:50:09.600' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (16, N'MH1', N'20CT1202', N'Which of the following identifiers is not legal in C#?', N'per cent increase', N'annualReview', N'HTML', N'alternativetaxcredit', N'per cent increase', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:50:43.673' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:50:43.673' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (17, N'MH1', N'20CT1202', N'The text of a program you write is called _____________________ .', N'object code', N'source code', N'machine language', N'executable documentation', N'source code', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:51:24.583' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:51:24.583' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (18, N'MH1', N'20CT1202', N'Programming errors such as using incorrect punctuation or misspelling words are collectively known as _____________________ errors.', N'syntax', N'logical', N'executable', N'fatal', N'syntax', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:52:03.760' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:52:03.760' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (19, N'MH1', N'20CT1202', N'A comment in the form /*this is a comment */ is a(n) _____________________ .', N'XML comment', N'block comment', N'executable comment', N'line comment', N'block comment', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:52:34.780' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:52:34.780' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (20, N'MH1', N'20CT1202', N'If a programmer inserts using static System.Console; at the top of a C# program, which of the following can the programmer use as an alternative to System.Console. WriteLine("Hello");?', N'System("Hello");', N'WriteLine("Hello");', N'Console.WriteLine("Hello");', N'Console("Hello");', N'Console("Hello");', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:53:47.133' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T20:10:36.177' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (21, N'KF5', N'20CT1202', N'1 + 1 = ?', N'2', N'hi', N'high', N'hai', N'high', N'Teacher - DLUIT', CAST(N'2021-10-03T09:41:52.460' AS DateTime), N'Teacher - DLUIT', CAST(N'2021-10-03T09:41:52.460' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (22, N'MH1', N'20CT1103', N'2 + 2 = ?', N'1', N'2', N'4', N'3', N'4', N'Teacher - DLUIT', CAST(N'2021-11-28T15:34:38.630' AS DateTime), N'Teacher - DLUIT', CAST(N'2021-11-28T15:34:38.630' AS DateTime))
INSERT [dbo].[Question] ([QuestionID], [ExamID], [SubjectID], [QContent], [OptionA], [OptionB], [OptionC], [OptionD], [Answer], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (23, N'KF5', N'20CT1202', N'Một con vịt xè ra 2 cái cánh, nó kêu rằng ___________.', N'cạp cạp', N'hihi hihi', N'cúc cúc', N'huhu huhu', N'cạp cạp', N'Manager - DLUIT', CAST(N'2021-12-01T22:03:50.370' AS DateTime), N'Manager - DLUIT', CAST(N'2021-12-01T22:03:50.370' AS DateTime))
SET IDENTITY_INSERT [dbo].[Question] OFF
GO
SET IDENTITY_INSERT [dbo].[Semester] ON 

INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (1, N'Học kì 1')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (2, N'Học kì 2')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (3, N'Học kì 3')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (4, N'Học kì 4')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (5, N'Học kì 5')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (6, N'Học kì 6')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (7, N'Học kì 7')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (8, N'Học kì 8')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (9, N'Học kì 9')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (10, N'Học kì 10')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (11, N'Học kì 11')
INSERT [dbo].[Semester] ([SemesterID], [SemesterName]) VALUES (12, N'Học kì 12')
SET IDENTITY_INSERT [dbo].[Semester] OFF
GO
INSERT [dbo].[Subject] ([SubjectID], [SubjectRole], [CourseID], [FacultyID], [SemesterID], [SubjectName], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'20CT1101', N'obligatory', N'K44', N'kcntt', 1, N'Nhập môn ngành CNTT', N'Tổng quan về ngành CNTT', N'Giao vien', CAST(N'2021-08-02T21:09:47.053' AS DateTime), N'Giao vien', CAST(N'2021-08-02T21:09:47.053' AS DateTime))
INSERT [dbo].[Subject] ([SubjectID], [SubjectRole], [CourseID], [FacultyID], [SemesterID], [SubjectName], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'20CT1102', N'obligatory', N'K44', N'kcntt', 1, N'Nguyên lý lập trình cấu trúc', N'Lập trình C++ cơ bản', N'Giao vien', CAST(N'2021-08-02T21:10:11.657' AS DateTime), N'Giao vien', CAST(N'2021-08-02T21:10:11.657' AS DateTime))
INSERT [dbo].[Subject] ([SubjectID], [SubjectRole], [CourseID], [FacultyID], [SemesterID], [SubjectName], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'20CT1103', N'obligatory', N'K44', N'kcntt', 1, N'Bảo trì máy tính', N'Cài win dạo', N'Teacher - DLUIT', CAST(N'2021-11-25T07:43:11.857' AS DateTime), N'Teacher - DLUIT', CAST(N'2021-11-25T07:43:11.857' AS DateTime))
INSERT [dbo].[Subject] ([SubjectID], [SubjectRole], [CourseID], [FacultyID], [SemesterID], [SubjectName], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'20CT1201', N'obligatory', N'K44', N'kcntt', 1, N'Cấu trúc dữ liệu và thuật giải', N'Các kĩ thuật cơ bản và nâng cao về cấu trúc thuật toán và dữ liệu', N'Giao vien', CAST(N'2021-08-02T21:13:07.377' AS DateTime), N'Giao vien', CAST(N'2021-08-02T21:13:07.377' AS DateTime))
INSERT [dbo].[Subject] ([SubjectID], [SubjectRole], [CourseID], [FacultyID], [SemesterID], [SubjectName], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'20CT1202', N'obligatory', N'K44', N'kcntt', 1, N'Nguyên lý lập trình hướng đối tượng', N'Các kĩ thuật cơ bản về C# và hướng đối tượng trong C#', N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:14:08.963' AS DateTime), N'Teacher - DLUIT', CAST(N'2021-09-14T11:31:55.397' AS DateTime))
INSERT [dbo].[Subject] ([SubjectID], [SubjectRole], [CourseID], [FacultyID], [SemesterID], [SubjectName], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'20CT1203', N'elective
', N'K44', N'kcntt', 1, N'Đồ họa ứng dụng', N'Học về kĩ thuật thiết kế và tùy biến giao diện, hình ảnh,.. trên Adobe Photoshop', N'Giao vien', CAST(N'2021-08-02T21:14:39.597' AS DateTime), N'Giao vien', CAST(N'2021-08-02T21:14:39.597' AS DateTime))
INSERT [dbo].[Subject] ([SubjectID], [SubjectRole], [CourseID], [FacultyID], [SemesterID], [SubjectName], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'20TN2102', N'elective
', N'K44', N'kcntt', 2, N'Toán cao cấp B2', N'Nơi tình yêu bắt đầu', N'Giao vien', CAST(N'2021-08-02T21:16:48.497' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:14:27.687' AS DateTime))
INSERT [dbo].[Subject] ([SubjectID], [SubjectRole], [CourseID], [FacultyID], [SemesterID], [SubjectName], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'TN1008D', N'obligatory', N'K44', N'kcntt', 2, N'Toán rời rạc', N'Nơi những giọt nước mắt đầu tiên rơi', N'Giao vien', CAST(N'2021-08-02T21:15:39.247' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-08-25T19:14:18.780' AS DateTime))
GO
INSERT [dbo].[SubjectRole] ([RoleID], [RoleName], [Description]) VALUES (N'elective
', N'Tự chọn', N'Học phần tự chọn')
INSERT [dbo].[SubjectRole] ([RoleID], [RoleName], [Description]) VALUES (N'obligatory', N'Bắt buộc', N'Học phần bắt buộc')
GO
INSERT [dbo].[TestForm] ([TestFormID], [TestFormName], [Description]) VALUES (N'BT1', N'Bài tập 1', N'Kiểm tra bài tập 1')
INSERT [dbo].[TestForm] ([TestFormID], [TestFormName], [Description]) VALUES (N'BT2', N'Bài tập 2', N'Kiểm tra bài tập 2')
INSERT [dbo].[TestForm] ([TestFormID], [TestFormName], [Description]) VALUES (N'CK', N'Cuối kỳ', N'Kiểm tra bài tập cuối kỳ')
INSERT [dbo].[TestForm] ([TestFormID], [TestFormName], [Description]) VALUES (N'GK', N'Giữa kỳ', N'Kiểm tra bài tập giữa kỳ')
INSERT [dbo].[TestForm] ([TestFormID], [TestFormName], [Description]) VALUES (N'Other', N'Khác ...', N'Kiểm tra bài tập phát sinh')
GO
SET IDENTITY_INSERT [dbo].[TestHistory] ON 

INSERT [dbo].[TestHistory] ([TestID], [ExamID], [SubjectID], [SemesterID], [UserID], [CorrectAnswer], [TotalQuestion], [Mark], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (1, N'MH1', N'20CT1202', 1, 3, 16, 20, 8, N'Triệu Trọng Hậu', CAST(N'2021-11-25T13:02:52.137' AS DateTime), N'Triệu Trọng Hậu', CAST(N'2021-11-25T13:02:52.137' AS DateTime))
INSERT [dbo].[TestHistory] ([TestID], [ExamID], [SubjectID], [SemesterID], [UserID], [CorrectAnswer], [TotalQuestion], [Mark], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (2, N'MH1', N'20CT1202', 1, 3, 15, 20, 7.5, N'Triệu Trọng Hậu', CAST(N'2021-11-25T13:22:27.550' AS DateTime), N'Triệu Trọng Hậu', CAST(N'2021-11-25T13:22:27.550' AS DateTime))
INSERT [dbo].[TestHistory] ([TestID], [ExamID], [SubjectID], [SemesterID], [UserID], [CorrectAnswer], [TotalQuestion], [Mark], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (3, N'KF5', N'20CT1202', 1, 3, 0, 1, 0, N'Triệu Trọng Hậu', CAST(N'2021-11-28T21:34:15.220' AS DateTime), N'Triệu Trọng Hậu', CAST(N'2021-11-28T21:34:15.220' AS DateTime))
INSERT [dbo].[TestHistory] ([TestID], [ExamID], [SubjectID], [SemesterID], [UserID], [CorrectAnswer], [TotalQuestion], [Mark], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (4, N'MH1', N'20CT1202', 1, 3, 14, 20, 7, N'Triệu Trọng Hậu', CAST(N'2021-12-01T17:01:57.777' AS DateTime), N'Triệu Trọng Hậu', CAST(N'2021-12-01T17:01:57.777' AS DateTime))
INSERT [dbo].[TestHistory] ([TestID], [ExamID], [SubjectID], [SemesterID], [UserID], [CorrectAnswer], [TotalQuestion], [Mark], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (5, N'MH1', N'20CT1202', 1, 3, 5, 20, 2.5, N'Triệu Trọng Hậu', CAST(N'2021-12-01T22:08:20.653' AS DateTime), N'Triệu Trọng Hậu', CAST(N'2021-12-01T22:08:20.653' AS DateTime))
INSERT [dbo].[TestHistory] ([TestID], [ExamID], [SubjectID], [SemesterID], [UserID], [CorrectAnswer], [TotalQuestion], [Mark], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (8, N'KF5', N'20CT1202', 1, 3, 1, 1, 10, N'Triệu Trọng Hậu', CAST(N'2021-11-29T21:11:10.037' AS DateTime), N'Triệu Trọng Hậu', CAST(N'2021-11-29T21:11:10.037' AS DateTime))
SET IDENTITY_INSERT [dbo].[TestHistory] OFF
GO
INSERT [dbo].[TrainingRole] ([TrainingID], [TrainingName], [Description]) VALUES (N'distance-education', N'Từ xa', N'Hệ đào tạo từ xa')
INSERT [dbo].[TrainingRole] ([TrainingID], [TrainingName], [Description]) VALUES (N'fulltime', N'Chính quy', N'Hệ đào tạo chính quy')
INSERT [dbo].[TrainingRole] ([TrainingID], [TrainingName], [Description]) VALUES (N'fulltime-transfer-degree', N'Liên thông', N'Hệ liên thông từ CĐ lên ĐH - CQ')
INSERT [dbo].[TrainingRole] ([TrainingID], [TrainingName], [Description]) VALUES (N'international-education', N'Quốc tế', N'Hệ đào tạo quốc tế')
GO
INSERT [dbo].[User_QuizTimes] ([UserID], [ExamID], [SubjectID], [QuizTimes]) VALUES (3, N'KF5', N'20CT1202', 10)
INSERT [dbo].[User_QuizTimes] ([UserID], [ExamID], [SubjectID], [QuizTimes]) VALUES (3, N'MH1', N'20CT1103', 10)
INSERT [dbo].[User_QuizTimes] ([UserID], [ExamID], [SubjectID], [QuizTimes]) VALUES (3, N'MH1', N'20CT1202', 9)
GO
SET IDENTITY_INSERT [dbo].[UserAccount] ON 

INSERT [dbo].[UserAccount] ([UserID], [UserRole], [ClassID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Birthday], [Note], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (1, N'Admin', NULL, N'Admin', N'33354741122871651676713774147412831195', N'DaLatAdmin', N'daithieugia123@.com', N'0852987191', N'Đà Lạt', CAST(N'2003-08-01' AS Date), N'Đã được sửa bởi Admin - DaLatAdmin vào 30/11/2021', N'Admin - DaLatAdmin', CAST(N'2021-07-17T13:53:53.847' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-11-30T16:50:47.530' AS DateTime))
INSERT [dbo].[UserAccount] ([UserID], [UserRole], [ClassID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Birthday], [Note], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (2, N'Manager', NULL, N'ItDlu', N'661512447519149825336913615157157122147', N'DLUIT', N'lamkute@.com', N'0852987191', N'Đà Lạt', CAST(N'2003-08-01' AS Date), N'Đã được sửa bởi Admin - DaLatAdmin vào 30/11/2021', N'Admin - DaLatAdmin', CAST(N'2021-07-17T13:54:58.460' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-11-30T16:50:09.623' AS DateTime))
INSERT [dbo].[UserAccount] ([UserID], [UserRole], [ClassID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Birthday], [Note], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (3, N'User', N'CTK44', N'2011379', N'223018912569815552702387813134219207146', N'Triệu Trọng Hậu', N'2011379@dlu.edu.vn', N'0852987191', N'Phú Yên', CAST(N'2002-05-07' AS Date), N'Đã được tạo bởi Admin - DaLatAdmin vào 02/10/2021', N'Admin - DaLatAdmin', CAST(N'2021-10-02T19:22:41.783' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-10-02T19:22:41.783' AS DateTime))
SET IDENTITY_INSERT [dbo].[UserAccount] OFF
GO
INSERT [dbo].[UserClass] ([ClassID], [CourseID], [FacultyID], [AdmissionYear], [NofTrainingSemester], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'CTK44', N'K44', N'kcntt', 2021, 8, N'Khóa 44 khoa Công nghệ thông tin', NULL, NULL, N'Admin - DaLatAdmin', CAST(N'2021-09-25T19:32:51.120' AS DateTime))
INSERT [dbo].[UserClass] ([ClassID], [CourseID], [FacultyID], [AdmissionYear], [NofTrainingSemester], [Description], [CreatedBy], [CreatedAt], [ModifiedBy], [ModifiedAt]) VALUES (N'HHK44', N'K44', N'khhmt', 2020, 8, N'Khóa 44 khoa Hóa học và môi trường', N'Admin - DaLatAdmin', CAST(N'2021-09-05T15:48:22.140' AS DateTime), N'Admin - DaLatAdmin', CAST(N'2021-09-05T15:48:22.140' AS DateTime))
GO
INSERT [dbo].[UserRole] ([RoleID], [RoleName], [Description]) VALUES (N'Admin', N'Administrator', N'Quản trị hệ thống')
INSERT [dbo].[UserRole] ([RoleID], [RoleName], [Description]) VALUES (N'Manager', N'Quản lý', N'Quản lý')
INSERT [dbo].[UserRole] ([RoleID], [RoleName], [Description]) VALUES (N'User', N'Người dùng', N'Người dùng, học sinh, sinh viên')
GO
ALTER TABLE [dbo].[Exam] ADD  CONSTRAINT [DF_Exam_ExamTime]  DEFAULT ((0)) FOR [ExamTime]
GO
ALTER TABLE [dbo].[Exam] ADD  CONSTRAINT [DF_Exam_QCount]  DEFAULT ((0)) FOR [QCount]
GO
ALTER TABLE [dbo].[Exam] ADD  CONSTRAINT [DF_Exam_QCurrentCount]  DEFAULT ((0)) FOR [QCurrentCount]
GO
ALTER TABLE [dbo].[Exam] ADD  CONSTRAINT [DF_Exam_CreatedBy]  DEFAULT ('Giao vien') FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Exam] ADD  CONSTRAINT [DF_Exam_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Exam] ADD  CONSTRAINT [DF_Exam_ModifiedBy]  DEFAULT ('Giao vien') FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Exam] ADD  CONSTRAINT [DF_Exam_ModifiedAt]  DEFAULT (getdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[Faculty] ADD  CONSTRAINT [DF_Faculty_FoundingDate]  DEFAULT (getdate()) FOR [FoundingDate]
GO
ALTER TABLE [dbo].[Question] ADD  CONSTRAINT [DF_Question_CreatedBy]  DEFAULT ('Giao vien') FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Question] ADD  CONSTRAINT [DF_Question_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Question] ADD  CONSTRAINT [DF_Question_ModifiedBy]  DEFAULT ('Giao vien') FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Question] ADD  CONSTRAINT [DF_Question_ModifiedAt]  DEFAULT (getdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[Subject] ADD  CONSTRAINT [DF_Subject_CreatedBy]  DEFAULT ('Giao vien') FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Subject] ADD  CONSTRAINT [DF_Subject_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Subject] ADD  CONSTRAINT [DF_Subject_ModifiedBy]  DEFAULT ('Giao vien') FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Subject] ADD  CONSTRAINT [DF_Subject_ModifiedAt]  DEFAULT (getdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[TestHistory] ADD  CONSTRAINT [DF_TestHistory_CreatedBy]  DEFAULT ('Giao vien') FOR [CreatedBy]
GO
ALTER TABLE [dbo].[TestHistory] ADD  CONSTRAINT [DF_TestHistory_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[TestHistory] ADD  CONSTRAINT [DF_TestHistory_ModifiedBy]  DEFAULT ('Giao vien') FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[TestHistory] ADD  CONSTRAINT [DF_TestHistory_ModifiedAt]  DEFAULT (getdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_CreatedBy]  DEFAULT ('Giao vien') FOR [CreatedBy]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_ModifiedBy]  DEFAULT ('Giao vien') FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[UserAccount] ADD  CONSTRAINT [DF_UserAccount_ModifiedAt]  DEFAULT (getdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[UserClass] ADD  CONSTRAINT [DF_UserClass_CreatedBy]  DEFAULT ('Admin') FOR [CreatedBy]
GO
ALTER TABLE [dbo].[UserClass] ADD  CONSTRAINT [DF_UserClass_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[UserClass] ADD  CONSTRAINT [DF_UserClass_ModifiedBy]  DEFAULT ('Admin') FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[UserClass] ADD  CONSTRAINT [DF_UserClass_ModifiedAt]  DEFAULT (getdate()) FOR [ModifiedAt]
GO
ALTER TABLE [dbo].[CourseOrder]  WITH CHECK ADD  CONSTRAINT [FK_CourseOrder_Faculty] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CourseOrder] CHECK CONSTRAINT [FK_CourseOrder_Faculty]
GO
ALTER TABLE [dbo].[CourseOrder]  WITH CHECK ADD  CONSTRAINT [FK_CourseOrder_TrainingRole] FOREIGN KEY([TrainingID])
REFERENCES [dbo].[TrainingRole] ([TrainingID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CourseOrder] CHECK CONSTRAINT [FK_CourseOrder_TrainingRole]
GO
ALTER TABLE [dbo].[EduProg]  WITH CHECK ADD  CONSTRAINT [FK_EduProg_CourseOrder] FOREIGN KEY([CourseID], [FacultyID])
REFERENCES [dbo].[CourseOrder] ([CourseID], [FacultyID])
GO
ALTER TABLE [dbo].[EduProg] CHECK CONSTRAINT [FK_EduProg_CourseOrder]
GO
ALTER TABLE [dbo].[EduProg]  WITH CHECK ADD  CONSTRAINT [FK_EduProg_Faculty] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
GO
ALTER TABLE [dbo].[EduProg] CHECK CONSTRAINT [FK_EduProg_Faculty]
GO
ALTER TABLE [dbo].[EduProg]  WITH CHECK ADD  CONSTRAINT [FK_EduProg_Semester] FOREIGN KEY([SemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EduProg] CHECK CONSTRAINT [FK_EduProg_Semester]
GO
ALTER TABLE [dbo].[EduProg]  WITH CHECK ADD  CONSTRAINT [FK_EduProg_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EduProg] CHECK CONSTRAINT [FK_EduProg_Subject]
GO
ALTER TABLE [dbo].[EduProg]  WITH CHECK ADD  CONSTRAINT [FK_EduProg_UserAccount1] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserAccount] ([UserID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EduProg] CHECK CONSTRAINT [FK_EduProg_UserAccount1]
GO
ALTER TABLE [dbo].[EP_TFMark]  WITH CHECK ADD  CONSTRAINT [FK_EP_TFMark_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EP_TFMark] CHECK CONSTRAINT [FK_EP_TFMark_Subject]
GO
ALTER TABLE [dbo].[EP_TFMark]  WITH CHECK ADD  CONSTRAINT [FK_EP_TFMark_TestForm] FOREIGN KEY([TestFormID])
REFERENCES [dbo].[TestForm] ([TestFormID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EP_TFMark] CHECK CONSTRAINT [FK_EP_TFMark_TestForm]
GO
ALTER TABLE [dbo].[EP_TFMark]  WITH CHECK ADD  CONSTRAINT [FK_EP_TFMark_UserAccount] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserAccount] ([UserID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EP_TFMark] CHECK CONSTRAINT [FK_EP_TFMark_UserAccount]
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD  CONSTRAINT [FK_Exam_ExamRole] FOREIGN KEY([ExamRole])
REFERENCES [dbo].[ExamRole] ([RoleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Exam] CHECK CONSTRAINT [FK_Exam_ExamRole]
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD  CONSTRAINT [FK_Exam_Subject1] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Exam] CHECK CONSTRAINT [FK_Exam_Subject1]
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD  CONSTRAINT [FK_Exam_TestForm] FOREIGN KEY([TestFormID])
REFERENCES [dbo].[TestForm] ([TestFormID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Exam] CHECK CONSTRAINT [FK_Exam_TestForm]
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_Exam] FOREIGN KEY([ExamID], [SubjectID])
REFERENCES [dbo].[Exam] ([ExamID], [SubjectID])
GO
ALTER TABLE [dbo].[Question] CHECK CONSTRAINT [FK_Question_Exam]
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_Subject1] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Question] CHECK CONSTRAINT [FK_Question_Subject1]
GO
ALTER TABLE [dbo].[Subject]  WITH NOCHECK ADD  CONSTRAINT [FK_Subject_CourseOrder] FOREIGN KEY([CourseID], [FacultyID])
REFERENCES [dbo].[CourseOrder] ([CourseID], [FacultyID])
GO
ALTER TABLE [dbo].[Subject] CHECK CONSTRAINT [FK_Subject_CourseOrder]
GO
ALTER TABLE [dbo].[Subject]  WITH NOCHECK ADD  CONSTRAINT [FK_Subject_Faculty] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
GO
ALTER TABLE [dbo].[Subject] CHECK CONSTRAINT [FK_Subject_Faculty]
GO
ALTER TABLE [dbo].[Subject]  WITH NOCHECK ADD  CONSTRAINT [FK_Subject_Semester] FOREIGN KEY([SemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
GO
ALTER TABLE [dbo].[Subject] CHECK CONSTRAINT [FK_Subject_Semester]
GO
ALTER TABLE [dbo].[Subject]  WITH NOCHECK ADD  CONSTRAINT [FK_Subject_SubjectRole] FOREIGN KEY([SubjectRole])
REFERENCES [dbo].[SubjectRole] ([RoleID])
GO
ALTER TABLE [dbo].[Subject] CHECK CONSTRAINT [FK_Subject_SubjectRole]
GO
ALTER TABLE [dbo].[TestHistory]  WITH CHECK ADD  CONSTRAINT [FK_TestHistory_Exam] FOREIGN KEY([ExamID], [SubjectID])
REFERENCES [dbo].[Exam] ([ExamID], [SubjectID])
GO
ALTER TABLE [dbo].[TestHistory] CHECK CONSTRAINT [FK_TestHistory_Exam]
GO
ALTER TABLE [dbo].[TestHistory]  WITH CHECK ADD  CONSTRAINT [FK_TestHistory_Semester] FOREIGN KEY([SemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TestHistory] CHECK CONSTRAINT [FK_TestHistory_Semester]
GO
ALTER TABLE [dbo].[TestHistory]  WITH CHECK ADD  CONSTRAINT [FK_TestHistory_Subject1] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TestHistory] CHECK CONSTRAINT [FK_TestHistory_Subject1]
GO
ALTER TABLE [dbo].[TestHistory]  WITH CHECK ADD  CONSTRAINT [FK_TestHistory_UserAccount] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserAccount] ([UserID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TestHistory] CHECK CONSTRAINT [FK_TestHistory_UserAccount]
GO
ALTER TABLE [dbo].[User_QuizTimes]  WITH CHECK ADD  CONSTRAINT [FK_User_QuizTimes_Exam] FOREIGN KEY([ExamID], [SubjectID])
REFERENCES [dbo].[Exam] ([ExamID], [SubjectID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[User_QuizTimes] CHECK CONSTRAINT [FK_User_QuizTimes_Exam]
GO
ALTER TABLE [dbo].[User_QuizTimes]  WITH CHECK ADD  CONSTRAINT [FK_User_QuizTimes_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subject] ([SubjectID])
GO
ALTER TABLE [dbo].[User_QuizTimes] CHECK CONSTRAINT [FK_User_QuizTimes_Subject]
GO
ALTER TABLE [dbo].[User_QuizTimes]  WITH CHECK ADD  CONSTRAINT [FK_User_QuizTimes_UserAccount] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserAccount] ([UserID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[User_QuizTimes] CHECK CONSTRAINT [FK_User_QuizTimes_UserAccount]
GO
ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_UserClass] FOREIGN KEY([ClassID])
REFERENCES [dbo].[UserClass] ([ClassID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserAccount] CHECK CONSTRAINT [FK_UserAccount_UserClass]
GO
ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_UserRole] FOREIGN KEY([UserRole])
REFERENCES [dbo].[UserRole] ([RoleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserAccount] CHECK CONSTRAINT [FK_UserAccount_UserRole]
GO
ALTER TABLE [dbo].[UserClass]  WITH CHECK ADD  CONSTRAINT [FK_UserClass_CourseOrder] FOREIGN KEY([CourseID], [FacultyID])
REFERENCES [dbo].[CourseOrder] ([CourseID], [FacultyID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserClass] CHECK CONSTRAINT [FK_UserClass_CourseOrder]
GO
ALTER TABLE [dbo].[UserClass]  WITH CHECK ADD  CONSTRAINT [FK_UserClass_Faculty] FOREIGN KEY([FacultyID])
REFERENCES [dbo].[Faculty] ([FacultyID])
GO
ALTER TABLE [dbo].[UserClass] CHECK CONSTRAINT [FK_UserClass_Faculty]
GO
/****** Object:  StoredProcedure [dbo].[USP_CancleQuizTimes]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_CancleQuizTimes]
@UserID INT,
@ExamID VARCHAR(50),
@SubjectID VARCHAR(50)
AS
BEGIN
	UPDATE dbo.User_QuizTimes SET QuizTimes -= 1 FROM dbo.User_QuizTimes
	WHERE UserID = @UserID AND ExamID = @ExamID AND SubjectID = @SubjectID AND QuizTimes > 0
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ChangeInfoAccount]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ChangeInfoAccount]
@username VARCHAR(100),
@fullName NVARCHAR(100),
@address NVARCHAR(100),
@phonenumber VARCHAR(50),
@email VARCHAR(100),
@birthday DATETIME,
@password NVARCHAR(200),
@newpassword NVARCHAR(100)
AS
BEGIN
    DECLARE @isRightPass INT = 0
	SELECT @isRightPass = COUNT(*) FROM dbo.UserAccount
	WHERE UserName = @username AND PassWord = @password

	IF (@isRightPass = 1)
	BEGIN
	    IF (@newpassword IS NULL OR @newpassword = '')
		BEGIN
		    UPDATE dbo.UserAccount
			SET FullName = @fullName,
			Address = @address,
			PhoneNumber = @phonenumber,
			Email = @email,
			Birthday = @birthday,
			Note = N'Đã được sửa bởi ' + @fullname + N' vào ' + CAST(GETDATE() AS NVARCHAR),
			ModifiedBy = @username,
			ModifiedAt = GETDATE()
			WHERE UserName = @username
		END
		ELSE
		BEGIN
		    UPDATE dbo.UserAccount 
			SET PassWord = @newpassword
			WHERE UserName = @username
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_CheckExistAccount]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_CheckExistAccount]
@Username VARCHAR(100),
@Password VARCHAR(200)
AS
BEGIN
    SELECT UserID FROM dbo.UserAccount
	WHERE @Username = Username
	AND @Password = Password
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteAccount]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_DeleteAccount]
@UserID INT
AS
BEGIN
    DELETE dbo.UserAccount WHERE UserID = @UserID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteClass]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_DeleteClass]
 @ClassID varchar(50)
 AS
 BEGIN
	DECLARE @error NVARCHAR(120)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	IF EXISTS (SELECT * FROM dbo.UserAccount WHERE ClassID = @ClassID)
	BEGIN
		BEGIN TRY
			-- RAISERROR with severity 11-19 will cause execution to 
			-- jump to the CATCH block.
			SELECT @error = CONCAT(N'Không thể xóa lớp "', @ClassID, N'" vì tồn tại dữ liệu ràng buộc liên quan!');
			RAISERROR (@error, -- Message text.
					   16, -- Severity.
					   1 -- State. 
					   )
			ROLLBACK TRAN
		END TRY
		BEGIN CATCH
			SELECT @error = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

			-- Use RAISERROR inside the CATCH block to return error
			-- information about the original error that caused
			-- execution to jump to the CATCH block.
			RAISERROR (@error, -- Message text.
					   @ErrorSeverity, -- Severity.
					   @ErrorState -- State.
					   )
			ROLLBACK TRAN
		END CATCH;
	END
	ELSE
	BEGIN
		DELETE dbo.UserClass WHERE ClassID = @ClassID
	END
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteCourse]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_DeleteCourse]
 @CourseID varchar(50),
 @FacultyID VARCHAR(50)
 AS
 BEGIN
	DECLARE @FacultyName NVARCHAR(200)
	DECLARE @error NVARCHAR(120)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	SELECT @FacultyName = F.FacultyName FROM dbo.Faculty F
	WHERE F.FacultyID = @FacultyID

    IF EXISTS (SELECT * FROM dbo.Subject WHERE CourseID = @CourseID AND @FacultyID = FacultyID)
	OR EXISTS (SELECT * FROM dbo.UserClass WHERE CourseID = @CourseID AND @FacultyID = FacultyID)
	OR EXISTS (SELECT * FROM dbo.EduProg WHERE CourseID = @CourseID AND @FacultyID = FacultyID)
	BEGIN
		BEGIN TRY
			-- RAISERROR with severity 11-19 will cause execution to 
			-- jump to the CATCH block.
			SELECT @error = CONCAT(N'Không thể xóa khóa "', @CourseID, N' - khoa ', @FacultyName, N'" vì tồn tại dữ liệu ràng buộc liên quan!');
			RAISERROR (@error, -- Message text.
					   16, -- Severity.
					   1 -- State. 
					   )
			ROLLBACK TRAN
		END TRY
		BEGIN CATCH
			SELECT @error = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

			-- Use RAISERROR inside the CATCH block to return error
			-- information about the original error that caused
			-- execution to jump to the CATCH block.
			RAISERROR (@error, -- Message text.
					   @ErrorSeverity, -- Severity.
					   @ErrorState -- State.
					   )
			ROLLBACK TRAN
		END CATCH;
	END
	ELSE
	BEGIN
	    DELETE dbo.CourseOrder WHERE CourseID = @CourseID AND FacultyID = @FacultyID
	END
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteExam]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_DeleteExam]
@ExamID varchar(50),
@SubjectID VARCHAR(50)
AS
BEGIN
    DELETE dbo.Exam WHERE ExamID = @ExamID AND SubjectID = @SubjectID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteFaculty]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_DeleteFaculty]
 @FacultyID varchar(50)
 AS
 BEGIN
     DELETE dbo.Faculty WHERE FacultyID = @FacultyID
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteQuestion]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_DeleteQuestion]
@QuestionID INT
AS
BEGIN
	DELETE dbo.Question WHERE QuestionID = @QuestionID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteSubject]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_DeleteSubject]
@SubjectID varchar(50)
AS
BEGIN
	DECLARE @SubjectName NVARCHAR(200)
	DECLARE @error NVARCHAR(120)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	SELECT @SubjectName = S.SubjectName FROM dbo.Subject S
	WHERE S.SubjectID = @SubjectID
	
	IF EXISTS (SELECT * FROM dbo.Question WHERE @SubjectID = SubjectID)
	OR EXISTS (SELECT * FROM dbo.Exam WHERE @SubjectID = SubjectID)
	OR EXISTS (SELECT * FROM dbo.User_QuizTimes WHERE @SubjectID = SubjectID)
	OR EXISTS (SELECT * FROM dbo.EP_TFMark WHERE @SubjectID = SubjectID)
	OR EXISTS (SELECT * FROM dbo.EduProg WHERE @SubjectID = SubjectID)
	BEGIN
		BEGIN TRY
			-- RAISERROR with severity 11-19 will cause execution to 
			-- jump to the CATCH block.
			SELECT @error = CONCAT(N'Không thể xóa môn "', @SubjectName, N'" vì tồn tại dữ liệu ràng buộc liên quan!');
			RAISERROR (@error, -- Message text.
						16, -- Severity.
						1 -- State. 
						)
			ROLLBACK TRAN
		END TRY
		BEGIN CATCH
			SELECT @error = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

			-- Use RAISERROR inside the CATCH block to return error
			-- information about the original error that caused
			-- execution to jump to the CATCH block.
			RAISERROR (@error, -- Message text.
						@ErrorSeverity, -- Severity.
						@ErrorState -- State.
						)
			ROLLBACK TRAN
		END CATCH;
	END
	ELSE
	BEGIN
		DELETE dbo.Subject WHERE SubjectID = @SubjectID
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_EduProgCursor]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_EduProgCursor]
@SubjectID VARCHAR(50),
@CourseID VARCHAR(50),
@FacultyID VARCHAR(50),
@SemesterID TINYINT
AS
BEGIN
    DECLARE EduProgCursor CURSOR FOR SELECT DISTINCT UserID
	FROM dbo.EduProg WHERE CourseID = @CourseID AND FacultyID = @FacultyID

	OPEN EduProgCursor

	DECLARE @UserID INT
	DECLARE @EduProgID INT

	FETCH NEXT FROM EduProgCursor INTO @UserID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @EduProgID = 1
		SELECT @EduProgID = dbo.FUNC_GetEduProgIDMissing(@EduProgID)

		SET IDENTITY_INSERT dbo.UserAccount OFF
		SET IDENTITY_INSERT dbo.EduProg ON

		INSERT INTO dbo.EduProg
		(
			EProgID,
		    UserID,
		    CourseID,
		    FacultyID,
		    SemesterID,
		    SubjectID,
		    TotalMark,
		    Success
		)
		VALUES
		(
			@EduProgID,
			@UserID,   -- UserID - int
		    @CourseID,  -- CourseID - varchar(50)
		    @FacultyID,  -- FacultyID - varchar(50)
		    @SemesterID,   -- SemesterID - tinyint
		    @SubjectID,  -- SubjectID - varchar(50)
		    NULL, -- TotalMark - float
		    NULL -- Success - bit
		    )
			
	    SET IDENTITY_INSERT dbo.EduProg OFF

		IF NOT EXISTS (SELECT * FROM dbo.EP_TFMark WHERE UserID = @UserID AND SubjectID = @SubjectID)
		BEGIN
		    EXEC dbo.USP_TFMarkCursor @UserID, @SubjectID
		END
	
		FETCH NEXT FROM EduProgCursor INTO @UserID
	END

	CLOSE EduProgCursor
	DEALLOCATE EduProgCursor
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ExamCursor]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ExamCursor]
@UserID INT,
@ClassID VARCHAR(50)
AS
BEGIN
    DECLARE ExamCursor CURSOR FOR SELECT E.ExamID, E.SubjectID, E.QuizTimes FROM dbo.Exam E
	JOIN dbo.UserClass C
	ON @ClassID = C.ClassID
	JOIN dbo.Subject S
	ON S.SubjectID = E.SubjectID AND S.CourseID = C.CourseID AND S.FacultyID = C.FacultyID

	OPEN ExamCursor
	
	DECLARE @ExamID VARCHAR(50)
	DECLARE @SubjectID VARCHAR(50)
	DECLARE @QuizTimes TINYINT

	FETCH NEXT FROM ExamCursor INTO @ExamID, @SubjectID, @QuizTimes
	

	WHILE @@FETCH_STATUS = 0
	BEGIN

	INSERT dbo.User_QuizTimes
	(
	    UserID,
	    ExamID,
	    SubjectID,
	    QuizTimes
	)
	VALUES
	(   @UserID,  -- UserID - int
	    @ExamID, -- ExamID - varchar(50)
	    @SubjectID, -- SubjecctID - varchar(50)
	    @QuizTimes   -- QuizTimes - tinyint
	    )
		
	FETCH NEXT FROM ExamCursor INTO @ExamID, @SubjectID, @QuizTimes
	END

	CLOSE ExamCursor
	DEALLOCATE ExamCursor
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountByUserName]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetAccountByUserName]
@Username VARCHAR(100)
AS
BEGIN
    SELECT * FROM dbo.UserAccount
	WHERE @Username = Username
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountIDMissing]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetAccountIDMissing]
AS
BEGIN
    DECLARE @idMissing INT = 1
	WHILE EXISTS (	SELECT UserID FROM dbo.UserAccount WHERE UserID = @idMissing)
	BEGIN
	    SET @idMissing += 1
	END
	SELECT @idMissing
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetExamByIDSubject]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetExamByIDSubject]
@SubjectID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.Exam WHERE @SubjectID = SubjectID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetQuestionIDMissing]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetQuestionIDMissing]
AS
BEGIN
    DECLARE @idMissing INT = 1
	WHILE EXISTS (	SELECT QuestionID FROM dbo.Question WHERE QuestionID = @idMissing)
	BEGIN
	    SET @idMissing += 1
	END
	SELECT @idMissing
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertAccount]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertAccount]
@UserID INT,
@UserRole varchar(50), 
@ClassID VARCHAR(50),
@Username varchar(100), 
@FullName nvarchar(100),
@Email varchar(100),
@PhoneNumber varchar(50),
@Address nvarchar(100),
@Birthday DATETIME,
@Note nvarchar(200),
@CreatedBy varchar(50),
@ModifiedBy varchar(50)
AS
BEGIN
	SET IDENTITY_INSERT dbo.UserAccount ON
	INSERT INTO dbo.UserAccount
	(
		UserID,
		UserRole,
		ClassID,
		Username,
		Password,
		FullName,
		Email,
		PhoneNumber,
		Address,
		Birthday,
		Note,
		CreatedBy,
		CreatedAt,
		ModifiedBy,
		ModifiedAt
	)
	VALUES
	(   @UserID,
		@UserRole,        -- RoleID - varchar(50)
		@ClassID,
		@Username,        -- Username - varchar(50)
		'223018912569815552702387813134219207146',        -- Password - varchar(50)
		@FullName,       -- FullName - nvarchar(50)
		@Email,        -- Email - varchar(50)
		@PhoneNumber,        -- PhoneNumber - varchar(50)
		@Address,       -- Address - nvarchar(50)
		@Birthday, -- Birthday - datetime
		@Note,       -- Note - nvarchar(50)
		@CreatedBy,        -- CreatedBy - varchar(50)
		GETDATE(), -- CreatedAt - datetime
		@ModifiedBy,        -- ModifiedBy - varchar(50)
		GETDATE()  -- ModifiedAt - datetime
		)
	SET IDENTITY_INSERT dbo.UserAccount OFF
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertClass]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertClass]
 @ClassID varchar(50)
,@CourseID VARCHAR(50)
,@FacultyID nvarchar(50)
,@AdmissionYear SMALLINT
,@NofTrainingSemester TINYINT
,@Description nvarchar(500)
,@CreatedBy varchar(50)
,@ModifiedBy varchar(50)
AS
BEGIN
	INSERT INTO [dbo].[UserClass]
           ([ClassID]
		   ,[CourseID]
           ,[FacultyID]
		   ,[AdmissionYear]
		   ,[NofTrainingSemester]
           ,[Description]
		   ,[CreatedBy]
		   ,[CreatedAt]
		   ,[ModifiedBy]
		   ,[ModifiedAt])
     VALUES
           (@ClassID, 
		   @CourseID,
           @FacultyID,
		   @AdmissionYear,
		   @NofTrainingSemester,
           @Description,
		   @CreatedBy,
		   GETDATE(),
		   @ModifiedBy,
		   GETDATE())
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertCourse]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertCourse]
 @CourseID varchar(50)
,@FacultyID nvarchar(50)
,@TrainingID VARCHAR(50)
,@Description nvarchar(500)
AS
BEGIN
	INSERT INTO [dbo].[CourseOrder]
           ([CourseID]
           ,[FacultyID]
		   ,[TrainingID]
           ,[Description])
     VALUES
           (@CourseID, 
           @FacultyID, 
		   @TrainingID,
           @Description)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertExam]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertExam]
@ExamID varchar(50)
,@SubjectID varchar(50)
,@TestFormID VARCHAR(50)
,@PercentMark TINYINT
,@ExamRole varchar(50)
,@ExamTime SMALLINT
,@QCount SMALLINT
,@QuizTimes TINYINT
,@Status BIT
,@CreatedBy varchar(50)
,@ModifiedBy varchar(50)
AS
BEGIN
	INSERT INTO dbo.Exam
	(
	[ExamID]
	,[SubjectID]
	,[TestFormID]
	,[PercentMark]
	,[ExamRole]
    ,[ExamTime]
    ,[QCount]
	,[QuizTimes]
	,[Status]
    ,[CreatedBy]
    ,[CreatedAt]
    ,[ModifiedBy]
    ,[ModifiedAt]
	)
	VALUES
        (@ExamID, 
		@SubjectID,
		@TestFormID,
		@PercentMark,
		@ExamRole,
        @ExamTime, 
        @QCount, 
		@QuizTimes,
		@Status,
        @CreatedBy, 
        GETDATE(), 
        @ModifiedBy, 
        GETDATE() )
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertFaculty]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertFaculty]
 @FacultyID varchar(50)
,@FacultyName nvarchar(200)
,@FoundingDate DATE
,@Description nvarchar(500)
AS
BEGIN
	INSERT INTO [dbo].[Faculty]
           ([FacultyID]
           ,[FacultyName]
		   ,[FoundingDate]
           ,[Description])
     VALUES
           (@FacultyID, 
           @FacultyName, 
		   @FoundingDate,
           @Description)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertQuestion]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertQuestion]
@QuestionID INT
,@SubjectID varchar(50)
,@ExamID varchar(50)
,@QContent nvarchar(500)
,@OptionA nvarchar(500)
,@OptionB nvarchar(500)
,@OptionC nvarchar(500)
,@OptionD nvarchar(500)
,@Answer nvarchar(500)
,@CreatedBy varchar(50)
,@ModifiedBy varchar(50)
AS
BEGIN
	SET IDENTITY_INSERT dbo.Question ON
    INSERT INTO [dbo].[Question]
           ([QuestionID]
		   ,[SubjectID]
		   ,[ExamID]
           ,[QContent]
           ,[OptionA]
           ,[OptionB]
           ,[OptionC]
           ,[OptionD]
           ,[Answer]
           ,[CreatedBy]
           ,[CreatedAt]
           ,[ModifiedBy]
           ,[ModifiedAt])
     VALUES
           (@QuestionID,
		   @SubjectID, 
		   @ExamID,
           @QContent, 
           @OptionA, 
           @OptionB, 
           @OptionC, 
           @OptionD, 
           @Answer, 
           @CreatedBy, 
           GETDATE(), 
           @ModifiedBy, 
           GETDATE() )
	SET IDENTITY_INSERT dbo.Question OFF
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertSubject]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertSubject]
 @SubjectID varchar(50)
,@SubjectRole VARCHAR(50)
,@CourseID VARCHAR(50)
,@FacultyID VARCHAR(50)
,@SemesterID TINYINT
,@SubjectName nvarchar(200)
,@Description nvarchar(500)
,@CreatedBy varchar(50)
,@ModifiedBy varchar(50)
AS
BEGIN
	INSERT INTO [dbo].[Subject]
           ([SubjectID]
		   ,[SubjectRole]
		   ,[CourseID]
		   ,[FacultyID]
		   ,[SemesterID]
           ,[SubjectName]
           ,[Description]
           ,[CreatedBy]
           ,[CreatedAt]
           ,[ModifiedBy]
           ,[ModifiedAt])
     VALUES
           (@SubjectID, 
		   @SubjectRole,
		   @CourseID,
		   @FacultyID,
		   @SemesterID,
           @SubjectName, 
           @Description, 
           @CreatedBy, 
           GETDATE(), 
           @ModifiedBy, 
           GETDATE() )
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertTestHistory]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertTestHistory]
@ExamID VARCHAR(50) 
,@SubjectID VARCHAR(50) 
,@UserID INT 
,@SemesterID INT
,@CorrectAnswer INT 
,@TotalQuestion INT 
,@MARK FLOAT 
,@CreatedBy NVARCHAR(50) 
AS
BEGIN
	DECLARE @TestID INT = 1
	SELECT @TestID = dbo.FUNC_GetTestHistoryIDMissing(@TestID)
	
	SET IDENTITY_INSERT dbo.TestHistory ON

	INSERT dbo.TestHistory
	(
		TestID,
		ExamID,
		SubjectID,
		UserID,
		SemesterID,
		CorrectAnswer,
		TotalQuestion,
		Mark,
		CreatedBy,
		CreatedAt,
		ModifiedBy,
		ModifiedAt
	)
	VALUES
	(   @TestID
		,@ExamID   
        ,@SubjectID   
        ,@UserID   
        ,@SemesterID
        ,@CorrectAnswer   
        ,@TotalQuestion   
        ,@MARK   
        ,@CreatedBy   
        ,GETDATE()
        ,@CreatedBy   
        ,GETDATE()
		)

	SET IDENTITY_INSERT dbo.TestHistory OFF
END
GO
/****** Object:  StoredProcedure [dbo].[USP_IsExistContraintClass]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_IsExistContraintClass]
@ClassID VARCHAR(50)
AS
BEGIN
    SELECT UserID FROM dbo.UserAccount WHERE ClassID = @ClassID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_ResetPassword]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ResetPassword]
@Username VARCHAR(100)
AS
BEGIN
    UPDATE dbo.UserAccount SET Password = '223018912569815552702387813134219207146'
	WHERE Username = @Username
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchAccount]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchAccount]
@keyword NVARCHAR(200),
@RoleID VARCHAR(50)
AS 
BEGIN
    SELECT * FROM dbo.UserAccount
	WHERE ([dbo].[fuConvertToUnsign](UserID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](UserRole) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](ClassID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Username) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](FullName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Email) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](PhoneNumber) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Address) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%')
	AND (@RoleID = 'ALL' OR UserRole LIKE @RoleID)
	--AND (@ClassID = N'Tất cả' OR ClassID LIKE @ClassID)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchClass]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchClass]
@keyword NVARCHAR(200)
AS 
BEGIN
    SELECT * FROM dbo.UserClass
	WHERE [dbo].[fuConvertToUnsign](ClassID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](CourseID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](FacultyID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](AdmissionYear) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](NofTrainingSemester) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Description) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchCourse]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_SearchCourse]
@keyword NVARCHAR(200)
AS 
BEGIN
    SELECT * FROM dbo.CourseOrder
	WHERE [dbo].[fuConvertToUnsign](CourseID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](FacultyID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](TrainingID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Description) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchEduProg]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchEduProg]
@keyword NVARCHAR(200)
AS
BEGIN
    SELECT DISTINCT S.SemesterID,
	E.SubjectID,
	S.SubjectName,
	SR.RoleName,
	S.CourseID,
	E.FacultyID,
	F.FacultyName,
	E.TotalMark,
	E.Success FROM dbo.EduProg E
	JOIN dbo.Subject S
	ON S.SubjectID = E.SubjectID AND S.CourseID = E.CourseID
	JOIN dbo.CourseOrder C
	ON S.CourseID = C.CourseID
	JOIN dbo.SubjectRole SR
	ON S.SubjectRole = SR.RoleID 
	JOIN dbo.Faculty F
	ON S.FacultyID = F.FacultyID
	WHERE ([dbo].[fuConvertToUnsign](S.SemesterID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](S.SubjectID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](S.SubjectName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](SR.RoleName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](S.CourseID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](F.FacultyID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](F.FacultyName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](E.TotalMark) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchExam]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchExam]
@keyword NVARCHAR(200)
AS 
BEGIN
    SELECT * FROM dbo.Exam
	WHERE ([dbo].[fuConvertToUnsign](ExamID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](SubjectID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](TestFormID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](ExamRole) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%')
	--OR @keyword IS NULL OR @keyword = '' OR @keyword LIKE N'Tất cả')
	--AND ([dbo].[fuConvertToUnsign](SubjectID) LIKE N'%' + [dbo].[fuConvertToUnsign](@SubjectID) + '%' OR @SubjectID = 'ALL')
	--AND ([dbo].[fuConvertToUnsign](ExamRole) LIKE N'%' + [dbo].[fuConvertToUnsign](@RoleID) + '%' OR @RoleID = 'ALL')
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchFaculty]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchFaculty]
@keyword NVARCHAR(200)
AS 
BEGIN
    SELECT * FROM dbo.Faculty
	WHERE [dbo].[fuConvertToUnsign](FacultyID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%' 
	OR [dbo].[fuConvertToUnsign](FacultyName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Description) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchHistory]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchHistory]
@keyword NVARCHAR(200)
AS
BEGIN
    SELECT U.UserID, U.FullName, S.SubjectName, S.SubjectID, T.CreatedAt, T.CorrectAnswer, T.TotalQuestion, T.Mark 
	FROM dbo.TestHistory T
	JOIN dbo.UserAccount U
	ON U.UserID = T.UserID 
	JOIN dbo.Subject S
	ON S.SubjectID = T.SubjectID
	WHERE ([dbo].[fuConvertToUnsign](U.UserID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](U.FullName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](S.SubjectName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](S.SubjectName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](S.SubjectID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](T.Mark) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchQuestion]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchQuestion]
@keyword NVARCHAR(200)
AS
BEGIN
    SELECT * FROM dbo.Question
	WHERE ([dbo].[fuConvertToUnsign](QContent) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](OptionA) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](OptionB) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](OptionC) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](OptionD) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Answer) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](QuestionID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](SubjectID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](ExamID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%')
	--OR @keyword IS NULL OR @keyword = '')
	--AND ([dbo].[fuConvertToUnsign](SubjectID) LIKE N'%' + [dbo].[fuConvertToUnsign](@SubjectID) + '%'
	--OR @SubjectID = 'ALL')
	--AND ([dbo].[fuConvertToUnsign](ExamID) LIKE N'%' + [dbo].[fuConvertToUnsign](@ExamID) + '%'
	--OR @ExamID = N'Tất cả')
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SearchSubject]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SearchSubject]
@keyword NVARCHAR(200)
AS 
BEGIN
    SELECT * FROM dbo.Subject
	WHERE [dbo].[fuConvertToUnsign](SubjectID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](SubjectRole) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](CourseID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](FacultyID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](SemesterID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](SubjectName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Description) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllAccount]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllAccount]
AS 
	SELECT * FROM dbo.UserAccount
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllClass]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllClass]
AS
	BEGIN
		SELECT * FROM dbo.UserClass
		ORDER BY ClassID ASC
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllCourse]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllCourse]
AS
	BEGIN
		SELECT * FROM dbo.CourseOrder
		ORDER BY CourseID ASC
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllCourseByFaculty]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllCourseByFaculty]
@FacultyID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.CourseOrder WHERE FacultyID = @FacultyID
	ORDER BY CourseID ASC
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllExam]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllExam]
AS 
	BEGIN
		SELECT * FROM dbo.Exam
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllFaculty]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllFaculty]
AS
	BEGIN
		SELECT * FROM dbo.Faculty
		ORDER BY FacultyID ASC
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllQuestion]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllQuestion]
AS
	BEGIN
		SELECT * FROM dbo.Question
		ORDER BY QuestionID ASC
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllRoleExam]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllRoleExam]
AS 
	BEGIN
		SELECT * FROM dbo.ExamRole
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllSemester]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllSemester]
AS 
	BEGIN
		SELECT * FROM dbo.Semester
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllSubject]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllSubject]
AS
	BEGIN
		SELECT * FROM dbo.Subject
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllSubjectRole]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllSubjectRole]
AS 
	BEGIN
		SELECT * FROM dbo.SubjectRole
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllTestForm]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_SelectAllTestForm]
AS 
	BEGIN
		SELECT * FROM dbo.TestForm
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllTrainingRole]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllTrainingRole]
AS 
	BEGIN
		SELECT * FROM dbo.TrainingRole
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectAllUserRole]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectAllUserRole]
AS 
	BEGIN
		SELECT * FROM dbo.UserRole
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectClassByCourseID]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectClassByCourseID]
@CourseID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.UserClass
	WHERE CourseID = @CourseID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectEduProg]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_SelectEduProg]
AS
BEGIN
	BEGIN
		SELECT DISTINCT S.SemesterID,
		S.SubjectID,
		S.SubjectName,
		SR.RoleName,
		S.CourseID,
		F.FacultyName
		FROM dbo.Subject S
		JOIN dbo.CourseOrder C
		ON S.CourseID = C.CourseID
		JOIN dbo.SubjectRole SR
		ON S.SubjectRole = SR.RoleID 
		JOIN dbo.Faculty F
		ON S.FacultyID = F.FacultyID
		ORDER BY S.SemesterID ASC
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectEduProgUser]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectEduProgUser]
@UserID INT
AS
	BEGIN
		SELECT DISTINCT S.SemesterID,
		E.SubjectID,
		S.SubjectName,
		SR.RoleName,
		S.CourseID,
		E.FacultyID,
		F.FacultyName,
		E.TotalMark,
		E.Success
		FROM dbo.EduProg E
		JOIN dbo.Subject S
		ON S.SubjectID = E.SubjectID AND S.CourseID = E.CourseID
		JOIN dbo.CourseOrder C
		ON S.CourseID = C.CourseID
		JOIN dbo.SubjectRole SR
		ON S.SubjectRole = SR.RoleID 
		JOIN dbo.Faculty F
		ON S.FacultyID = F.FacultyID
		WHERE E.UserID = @UserID
		ORDER BY S.SemesterID ASC
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectExamByRequest]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectExamByRequest]
@SubjectID VARCHAR(50),
@IsMockTest BIT
AS
BEGIN
	IF (@IsMockTest = 1)
	BEGIN
		SELECT TOP(1) * FROM dbo.Exam
		WHERE SubjectID = @SubjectID AND ExamRole = 'mock-test'
		ORDER BY NEWID()
	END
	ELSE IF (@IsMockTest = 0)
	BEGIN
		SELECT TOP(1) * FROM dbo.Exam
		WHERE SubjectID = @SubjectID AND ExamRole = 'actual-test'
		ORDER BY NEWID()
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectFacultyByID]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectFacultyByID]
@FacultyID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.Faculty WHERE FacultyID = @FacultyID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectLeaderBoard]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectLeaderBoard]
AS
BEGIN
    SELECT U.UserID, U.FullName, S.SubjectName, S.SubjectID, T.CreatedAt, T.CorrectAnswer, T.TotalQuestion, T.Mark 
	FROM dbo.TestHistory T
	JOIN dbo.UserAccount U
	ON U.UserID = T.UserID 
	JOIN dbo.Subject S
	ON S.SubjectID = T.SubjectID
	ORDER BY T.Mark DESC
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectQuestionByID]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectQuestionByID]
@QuestionID INT
AS
BEGIN
    SELECT * FROM dbo.Question WHERE @QuestionID = QuestionID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectQuestionByRequest]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectQuestionByRequest]
@ExamID VARCHAR(50),
@SubjectID VARCHAR(50)
AS
BEGIN
		SELECT N'Câu ' + CONVERT(VARCHAR(20), ROW_NUMBER() OVER(ORDER BY NEWID())) AS QuestionIdx,
		QuestionID, ExamID, SubjectID, QContent, OptionA, OptionB, OptionC, OptionD, Answer FROM (
		SELECT QuestionID, ExamID, SubjectID, QContent, OptionA, OptionB, OptionC, OptionD, Answer FROM dbo.Question
		WHERE SubjectID = @SubjectID AND ExamID = @ExamID ) MyQuestion
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectSubjectByID]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectSubjectByID]
@SubjectID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.Subject WHERE SubjectID = @SubjectID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectSubjectFromEduProg]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectSubjectFromEduProg]
@UserID INT,
@IsMockTest BIT
AS
BEGIN
	IF (@IsMockTest = 0)
	BEGIN
	    SELECT * FROM ( SELECT DISTINCT S.SubjectID, S.SubjectName, E.SemesterID, E.UserID, E.Success FROM dbo.EduProg E JOIN dbo.Subject S
		ON E.UserID = @UserID AND S.SubjectID = E.SubjectID AND E.Success IS NULL
		JOIN dbo.UserClass U
		ON U.CourseID = E.CourseID
		AND U.FacultyID = E.FacultyID 
		AND (YEAR(GETDATE()) - U.AdmissionYear >= 0 
		AND YEAR(GETDATE()) - U.AdmissionYear <= U.NofTrainingSemester / 2
		--AND E.SemesterID - 1 <= (YEAR(GETDATE()) - U.AdmissionYear) * 2
		AND E.SemesterID <= 2 + (YEAR(GETDATE()) - U.AdmissionYear) * 2)
		/*JOIN dbo.CourseOrder C
		ON E.CourseID = C.CourseID AND E.SemesterID <= (C.Year * 2)*/) E
		WHERE EXISTS (SELECT * FROM dbo.Exam Ex JOIN dbo.User_QuizTimes UQ
		ON Ex.ExamID = UQ.ExamID AND Ex.SubjectID = UQ.SubjectID AND UQ.UserID = @UserID AND UQ.QuizTimes > 0
		WHERE E.SubjectID = Ex.SubjectID AND Ex.ExamRole = 'actual-test')
		AND E.UserID = @UserID
	END
    
	IF (@IsMockTest = 1)
	BEGIN
	    SELECT * FROM ( SELECT DISTINCT S.SubjectID, S.SubjectName, E.SemesterID, E.UserID, E.Success FROM dbo.EduProg E JOIN dbo.Subject S
		ON E.UserID = @UserID AND S.SubjectID = E.SubjectID
		JOIN dbo.UserClass U
		ON U.CourseID = E.CourseID
		AND U.FacultyID = E.FacultyID 
		AND (YEAR(GETDATE()) - U.AdmissionYear >= 0 
		AND YEAR(GETDATE()) - U.AdmissionYear <= U.NofTrainingSemester / 2
		AND E.SemesterID <= 2 + (YEAR(GETDATE()) - U.AdmissionYear) * 2)) E
		WHERE EXISTS (SELECT * FROM dbo.Exam Ex JOIN dbo.User_QuizTimes UQ
		ON Ex.ExamID = UQ.ExamID AND Ex.SubjectID = UQ.SubjectID AND UQ.UserID = @UserID AND UQ.QuizTimes > 0
		WHERE E.SubjectID = Ex.SubjectID AND Ex.ExamRole = 'mock-test')
		AND E.UserID = @UserID
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectTestHistory]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SelectTestHistory]
@UserID INT
AS
BEGIN
    SELECT S.SubjectName, S.SubjectID, T.CreatedAt, T.CorrectAnswer, T.TotalQuestion, T.Mark 
	FROM dbo.TestHistory T
	JOIN dbo.Subject S
	ON S.SubjectID = T.SubjectID
	WHERE T.UserID = @UserID
	ORDER BY T.TestID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SubjectCursor]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SubjectCursor]
@CourseID VARCHAR(50),
@FacultyID VARCHAR(50),
@UserID INT
AS
BEGIN
    DECLARE SubjectCursor CURSOR FOR SELECT SubjectID, CourseID, FacultyID, SemesterID 
	FROM dbo.Subject WHERE CourseID = @CourseID AND FacultyID = @FacultyID

	OPEN SubjectCursor

	DECLARE @SubjectID VARCHAR(50)
	DECLARE @Course VARCHAR(50)
	DECLARE @Faculty VARCHAR(50)
	DECLARE @Semester TINYINT
    
	DECLARE @EduProgID INT

	FETCH NEXT FROM SubjectCursor INTO @SubjectID, @Course, @Faculty, @Semester
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @EduProgID = 1
		SELECT @EduProgID = dbo.FUNC_GetEduProgIDMissing(@EduProgID)

		SET IDENTITY_INSERT dbo.UserAccount OFF
		SET IDENTITY_INSERT dbo.EduProg ON

		INSERT INTO dbo.EduProg
		(
			EProgID,
		    UserID,
		    CourseID,
		    FacultyID,
		    SemesterID,
		    SubjectID,
		    TotalMark,
		    Success
		)
		VALUES
		(
			@EduProgID,
			@UserID,   -- UserID - int
		    @Course,  -- CourseID - varchar(50)
		    @Faculty,  -- FacultyID - varchar(50)
		    @Semester,   -- SemesterID - tinyint
		    @SubjectID,  -- SubjectID - varchar(50)
		    NULL, -- TotalMark - float
		    NULL -- Success - bit
		    )

		SET IDENTITY_INSERT dbo.EduProg OFF

	    IF NOT EXISTS (SELECT * FROM dbo.EP_TFMark WHERE UserID = @UserID AND SubjectID = @SubjectID)
		BEGIN
		    EXEC dbo.USP_TFMarkCursor @UserID, @SubjectID
		END
		
		FETCH NEXT FROM SubjectCursor INTO @SubjectID, @Course, @Faculty, @Semester
	END

	CLOSE SubjectCursor
	DEALLOCATE SubjectCursor
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TFMarkCursor]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_TFMarkCursor]
@UserID INT,
@SubjectID VARCHAR(50)
AS
BEGIN
    DECLARE TFMarkCursor CURSOR FOR SELECT TestFormID FROM dbo.TestForm

	OPEN TFMarkCursor

	DECLARE @TestFormID VARCHAR(50)

	FETCH NEXT FROM TFMarkCursor INTO @TestFormID
	

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		INSERT dbo.EP_TFMark
		(
		    UserID,
		    SubjectID,
		    TestFormID,
		    Mark
		)
		VALUES
		(
		    @UserID,  -- UserID - int
			@SubjectID,  -- SubjectID - int
		    @TestFormID, -- TestFormID - varchar(50)
		    NULL -- Mark - float
		    )
	
		FETCH NEXT FROM TFMarkCursor INTO @TestFormID
	END

	CLOSE TFMarkCursor
	DEALLOCATE TFMarkCursor
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateAccount]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_UpdateAccount]
@UserID INT,
@UserRole varchar(50), 
@ClassID VARCHAR(50),
@Username varchar(100), 
@FullName nvarchar(100),
@Email varchar(100),
@PhoneNumber varchar(50),
@Address nvarchar(100),
@Birthday DATETIME,
@Note nvarchar(200),
@ModifiedBy varchar(50)
AS
BEGIN
    UPDATE [dbo].[UserAccount]
   SET [UserRole] = @UserRole  
	  ,[ClassID] = @ClassID
      ,[Username] = @Username  
      ,[FullName] = @FullName  
      ,[Email] = @Email  
      ,[PhoneNumber] = @PhoneNumber  
      ,[Address] = @ADDRESS  
      ,[Birthday] = @Birthday  
      ,[Note] = @Note  
      ,[ModifiedBy] = @ModifiedBy  
      ,[ModifiedAt] = GETDATE()
	  WHERE UserID = @UserID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateClass]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_UpdateClass]
 @ClassID varchar(50)
,@CourseID VARCHAR(50)
,@FacultyID nvarchar(50)
,@AdmissionYear SMALLINT
,@NofTrainingSemester TINYINT
,@Description nvarchar(500)
,@ModifiedBy varchar(50)
AS
BEGIN
UPDATE [dbo].[UserClass]
 SET  CourseID = @CourseID
	  ,FacultyID = @FacultyID
	  ,AdmissionYear = @AdmissionYear
	  ,NofTrainingSemester = @NofTrainingSemester
      ,[Description] = @Description 
	  ,[ModifiedBy] = @ModifiedBy
	  ,[ModifiedAt] = GETDATE()
 WHERE ClassID = @ClassID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateCourse]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_UpdateCourse]
 @CourseID varchar(50)
,@FacultyID nvarchar(50)
,@TrainingID VARCHAR(50)
,@Description nvarchar(500)
AS
BEGIN
UPDATE [dbo].[CourseOrder]
 SET   TrainingID = @TrainingID
      ,[Description] = @Description 
 WHERE CourseID = @CourseID AND FacultyID = @FacultyID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateExam]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UpdateExam]
@ExamID varchar(50)
,@SubjectID varchar(50)
,@TestFormID VARCHAR(50)
,@PercentMark TINYINT
,@ExamRole varchar(50)
,@ExamTime SMALLINT
,@QCount SMALLINT
,@QuizTimes TINYINT
,@Status BIT
,@ModifiedBy varchar(50)
AS
BEGIN
   UPDATE [dbo].[Exam]
   SET [TestFormID] = @TestFormID
      ,[PercentMark] = @PercentMark
      ,[ExamRole] = @ExamRole
	  ,[ExamTime] = @ExamTime
      ,[QCount] = @QCount
	  ,[QuizTimes] = @QuizTimes
	  ,[Status] = @Status
      ,[ModifiedBy] = @ModifiedBy
      ,[ModifiedAt] = GETDATE()
	  WHERE ExamID = @ExamID AND SubjectID = @SubjectID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateFaculty]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_UpdateFaculty]
 @FacultyID varchar(50)
,@FacultyName nvarchar(200)
,@FoundingDate DATE
,@Description nvarchar(500)
AS
BEGIN
UPDATE [dbo].[Faculty]
 SET   [FacultyName] = @FacultyName  
	  ,[FoundingDate] = @FoundingDate
      ,[Description] = @Description 
 WHERE FacultyID = @FacultyID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateQuestion]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UpdateQuestion]
@QuestionID INT
,@SubjectID varchar(50)
,@ExamID varchar(50)
,@QContent nvarchar(500)
,@OptionA nvarchar(500)
,@OptionB nvarchar(500)
,@OptionC nvarchar(500)
,@OptionD nvarchar(500)
,@Answer nvarchar(500)
,@ModifiedBy varchar(50)
AS
BEGIN
	UPDATE [dbo].[Question]
	   SET [SubjectID] = @SubjectID
		  ,[ExamID] = @ExamID
		  ,[QContent] = @QContent 
		  ,[OptionA] = @OptionA 
		  ,[OptionB] = @OptionB 
		  ,[OptionC] = @OptionC 
		  ,[OptionD] = @OptionD 
		  ,[Answer] = @Answer 
		  ,[ModifiedBy] = @ModifiedBy 
		  ,[ModifiedAt] = GETDATE()
		  WHERE QuestionID = @QuestionID 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateSubject]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_UpdateSubject]
 @SubjectID varchar(50)
,@SubjectRole VARCHAR(50)
,@CourseID VARCHAR(50)
,@FacultyID VARCHAR(50)
,@SemesterID TINYINT
,@SubjectName NVARCHAR(200)
,@Description nvarchar(500)
,@ModifiedBy varchar(50)
AS
BEGIN
UPDATE [dbo].[Subject]
 SET   [SubjectRole] = @SubjectRole
	  ,[CourseID] =@CourseID
	  ,[FacultyID]= @FacultyID
	  ,[SemesterID]= @SemesterID
	  ,[SubjectName] = @SubjectName  
      ,[Description] = @Description 
      ,[ModifiedBy] = @ModifiedBy  
      ,[ModifiedAt] = GETDATE()
 WHERE SubjectID = @SubjectID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UserQTCursor]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UserQTCursor]
@ExamID VARCHAR(50),
@SubjectID VARCHAR(50),
@QuizTimes TINYINT
AS
BEGIN
    DECLARE UserQTCursor CURSOR FOR SELECT DISTINCT U.UserID FROM dbo.User_QuizTimes UQ
	JOIN dbo.UserAccount U
	ON U.UserRole = 'User'
	JOIN dbo.UserClass C
	ON U.ClassID = C.ClassID
	JOIN dbo.Subject S
	ON S.SubjectID = @SubjectID AND S.CourseID = C.CourseID AND S.FacultyID = C.FacultyID

	OPEN UserQTCursor

	DECLARE @UserID INT

	FETCH NEXT FROM UserQTCursor INTO @UserID
	

	WHILE @@FETCH_STATUS = 0
	BEGIN

	INSERT dbo.User_QuizTimes
	(
	    UserID,
	    ExamID,
	    SubjectID,
	    QuizTimes
	)
	VALUES
	(   @UserID,  -- UserID - int
	    @ExamID, -- ExamID - varchar(50)
	    @SubjectID, -- SubjecctID - varchar(50)
	    @QuizTimes   -- QuizTimes - tinyint
	    )

		FETCH NEXT FROM UserQTCursor INTO @UserID
	END

	CLOSE UserQTCursor
	DEALLOCATE UserQTCursor
END
GO
/****** Object:  Trigger [dbo].[TG_EduProg]    Script Date: 12/2/2021 3:00:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_EduProg] ON [dbo].[EduProg]
FOR INSERT
AS
BEGIN
	DECLARE @UserID INT
    DECLARE @SubjectID VARCHAR(50)

	IF EXISTS (SELECT * FROM Inserted)
	BEGIN
		SELECT @UserID = I.UserID, @SubjectID = I.SubjectID FROM Inserted I
	    IF NOT EXISTS (SELECT * FROM dbo.EP_TFMark WHERE UserID = @UserID AND SubjectID = @SubjectID)
		BEGIN
		    EXEC dbo.USP_TFMarkCursor @UserID, @SubjectID
		END
	END
END
GO
ALTER TABLE [dbo].[EduProg] ENABLE TRIGGER [TG_EduProg]
GO
/****** Object:  Trigger [dbo].[TG_EPTF]    Script Date: 12/2/2021 3:00:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_EPTF] ON [dbo].[EP_TFMark]
FOR UPDATE
AS
BEGIN
	DECLARE @UserID INT
	DECLARE @SubjectID VARCHAR(50)

	SELECT @SubjectID = I.SubjectID, @UserID = I.UserID FROM Inserted I

    IF EXISTS (SELECT * FROM dbo.EP_TFMark WHERE SubjectID = @SubjectID AND UserID = @UserID
	AND TestFormID = 'CK' AND Mark IS NOT NULL)
	BEGIN
		DECLARE @Mark FLOAT
		SELECT @Mark = (SELECT ROUND((SUM(Mark) / 4), 2) FROM dbo.EP_TFMark);
		IF (@Mark <= 0)
			SELECT @Mark = 0
			
		SET ANSI_WARNINGS OFF;
	    UPDATE dbo.EduProg SET TotalMark = @Mark FROM dbo.EduProg E
		JOIN dbo.Subject S
		ON S.SubjectID = E.SubjectID AND S.CourseID = E.CourseID AND S.FacultyID = E.FacultyID AND S.SemesterID = E.SemesterID
		WHERE E.SubjectID = @SubjectID AND E.UserID = @UserID

		IF (@Mark >= 4)
			UPDATE dbo.EduProg SET Success = 1 FROM dbo.EduProg E
			JOIN dbo.Subject S
			ON S.SubjectID = E.SubjectID AND S.CourseID = E.CourseID AND S.FacultyID = E.FacultyID AND S.SemesterID = E.SemesterID
			WHERE E.SubjectID = @SubjectID AND E.UserID = @UserID
		ELSE
			UPDATE dbo.EduProg SET Success = 0 FROM dbo.EduProg E
			JOIN dbo.Subject S
			ON S.SubjectID = E.SubjectID AND S.CourseID = E.CourseID AND S.FacultyID = E.FacultyID AND S.SemesterID = E.SemesterID
			WHERE E.SubjectID = @SubjectID AND E.UserID = @UserID
	END
END
GO
ALTER TABLE [dbo].[EP_TFMark] ENABLE TRIGGER [TG_EPTF]
GO
/****** Object:  Trigger [dbo].[TG_Exam]    Script Date: 12/2/2021 3:00:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_Exam] ON [dbo].[Exam]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @ExamID VARCHAR(50)
	DECLARE @SubjectID VARCHAR(50)
	DECLARE @QuizTimes TINYINT

	
	IF EXISTS (SELECT * FROM Inserted) AND EXISTS (SELECT * FROM Deleted)
	BEGIN
		DECLARE @QuizTimes2 TINYINT
		SELECT @QuizTimes2 = Deleted.QuizTimes FROM Deleted
		SELECT @ExamID = Inserted.ExamID, @SubjectID = Inserted.SubjectID, @QuizTimes = Inserted.QuizTimes FROM Inserted
	    
		IF (@QuizTimes <> @QuizTimes2)
		BEGIN
			DECLARE @set TINYINT
			IF (@QuizTimes > @QuizTimes2)
			BEGIN
			    SELECT @set = @QuizTimes - @QuizTimes2
				UPDATE dbo.User_QuizTimes SET QuizTimes += @set FROM dbo.User_QuizTimes
				WHERE ExamID = @ExamID AND SubjectID = @SubjectID
			END
			ELSE IF (@QuizTimes < @QuizTimes2)
			BEGIN
			    SELECT @set = @QuizTimes2 - @QuizTimes
				UPDATE dbo.User_QuizTimes SET QuizTimes -= @set FROM dbo.User_QuizTimes
				WHERE ExamID = @ExamID AND SubjectID = @SubjectID
			END
		END
	END
	
	IF EXISTS (SELECT * FROM Inserted) AND NOT EXISTS (SELECT * FROM Deleted)
	BEGIN
		SELECT @ExamID = Inserted.ExamID, @SubjectID = Inserted.SubjectID, @QuizTimes = Inserted.QuizTimes FROM Inserted

		IF NOT EXISTS (SELECT * FROM dbo.User_QuizTimes WHERE ExamID = @ExamID AND SubjectID = @SubjectID)
		BEGIN
		    EXEC dbo.USP_UserQTCursor @ExamID, @SubjectID, @QuizTimes
		END
	END
	
	IF EXISTS (SELECT * FROM Deleted) AND NOT EXISTS (SELECT * FROM Inserted)
		BEGIN
		SELECT @ExamID = Deleted.ExamID, @SubjectID = Deleted.SubjectID FROM Deleted

		IF EXISTS (SELECT * FROM dbo.Question WHERE SubjectID = @SubjectID AND ExamID = @ExamID)
		BEGIN
			UPDATE dbo.Question SET ExamID = NULL, SubjectID = NULL FROM dbo.Question Q
			WHERE Q.SubjectID = @SubjectID AND Q.ExamID = @ExamID
		END

		IF EXISTS (SELECT * FROM dbo.TestHistory WHERE @SubjectID = SubjectID AND ExamID = @ExamID)
		BEGIN
			UPDATE dbo.TestHistory SET ExamID = NULL, SubjectID = NULL FROM dbo.TestHistory T
			WHERE T.SubjectID = @SubjectID AND T.ExamID = @ExamID
		END

		IF EXISTS (SELECT * FROM dbo.User_QuizTimes WHERE @SubjectID = SubjectID AND ExamID = @ExamID)
		BEGIN
			DELETE dbo.User_QuizTimes WHERE SubjectID = @SubjectID AND ExamID = @ExamID
		END
	END
END
GO
ALTER TABLE [dbo].[Exam] ENABLE TRIGGER [TG_Exam]
GO
/****** Object:  Trigger [dbo].[TG_Faculty]    Script Date: 12/2/2021 3:00:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_Faculty] ON [dbo].[Faculty]
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @FacultyID VARCHAR(50)
	DECLARE @FacultyName VARCHAR(200)
	DECLARE @error NVARCHAR(120)
	DECLARE @ErrorSeverity INT
	DECLARE @ErrorState INT

	SELECT @FacultyID = Deleted.FacultyID, @FacultyName = Deleted.FacultyName FROM Deleted

    IF EXISTS (SELECT * FROM dbo.CourseOrder WHERE @FacultyID = FacultyID)
	OR EXISTS (SELECT * FROM dbo.Subject WHERE @FacultyID = FacultyID)
	OR EXISTS (SELECT * FROM dbo.UserClass WHERE @FacultyID = FacultyID)
	OR EXISTS (SELECT * FROM dbo.EduProg WHERE @FacultyID = FacultyID)
	BEGIN
		BEGIN TRY
			-- RAISERROR with severity 11-19 will cause execution to 
			-- jump to the CATCH block.
			SELECT @error = CONCAT(N'Không thể xóa khoa "', @FacultyID,' - ', @FacultyName, N'" vì tồn tại dữ liệu ràng buộc liên quan!');
			RAISERROR (@error, -- Message text.
					   16, -- Severity.
					   1 -- State. 
					   )
			ROLLBACK TRAN
		END TRY
		BEGIN CATCH
			SELECT @error = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

			-- Use RAISERROR inside the CATCH block to return error
			-- information about the original error that caused
			-- execution to jump to the CATCH block.
			RAISERROR (@error, -- Message text.
					   @ErrorSeverity, -- Severity.
					   @ErrorState -- State.
					   )
			ROLLBACK TRAN
		END CATCH;
	END
	ELSE
	BEGIN
	    DELETE dbo.Faculty WHERE FacultyID = @FacultyID
	END
END
GO
ALTER TABLE [dbo].[Faculty] ENABLE TRIGGER [TG_Faculty]
GO
/****** Object:  Trigger [dbo].[TG_Question]    Script Date: 12/2/2021 3:00:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_Question] ON [dbo].[Question]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @ExamID VARCHAR(50)
	DECLARE @ExamIDDel VARCHAR(50)
	DECLARE @SubjectID VARCHAR(50)
	DECLARE @SubjectIDDel VARCHAR(50)
	DECLARE @SubjectName NVARCHAR(200)
	DECLARE @QCount INT

	SELECT @ExamID = I.ExamID, @SubjectID = I.SubjectID, @SubjectName = S.SubjectName FROM Inserted I JOIN dbo.Subject S ON I.SubjectID = S.SubjectID
	SELECT @ExamIDDel = Deleted.ExamID, @SubjectIDDel = Deleted.SubjectID FROM Deleted
	SELECT @QCount = E.QCount FROM Inserted I JOIN dbo.Exam E ON I.ExamID = E.ExamID AND I.SubjectID = E.SubjectID

    IF EXISTS (SELECT * FROM dbo.Exam WHERE @ExamID = ExamID AND @SubjectID = SubjectID AND QCurrentCount >= QCount)
	BEGIN
		DECLARE @error NVARCHAR(150)
		SELECT @error = CONCAT(N'Không thể sửa hoặc thêm câu hỏi cho mã đề -', @ExamID, N'- thuộc môn -', @SubjectName , N'- nữa vì đã quá số lượng ', CAST(@QCount AS VARCHAR), N' câu hỏi cho phép trên mã đề này!');
		RAISERROR (@error, 16, 1)
		ROLLBACK TRAN
	END
	ELSE 
	BEGIN
		SET NOCOUNT ON;

		IF EXISTS (SELECT * FROM Inserted) AND EXISTS (SELECT * FROM Deleted)
		BEGIN
			-- UPDATE
			IF EXISTS (SELECT * FROM dbo.Exam WHERE @ExamID = ExamID AND @SubjectID = SubjectID AND QCurrentCount < QCount)
				UPDATE dbo.Exam SET QCurrentCount += 1 WHERE @ExamID = ExamID AND SubjectID = @SubjectID
			IF EXISTS (SELECT * FROM dbo.Exam E WHERE @ExamIDDel = E.ExamID AND E.SubjectID = @SubjectIDDel AND E.QCurrentCount > 0)
				UPDATE dbo.Exam SET QCurrentCount -= 1 WHERE @ExamIDDel = ExamID AND SubjectID = @SubjectIDDel
		END
		ELSE IF EXISTS(SELECT * FROM Inserted) AND NOT EXISTS (SELECT * FROM Deleted)
		BEGIN
			-- INSERT
			IF EXISTS (SELECT * FROM dbo.Exam WHERE @ExamID = ExamID AND @SubjectID = SubjectID AND QCurrentCount < QCount)
				UPDATE dbo.Exam SET QCurrentCount += 1 WHERE @ExamID = ExamID AND SubjectID = @SubjectID
		END
		ElSE IF EXISTS(SELECT * FROM Deleted) AND NOT EXISTS (SELECT * FROM Inserted)
		BEGIN
			-- DELETE
			IF EXISTS (SELECT * FROM dbo.Exam E WHERE @ExamIDDel = E.ExamID AND E.SubjectID = @SubjectIDDel AND E.QCurrentCount > 0)
				UPDATE dbo.Exam SET QCurrentCount -= 1 WHERE @ExamIDDel = ExamID AND SubjectID = @SubjectIDDel
		END
	END
END
GO
ALTER TABLE [dbo].[Question] ENABLE TRIGGER [TG_Question]
GO
/****** Object:  Trigger [dbo].[TG_Subject]    Script Date: 12/2/2021 3:00:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_Subject] ON [dbo].[Subject]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @SubjectID VARCHAR(50)
	DECLARE @CourseID VARCHAR(50)
	DECLARE @FacultyID VARCHAR(50)
	DECLARE @SemesterID TINYINT

	IF EXISTS (SELECT * FROM Inserted) AND NOT EXISTS (SELECT * FROM Deleted)
	BEGIN
		SELECT @SubjectID = I.SubjectID, @CourseID = I.CourseID, @FacultyID = I.FacultyID, @SemesterID = I.SemesterID FROM Inserted I

		IF EXISTS (SELECT * FROM dbo.EduProg WHERE CourseID = @CourseID AND FacultyID = @FacultyID)
		BEGIN
			EXEC USP_EduProgCursor @SubjectID, @CourseID, @FacultyID, @SemesterID
		END
	END

	IF EXISTS (SELECT * FROM Deleted) AND NOT EXISTS (SELECT * FROM Inserted)
	BEGIN
		SELECT @SubjectID = D.SubjectID, @CourseID = D.CourseID, @FacultyID = D.FacultyID FROM Deleted D

	    IF EXISTS (SELECT * FROM dbo.TestHistory WHERE @SubjectID = SubjectID)
		BEGIN
			UPDATE dbo.TestHistory SET SubjectID = NULL FROM dbo.TestHistory T
			WHERE T.SubjectID = @SubjectID
		END

		IF EXISTS (SELECT * FROM dbo.Question WHERE @SubjectID = SubjectID)
		BEGIN
			UPDATE dbo.Question SET SubjectID = NULL FROM dbo.Question Q
			WHERE Q.SubjectID = @SubjectID
		END

		IF EXISTS (SELECT * FROM dbo.Exam E WHERE @SubjectID  = SubjectID)
		BEGIN
			DELETE dbo.Exam FROM dbo.Exam E
			WHERE E.SubjectID = @SubjectID
		END

		IF EXISTS (SELECT * FROM dbo.EP_TFMark WHERE @SubjectID = SubjectID)
		BEGIN
			DELETE dbo.EP_TFMark WHERE SubjectID = @SubjectID
		END
		
		IF EXISTS (SELECT * FROM dbo.EduProg E WHERE @SubjectID = SubjectID)
		BEGIN
			DELETE dbo.EduProg FROM dbo.EduProg E
			WHERE @SubjectID = E.SubjectID AND @CourseID = E.CourseID AND @FacultyID = E.FacultyID
		END

		IF EXISTS (SELECT * FROM dbo.User_QuizTimes U WHERE @SubjectID  = SubjectID)
		BEGIN
			DELETE dbo.User_QuizTimes FROM dbo.User_QuizTimes U
			WHERE U.SubjectID = @SubjectID
		END
	END
	
	IF EXISTS (SELECT * FROM Inserted) AND EXISTS (SELECT * FROM Deleted)
	BEGIN
	    DECLARE @SemesterID2 TINYINT
		SELECT @SemesterID = D.SemesterID FROM Deleted D
		SELECT @SubjectID = I.SubjectID, @CourseID = I.CourseID, @FacultyID = I.FacultyID, @SemesterID2 = I.SemesterID FROM Inserted I
		
		IF (@SemesterID <> @SemesterID2)
		BEGIN
		    IF EXISTS (SELECT * FROM dbo.TestHistory WHERE @SubjectID = SubjectID)
			BEGIN
				UPDATE dbo.TestHistory SET SemesterID = @SemesterID2 FROM dbo.TestHistory T
				WHERE T.SubjectID = @SubjectID
			END

			IF EXISTS (SELECT * FROM dbo.EduProg E WHERE @SubjectID = SubjectID)
			BEGIN
				UPDATE dbo.EduProg SET SemesterID = @SemesterID2 FROM dbo.EduProg E
				WHERE @SubjectID = E.SubjectID AND @CourseID = E.CourseID AND @FacultyID = E.FacultyID
			END
		END
	END
END
GO
ALTER TABLE [dbo].[Subject] ENABLE TRIGGER [TG_Subject]
GO
/****** Object:  Trigger [dbo].[TG_TestHistory]    Script Date: 12/2/2021 3:00:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_TestHistory] ON [dbo].[TestHistory]
FOR	INSERT
AS
BEGIN
	DECLARE @UserID INT
	DECLARE @SubjectID VARCHAR(50)
	DECLARE @TestFormID VARCHAR(50)
	DECLARE @Mark FLOAT

	SELECT @SubjectID = S.SubjectID, @UserID = I.UserID, @TestFormID = Ex.TestFormID, @Mark = ROUND(CAST((I.Mark * Ex.PercentMark / 100) AS FLOAT), 2) FROM Inserted I
	JOIN dbo.Exam Ex
	ON Ex.ExamID = I.ExamID AND Ex.SubjectID = I.SubjectID
	JOIN dbo.TestForm TFrm
	ON TFrm.TestFormID = Ex.TestFormID
	JOIN dbo.Subject S
	ON S.SubjectID = I.SubjectID AND S.SubjectID = Ex.SubjectID

	IF (@TestFormID IS NOT NULL AND EXISTS (SELECT * FROM dbo.TestForm WHERE TestFormID = @TestFormID))
	BEGIN
		IF (@Mark <= 0)
			SELECT @Mark = 0
		SET ANSI_WARNINGS OFF;
	    UPDATE dbo.EP_TFMark SET Mark = @Mark FROM dbo.EP_TFMark
		WHERE UserID = @UserID AND SubjectID = @SubjectID AND TestFormID = @TestFormID
	END
END
GO
ALTER TABLE [dbo].[TestHistory] ENABLE TRIGGER [TG_TestHistory]
GO
/****** Object:  Trigger [dbo].[TG_Account]    Script Date: 12/2/2021 3:00:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TG_Account] ON [dbo].[UserAccount]
FOR INSERT, DELETE
AS
BEGIN
	DECLARE @UserID INT
	DECLARE @ClassID VARCHAR(50)
	DECLARE @FacultyID VARCHAR(50)
	DECLARE @UserRole VARCHAR(50)
	DECLARE @CourseID VARCHAR(50)

	IF EXISTS (SELECT * FROM Inserted)
	BEGIN
		SELECT @UserID = I.UserID, @ClassID = I.ClassID, @UserRole = I.UserRole FROM Inserted I
		SELECT @CourseID = CourseID, @FacultyID = FacultyID FROM dbo.UserClass WHERE ClassID = @ClassID
	
		IF (@ClassID IS NOT NULL AND EXISTS (SELECT * FROM dbo.UserClass WHERE ClassID = @ClassID) AND @UserRole = 'User')
		BEGIN
			EXEC USP_SubjectCursor @CourseID, @FacultyID, @UserID
			EXEC dbo.USP_ExamCursor @UserID, @ClassID
		END
	END

	IF EXISTS (SELECT * FROM Deleted)
	BEGIN
		SELECT @UserID = D.UserID FROM Deleted D

		IF EXISTS (SELECT * FROM dbo.TestHistory WHERE @UserID = UserID)
		BEGIN
			DELETE dbo.TestHistory WHERE UserID = @UserID
		END

		IF EXISTS (SELECT * FROM dbo.EP_TFMark WHERE @UserID = UserID)
		BEGIN
			DELETE dbo.EP_TFMark WHERE UserID = @UserID
		END

		IF EXISTS (SELECT * FROM dbo.EduProg WHERE @UserID = UserID)
		BEGIN
			DELETE dbo.EduProg WHERE UserID = @UserID
		END

		IF EXISTS (SELECT * FROM dbo.User_QuizTimes WHERE @UserID = UserID)
		BEGIN
			DELETE dbo.User_QuizTimes WHERE UserID = @UserID
		END
	END
END
GO
ALTER TABLE [dbo].[UserAccount] ENABLE TRIGGER [TG_Account]
GO
USE [master]
GO
ALTER DATABASE [TestProjectDB] SET  READ_WRITE 
GO
