-- Liệt kê những dòng xe có số chỗ ngồi trên 5 chỗ
SELECT dongxe.dongxe FROM dongxe
WHERE dongxe.sochongoi > 5;
-- Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp những dòng xe
-- thuộc hãng xe “Toyota” với mức phí có đơn giá là 15.000 VNĐ/km hoặc những dòng xe
-- thuộc hãng xe “KIA” với mức phí có đơn giá là 20.000 VNĐ/km
SELECT tennhacc,diachi,sodt,masothue,dangkycungcap.dongxe,dongxe.hangxe,mucphi.dongia FROM nhacungcap, dangkycungcap, dongxe, mucphi
WHERE nhacungcap.manhacc = dangkycungcap.manhacc AND dangkycungcap.dongxe = dongxe.dongxe AND dangkycungcap.mamp = mucphi.mamp
AND ((CAST(mucphi.dongia AS INT) > 15000 AND dongxe.hangxe = 'Toyota') OR (CAST(mucphi.dongia AS INT) > 20000) AND dongxe.hangxe = 'KIA');
-- Liệt kê thông tin toàn bộ nhà cung cấp được sắp xếp tăng dần theo tên nhà cung
-- cấp và giảm dần theo mã số thuế
SELECT * FROM nhacungcap
ORDER BY tennhacc, masothue DESC;
-- Đếm số lần đăng ký cung cấp phương tiện tương ứng cho từng nhà cung cấp với
-- yêu cầu chỉ đếm cho những nhà cung cấp thực hiện đăng ký cung cấp có ngày bắt đầu
-- cung cấp là “20/11/2015”
SELECT dangkycungcap.manhacc,COUNT(dangkycungcap.manhacc) FROM dangkycungcap
WHERE dangkycungcap.ngaybatdaucungcap = '2015/11/20'
GROUP BY dangkycungcap.manhacc;
-- Liệt kê tên của toàn bộ các hãng xe có trong cơ sở dữ liệu với yêu cầu mỗi hãng xe
-- chỉ được liệt kê một lần
SELECT dongxe.hangxe FROM dongxe
GROUP BY dongxe.hangxe;
-- Liệt kê MaDKCC, MaNhaCC, TenNhaCC, DiaChi, MaSoThue, TenLoaiDV, DonGia,
-- HangXe, NgayBatDauCC, NgayKetThucCC của tất cả các lần đăng ký cung cấp phương
-- tiện với yêu cầu những nhà cung cấp nào chưa từng thực hiện đăng ký cung cấp phương
-- tiện thì cũng liệt kê thông tin những nhà cung cấp đó ra
SELECT dangkycungcap.madkcc, dangkycungcap.manhacc, nhacungcap.tennhacc, nhacungcap.diachi, nhacungcap.masothue, mucphi.dongia,
dongxe.hangxe, dangkycungcap.ngaybatdaucungcap, dangkycungcap.ngayketthuccungcap
FROM dangkycungcap, dongxe, mucphi, nhacungcap
WHERE nhacungcap.manhacc = dangkycungcap.manhacc AND dangkycungcap.dongxe = dongxe.dongxe AND dangkycungcap.mamp = mucphi.mamp
UNION
SELECT null, null, nhacungcap.tennhacc, nhacungcap.diachi, nhacungcap.masothue, null,
null, null, null
FROM nhacungcap
WHERE nhacungcap.manhacc NOT IN (SELECT manhacc FROM dangkycungcap);
-- Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp phương tiện
-- thuộc dòng xe “Hiace” hoặc từng đăng ký cung cấp phương tiện thuộc dòng xe “Cerato”
SELECT DISTINCT nhacungcap.tennhacc, nhacungcap.diachi, nhacungcap.masothue, nhacungcap.sodt
FROM nhacungcap, dangkycungcap
WHERE nhacungcap.manhacc = dangkycungcap.manhacc
AND dangkycungcap.dongxe IN ('Hiace','Cerato');
-- Liệt kê thông tin của các nhà cung cấp chưa từng thực hiện đăng ký cung cấp
-- phương tiện lần nào cả.
SELECT nhacungcap.tennhacc, nhacungcap.diachi, nhacungcap.masothue, nhacungcap.sodt
FROM nhacungcap
WHERE nhacungcap.manhacc NOT IN (SELECT manhacc FROM dangkycungcap);