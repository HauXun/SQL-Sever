-- use Master
use model
-- use msdb
-- use tempdb

create database DanhBa
go

use DanhBa

create table ThongTin
(
	HoVaTen nvarchar(100), 
	DiaChi nvarchar(200),
	NgaySinh date,
	SDT varchar(15)
);

-- Thay đổi cột SDT
alter table ThongTin alter column SDT varchar(12);

-- Thêm cột
alter table ThongTin add GhiChu nvarchar(100);

-- Xóa cột
alter table ThongTin drop column GhiChu;

-- Thêm đúng thứ tự tất cả các cột
insert into ThongTin values(N'Trần Nam', N'Hải Dương', '05/16/2000', '0894746162')
insert into ThongTin values(N'Trần Hào', N'Hải Phòng', '12/26/2001', '0539851383')
insert into ThongTin values(N'Trần Thanh', N'Hà Nội', '05/26/2000', '08947412162')
insert into ThongTin values(N'Trần Sơn', N'Bình Dương', '07/26/2000', '08947523162')
insert into ThongTin values(N'Trần Linh', N'Bình Thuận', '07/04/2002', '0894752362')

-- Tùy biến
insert into ThongTin (HoVaTen, DiaChi, NgaySinh, SDT, [Gioi Tinh]) values(N'Nguyễn Hữu', N'Bình Dương', '08/05/2002', '0894122362', 0)

-- Lỗi định dạng tiếng Ziệt
insert into ThongTin values(N'Trần Quang', N'Bình Thuận', '07/26/2000', '08947523162')

select * from ThongTin
select HoVaTen from ThongTin
select HoVaTen as N'Họ và Tên', NgaySinh as 'Ngày sinh', DiaChi from ThongTin

-- Sắp tăng theo họ tên
select * from ThongTin order by HoVaTen

-- Sắp giảm theo họ tên
select * from ThongTin order by HoVaTen desc

-- Tìm theo tháng 7
select * from ThongTin where [Gioi Tinh] is null

-- Tìm theo tháng (khác tháng 7)
select * from ThongTin where month(NgaySinh) != 7

-- Tìm theo tháng 7 và có địa chỉ là Bình Thuận
select * from ThongTin where month(NgaySinh) = 7 and DiaChi = N'Bình Thuận'

-- Cập nhập thông tin
update ThongTin set SDT = '123123123' where DiaChi = N'Bình Thuận'

-- Xóa hết dữ liệu
delete from ThongTin

-- Xóa có điều kiện
delete from ThongTin where DiaChi = N'Bình Thuận'

-- Tìm (địa chỉ bắt đầu bằng Hải)
select * from ThongTin where DiaChi like N'Hải%'

-- Tìm địa chỉ kết thúc bằng chữ 'Ng'
select * from ThongTin where DiaChi like N'%Ng'