USE HowKteam
GO

/*
-- Store PROCEDURE
- Là chương trình hay thủ tục
- Ta có thể dùng Transact - SQL EXCUTE (EXEC) để thực thi các Stored PROCEDURE
- Stored PROCEDURE khác với các hàm xử lý là giá trị trả về của chúng
- Không chứa trong tên và chúng không được sử dụng trực tiếp trong biểu thức
*/

/*
- Động: Có thể chỉnh sửa khối lệnh, tái sử dụng nhiều lần
- Nhanh hơn: Tự phân tích cú pháp cho tối ưu. Và tạo bản sao để lần chạy sau
không cần thực thi lại từ đầu
- Bảo mật: Giới hạn quyền cho user nào sử dụng user nào không
- Giảm bandwidth: Với các gói transaction lớn. Vài ngàn dòng lệnh một lúc thì
dùng Store sẽ đảm bảo.
*/

/*
CREATE PROC <Tên Store>
[Parameter nếu có]
AS
BEGIN
	<Code xử lý>
END

Nếu chỉ là câu truy vấn thì có thể không cần BEGIN và END
*/

--------------------------------------------------------------------------------

CREATE PROCEDURE USP_Test
@MaGV NVARCHAR(10), @Luong INT
AS
BEGIN
    SELECT * FROM dbo.GIAOVIEN WHERE MAGV = @MaGV AND LUONG = @Luong
END
GO

EXECUTE dbo.USP_Test @MaGV = N'', -- nvarchar(10)
                     @Luong = 0   -- int
EXECUTE dbo.USP_Test N'', 0
GO

CREATE PROC USP_SelectAllGiaoVien
AS SELECT * FROM dbo.GIAOVIEN
GO

EXEC dbo.USP_SelectAllGiaoVien