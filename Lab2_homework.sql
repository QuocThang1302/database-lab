-- Hi?n th? t�n v� s? n?m kinh nghi?m c?a c�c chuy�n gia, s?p x?p theo s? n?m kinh nghi?m gi?m d?n.
SELECT HoTen, NamKinhNghiem
FROM ChuyenGia;
-- Hi?n th? t�n v� s? ?i?n tho?i c?a c�c chuy�n gia c� chuy�n ng�nh 'Ph�t tri?n ph?n m?m'.
SELECT HoTen, SoDienThoai
FROM ChuyenGia
WHERE ChuyenNganh = N'Ph�t tri?n ph?n m?m';
-- Li?t k� t?t c? c�c c�ng ty c� tr�n 100 nh�n vi�n.
SELECT TenCongTy
FROM CongTy
WHERE SoNhanVien > 100;
-- Hi?n th? t�n v� ng�y b?t ??u c?a c�c d? �n b?t ??u trong n?m 2023.
SELECT TenDuAn, NgayBatDau
FROM DUAn
WHERE YEAR(NgayBatDau) = 2023;
-- Li?t k� t?t c? c�c k? n?ng v� s?p x?p theo t�n k? n?ng.
SELECT TenKyNang
FROM KyNang
ORDER BY TenKyNang ASC;
-- Hi?n th? t�n v� email c?a c�c chuy�n gia c� tu?i d??i 35 (t�nh ??n n?m 2024).
SELECT HoTen, Email
FROM ChuyenGia
WHERE (2024 - YEAR(NgaySinh))<35;
-- Hi?n th? t�n v� chuy�n ng�nh c?a c�c chuy�n gia n?.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE GioiTinh = N'N??'
-- Li?t k� t�n c�c k? n?ng thu?c lo?i 'C�ng ngh?'.
SELECT TenKyNang
FROM KyNang
WHERE LoaiKyNang = N'C�ng ngh?';
-- Hi?n th? t�n v� ??a ch? c?a c�c c�ng ty trong l?nh v?c 'Ph�n t�ch d? li?u'.
SELECT TenCongTy, DiaChi
FROM CongTy
WHERE LinhVuc = N'Ph�n t�ch d? li?u';
-- Li?t k� t�n c�c d? �n c� tr?ng th�i 'Ho�n th�nh'.
SELECT TenDuAn
FROM DuAn
WHERE TrangThai = N'Ho�n th�nh';
-- Hi?n th? t�n v� s? n?m kinh nghi?m c?a c�c chuy�n gia, s?p x?p theo s? n?m kinh nghi?m gi?m d?n.
SELECT HoTen, NamKinhNghiem
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC;
-- Li?t k� t�n c�c c�ng ty v� s? l??ng nh�n vi�n, ch? hi?n th? c�c c�ng ty c� t? 100 ??n 200 nh�n vi�n.
SELECT TenCongTy, SoNhanVien
FROM CongTy
WHERE SoNhanVien BETWEEN 100 AND 200;
-- Hi?n th? t�n d? �n v� ng�y k?t th�c c?a c�c d? �n k?t th�c trong n?m 2023.
SELECT TenDuAn, NgayKetThuc
FROM DuAn
WHERE YEAR(NgayKetTHuc) = 2023
-- Li?t k� t�n v� email c?a c�c chuy�n gia c� t�n b?t ??u b?ng ch? 'N'.
SELECT HoTen, Email
FROM ChuyenGia
WHERE HoTen LIKE 'N%';
-- Hi?n th? t�n k? n?ng v� lo?i k? n?ng, kh�ng bao g?m c�c k? n?ng thu?c lo?i 'Ng�n ng? l?p tr�nh'.
(SELECT TenKyNang, LoaiKyNang
FROM KyNang)
EXCEPT
(SELECT TenKyNang, LoaiKyNang
FROM KyNang
WHERE LoaiKyNang = N'Ng�n ng? l?p tr�nh')
-- Hi?n th? t�n c�ng ty v� l?nh v?c ho?t ??ng, s?p x?p theo l?nh v?c.
SELECT TenCongTy, LinhVuc
FROM CongTy
ORDER BY LinhVuc;
-- Hi?n th? t�n v� chuy�n ng�nh c?a c�c chuy�n gia nam c� tr�n 5 n?m kinh nghi?m.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE NamKinhNghiem>5 AND GioiTinh = N'Nam';
-- Li?t k� t?t c? c�c chuy�n gia trong c? s? d? li?u.
SELECT*
FROM ChuyenGia;
-- Hi?n th? t�n v� email c?a t?t c? c�c chuy�n gia n?.
SELECT HoTen, Email
FROM ChuyenGia
WHERE GioiTinh = N'N??';
--  Li?t k� t?t c? c�c c�ng ty v� s? nh�n vi�n c?a h?, s?p x?p theo s? nh�n vi�n gi?m d?n.
SELECT TenCongTy, SoNhanVien
FROM CongTy
ORDER BY SoNhanVien DESC;
-- Hi?n th? t?t c? c�c d? �n ?ang trong tr?ng th�i "?ang th?c hi?n".
SELECT* 
FROM DuAn
WHERE TrangThai = N'?ang th?c hi?n';
-- Li?t k� t?t c? c�c k? n?ng thu?c lo?i "Ng�n ng? l?p tr�nh".
SELECT*
FROM KyNang
WHERE LoaiKyNang = N'Ng�n ng? l?p tr�nh';
-- Hi?n th? t�n v� chuy�n ng�nh c?a c�c chuy�n gia c� tr�n 8 n?m kinh nghi?m.
SELECT HoTen, ChuyenNganh
FROM ChuyenGia
WHERE NamKinhNghiem > 8;
-- Li?t k� t?t c? c�c d? �n c?a c�ng ty c� MaCongTy l� 1.
SELECT*
FROM DuAn
WHERE MaCongTy = 1;
-- ??m s? l??ng chuy�n gia trong m?i chuy�n ng�nh.
SELECT ChuyenNganh, COUNT(*) AS SoLuongChuyenGia
FROM ChuyenGia
GROUP BY ChuyenNganh;
-- T�m chuy�n gia c� s? n?m kinh nghi?m cao nh?t.
SELECT TOP 1 HoTen, NamKinhNghiem
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC;
-- Li?t k� t?ng s? nh�n vi�n cho m?i c�ng ty m� c� s? nh�n vi�n l?n h?n 100. S?p x?p k?t qu? theo s? nh�n vi�n t?ng d?n.
SELECT TenCongTy, SoNhanVien
FROM CongTy
WHERE SoNhanVien > 100 
ORDER BY SoNhanVien ASC;
-- X�c ??nh s? l??ng d? �n m� m?i c�ng ty tham gia c� tr?ng th�i '?ang th?c hi?n'. Ch? bao g?m c�c c�ng ty c� h?n m?t d? �n ?ang th?c hi?n. S?p x?p k?t qu? theo s? l??ng d? �n gi?m d?n.
SELECT CongTy.TenCongTy, COUNT(*) AS SoLuongDuAn
FROM CongTy
JOIN DuAn On CongTy.MaCongTy = DuAn.MaCongTy
WHERE DuAn.TrangThai = N'?ang th?c hi?n'
GROUP BY CongTy.TenCongTy
HAVING COUNT(*) > 1
ORDER BY SoLuongDuAn DESC;
-- T�m ki?m c�c k? n?ng m� chuy�n gia c� c?p ?? t? 4 tr? l�n v� t�nh t?ng s? chuy�n gia cho m?i k? n?ng ?�. Ch? bao g?m nh?ng k? n?ng c� t?ng s? chuy�n gia l?n h?n 2. S?p x?p k?t qu? theo t�n k? n?ng t?ng d?n.
SELECT KyNang.TenKyNang, COUNT(*) TongSoChuyenGia
FROM ChuyenGia_KyNang
JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
WHERE CapDo >= 4
GROUP BY KyNang.TenKyNang
HAVING COUNT(*) > 2
ORDER BY KyNang.TenKyNang ASC;
-- Li?t k� t�n c�c c�ng ty c� l?nh v?c '?i?n to�n ?�m m�y' v� t�nh t?ng s? nh�n vi�n c?a h?. S?p x?p k?t qu? theo t?ng s? nh�n vi�n t?ng d?n.
SELECT TenCongTy, SoNhanVien
FROM CongTy
WHERE LinhVuc = N'?i?n to�n ?�m m�y'
ORDER BY SoNhanVien ASC;
-- Li?t k� t�n c�c c�ng ty c� s? nh�n vi�n t? 50 ??n 150 v� t�nh trung b�nh s? nh�n vi�n c?a h?. S?p x?p k?t qu? theo t�n c�ng ty t?ng d?n.
SELECT TenCongTy, AVG(SoNhanVien) OVER () AS TrungBinhSoNhanVien
FROM CongTy
WHERE SoNhanVien BETWEEN 50 AND 150
ORDER BY TenCongTy ASC
-- X�c ??nh s? l??ng k? n?ng cho m?i chuy�n gia c� c?p ?? t?i ?a l� 5 v� ch? bao g?m nh?ng chuy�n gia c� �t nh?t m?t k? n?ng ??t c?p ?? t?i ?a n�y. S?p x?p k?t qu? theo t�n chuy�n gia t?ng d?n.
SELECT ChuyenGia.HoTen, COUNT(*) SoLuongKyNang
FROM ChuyenGia_KyNang
JOIN ChuyenGia ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
WHERE CapDo <= 5
GROUP BY ChuyenGia.HoTen
HAVING COUNT(*) >= 1
ORDER BY HoTen ASC;
-- Li?t k� t�n c�c k? n?ng m� chuy�n gia c� c?p ?? t? 4 tr? l�n v� t�nh t?ng s? chuy�n gia cho m?i k? n?ng ?�. Ch? bao g?m nh?ng k? n?ng c� t?ng s? chuy�n gia l?n h?n 2. S?p x?p k?t qu? theo t�n k? n?ng t?ng d?n.
SELECT KyNang.TenKyNang, COUNT(ChuyenGia_KyNang.MaChuyenGia) AS TongSoChuyenGia
FROM ChuyenGia_KyNang
JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
WHERE CapDo >= 4
GROUP BY KyNang.TenKyNang
HAVING COUNT(ChuyenGia_KyNang.MaChuyenGia) > 2
ORDER BY KyNang.TenKyNang ASC;
-- T�m ki?m t�n c?a c�c chuy�n gia trong l?nh v?c 'Ph�t tri?n ph?n m?m' v� t�nh trung b�nh c?p ?? k? n?ng c?a h?. Ch? bao g?m nh?ng chuy�n gia c� c?p ?? trung b�nh l?n h?n 3. S?p x?p k?t qu? theo c?p ?? trung b�nh gi?m d?n.
SELECT ChuyenGia.HoTen, AVG(ChuyenGia_KyNang.CapDo) AS TrungBinhCapDo
FROM ChuyenGia
JOIN ChuyenGia_KyNang On ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
WHERE ChuyenGia.ChuyenNganh = N'Ph�t tri?n ph?n m?m'
GROUP BY ChuyenGia.HoTen
HAVING AVG(ChuyenGia_KyNang.CapDo) > 3
ORDER By TrungBinhCapDo DESC;