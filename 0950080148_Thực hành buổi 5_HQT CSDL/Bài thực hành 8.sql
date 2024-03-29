﻿--1. Viết SP spTangLuong dùng để tăng lương lên 10% cho tất cả các nhân viên.
CREATE PROCEDURE spTangLuong
AS
BEGIN
    UPDATE NHANVIEN
    SET Luong = Luong * 1.1;
END
--2. Thêm vào cột NgayNghiHuu (ngày nghỉ hưu) trong bảng NHANVIEN. Viết SP
--spNghiHuu dùng để cập nhật ngày nghỉ hưu là ngày hiện tại cộng thêm 100 (ngày) cho những
--nhân viên nam có tuổi từ 60 trở lên và nữ từ 55 trở lên.
ALTER TABLE NHANVIEN
ADD NgayNghiHuu DATE;

CREATE PROCEDURE spNghiHuu
AS
BEGIN
    UPDATE NHANVIEN
    SET NgayNghiHuu = DATEADD(day, 100, GETDATE())
    WHERE (PHAI = 'Nam' AND DATEDIFF(year, NGSINH, GETDATE()) >= 60)
    OR (PHAI = 'Nu' AND DATEDIFF(year, NGSINH, GETDATE()) >= 55)
END;

EXEC spNghiHuu;


--3. Tạo SP spXemDeAn cho phép xem các đề án có địa điểm đề án được truyền vào khi
--gọi thủ tục.
CREATE PROCEDURE spXemDeAn
    @DiaDiem NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM DEAN
    WHERE DDIEM_DA = @DiaDiem
END
--4. Tạo SP spCapNhatDeAn cho phép cập nhật lại địa điểm đề án với 2 tham số truyền
--vào là diadiem_cu, diadiem_moi.
CREATE PROCEDURE spCapNhatDeAn @diadiem_cu NVARCHAR(255), @diadiem_moi NVARCHAR(255)
AS
BEGIN
    UPDATE DeAn
    SET DDIEM_DA = @diadiem_moi
    WHERE DDIEM_DA = @diadiem_cu
END;

EXEC spCapNhatDeAn @diadiem_cu = N'<địa điểm cũ>', @diadiem_moi = N'<địa điểm mới>';
--5. Viết SP spThemDeAn để thêm dữ liệu vào bảng DEAN với các tham số vào là các
--trường của bảng DEAN.
CREATE PROCEDURE spThemDeAn
    @MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50),
    @NgayBatDau DATETIME,
    @NgayKetThuc DATETIME
AS
BEGIN
    INSERT INTO DEAN(MaDeAn, TenDeAn, DiaDiem, NgayBatDau, NgayKetThuc)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem, @NgayBatDau, @NgayKetThuc)
END
--6. Cập nhật SP spThemDeAn ở câu trên để thỏa mãn ràng buộc sau: kiểm tra mã đề án có
--trùng với các mã đề án khác không. Nếu có thì thông báo lỗi “Mã đề án đã tồn tại, đề nghị chọn
--mã đề án khác”. Sau đó, tiếp tục kiểm tra mã phòng ban. Nếu mã phòng ban không tồn tại
--trong bảng PHONGBAN thì thông báo lỗi: “Mã phòng không tồn tại”. Thực thi thủ tục với 1
--trường hợp đúng và 2 trường hợp sai để kiểm chứng.
CREATE PROCEDURE spThemDeAn
    @MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50),
    @NgayBatDau DATETIME,
    @NgayKetThuc DATETIME
AS
BEGIN
    IF EXISTS(SELECT 1 FROM DEAN WHERE MaDeAn = @MaDeAn)
    BEGIN
        RAISERROR ('Mã đề án đã tồn tại, đề nghị chọn mã đề án khác',16,1)
        RETURN;
    END
    
    IF NOT EXISTS(SELECT 1 FROM PHONGBAN WHERE MaPhongBan = @MaPhongBan)
BEGIN
        RAISERROR ('Mã phòng không tồn tại',16,1)
        RETURN;
    END
    
    INSERT INTO DEAN(MaDeAn, TenDeAn, DiaDiem, NgayBatDau, NgayKetThuc)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem, @NgayBatDau, @NgayKetThuc)
END

--7. Tạo SP spXoaDeAn cho phép xóa các đề án với tham số truyền vào là Mã đề án. Lưu ý
--trước khi xóa cần kiểm tra mã đề án có tồn tại trong bảng PHANCONG hay không, nếu có thì
--viết ra thông báo và không thực hiện việc xóa dữ liệu.
CREATE PROCEDURE spXoaDeAn
    @MaDeAn INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM PHANCONG WHERE MADA = @MaDeAn)
    BEGIN
        RAISERROR ('Mã đề án đã tồn tại trong bảng PHANCONG',16,1)
        RETURN;
    END
    
    DELETE FROM DEAN WHERE MADA = @MaDeAn
END
--8. Cập nhật SP spXoaDeAn cho phép xóa các đề án với tham số truyền vào là Mã đề án.
--Lưu ý trước khi xóa cần kiểm tra mã đề án có tồn tại trong bảng PHANCONG hay không, nếu
--có thì thực hiện xóa tất cả các dữ liệu trong bảng PHANCONG có liên quan đến mã đề án cần
--xóa, sau đó tiến hành xóa dữ liệu trong bảng DEAN.
CREATE PROCEDURE spXoaDeAn
    @MaDeAn INT
AS
BEGIN
    DELETE FROM PHANCONG WHERE MaDeAn = @MaDeAn
    DELETE FROM DEAN WHERE MaDeAn = @MaDeAn
END
--9. Tạo SP spTongGioLamViec có tham số truyền vào là MaNV, tham số ra là tổng thời
--gian (tính bằng giờ) làm việc ở tất cả các dự án của nhân viên đó.
CREATE PROCEDURE spTongGioLamViec
@MaNV INT,
@TongThoiGian INT OUT
AS
BEGIN
SELECT @TongThoiGian = SUM(ThoiGian)
FROM PHANCONG
WHERE MaNV = @MaNV
END
--10. Viết SP spTongTien để in ra màn hình tổng tiền phải trả cho nhân viên với tham số
--truyền vào là mã nhân viên. (Tổng tiền phải trả cho nhân viên = lương + lương đề án; lương đề
--án = 100000 đ x thời gian). Kết quả của thủ tục là dòng chữ: “Tổng tiền phải trả cho nhân viên
--‘333’ là 1200000 đồng.
CREATE PROCEDURE spTongTien
@MaNV INT
AS
BEGIN
DECLARE @TongTien INT
DECLARE @Luong INT
SELECT @Luong = Luong 
FROM NHANVIEN 
WHERE MaNV = @MaNV

SELECT @TongTien = @Luong + (100000 * SUM(ThoiGian))
FROM PHANCONG 
WHERE MaNV = @MaNV

PRINT 'Tổng tiền phải trả cho nhân viên ''' + CONVERT(VARCHAR, @MaNV) + ''' là ' + CONVERT(VARCHAR, @TongTien) + ' đồng.'
END
