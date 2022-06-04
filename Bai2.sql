-- Đưa ra thông tin gồm mã số, họ tênvà tên khoa của tất cả các giảng viên
SELECT TBLGiangVien.magv, TBLGiangVien.hotengv, TBLGiangVien.luong, TBLKhoa.tenkhoa
FROM TBLGiangVien, TBLKhoa
WHERE TBLGiangVien.makhoa = TBLKhoa.makhoa;
-- Đưa ra thông tin gồm mã số, họ tênvà tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
SELECT TBLGiangVien.magv, TBLGiangVien.hotengv, TBLGiangVien.luong, TBLKhoa.tenkhoa
FROM TBLGiangVien, TBLKhoa
WHERE TBLGiangVien.makhoa = TBLKhoa.makhoa 
AND TBLKhoa.tenkhoa = 'Dia ly va QLTN';
-- Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
SELECT COUNT(*) FROM TBLSinhVien, TBLKhoa
WHERE TBLSinhVien.makhoa = TBLKhoa.makhoa 
AND TBLKhoa.tenkhoa = 'Cong nghe Sinh hoc';
-- Đưa ra danh sách gồm mã số, họ tênvà tuổi của các sinh viên khoa ‘TOAN’
SELECT TBLSinhVien.masv, TBLSinhVien.hotensv, date_part('year', CURRENT_DATE)-TBLSinhVien.namsinh AS TUOI
FROM TBLSinhVien, TBLKhoa
WHERE TBLSinhVien.makhoa = TBLKhoa.makhoa AND TBLKhoa.tenkhoa = 'Toan';
-- Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
SELECT COUNT(*) FROM TBLGiangVien, TBLKhoa
WHERE TBLGiangVien.makhoa = TBLKhoa.makhoa 
AND TBLKhoa.tenkhoa = 'Cong nghe Sinh hoc';
-- Cho biết thông tin về sinh viên không tham gia thực tập
SELECT * FROM TBLSinhVien
WHERE TBLSinhVien.masv NOT IN (
	SELECT TBLSinhVien.masv FROM TBLSinhVien, TBLHuongDan
	WHERE TBLSinhVien.masv = TBLHuongDan.masv
);
-- Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
SELECT TBLKhoa.makhoa,TBLKhoa.tenkhoa,COUNT(TBLGiangVien.magv) AS SoGiangVien
FROM TBLGiangVien, TBLKhoa
WHERE TBLGiangVien.makhoa = TBLKhoa.makhoa
GROUP BY TBLKhoa.makhoa;
-- Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
SELECT TBLHuongDan.madt,TBLDetai.tendt
FROM TBLHuongDan,TBLGiangVien,TBLDeTai
WHERE TBLHuongDan.magv = TBLGiangVien.magv AND TBLHuongDan.madt = TBLDetai.madt
AND TBLGiangVien.hotengv = 'Tran Son';
-- Cho biết tên đề tài không có sinh viên nào thực tập
SELECT TBLDeTai.tendt
FROM TBLDeTai
WHERE TBLDetai.madt NOT IN (
	SELECT TBLHuongDan.madt
	FROM TBLHuongDan,TBLSinhVien
	WHERE TBLHuongDan.masv = TBLSinhVien.masv
);
-- Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
SELECT TBLGiangVien.magv, TBLGiangVien.hotengv, TBLKhoa.tenkhoa
FROM TBLGiangVien, TBLKhoa
WHERE TBLGiangVien.makhoa = TBLKhoa.makhoa 
AND TBLGiangVien.magv IN (
	SELECT TBLHuongDan.magv FROM TBLHuongDan,TBLSinhVien,TBLGiangVien
	WHERE TBLHuongDan.masv = TBLSinhVien.masv AND TBLHuongDan.magv = TBLGiangVien.magv
	GROUP BY TBLHuongDan.magv
	HAVING COUNT(TBLHuongDan.magv) > 3
);
-- Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
SELECT tbldetai.madt, tbldetai.tendt FROM tbldetai
WHERE tbldetai.kinhphi IN(
	SELECT MAX(tbldetai.kinhphi) 
	FROM tbldetai
);
-- Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
SELECT TBLDeTai.madt, TBLDeTai.tendt
FROM TBLHuongDan,TBLSinhVien, TBLDeTai
WHERE TBLHuongDan.masv = TBLSinhVien.masv AND TBLDeTai.madt = TBLHuongDan.madt
GROUP BY TBLDeTai.madt
HAVING COUNT(TBLHuongDan.madt) > 2;
-- Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN’
SELECT TBLSinhVien.masv,TBLSinhVien.hotensv, TBLHuongDan.ketqua
FROM TBLHuongDan,TBLSinhVien,TBLKhoa
WHERE TBLSinhVien.makhoa = TBLKhoa.makhoa AND TBLHuongDan.masv = TBLSinhVien.masv
AND TBLKhoa.tenkhoa = 'Dia ly va QLTN';
-- Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
SELECT TBLKhoa.tenkhoa,COUNT(TBLSinhVien.masv) 
FROM TBLKhoa,TBLSinhVien
WHERE TBLKhoa.makhoa = TBLSinhVien.makhoa
GROUP BY TBLKhoa.tenkhoa;
-- Cho biết thông tin về các sinh viên thực tập tại quê nhà
SELECT TBLSinhVien.masv,TBLSinhVien.hotensv, TBLSinhVien.makhoa, TBLSinhVien.quequan 
FROM TBLHuongDan,TBLSinhVien,TBLDeTai
WHERE TBLSinhVien.masv = TBLHuongDan.masv AND TBLDeTai.madt = TBLHuongDan.madt
AND TBLDeTai.noithuctap = TBLSinhVien.quequan;
-- Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
-- CASE 1: CÓ THỰC TẬP NHƯNG KHÔNG CÓ ĐIỂM
SELECT TBLSinhVien.masv,TBLSinhVien.hotensv, TBLSinhVien.makhoa 
FROM TBLHuongDan,TBLSinhVien
WHERE TBLSinhVien.masv = TBLHuongDan.masv
AND TBLHuongDan.ketqua IS NULL;
-- CASE 2: CÓ THỰC TẬP NHƯNG KHÔNG CÓ ĐIỂM VÀ KHÔNG THỰC TẬP
SELECT TBLSinhVien.masv,TBLSinhVien.hotensv, TBLSinhVien.makhoa 
FROM TBLHuongDan,TBLSinhVien
WHERE TBLSinhVien.masv = TBLHuongDan.masv
AND TBLHuongDan.ketqua IS NULL
UNION
SELECT TBLSinhVien.masv,TBLSinhVien.hotensv, TBLSinhVien.makhoa FROM TBLSinhVien
WHERE TBLSinhVien.masv NOT IN (
	SELECT TBLSinhVien.masv FROM TBLSinhVien, TBLHuongDan
	WHERE TBLSinhVien.masv = TBLHuongDan.masv
);
-- Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
SELECT TBLSinhVien.masv,TBLSinhVien.hotensv 
FROM TBLHuongDan,TBLSinhVien
WHERE TBLSinhVien.masv = TBLHuongDan.masv
AND TBLHuongDan.ketqua = 0;