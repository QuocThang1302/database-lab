
-- 8. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1.
	SELECT KyNang.TenKyNang, ChuyenGia_KyNang.CapDo
	FROM ChuyenGia_KyNang
	JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
	WHERE ChuyenGia_KyNang.MaChuyenGia = 1; 

-- 9. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2.
	SELECT ChuyenGia.HoTen
	FROM ChuyenGia, ChuyenGia_DuAn
	WHERE 
		ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
		AND MaDuAn = '2'

-- 10. Hiển thị tên công ty và tên dự án của tất cả các dự án.
	SELECT CongTy.TenCongTy, DuAn.TenDuAn
	FROM CongTy, DuAn
	WHERE 
		CongTy.MaCongTy = DuAn.MaCongTy

-- 11. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
	SELECT ChuyenNganh, COUNT(*) AS SoLuongChuyenGia
	FROM ChuyenGia
	GROUP BY ChuyenNganh;

-- 12. Tìm chuyên gia có số năm kinh nghiệm cao nhất.
	SELECT HoTen, NamKinhNghiem
	FROM ChuyenGia
	WHERE 
		NamKinhNghiem = (SELECT MAX(NamKinhNghiem) FROM ChuyenGia);

-- 13. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia.
	SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_DuAn.MaDuAn) AS SoLuongDuAn
	FROM ChuyenGia
	JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
	GROUP BY ChuyenGia.HoTen;

-- 14. Hiển thị tên công ty và số lượng dự án của mỗi công ty.
	SELECT CongTy.TenCongTy, COUNT(DuAn.MaDuAn) AS SoLuongDuAn
	FROM CongTy
	JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
	GROUP BY CongTy.TenCongTy;

-- 15. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất.
	SELECT KyNang.TenKyNang, COUNT(ChuyenGia_KyNang.MaChuyenGia) AS SoLuongChuyenGia
	FROM KyNang
	JOIN ChuyenGia_KyNang ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
	GROUP BY KyNang.TenKyNang
	ORDER BY SoLuongChuyenGia DESC

-- 16. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên.
	SELECT ChuyenGia.HoTen
	FROM ChuyenGia
	JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
	JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
	WHERE KyNang.TenKyNang = 'Python'
	AND ChuyenGia_KyNang.CapDo >= 4;


-- 17. Tìm dự án có nhiều chuyên gia tham gia nhất.
	SELECT DuAn.TenDuAn, COUNT(ChuyenGia_DuAn.MaChuyenGia) AS SoLuongChuyenGia
	FROM DuAn
	JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
	GROUP BY DuAn.TenDuAn
	ORDER BY SoLuongChuyenGia DESC

-- 18. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia.
	SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaKyNang) AS SoLuongKyNang
	FROM ChuyenGia
	JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
	GROUP BY ChuyenGia.HoTen;


-- 19. Tìm các cặp chuyên gia làm việc cùng dự án.
	SELECT A.MaChuyenGia AS MaChuyenGia1, B.MaChuyenGia AS MaChuyenGia2, A.MaDuAn
	FROM ChuyenGia_DuAn A
	JOIN ChuyenGia_DuAn B ON A.MaDuAn = B.MaDuAn
	WHERE A.MaChuyenGia < B.MaChuyenGia;


-- 20. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ.
	SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaKyNang) AS SoLuongKyNangCap5
	FROM ChuyenGia
	JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
	WHERE ChuyenGia_KyNang.CapDo = 5
	GROUP BY ChuyenGia.HoTen;

-- 21. Tìm các công ty không có dự án nào.
	SELECT CongTy.TenCongTy
	FROM CongTy
	LEFT JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
	WHERE DuAn.MaDuAn IS NULL;


-- 22. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả chuyên gia không tham gia dự án nào.
	SELECT ChuyenGia.HoTen, DuAn.TenDuAn
	FROM ChuyenGia
	LEFT JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
	LEFT JOIN DuAn ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn;


-- 23. Tìm các chuyên gia có ít nhất 3 kỹ năng.
	SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaKyNang) AS SoLuongKyNang
	FROM ChuyenGia
	JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
	GROUP BY ChuyenGia.HoTen
	HAVING COUNT(ChuyenGia_KyNang.MaKyNang) >= 3;

-- 24. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó.
	SELECT CongTy.TenCongTy, SUM(ChuyenGia.NamKinhNghiem) AS TongSoNamKinhNghiem
	FROM CongTy
	JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
	JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
	JOIN ChuyenGia ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
	GROUP BY CongTy.TenCongTy;


-- 25. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python'.
	SELECT ChuyenGia.HoTen
	FROM ChuyenGia
	JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
	JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
	WHERE KyNang.TenKyNang = 'Java'
	AND ChuyenGia.MaChuyenGia NOT IN (
		SELECT ChuyenGia_KyNang.MaChuyenGia
		FROM ChuyenGia_KyNang
		JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
		WHERE KyNang.TenKyNang = 'Python'
	);

-- 76. Tìm chuyên gia có số lượng kỹ năng nhiều nhất.
	SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaKyNang) AS SoLuongKyNang
	FROM ChuyenGia
	JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
	GROUP BY ChuyenGia.HoTen
	ORDER BY SoLuongKyNang DESC;

-- 77. Liệt kê các cặp chuyên gia có cùng chuyên ngành.
	SELECT cg1.HoTen AS ChuyenGia1, cg2.HoTen AS ChuyenGia2, cg1.ChuyenNganh
	FROM ChuyenGia cg1
	JOIN ChuyenGia cg2 ON cg1.ChuyenNganh = cg2.ChuyenNganh
	WHERE cg1.MaChuyenGia < cg2.MaChuyenGia;

-- 78. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất.
	SELECT CongTy.TenCongTy, SUM(ChuyenGia.NamKinhNghiem) AS TongSoNamKinhNghiem
	FROM CongTy
	JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
	JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
	JOIN ChuyenGia ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
	GROUP BY CongTy.TenCongTy
	ORDER BY TongSoNamKinhNghiem DESC;

-- 79. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia.
	SELECT TenKyNang
	FROM KyNang
	WHERE MaKyNang NOT IN (
		SELECT DISTINCT ky1.MaKyNang
		FROM ChuyenGia_KyNang ky1
		LEFT JOIN ChuyenGia_KyNang ky2 ON ky1.MaKyNang = ky2.MaKyNang
		GROUP BY ky1.MaKyNang
		HAVING COUNT(ky2.MaChuyenGia) < (
			SELECT COUNT(*)
			FROM ChuyenGia
		)
	);