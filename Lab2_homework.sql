-- Hi?n th? tên và s? n?m kinh nghi?m c?a các chuyên gia, s?p x?p theo s? n?m kinh nghi?m gi?m d?n.
SELECT HoTen, NamKinhNghiem
FROM ChuyenGia;
-- Hi?n th? tên và s? ?i?n tho?i c?a các chuyên gia có chuyên ngành 'Phát tri?n ph?n m?m'.
SELECT HoTen, SoDienThoai
FROM ChuyenGia
WHERE ChuyenNganh = N'Phát tri?n ph?n m?m';
-- Li?t kê t?t c? các công ty có trên 100 nhân viên.
SELECT TenCongTy
FROM CongTy
WHERE SoNhanVien > 100;
-- Hi?n th? tên và ngày b?t ??u c?a các d? án b?t ??u trong n?m 2023.
SELECT TenDuAn, NgayBatDau
FROM DUAn
WHERE YEAR(NgayBatDau) = 2023;
-- Li?t kê t?t c? các k? n?ng và s?p x?p theo tên k? n?ng.
SELECT TenKyNang
FROM KyNang
ORDER BY TenKyNang ASC;
-- Hi?n th? tên và email c?a các chuyên gia có tu?i d??i 35 (tính ??n n?m 2024).
SELECT HoTen, Email
FROM ChuyenGia
WHERE (2024 - YEAR(NgaySinh))<35;
-- Hi?n th? tên và chuyên ngành c?a các chuyên gia n?.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE GioiTinh = N'N??'
-- Li?t kê tên các k? n?ng thu?c lo?i 'Công ngh?'.
SELECT TenKyNang
FROM KyNang
WHERE LoaiKyNang = N'Công ngh?';
-- Hi?n th? tên và ??a ch? c?a các công ty trong l?nh v?c 'Phân tích d? li?u'.
SELECT TenCongTy, DiaChi
FROM CongTy
WHERE LinhVuc = N'Phân tích d? li?u';
-- Li?t kê tên các d? án có tr?ng thái 'Hoàn thành'.
SELECT TenDuAn
FROM DuAn
WHERE TrangThai = N'Hoàn thành';
-- Hi?n th? tên và s? n?m kinh nghi?m c?a các chuyên gia, s?p x?p theo s? n?m kinh nghi?m gi?m d?n.
SELECT HoTen, NamKinhNghiem
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC;
-- Li?t kê tên các công ty và s? l??ng nhân viên, ch? hi?n th? các công ty có t? 100 ??n 200 nhân viên.
SELECT TenCongTy, SoNhanVien
FROM CongTy
WHERE SoNhanVien BETWEEN 100 AND 200;
-- Hi?n th? tên d? án và ngày k?t thúc c?a các d? án k?t thúc trong n?m 2023.
SELECT TenDuAn, NgayKetThuc
FROM DuAn
WHERE YEAR(NgayKetTHuc) = 2023
-- Li?t kê tên và email c?a các chuyên gia có tên b?t ??u b?ng ch? 'N'.
SELECT HoTen, Email
FROM ChuyenGia
WHERE HoTen LIKE 'N%';
-- Hi?n th? tên k? n?ng và lo?i k? n?ng, không bao g?m các k? n?ng thu?c lo?i 'Ngôn ng? l?p trình'.
(SELECT TenKyNang, LoaiKyNang
FROM KyNang)
EXCEPT
(SELECT TenKyNang, LoaiKyNang
FROM KyNang
WHERE LoaiKyNang = N'Ngôn ng? l?p trình')
-- Hi?n th? tên công ty và l?nh v?c ho?t ??ng, s?p x?p theo l?nh v?c.
SELECT TenCongTy, LinhVuc
FROM CongTy
ORDER BY LinhVuc;
-- Hi?n th? tên và chuyên ngành c?a các chuyên gia nam có trên 5 n?m kinh nghi?m.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE NamKinhNghiem>5 AND GioiTinh = N'Nam';
-- Li?t kê t?t c? các chuyên gia trong c? s? d? li?u.
SELECT*
FROM ChuyenGia;
-- Hi?n th? tên và email c?a t?t c? các chuyên gia n?.
SELECT HoTen, Email
FROM ChuyenGia
WHERE GioiTinh = N'N??';
--  Li?t kê t?t c? các công ty và s? nhân viên c?a h?, s?p x?p theo s? nhân viên gi?m d?n.
SELECT TenCongTy, SoNhanVien
FROM CongTy
ORDER BY SoNhanVien DESC;
-- Hi?n th? t?t c? các d? án ?ang trong tr?ng thái "?ang th?c hi?n".
SELECT* 
FROM DuAn
WHERE TrangThai = N'?ang th?c hi?n';
-- Li?t kê t?t c? các k? n?ng thu?c lo?i "Ngôn ng? l?p trình".
SELECT*
FROM KyNang
WHERE LoaiKyNang = N'Ngôn ng? l?p trình';
-- Hi?n th? tên và chuyên ngành c?a các chuyên gia có trên 8 n?m kinh nghi?m.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE NamKinhNghiem > 8;
-- Li?t kê t?t c? các d? án c?a công ty có MaCongTy là 1.
SELECT*
FROM DuAn
WHERE MaCongTy = 1;
-- ??m s? l??ng chuyên gia trong m?i chuyên ngành.
SELECT ChuyenNganh, COUNT(*) AS SoLuongChuyenGia
FROM ChuyenGia
GROUP BY ChuyenNganh;
-- Tìm chuyên gia có s? n?m kinh nghi?m cao nh?t.
SELECT TOP 1 HoTen, NamKinhNghiem
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC;
-- Li?t kê t?ng s? nhân viên cho m?i công ty mà có s? nhân viên l?n h?n 100. S?p x?p k?t qu? theo s? nhân viên t?ng d?n.
SELECT TenCongTy, SoNhanVien
FROM CongTy
WHERE SoNhanVien > 100 
ORDER BY SoNhanVien ASC;
-- Xác ??nh s? l??ng d? án mà m?i công ty tham gia có tr?ng thái '?ang th?c hi?n'. Ch? bao g?m các công ty có h?n m?t d? án ?ang th?c hi?n. S?p x?p k?t qu? theo s? l??ng d? án gi?m d?n.
SELECT CongTy.TenCongTy, COUNT(*) AS SoLuongDuAn
FROM CongTy
JOIN DuAn On CongTy.MaCongTy = DuAn.MaCongTy
WHERE DuAn.TrangThai = N'?ang th?c hi?n'
GROUP BY CongTy.TenCongTy
HAVING COUNT(*) > 1
ORDER BY SoLuongDuAn DESC;
-- Tìm ki?m các k? n?ng mà chuyên gia có c?p ?? t? 4 tr? lên và tính t?ng s? chuyên gia cho m?i k? n?ng ?ó. Ch? bao g?m nh?ng k? n?ng có t?ng s? chuyên gia l?n h?n 2. S?p x?p k?t qu? theo tên k? n?ng t?ng d?n.
SELECT KyNang.TenKyNang, COUNT(*) TongSoChuyenGia
FROM ChuyenGia_KyNang
JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
WHERE CapDo >= 4
GROUP BY KyNang.TenKyNang
HAVING COUNT(*) > 2
ORDER BY KyNang.TenKyNang ASC;
-- Li?t kê tên các công ty có l?nh v?c '?i?n toán ?ám mây' và tính t?ng s? nhân viên c?a h?. S?p x?p k?t qu? theo t?ng s? nhân viên t?ng d?n.
SELECT TenCongTy, SoNhanVien
FROM CongTy
WHERE LinhVuc = N'?i?n toán ?ám mây'
ORDER BY SoNhanVien ASC;
-- Li?t kê tên các công ty có s? nhân viên t? 50 ??n 150 và tính trung bình s? nhân viên c?a h?. S?p x?p k?t qu? theo tên công ty t?ng d?n.
SELECT TenCongTy, AVG(SoNhanVien) OVER () AS TrungBinhSoNhanVien
FROM CongTy
WHERE SoNhanVien BETWEEN 50 AND 150
ORDER BY TenCongTy ASC
-- Xác ??nh s? l??ng k? n?ng cho m?i chuyên gia có c?p ?? t?i ?a là 5 và ch? bao g?m nh?ng chuyên gia có ít nh?t m?t k? n?ng ??t c?p ?? t?i ?a này. S?p x?p k?t qu? theo tên chuyên gia t?ng d?n.
SELECT ChuyenGia.HoTen, COUNT(*) SoLuongKyNang
FROM ChuyenGia_KyNang
JOIN ChuyenGia ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
WHERE CapDo <= 5
GROUP BY ChuyenGia.HoTen
HAVING COUNT(*) >= 1
ORDER BY HoTen ASC;
-- Li?t kê tên các k? n?ng mà chuyên gia có c?p ?? t? 4 tr? lên và tính t?ng s? chuyên gia cho m?i k? n?ng ?ó. Ch? bao g?m nh?ng k? n?ng có t?ng s? chuyên gia l?n h?n 2. S?p x?p k?t qu? theo tên k? n?ng t?ng d?n.
SELECT KyNang.TenKyNang, COUNT(ChuyenGia_KyNang.MaChuyenGia) AS TongSoChuyenGia
FROM ChuyenGia_KyNang
JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
WHERE CapDo >= 4
GROUP BY KyNang.TenKyNang
HAVING COUNT(ChuyenGia_KyNang.MaChuyenGia) > 2
ORDER BY KyNang.TenKyNang ASC;
-- Tìm ki?m tên c?a các chuyên gia trong l?nh v?c 'Phát tri?n ph?n m?m' và tính trung bình c?p ?? k? n?ng c?a h?. Ch? bao g?m nh?ng chuyên gia có c?p ?? trung bình l?n h?n 3. S?p x?p k?t qu? theo c?p ?? trung bình gi?m d?n.
SELECT ChuyenGia.HoTen, AVG(ChuyenGia_KyNang.CapDo) AS TrungBinhCapDo
FROM ChuyenGia
JOIN ChuyenGia_KyNang On ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
WHERE ChuyenGia.ChuyenNganh = N'Phát tri?n ph?n m?m'
GROUP BY ChuyenGia.HoTen
HAVING AVG(ChuyenGia_KyNang.CapDo) > 3
ORDER By TrungBinhCapDo DESC;