-- Câu 1:Liệt kê MaDatPhong, MaDV, SoLuong của tất cả các dịch vụ có số lượng lớn hơn 3 và nhỏ hơn 10. (1 điểm)
SELECT * FROM CHI_TIET_SU_DUNG_DV 
WHERE CHI_TIET_SU_DUNG_DV.soluong BETWEEN 4 AND 9;
-- Câu 2: Cập nhật dữ liệu trên trường GiaPhong thuộc bảng PHONG tăng lên 10,000 VNĐ so với giá phòng hiện tại, 
-- chỉ cập nhật giá phòng của những phòng có số khách tối đa lớn hơn 10. (1 điểm)
UPDATE PHONG
SET GiaPhong = GiaPhong + '10.000'
WHERE PHONG.sokhachtoida > 10;
-- Câu 3: Xóa tất cả những đơn đặt phòng (từ bảng DAT_PHONG) có trạng thái đặt (TrangThaiDat) là “Da huy”. (1 điểm)
DELETE FROM chi_tiet_su_dung_dv 
WHERE chi_tiet_su_dung_dv.madatphong IN (
SELECT DAT_PHONG.madatphong 
FROM DAT_PHONG
WHERE DAT_PHONG.TrangThaiDat = 'DA HUY');
DELETE FROM DAT_PHONG WHERE DAT_PHONG.TrangThaiDat = 'DA HUY';
-- Câu 4: Hiển thị TenKH của những khách hàng có tên bắt đầu là một trong các ký tự “H”, “N”, “M” 
-- và có độ dài tối đa là 20 ký tự. (1 điểm)
SELECT * FROM KHACH_HANG
WHERE KHACH_HANG.tenkh LIKE ANY (array['H%', 'N%', 'M%'])
AND LENGTH(KHACH_HANG.tenkh) <= 20;
-- Câu 5: Hiển thị TenKH của tất cả các khách hàng có trong hệ thống, TenKH nào 
-- trùng nhau thì chỉ hiển thị một lần. Sinh viên sử dụng hai cách khác nhau để thực hiện yêu cầu trên, mỗi cách sẽ được 0,5 điểm. (1 điểm)
-- CACH 1:
SELECT KHACH_HANG.tenkh FROM KHACH_HANG
GROUP BY KHACH_HANG.tenkh;
-- CACH 2:
SELECT DISTINCT KHACH_HANG.tenkh FROM KHACH_HANG;
-- Câu 6: Hiển thị MaDV, TenDV, DonViTinh, DonGia của những dịch vụ đi kèm có DonViTinh là “lon” 
-- và có DonGia lớn hơn 10,000 VNĐ hoặc những dịch vụ đi kèm có DonViTinh là “Cai” và có DonGia nhỏ hơn 5,000 VNĐ. (1 điểm)
SELECT DICH_VU_DI_KEM.MaDV,DICH_VU_DI_KEM.TenDV,DICH_VU_DI_KEM.DonViTinh,DICH_VU_DI_KEM.DonGia 
FROM DICH_VU_DI_KEM
WHERE (DICH_VU_DI_KEM.donvitinh = 'LON' AND DICH_VU_DI_KEM.dongia > '10.000')
OR (DICH_VU_DI_KEM.donvitinh = 'Cai' AND DICH_VU_DI_KEM.dongia < '5.000')
-- Câu 7: Hiển thị MaDatPhong, MaPhong, LoaiPhong, SoKhachToiDa, GiaPhong, MaKH, TenKH, SoDT, 
-- NgayDat, GioBatDau, GioKetThuc, MaDichVu, SoLuong, DonGia của những đơn đặt phòng có 
-- năm đặt phòng là “2016”, “2017” và đặt những phòng có giá phòng > 50,000 VNĐ/ 1 giờ. (1 điểm)
SELECT DAT_PHONG.MaDatPhong,DAT_PHONG.MaPhong,PHONG.loaiphong,PHONG.sokhachtoida,
PHONG.giaphong,DAT_PHONG.MaKH,KHACH_HANG.tenkh,KHACH_HANG.sodt,DAT_PHONG.ngaydat,DAT_PHONG.giobatdau,DAT_PHONG.gioketthuc,
DICH_VU_DI_KEM.madv,CHI_TIET_SU_DUNG_DV.SoLuong,DICH_VU_DI_KEM.DonGia FROM DAT_PHONG,PHONG,DICH_VU_DI_KEM,CHI_TIET_SU_DUNG_DV,KHACH_HANG
WHERE DAT_PHONG.MaPhong = PHONG.maphong AND CHI_TIET_SU_DUNG_DV.madatphong = DAT_PHONG.MaDatPhong 
AND DAT_PHONG.makh = KHACH_HANG.makh AND DICH_VU_DI_KEM.madv = CHI_TIET_SU_DUNG_DV.madv 
AND EXTRACT(YEAR FROM DAT_PHONG.ngaydat) IN (2016,2017)
AND PHONG.giaphong > '50.000';
-- Câu 8: Hiển thị MaDatPhong, MaPhong, LoaiPhong, GiaPhong, TenKH, NgayDat, TongTienHat, TongTienSuDungDichVu, 
-- TongTienThanhToan tương ứng với từng mã đặt phòng có trong bảng DAT_PHONG. 
-- Những đơn đặt phòng nào không sử dụng dịch vụ đi kèm thì cũng liệt kê thông tin của đơn đặt phòng đó ra. (1 điểm)
-- TongTienHat = GiaPhong * (GioKetThuc – GioBatDau)
-- TongTienSuDungDichVu = SoLuong * DonGia
-- TongTienThanhToan = TongTienHat + sum (TongTienSuDungDichVu)
SELECT DAT_PHONG.MaDatPhong,DAT_PHONG.MaPhong,PHONG.loaiphong,PHONG.giaphong,KHACH_HANG.tenkh,DAT_PHONG.ngaydat,
SUM(PHONG.giaphong * EXTRACT(HOUR FROM DAT_PHONG.gioketthuc - DAT_PHONG.giobatdau)) AS TongTienHat,
SUM(CHI_TIET_SU_DUNG_DV.SoLuong * DICH_VU_DI_KEM.DonGia) AS TongTienSuDungDichVu,
SUM(PHONG.giaphong * EXTRACT(HOUR FROM DAT_PHONG.gioketthuc - DAT_PHONG.giobatdau) + CHI_TIET_SU_DUNG_DV.SoLuong * DICH_VU_DI_KEM.DonGia) AS TongTienThanhToan
FROM DAT_PHONG,PHONG,DICH_VU_DI_KEM,CHI_TIET_SU_DUNG_DV,KHACH_HANG
WHERE DAT_PHONG.MaPhong = PHONG.maphong AND CHI_TIET_SU_DUNG_DV.madatphong = DAT_PHONG.MaDatPhong 
AND DAT_PHONG.makh = KHACH_HANG.makh AND DICH_VU_DI_KEM.madv = CHI_TIET_SU_DUNG_DV.madv
GROUP BY DAT_PHONG.MaDatPhong,PHONG.loaiphong,PHONG.giaphong,KHACH_HANG.tenkh
UNION
SELECT DAT_PHONG.MaDatPhong,DAT_PHONG.MaPhong,PHONG.loaiphong,PHONG.giaphong,KHACH_HANG.tenkh,DAT_PHONG.ngaydat,
SUM(PHONG.giaphong * EXTRACT(HOUR FROM DAT_PHONG.gioketthuc - DAT_PHONG.giobatdau)) AS TongTienHat,
null AS TongTienSuDungDichVu,
SUM(PHONG.giaphong * EXTRACT(HOUR FROM DAT_PHONG.gioketthuc - DAT_PHONG.giobatdau)) AS TongTienThanhToan
FROM DAT_PHONG,PHONG,KHACH_HANG
WHERE DAT_PHONG.MaPhong = PHONG.maphong AND DAT_PHONG.makh = KHACH_HANG.makh
AND DAT_PHONG.MaDatPhong NOT IN(
	SELECT CHI_TIET_SU_DUNG_DV.madatphong FROM CHI_TIET_SU_DUNG_DV
)
GROUP BY DAT_PHONG.MaDatPhong,PHONG.loaiphong,PHONG.giaphong,KHACH_HANG.tenkh
-- Câu 9: Hiển thị MaKH, TenKH, DiaChi, SoDT của những khách hàng 
-- đã từng đặt phòng karaoke có địa chỉ ở “Hoa xuan”. (1 điểm)
SELECT KHACH_HANG.makh, KHACH_HANG.tenkh, KHACH_HANG.diachi, KHACH_HANG.sodt
FROM KHACH_HANG, DAT_PHONG
WHERE DAT_PHONG.makh = KHACH_HANG.makh 
AND KHACH_HANG.diachi = 'HOA XUAN'
GROUP BY KHACH_HANG.makh;
-- Câu 10: Hiển thị MaPhong, LoaiPhong, SoKhachToiDa, GiaPhong, SoLanDat của những phòng được khách hàng đặt có số lần đặt lớn hơn 2 lần và trạng thái đặt là “Da dat”. (1 điểm)
SELECT PHONG.maphong, PHONG.loaiphong, PHONG.sokhachtoida, PHONG.giaphong,COUNT(DAT_PHONG.MaPhong)
FROM DAT_PHONG, PHONG
WHERE DAT_PHONG.MaPhong = PHONG.maphong
AND DAT_PHONG.trangthaidat = 'DA DAT'
GROUP BY DAT_PHONG.MaPhong,PHONG.maphong
HAVING COUNT(PHONG.maphong) > 2;
-- Bonus: 1 API tìm kiềm phòng gửi lên các tiêu chí tìm kiếm:
-- - Giá thương lượng: Giá của phòng sẽ dao động từ 0.6*(Giá thương lượng) < giá phòng < 1.6*(Giá thương lượng)
CREATE OR REPLACE FUNCTION ChonGia(Gia numeric(6,3))
RETURNS TABLE(
	maphong int, loaiphong varchar(20), sokhachtoida int, giaphong numeric(6,3), mota varchar(255)
)
AS
$$
BEGIN
	RETURN QUERY
		SELECT * FROM PHONG
		WHERE PHONG.giaphong BETWEEN 0.6*Gia AND 1.6*Gia;
END;
$$ LANGUAGE plpgsql;
-- Test KQ
SELECT * FROM ChonGia('120.000');
-- - Sắp xếp theo thứ tự tăng dần về giá
CREATE OR REPLACE FUNCTION SapXepGia()
RETURNS TABLE(
	maphong int, loaiphong varchar(20), sokhachtoida int, giaphong numeric(6,3), mota varchar(255)
)
AS
$$
BEGIN
	RETURN QUERY
		SELECT * FROM PHONG
		ORDER BY PHONG.giaphong;
END;
$$ LANGUAGE plpgsql;
-- Test KQ
SELECT * FROM SapXepGia()
