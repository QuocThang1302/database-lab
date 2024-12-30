
-- Tạo bảng NHANVIEN
CREATE TABLE NHANVIEN (
    MaNV CHAR(5) PRIMARY KEY,          -- Mã nhân viên (Khóa chính)
    HoTen VARCHAR(20),                 -- Họ tên
    NgayVL SMALLDATETIME,              -- Ngày vào làm
    HSLuong NUMERIC(4, 2),             -- Hệ số lương
    MaPhong CHAR(5)                    
);
ALTER TABLE NHANVIEN
ADD CONSTRAINT Khoa_MaPhong FOREIGN KEY (MaPhong) REFERENCES PHONGBAN(MaPhong);
-- Tạo bảng PHONGBAN
CREATE TABLE PHONGBAN (
    MaPhong CHAR(5) PRIMARY KEY,       -- Mã phòng (Khóa chính)
    TenPhong VARCHAR(25),              -- Tên phòng
    TruongPhong CHAR(5)                -- Trưởng phòng (có thể là khóa ngoại liên kết đến MaNV trong NHANVIEN nếu cần)
	FOREIGN KEY(TruongPhong) references NHANVIEN(MaNV)
);



-- Tạo bảng XE
CREATE TABLE XE (
    MaXe CHAR(5) PRIMARY KEY,          -- Mã xe (Khóa chính)
    LoaiXe VARCHAR(20),                -- Loại xe
    SoChoNgoi INT,                     -- Số chỗ ngồi
    NamSX INT                          -- Năm sản xuất
);

-- Tạo bảng PHANCONG
CREATE TABLE PHANCONG (
    MaPC CHAR(5) PRIMARY KEY,          -- Mã phân công (Khóa chính)
    MaNV CHAR(5),                      -- Mã nhân viên (Không có khóa ngoại)
    MaXe CHAR(5),                      -- Mã xe (Không có khóa ngoại)
    NgayDi SMALLDATETIME,              -- Ngày đi
    NgayVe SMALLDATETIME,              -- Ngày về
    NoiDen VARCHAR(25)                 -- Nơi đến
	FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),  -- Khóa ngoại liên kết tới NHANVIEN
    FOREIGN KEY (MaXe) REFERENCES XE(MaXe)         -- Khóa ngoại liên kết tới XE
);
--Năm sản xuất của xe loại Toyota phải từ năm 2006 trở về sau.
ALTER TABLE XE 
ADD CONSTRAINT chk_namsx CHECK (NamSX > 2016)

--Nhân viên thuộc phòng lái xe “Ngoại thành” chỉ được phân công lái xe loại Toyota.
CREATE TRIGGER TRG_PHANCONG_XE
ON PHANCONG
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra nếu có nhân viên thuộc phòng "Ngoại thành" nhưng không lái xe loại "Toyota"
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN NHANVIEN n ON i.MaNV = n.MaNV
        JOIN PHONGBAN p ON n.MaPhong = p.MaPhong
        JOIN XE x ON i.MaXe = x.MaXe
        WHERE p.TenPhong = N'Ngoại thành' AND x.LoaiXe != N'Toyota'
    )
    BEGIN
        RAISERROR (N'Nhân viên phòng "Ngoại thành" chỉ được phân công lái xe loại Toyota!', 16, 1)
        ROLLBACK TRANSACTION
    END
END;

-- Tìm nhân viên(MANV,HoTen) là trưởng phòng được phân công lái tất cả các loại xe
SELECT DISTINCT NV.MaNV, NV.HoTen
FROM NHANVIEN NV
JOIN PHONGBAN PB ON NV.MaNV = PB.TruongPhong
WHERE NOT EXISTS (
    SELECT 1
    FROM XE X
    WHERE NOT EXISTS (
        SELECT 1
        FROM PHANCONG PC
        WHERE PC.MaNV = NV.MaNV AND PC.MaXe = X.MaXe
    )
);
 -- Trong mỗi phòng ban,tìm nhân viên (MaNV,HoTen) được phân công lái ít nhất loại xe Toyota.
 WITH ToyotaXe AS (
    -- Lọc danh sách các xe Toyota
    SELECT MaXe
    FROM XE
    WHERE LoaiXe = 'Toyota'
),
ToyotaPhanCong AS (
    -- Lấy danh sách phân công liên quan đến xe Toyota
    SELECT PC.MaNV, COUNT(DISTINCT PC.MaXe) AS SoXeToyota
    FROM PHANCONG PC
    JOIN ToyotaXe TX ON PC.MaXe = TX.MaXe
    GROUP BY PC.MaNV
),
NhanVienPhongBan AS (
    -- Lấy thông tin nhân viên và phòng ban của họ
    SELECT NV.MaNV, NV.HoTen, NV.MaPhong, COALESCE(TPC.SoXeToyota, 0) AS SoXeToyota
    FROM NHANVIEN NV
    LEFT JOIN ToyotaPhanCong TPC ON NV.MaNV = TPC.MaNV
),
MinToyotaPerPhong AS (
    -- Tìm số xe Toyota lái ít nhất trong từng phòng ban
    SELECT MaPhong, MIN(SoXeToyota) AS MinSoXeToyota
    FROM NhanVienPhongBan
    GROUP BY MaPhong
)
-- Kết quả: Nhân viên lái ít nhất số xe Toyota trong mỗi phòng ban
SELECT NV.MaNV, NV.HoTen, NV.MaPhong, NV.SoXeToyota
FROM NhanVienPhongBan NV
JOIN MinToyotaPerPhong MTP ON NV.MaPhong = MTP.MaPhong AND NV.SoXeToyota = MTP.MinSoXeToyota;