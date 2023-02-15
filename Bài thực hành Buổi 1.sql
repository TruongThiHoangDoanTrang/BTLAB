-----1. Tạo các kiểu dữliêụ người dùng
EXEC sp_addtype 'Mota', 'nvarchar(40)', 'null'
EXEC sp_addtype 'IDKH', 'char(10)', 'Not null'
EXEC sp_addtype 'DT', 'char(12)' , 'null'
go
-----2. Taọ các bảng
CREATE TABLE SanPham (
MaSP CHAR(6) NOT NULL,
TenSP VARCHAR(20),
NgayNhap Date,
DVT CHAR(10),
SoLuongTon INT,
DonGiaNhap money,
)
CREATE TABLE HoaDon (
MaHD CHAR(10) NOT NULL,
NgayLap Date,
NgayGiao Date,
MaKH IDKH,
DienGiai Mota,
)
CREATE TABLE KhachHang (
MaKH IDKH,
TenKH NVARCHAR(30),
DiaCHi NVARCHAR(40),
DienThoai DT,
)
CREATE TABLE ChiTietHD (
MaHD CHAR(10) NOT NULL,
MaSP CHAR(6) NOT NULL,
SoLuong INT
)
GO
-----3. Trong Table HoaDon, sửa cột DienGiai thành nvarchar(100)
ALTER TABLE HoaDon
ALTER COLUMN DienGiai NVARCHAR(100)
GO
-----4. Thêm vào bảng SanPham cột TyLeHoaHong float
ALTER TABLE SanPham
ADD TyLeHoaHong float
GO
-----5. Xóa cột NgayNhap trong bảng SanPham
ALTER TABLE SanPham
DROP COLUMN NgayNhap
-----6. Tạo các ràng buộc khoá chính và khoá ngoại 
ALTER TABLE SanPham
ADD
CONSTRAINT pk_sp primary key(MASP)

ALTER TABLE HoaDon
ADD
CONSTRAINT pk_hd primary key(MaHD)

ALTER TABLE KhachHang
ADD
CONSTRAINT pk_khanghang primary key(MaKH)

ALTER TABLE HoaDon
ADD
CONSTRAINT fk_khachhang_hoadon FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT fk_hoadon_chitiethd FOREIGN KEY(MaHD) REFERENCES HoaDon(MaHD)

ALTER TABLE ChiTietHD
ADD
CONSTRAINT fk_sanpham_chitiethd FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
----- 7.Thêm vào bảng HoaDon các ràng buộc
ALTER TABLE HoaDon
ADD CHECK (NgayGiao > NgayLap)

ALTER TABLE HoaDon
ADD CHECK (MaHD like '[A-Z][A-Z][0-9][0-9][0-9][0-9]')

ALTER TABLE HoaDon
ADD CONSTRAINT df_ngaylap DEFAULT GETDATE() FOR NgayLap
-----8. Thêm vào bảng Sản phẩm các ràng buộc
ALTER TABLE SanPham
ADD CHECK (SoLuongTon > 0 and SoLuongTon < 50)

ALTER TABLE SanPham
ADD CHECK (DonGiaNhap > 0)

ALTER TABLE SanPham
ADD CONSTRAINT df_ngaynhap DEFAULT GETDATE() FOR NgayNhap

ALTER TABLE SanPham
ADD CHECK (DVT like 'KG''Thùng''Hộp''Cái')
-----9. nhập dữ liệu vào 4 table trên, dữ liệu tùy ý, chú ý các ràng buộc của mỗi	
INSERT INTO SanPham(Masp, Tensp, NgayNhap, DVT, SoluongTon, DonGiaNhap)
VALUES 
	('SP01', 'SAMSUNG', '2023/1/15', 'VNĐ', '20', '9000000'),
	('SP02', 'ACER', '2023/2/20', 'VNĐ', '1', '500000000'),
	('SP03', 'DELL', '2023/3/30', 'VNĐ', '100', '19000000'),
	('SP04', 'MACBOOK', '2023/12/24', 'VNĐ', '50', '40000000');

INSERT INTO KhachHang(Makh, TenKH, DiaCHi, DienThoai)
VALUES 
	('KH01', 'TRƯƠNG THỊ HOÀNG ĐOAN TRANG', 'Đường 1A, Vĩnh Lộc B, Bình Chánh', '0834841329'),
	('KH02', 'ĐẶNG VĂN TIÊN', 'Bình Định', '0723291064'),
	('KH03', 'ĐỔ HUỲNH PHƯƠNG TRINH', '126 Âu Cơ, phường 11, Tân phú', '0123899720'),
	('KH04', 'NGUYỄN LÊ THẢO QUYÊN', 'Đăk Nông', '0236343511');

INSERT INTO HoaDon(MaHD, NgayLap, NgayGiao, MaKH, DienGiai)
VALUES 
	('HD01', '2023/2/15','2023/2/30','KH01','xinh đẹp'),
	('HD02', '2023/3/15','2023/3/30','KH02','mắc géc'),
	('HD03', '2023/4/15','2023/4/30','KH03','dễ thương'),
	('HD04', '2023/5/15','2023/5/30','KH04','cũng xinh');

INSERT INTO ChiTietHD(MaHD, MaSP, SoLuong)
VALUES ('HD01','SP01', 20),
		('HD02','SP02', 30),
		('HD03','SP03', 40),
		('HD04','SP04', 50);

-----10.
-----11.
-----12.
-----13
