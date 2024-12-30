CREATE DATABASE NHASACH
CREATE TABLE TACGIA
(
MaTG CHAR(5) PRIMARY KEY ,
HoTen VARCHAR(20) ,
DiaChi VARCHAR(50),
NgSinh SMALLDATETIME ,
SoDT VARCHAR(15),
)
CREATE TABLE SACH
(
MaSach CHAR(5) PRIMARY KEY,
TenSach VARCHAR(25),
TheLoai VARCHAR(25),
)
CREATE TABLE TACGIA_SACH
(
MaTG Char(5),
MaSach char(5),
PRIMARY KEY(MaTG, MaSach),
FOREIGN KEY (MaTG) REFERENCES TACGIA(MaTG),
FOREIGN KEY (MaSach) REFERENCES SACH(MaSach),

)
CREATE TABLE PHATHANH
(
MaPH char(5) PRIMARY KEY,
MaSach char(5),
NgayPH smalldatetime,
SoLuong int,
NhaXuatBan varchar(20),
FOREIGN KEY (MaSach) REFERENCES SACH(MaSach),
)

-- Xóa dữ liệu cũ (nếu có)
DELETE FROM PHATHANH;
DELETE FROM TACGIA_SACH;
DELETE FROM SACH;
DELETE FROM TACGIA;

-- Thêm dữ liệu vào bảng TACGIA
INSERT INTO TACGIA (MaTG, HoTen, DiaChi, NgSinh, SoDT)
VALUES
('TG001', 'Nguyen Van A', 'Ha Noi', '1975-05-20', '0987654321'),
('TG002', 'Tran Thi B', 'Ho Chi Minh', '1980-10-15', '0934567890'),
('TG003', 'Le Van C', 'Da Nang', '1990-03-25', '0912345678');

-- Thêm dữ liệu vào bảng SACH
INSERT INTO SACH (MaSach, TenSach, TheLoai)
VALUES
('S001', 'Toan 12', 'Giáo khoa'),
('S002', 'Van 10', 'Giáo khoa'),
('S003', 'Lich Su Viet Nam', 'Tham khảo'),
('S004', 'Lap Trinh C', 'Kỹ thuật');

-- Thêm dữ liệu vào bảng TACGIA_SACH
INSERT INTO TACGIA_SACH (MaTG, MaSach)
VALUES
('TG001', 'S001'), -- Tác giả TG001 viết sách S001
('TG002', 'S002'), -- Tác giả TG002 viết sách S002
('TG002', 'S003'), -- Tác giả TG002 viết sách S003
('TG003', 'S004'); -- Tác giả TG003 viết sách S004

-- Thêm dữ liệu vào bảng PHATHANH
INSERT INTO PHATHANH (MaPH, MaSach, NgayPH, SoLuong, NhaXuatBan)
VALUES
('PH001', 'S001', '2022-08-15', 500, 'Giáo dục'), -- Hợp lệ: Giáo khoa -> Giáo dục
('PH002', 'S002', '2021-07-10', 300, 'Giáo dục'), -- Hợp lệ: Giáo khoa -> Giáo dục
('PH003', 'S003', '2020-06-05', 200, 'NXB Lao Động'), -- Hợp lệ: Không phải Giáo khoa
('PH004', 'S004', '2023-03-12', 100, 'NXB Kỹ Thuật'); -- Hợp lệ: Không phải Giáo khoa

--Ngày phát hành sách phải lớn hơn ngày sinh của tác giả.
CREATE TRIGGER TRG_PHATHANH_NGAY
ON PHATHANH
AFTER INSERT, UPDATE
AS
BEGIN 
IF EXISTS  (
	SELECT 1
	FROM INSERTED i
	JOIN SACH s on i.MaSach = s.MaSach
	join TACGIA_SACH ts on i.MaSach = ts.MaSach
	join TACGIA tg on ts.MaTG = tg.MaTG
	WHERE i.NgayPH <= tg.NgSinh
)
BEGIN 
	RAISERROR ('Ngày phát hành phải lớn hơn ngày sinh của tác giả!', 16, 1)
	ROLLBACK TRANSACTION
	END
END

--Sách thuộc thể loại “Giáo khoa” chỉ do nhà xuất bản “Giáo dục” phát hành.
CREATE TRIGGER TRG_THELOAI_NXB
ON PHATHANH
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra nếu có sách thuộc thể loại "Giáo khoa" nhưng nhà xuất bản không phải "Giáo dục"
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN SACH s ON i.MaSach = s.MaSach
        WHERE s.TheLoai = N'Giáo khoa' AND i.NhaXuatBan != N'Giáo dục'
    )
    BEGIN
        RAISERROR (N'Sách thể loại "Giáo khoa" chỉ được phát hành bởi "Giáo dục"!', 16, 1)
        ROLLBACK TRANSACTION
    END
END

--Tìm tác giả (MaTG,HoTen,SoDT) của những quyển sách thuộc thể loại “Văn học” do nhà xuất bản Trẻ phát hành. 
select tg.MaTG, HoTen, SoDT
from TACGIA tg
join TACGIA_SACH ts on tg.MaTG = ts.MaTG
join PHATHANH ph on ph.MaSach = ts.MaSach

--Tìm nhà xuất bản phát hành nhiều thể loại sách nhất.
select top 1 WITH TIES NhaXuatBan, count(distinct TheLoai) as SoTheLoai
FROM PHATHANH ph
join SACH s on ph.MaSach = s.MaSach
Group by NhaXuatBan
order by SoTheLoai desc

--Trong mỗi nhà xuất bản, tìm tác giả (MaTG,HoTen) có số lần phát hành nhiều sách nhất
WITH PhatHanh_TacGia AS (
    SELECT 
        ph.NhaXuatBan,
        tg.MaTG,
        tg.HoTen,
        COUNT(ph.MaPH) AS SoLanPhatHanh
    FROM PHATHANH ph
    JOIN SACH s ON ph.MaSach = s.MaSach
    JOIN TACGIA_SACH tgs ON s.MaSach = tgs.MaSach
    JOIN TACGIA tg ON tgs.MaTG = tg.MaTG
    GROUP BY ph.NhaXuatBan, tg.MaTG, tg.HoTen
),
MaxPhatHanh AS (
    SELECT 
        NhaXuatBan,
        MAX(SoLanPhatHanh) AS MaxLanPhatHanh
    FROM PhatHanh_TacGia
    GROUP BY NhaXuatBan
)
SELECT 
    pht.NhaXuatBan,
    pht.MaTG,
    pht.HoTen,
    pht.SoLanPhatHanh
FROM PhatHanh_TacGia pht
JOIN MaxPhatHanh mph ON pht.NhaXuatBan = mph.NhaXuatBan AND pht.SoLanPhatHanh = mph.MaxLanPhatHanh;
