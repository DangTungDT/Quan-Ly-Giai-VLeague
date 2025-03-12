--Tao database
create database HeThongQuanLyGiaiDauVLeague
go
use HeThongQuanLyGiaiDauVLeague
go

--Chỉnh format về dmy
set dateformat dmy
go

--Tạo bảng Giải đấu
create table GiaiDau
(
	MaGiaiDau int IDENTITY(1,1) not null,
	Ten nvarchar(500),
	Nam int,
	SoLuongDoi int,
	SoVong int,
	MoTa nvarchar(max),
	primary key(MaGiaiDau),
	constraint chk_GiaiDau check (Nam > 0 and SoLuongDoi > 0 and SoVong> 0)
)
go

--Tạo bảng vòng đấu
create table VongDau
(
	MaVongDau int IDENTITY(1,1) not null,
	SoVong int,
	MaGiaiDau int,
	MoTa nvarchar(max),
	primary key(MaVongDau),
	constraint chk_VongDau check (SoVong > 0)
)
go

--Tạo bảng Trọng tài
create table TrongTai
(
	MaTrongTai int IDENTITY(1,1) not null,
	Ten nvarchar(500),
	NgaySinh date,
	KinhNghiem nvarchar(50),
	BangCap nvarchar(500),
	primary key(MaTrongTai),
	constraint chk_TrongTai check (NgaySinh <= dateadd(year, -18, getdate()))
)
go

--Tạo bảng phụ cho 2 bảng (TrongTai và TranDau)
create table TrongTai_TranDau
(
	MaTrongTai int not null,
	MaTranDau int not null,
	primary key(MaTrongTai, MaTranDau)
)
go

--Tạo bảng thẻ phạt
create table ThePhat
(
	MaThePhat int IDENTITY(1,1) not null,
	LoaiThe nvarchar(50),
	ThoiGianRaThe nvarchar(50),
	MaTranDau int,
	MaCauThu int,
	MaTrongTai int,
	primary key(MaThePhat),
	constraint chk_ThePhat check (LoaiThe like N'Thẻ vàng' or LoaiThe like N'Thẻ đỏ')
)
go

--Tạo bảng bàn thắng
create table BanThang
(
	MaBanThang int IDENTITY(1,1) not null,
	ThoiGianGhiBan nvarchar(50),
	LoaiBanThang nvarchar(50),
	MaCauThu int,
	MaTranDau int,
	primary key(MaBanThang)
)
go

--Tạo bảng Sân vân động
create table SanVanDong
(
	MaSanVanDong int identity(1,1) not null,
	TenSan nvarchar(255),
	DiaChi nvarchar(255),
	NamXayDung int,
	MaCauLacBo int,
	primary key(MaSanVanDong)
)
go

--Tạo bảng Câu Lạc Bộ
create table CauLacBo
(
	MaCauLacBo int identity(1,1) not null,
	Ten nvarchar(255),
	Logo nvarchar(500),
	DiaChi nvarchar(255),
	ChuSoHuu nvarchar(255),
	MaSanVanDong int,
	primary key(MaCauLacBo)
)
go

--Tạo bảng cầu thủ
create table CauThu
(
	MaCauThu int identity(1,1) not null,
	Ten nvarchar(255),
	NgaySinh date,
	ViTriChoi nvarchar(100),
	SoAo int,
	CanNang float,
	ChieuCao float,
	LichSuThiDau varchar(max),
	MaCauLacBo int,
	primary key(MaCauThu),
	constraint chk_CauThu check (NgaySinh <= dateadd(year, -16, getdate()))
)
go

--Tạo bảng Huấn luyện viên
create table HuanLuyenVien
(
	MaHuanLuyenVien int identity(1,1) not null,
	Ten nvarchar(255),
	NgaySinh date,
	KinhNghiem nvarchar(50),
	BangCap nvarchar(500),
	LichSuThiDau varchar(max),
	MaCauLacBo int,
	primary key(MaHuanLuyenVien),
	constraint chk_HuanLuyenVien check (NgaySinh <= dateadd(year, -18, getdate()))
)
go

--Tạo bảng phụ cho 2 bảng (HuanLuyenVien và TranDau)
create table HuanLuyenVien_TranDau
(
	MaHuanLuyenVien int not null,
	MaTranDau int not null,
	primary key(MaHuanLuyenVien, MaTranDau)
)
go

--Tạo bảng phụ cho 2 bảng (CauThu và TranDau)
create table CauThu_TranDau
(
	MaCauThu int not null,
	MaTranDau int not null,
	primary key(MaCauThu, MaTranDau)
)
go

--Tạo bảng phụ cho 2 bảng (CauLacBo và TranDau)
create table CauLacBo_TranDau
(
	MaCauLacBo int not null,
	MaTranDau int not null,
	LoaiDoi nvarchar(50), --đội chủ nhà hoặc đội khách
	primary key(MaCauLacBo, MaTranDau)
)
go

--Tạo table trận đấu
create table TranDau
(
	MaTranDau int identity(1,1) not null,
	NgayThiDau date,
	KetQuaHiep1 nvarchar(50),
	KetQuaChung nvarchar(50),
	MaGiaiDau int,
	MaVongDau int,
	MaSanVanDong int,
	primary key(MaTranDau)
)
go

----Tạo ràng buộc
--Ràng buộc khóa ngoại
alter table VongDau
add constraint fk_GiaiDau_VongDau foreign key(MaGiaiDau) references GiaiDau(MaGiaiDau)
go

alter table TranDau
add constraint fk_VongDau_TranDau foreign key(MaVongDau) references VongDau(MaVongDau),
	constraint fk_GiaiDau_TranDau foreign key(MaGiaiDau) references GiaiDau(MaGiaiDau),
	constraint fk_SanVanDong_TranDau foreign key(MaSanVanDong) references GiaiDau(MaSanVanDong);
go

alter table TrongTai_TranDau
add constraint fk_TrongTai_TTTD foreign key(MaTrongTai) references TrongTai(MaTrongTai),
	constraint fk_TranDau_TTTD foreign key(MaTranDau) references TranDau(MaTranDau);
go

alter table ThePhat
add constraint fk_TrongTai_ThePhat foreign key(MaTrongTai) references TrongTai(MaTrongTai),
	constraint fk_TranDau_ThePhat foreign key(MaTranDau) references TranDau(MaTranDau),
	constraint fk_CauThu_ThePhat foreign key(MaCauThu) references CauThu(MaCauThu);
go

alter table BanThang
add constraint fk_TranDau_BanThang foreign key(MaTranDau) references TranDau(MaTranDau),
	constraint fk_CauThu_BanThang foreign key(MaCauThu) references CauThu(MaCauThu);
go

alter table SanVanDong
add constraint fk_CauLacBo_SanVanDong foreign key(MaCauLacBo) references CauLacBo(MaCauLacBo);
go

alter table CauThu
add constraint fk_CauLacBo_CauThu foreign key(MaCauLacBo) references CauLacBo(MaCauLacBo);
go

alter table CauThu_TranDau
add constraint fk_CauThu_CTTD foreign key(MaCauThu) references CauThu(MaCauThu),
	constraint fk_TranDau_CTTD foreign key(MaTranDau) references TranDau(MaTranDau);
go

alter table CauLacBo_TranDau
add constraint fk_CauLacBo_CLBTD foreign key(MaCauLacBo) references CauLacBo(MaCauLacBo),
	constraint fk_TranDau_CLBTD foreign key(MaTranDau) references TranDau(MaTranDau);
go

alter table HuanLuyenVien_TranDau
add constraint fk_HuanLuyenVien_HLVTD foreign key(MaHuanLuyenVien) references HuanLuyenVien(MaHuanLuyenVien),
	constraint fk_TranDau_HLVTD foreign key(MaTranDau) references TranDau(MaTranDau);
go

alter table HuanLuyenVien
add constraint fk_CauLacBo_HuanLuyenVien foreign key(MaCauLacBo) references CauLacBo(MaCauLacBo);
go




	



