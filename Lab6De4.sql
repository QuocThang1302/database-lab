create database BANGDIA
-- Tạo bảng KHACHHANG
CREATE TABLE KHACHHANG (
    MaKH CHAR(5) PRIMARY KEY, -- Mã khách hàng
    HoTen VARCHAR(30),        -- Họ tên
    DiaChi VARCHAR(30),       -- Địa chỉ
    SoDT VARCHAR(15),         -- Số điện thoại
    LoaiKH VARCHAR(10)        -- Loại khách hàng
);

-- Tạo bảng BANG_DIA
CREATE TABLE BANG_DIA (
    MaBD CHAR(5) PRIMARY KEY, -- Mã băng đĩa
    TenBD VARCHAR(25),        -- Tên băng đĩa
    TheLoai VARCHAR(25)       -- Thể loại
);

-- Tạo bảng PHIEUTHUE
CREATE TABLE PHIEUTHUE (
    MaPT CHAR(5) PRIMARY KEY, -- Mã phiếu thuê
    MaKH CHAR(5),             -- Mã khách hàng
    NgayThue SMALLDATETIME,   -- Ngày thuê
    NgayTra SMALLDATETIME,    -- Ngày trả
    Soluongthue INT,          -- Số lượng băng đĩa thuê
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) -- Ràng buộc khóa ngoại
);

-- Tạo bảng CHITIET_PM
CREATE TABLE CHITIET_PM (
    MaPT CHAR(5),             -- Mã phiếu thuê
    MaBD CHAR(5),             -- Mã băng đĩa
    PRIMARY KEY (MaPT, MaBD), -- Khóa chính gồm MaPT và MaBD
    FOREIGN KEY (MaPT) REFERENCES PHIEUTHUE(MaPT), -- Ràng buộc khóa ngoại
    FOREIGN KEY (MaBD) REFERENCES BANG_DIA(MaBD)  -- Ràng buộc khóa ngoại
);
--Chỉ những khách hàng thuộc loại VIP mới được thuê với số lượng băng đĩa trên 5
CREATE TRIGGER trg_CheckSoluongthue
ON PHIEUTHUE
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra điều kiện khách hàng loại VIP với số lượng thuê > 5
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN KHACHHANG k ON i.MaKH = k.MaKH
        WHERE i.Soluongthue > 5 AND k.LoaiKH != 'VIP'
    )
    BEGIN
        RAISERROR ('Chỉ khách hàng loại VIP mới được thuê với số lượng băng đĩa trên 5.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

