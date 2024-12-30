create database SACH
-- Tạo bảng DOCGIA
CREATE TABLE DOCGIA (
    MaDG CHAR(5) PRIMARY KEY,        -- Mã độc giả
    HoTen VARCHAR(30),               -- Họ tên
    NgaySinh SMALLDATETIME,          -- Ngày sinh
    DiaChi VARCHAR(30),              -- Địa chỉ
    SoDT VARCHAR(15)                 -- Số điện thoại
);

-- Tạo bảng SACH
CREATE TABLE SACH (
    MaSach CHAR(5) PRIMARY KEY,      -- Mã sách
    TenSach VARCHAR(25),             -- Tên sách
    TheLoai VARCHAR(25),             -- Thể loại
    NhaXuatBan VARCHAR(30)           -- Nhà xuất bản
);

-- Tạo bảng PHIEUTHUE
CREATE TABLE PHIEUTHUE (
    MaPT CHAR(5) PRIMARY KEY,        -- Mã phiếu thuê
    MaDG CHAR(5),                    -- Mã độc giả (Khóa ngoại tham chiếu DOCGIA)
    NgayThue SMALLDATETIME,          -- Ngày thuê
    NgayTra SMALLDATETIME,           -- Ngày trả
    SoSachThue INT,                  -- Số sách thuê
    FOREIGN KEY (MaDG) REFERENCES DOCGIA(MaDG) -- Ràng buộc khóa ngoại
);

-- Tạo bảng CHITIET_PT
CREATE TABLE CHITIET_PT (
    MaPT CHAR(5),                    -- Mã phiếu thuê (Khóa ngoại tham chiếu PHIEUTHUE)
    MaSach CHAR(5),                  -- Mã sách (Khóa ngoại tham chiếu SACH)
    PRIMARY KEY (MaPT, MaSach),      -- Khóa chính gồm MaPT và MaSach
    FOREIGN KEY (MaPT) REFERENCES PHIEUTHUE(MaPT), -- Ràng buộc khóa ngoại
    FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)   -- Ràng buộc khóa ngoại
);

--Mỗi lần thuê  sách, độc giả không được thuê quá 10 ngày.
CREATE TRIGGER TRG_KiemTraNgayThue
ON PHIEUTHUE
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra điều kiện: Ngày thuê và ngày trả không vượt quá 10 ngày
    IF EXISTS (
        SELECT 1
        FROM INSERTED
        WHERE DATEDIFF(DAY, NgayThue, NgayTra) > 10
    )
    BEGIN
        RAISERROR (N'Mỗi lần thuê sách không được vượt quá 10 ngày.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--Số sách thuê trong bảng phiếu thuê bằng tổng số lần thuê sách có trong bảng chi tiết phiếu thuê. 
CREATE TRIGGER TRG_KiemTraSoSachThue
ON PHIEUTHUE
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra nếu số sách thuê không khớp với tổng số sách trong bảng CHITIET_PT
    IF EXISTS (
        SELECT 1
        FROM PHIEUTHUE P
        JOIN (
            SELECT MaPT, COUNT(MaSach) AS TongSoSach
            FROM CHITIET_PT
            GROUP BY MaPT
        ) CT ON P.MaPT = CT.MaPT
        WHERE P.SoSachThue != CT.TongSoSach
    )
    BEGIN
        RAISERROR (N'Số sách thuê không khớp với tổng số sách trong chi tiết phiếu thuê.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- Tìm các độc giả (MaDG,HoTen) đã thuê sách thuộc thể loại “Tin học” trong năm 2007. 
SELECT DISTINCT DG.MaDG, DG.HoTen
FROM DOCGIA DG
JOIN PHIEUTHUE PT ON DG.MaDG = PT.MaDG
JOIN CHITIET_PT CT ON PT.MaPT = CT.MaPT
JOIN SACH S ON CT.MaSach = S.MaSach
WHERE S.TheLoai = N'Tin học' 
  AND YEAR(PT.NgayThue) = 2007;

--Tìm các độc giả (MaDG,HoTen) đã thuê nhiều thể loại sách nhất. 
WITH TheLoaiDocGia AS (
    -- Tính số lượng thể loại sách mỗi độc giả đã thuê
    SELECT DG.MaDG, DG.HoTen, COUNT(DISTINCT S.TheLoai) AS SoTheLoai
    FROM DOCGIA DG
    JOIN PHIEUTHUE PT ON DG.MaDG = PT.MaDG
    JOIN CHITIET_PT CT ON PT.MaPT = CT.MaPT
    JOIN SACH S ON CT.MaSach = S.MaSach
    GROUP BY DG.MaDG, DG.HoTen
),
MaxTheLoai AS (
    -- Tìm số lượng thể loại sách lớn nhất mà độc giả đã thuê
    SELECT MAX(SoTheLoai) AS MaxSoTheLoai
    FROM TheLoaiDocGia
)
-- Lọc các độc giả đã thuê số lượng thể loại sách bằng giá trị lớn nhất
SELECT TLDG.MaDG, TLDG.HoTen, TLDG.SoTheLoai
FROM TheLoaiDocGia TLDG
JOIN MaxTheLoai MT ON TLDG.SoTheLoai = MT.MaxSoTheLoai;
 

-- Cach 2:
--SELECT TOP 1 WITH TIES DG.MaDG, DG.HoTen, COUNT(DISTINCT S.TheLoai) AS SoTheLoai
--FROM DOCGIA DG
--JOIN PHIEUTHUE PT ON DG.MaDG = PT.MaDG
--JOIN CHITIET_PT CT ON PT.MaPT = CT.MaPT
--JOIN SACH S ON CT.MaSach = S.MaSach
--GROUP BY DG.MaDG, DG.HoTen
--ORDER BY SoTheLoai DESC;

--Trong mỗi thể loại sách, cho biết tên sách được thuê nhiều nhất. 

--Trong mỗi thể loại sách, cho biết tên sách được thuê nhiều nhất
WITH TheLoai_Sach_Count AS (
    SELECT s.TheLoai, s.TenSach, COUNT(ct.MaSach) AS SoLanThue
    FROM SACH s
    JOIN CHITIET_PT ct ON s.MaSach = ct.MaSach
    GROUP BY s.TheLoai, s.TenSach
),
RankedBooks AS ( -- Đồng nhất tên bảng là "RankedBooks"
    SELECT TheLoai, TenSach, SoLanThue,
           RANK() OVER (PARTITION BY TheLoai ORDER BY SoLanThue DESC) AS Rnk
    FROM TheLoai_Sach_Count
)
SELECT TheLoai, TenSach, SoLanThue
FROM RankedBooks -- Sử dụng tên "RankedBooks" như đã khai báo
WHERE Rnk = 1;
