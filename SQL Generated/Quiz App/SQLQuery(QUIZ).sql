USE master
GO

USE TestProjectDB
GO

 -- Turn recursive triggers OFF in the database. 
ALTER DATABASE TestProjectDB    
SET RECURSIVE_TRIGGERS OFF 
GO

ALTER TABLE dbo.UserClass ADD CONSTRAINT FK_UserClass_Faculty FOREIGN KEY (FacultyID) REFERENCES dbo.Faculty (FacultyID)
ALTER TABLE dbo.Question ADD CONSTRAINT FK_Question_Exam FOREIGN KEY (ExamID, SubjectID) REFERENCES dbo.Exam (ExamID, SubjectID)
ALTER TABLE dbo.TestHistory ADD CONSTRAINT FK_TestHistory_Exam FOREIGN KEY (ExamID, SubjectID) REFERENCES dbo.Exam (ExamID, SubjectID)
ALTER TABLE dbo.EduProg ADD CONSTRAINT FK_EduProg_CourseOrder FOREIGN KEY (CourseID, FacultyID) REFERENCES dbo.CourseOrder (CourseID, FacultyID)
ALTER TABLE dbo.EduProg ADD CONSTRAINT FK_EduProg_Faculty FOREIGN KEY (FacultyID) REFERENCES dbo.Faculty (FacultyID)
ALTER TABLE dbo.Subject WITH NOCHECK ADD CONSTRAINT FK_Subject_SubjectRole FOREIGN KEY (SubjectRole) REFERENCES dbo.SubjectRole (RoleID)
ALTER TABLE dbo.Subject WITH NOCHECK ADD CONSTRAINT FK_Subject_Semester FOREIGN KEY (SemesterID) REFERENCES dbo.Semester (SemesterID)
ALTER TABLE dbo.Subject WITH NOCHECK ADD CONSTRAINT FK_Subject_CourseOrder FOREIGN KEY (CourseID, FacultyID) REFERENCES dbo.CourseOrder (CourseID, FacultyID)
ALTER TABLE dbo.Subject WITH NOCHECK ADD CONSTRAINT FK_Subject_Faculty FOREIGN KEY (FacultyID) REFERENCES dbo.Faculty (FacultyID)
ALTER TABLE dbo.User_QuizTimes WITH NOCHECK ADD CONSTRAINT FK_UQT_Subject FOREIGN KEY (SubjectID) REFERENCES dbo.Subject (SubjectID)
GO

-----------------------------------------------------------------------------------------

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

-------------------------------------- UserAccount --------------------------------------

CREATE PROC USP_CheckExistAccount
@Username VARCHAR(100),
@Password VARCHAR(200)
AS
BEGIN
    SELECT UserID FROM dbo.UserAccount
	WHERE @Username = Username
	AND @Password = Password
END
GO

CREATE PROC USP_ChangeInfoAccount
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

CREATE PROC USP_ResetPassword
@Username VARCHAR(100)
AS
BEGIN
    UPDATE dbo.UserAccount SET Password = '223018912569815552702387813134219207146'
	WHERE Username = @Username
END
GO

CREATE PROC USP_GetAccountByUserName
@Username VARCHAR(100)
AS
BEGIN
    SELECT * FROM dbo.UserAccount
	WHERE @Username = Username
END
GO

CREATE PROC USP_GetAccountIDMissing
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

CREATE PROC USP_SelectAllAccount
AS 
	BEGIN
		SELECT * FROM dbo.UserAccount
	END
GO

CREATE PROC USP_InsertAccount
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

CREATE PROC USP_UpdateAccount
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

CREATE PROC USP_DeleteAccount
@UserID INT
AS
BEGIN
    DELETE dbo.UserAccount WHERE UserID = @UserID
END
GO

CREATE PROC USP_SearchAccount
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

CREATE PROC USP_TFMarkCursor
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

CREATE PROC USP_SubjectCursor
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

CREATE PROC USP_ExamCursor
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

CREATE TRIGGER TG_Account ON dbo.UserAccount
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

-----------------------------------------------------------------------------------------

----------------------------------------- UserRole ---------------------------------------

CREATE PROC USP_SelectAllUserRole
AS 
	BEGIN
		SELECT * FROM dbo.UserRole
	END
GO

-----------------------------------------------------------------------------------------

----------------------------------------- Subject ---------------------------------------

ALTER PROC USP_SelectSubjectFromEduProg
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

CREATE PROC USP_SelectSubjectByID
@SubjectID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.Subject WHERE SubjectID = @SubjectID
END
GO

CREATE PROC USP_SelectAllSubject
AS
	BEGIN
		SELECT * FROM dbo.Subject
		ORDER BY SubjectID ASC
	END
GO

ALTER PROC USP_InsertSubject
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

ALTER PROC USP_UpdateSubject
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

ALTER PROC USP_DeleteSubject
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

CREATE PROC USP_SearchSubject
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

CREATE PROC USP_EduProgCursor
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

CREATE TRIGGER TG_Subject ON dbo.Subject
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @SubjectID VARCHAR(50)
	DECLARE @CourseID VARCHAR(50)
	DECLARE @FacultyID VARCHAR(50)
	DECLARE @SemesterID TINYINT
	DECLARE @error NVARCHAR(120)

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

-----------------------------------------------------------------------------------------

----------------------------------------- Question ---------------------------------------

CREATE PROC USP_SelectQuestionByID
@QuestionID INT
AS
BEGIN
    SELECT * FROM dbo.Question WHERE @QuestionID = QuestionID
END
GO

CREATE PROC USP_SelectQuestionByRequest
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

CREATE PROC USP_GetQuestionIDMissing
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

CREATE PROC USP_SelectAllQuestion
AS
	BEGIN
		SELECT * FROM dbo.Question
		ORDER BY QuestionID ASC
	END
GO

CREATE PROC USP_InsertQuestion
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

CREATE PROC USP_UpdateQuestion
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

CREATE PROC USP_DeleteQuestion
@QuestionID INT
AS
BEGIN
	DELETE dbo.Question WHERE QuestionID = @QuestionID
END
GO

CREATE PROC USP_SearchQuestion
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

ALTER TRIGGER TG_Question ON dbo.Question
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

-----------------------------------------------------------------------------------------

------------------------------------------- Exam ----------------------------------------

CREATE PROC USP_SelectExamByRequest
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

CREATE PROC USP_CancleQuizTimes
@UserID INT,
@ExamID VARCHAR(50),
@SubjectID VARCHAR(50)
AS
BEGIN
	UPDATE dbo.User_QuizTimes SET QuizTimes -= 1 FROM dbo.User_QuizTimes
	WHERE UserID = @UserID AND ExamID = @ExamID AND SubjectID = @SubjectID AND QuizTimes > 0
END
GO

CREATE PROC USP_GetExamByIDSubject
@SubjectID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.Exam WHERE @SubjectID = SubjectID
END
GO

CREATE PROC USP_SelectAllExam
AS 
	BEGIN
		SELECT * FROM dbo.Exam
	END
GO

CREATE PROC USP_InsertExam
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

CREATE PROC USP_UpdateExam
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

CREATE PROC USP_DeleteExam
@ExamID varchar(50),
@SubjectID VARCHAR(50)
AS
BEGIN
    DELETE dbo.Exam WHERE ExamID = @ExamID AND SubjectID = @SubjectID
END
GO

CREATE PROC USP_SearchExam
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

CREATE PROC USP_UserQTCursor
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

CREATE TRIGGER TG_Exam ON dbo.Exam
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

-----------------------------------------------------------------------------------------

---------------------------------------- ExamRole ---------------------------------------

CREATE PROC USP_SelectAllRoleExam
AS 
	BEGIN
		SELECT * FROM dbo.ExamRole
	END
GO

-----------------------------------------------------------------------------------------

---------------------------------------- TestForm ---------------------------------------

CREATE PROC USP_SelectAllTestForm
AS 
	BEGIN
		SELECT * FROM dbo.TestForm
	END
GO

-----------------------------------------------------------------------------------------

----------------------------------------- Faculty ---------------------------------------

CREATE PROC USP_SelectFacultyByID
@FacultyID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.Faculty WHERE FacultyID = @FacultyID
END
GO

CREATE PROC USP_SelectAllFaculty
AS
	BEGIN
		SELECT * FROM dbo.Faculty
		ORDER BY FacultyID ASC
	END
GO

CREATE PROC USP_InsertFaculty
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

CREATE PROC USP_UpdateFaculty
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

CREATE PROC USP_DeleteFaculty
 @FacultyID varchar(50)
 AS
 BEGIN
     DELETE dbo.Faculty WHERE FacultyID = @FacultyID
 END
 GO

CREATE PROC USP_SearchFaculty
@keyword NVARCHAR(200)
AS 
BEGIN
    SELECT * FROM dbo.Faculty
	WHERE [dbo].[fuConvertToUnsign](FacultyID) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%' 
	OR [dbo].[fuConvertToUnsign](FacultyName) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
	OR [dbo].[fuConvertToUnsign](Description) LIKE N'%' + [dbo].[fuConvertToUnsign](@keyword) + '%'
END
GO

CREATE TRIGGER TG_Faculty ON dbo.Faculty
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

-----------------------------------------------------------------------------------------

----------------------------------------- CourseOrder ---------------------------------------

CREATE PROC USP_SelectAllCourseByFaculty
@FacultyID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.CourseOrder WHERE FacultyID = @FacultyID
	ORDER BY CourseID ASC
END
GO

CREATE PROC USP_SelectAllCourse
AS
	BEGIN
		SELECT * FROM dbo.CourseOrder
		ORDER BY CourseID ASC
	END
GO

CREATE PROC USP_InsertCourse
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

CREATE PROC USP_UpdateCourse
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

CREATE PROC USP_DeleteCourse
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

CREATE PROC USP_SearchCourse
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

-----------------------------------------------------------------------------------------

-------------------------------------- TrainingRole -------------------------------------

CREATE PROC USP_SelectAllTrainingRole
AS 
	BEGIN
		SELECT * FROM dbo.TrainingRole
	END
GO

-----------------------------------------------------------------------------------------

---------------------------------------- UserClass --------------------------------------

CREATE PROC USP_IsExistContraintClass
@ClassID VARCHAR(50)
AS
BEGIN
    SELECT UserID FROM dbo.UserAccount WHERE ClassID = @ClassID
END
GO

CREATE PROC USP_SelectClassByCourseID
@CourseID VARCHAR(50)
AS
BEGIN
    SELECT * FROM dbo.UserClass
	WHERE CourseID = @CourseID
END
GO

CREATE PROC USP_SelectAllClass
AS
	BEGIN
		SELECT * FROM dbo.UserClass
		ORDER BY ClassID ASC
	END
GO

CREATE PROC USP_InsertClass
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

CREATE PROC USP_UpdateClass
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

CREATE PROC USP_DeleteClass
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

CREATE PROC USP_SearchClass
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

-----------------------------------------------------------------------------------------

----------------------------------------- Semester --------------------------------------

CREATE PROC USP_SelectAllSemester
AS 
	BEGIN
		SELECT * FROM dbo.Semester
	END
GO

-----------------------------------------------------------------------------------------

--------------------------------------- SubjectRole -------------------------------------

CREATE PROC USP_SelectAllSubjectRole
AS 
	BEGIN
		SELECT * FROM dbo.SubjectRole
	END
GO

-----------------------------------------------------------------------------------------

--------------------------------------- TestHistory -------------------------------------

CREATE PROC USP_SelectLeaderBoard
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

CREATE PROC USP_SelectTestHistory
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

CREATE PROC USP_InsertTestHistory
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

CREATE PROC USP_SearchHistory
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

ALTER TRIGGER TG_TestHistory ON dbo.TestHistory
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

-----------------------------------------------------------------------------------------

----------------------------------------- EduProg ---------------------------------------

CREATE FUNCTION FUNC_GetEduProgIDMissing (@EduProgID INT)
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


CREATE PROC USP_SelectEduProg
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

CREATE PROC USP_SelectEduProgUser
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

CREATE PROC USP_SearchEduProg
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


CREATE TRIGGER TG_EduProg ON dbo.EduProg
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

-----------------------------------------------------------------------------------------

----------------------------------------- EP_TFMark ---------------------------------------

ALTER TRIGGER TG_EPTF ON dbo.EP_TFMark
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

-----------------------------------------------------------------------------------------

SELECT message_id AS Error, severity AS Severity,  
[Event Logged] = CASE is_event_logged WHEN 0 THEN 'No' ELSE 'Yes' END,
text AS [Description]
FROM sys.messages
WHERE language_id = 1040 /* replace 1040 with the desired language ID, such as 1033 for US English*/
ORDER BY message_id
GO

SELECT DSS.servicename,
       DSS.startup_type_desc,
       DSS.status_desc,
       DSS.last_startup_time,
       DSS.service_account,
       DSS.is_clustered,
       DSS.cluster_nodename,
       DSS.filename,
       DSS.startup_type,
       DSS.status,
       DSS.process_id
FROM   sys.dm_server_services AS DSS;   

SELECT * FROM sys.databases d
WHERE d.database_id > 4

SELECT CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'SE Asia Standard Time')))