				--QuanLyBanHang--
					--Bai01--
-- I.11 
	-- Trigger: thêm và sửa NgHD của HoaDon
	CREATE TRIGGER trg_ins_udt_NgHD ON HoaDon
	FOR Insert, Update
	AS
	BEGIN
		IF (EXISTS (SELECT * FROM KhachHang, inserted 
					WHERE KhachHang.MaKH = inserted.MaKH 
					AND KhachHang.NgDK > inserted.NgHD))
		BEGIN
			PRINT 'Error: NgHD phai >= NgDK'
			ROLLBACK TRANSACTION
		END
	END

	-- Trigger: sửa NgDK của KhachHang
	CREATE TRIGGER trg_upd_NgDK ON KhachHang
	FOR Update
	AS
	BEGIN
		IF (EXISTS (SELECT * FROM HoaDon, inserted
					WHERE HoaDon.MaKH = inserted.MAKH
					AND HoaDon.NgHD < inserted.NgDK))
		BEGIN
			PRINT 'Error: NgHD phai >= NgDK'
			ROLLBACK TRANSACTION
		END
	END

-- I.12

	-- Trigger: thêm và sửa NgHD của HoaDon
	CREATE TRIGGER trg_ins_udt_NgBH ON HoaDon
	FOR Insert, Update
	AS
	BEGIN
		IF (EXISTS (SELECT * FROM NhanVien, inserted 
					WHERE NhanVien.MaNV = inserted.MaKH 
					AND NhanVien.NgVL > inserted.NgHD))
		BEGIN
			PRINT 'Error: NgHD phai >= NgVL'
			ROLLBACK TRANSACTION
		END
	END

	-- Trigger: sửa NGVL của NhanVien
	CREATE TRIGGER trg_upd_NgVL ON NhanVien
	FOR Update
	AS
	BEGIN
		IF (EXISTS (SELECT * FROM HoaDon, inserted
					WHERE HoaDon.MaNV = inserted.MANV
					AND HoaDon.NgHD < inserted.NgVL))
		BEGIN
			PRINT 'Error: NgHD phai >= NgDK'
			ROLLBACK TRANSACTION
		END
	END

-- I.13 

	-- Trigger: Xóa một CTHD
	CREATE TRIGGER trg_del_CTHD ON CTHD
	FOR Delete
	AS
	BEGIN
		IF ((SELECT COUNT(*) FROM deleted WHERE SoHD = deleted.SoHD)
			= (SELECT COUNT(*) FROM HoaDon, deleted WHERE deleted.SoHD = HoaDon.SoHD))
		BEGIN
			PRINT 'Error: Moi hoa don phai co it nhat 1 CTHD'
			ROLLBACK TRANSACTION
		END
	END

-- I.14 

	-- Trigger: Update DoanhSo của KhachHang
	CREATE TRIGGER trg_upd_DoanhSo ON KhachHang
	FOR Update
	AS
	BEGIN
		DECLARE @TongTriGia MONEY, @DoanhSo MONEY

		SELECT @TongTriGia = SUM(TriGia)
		FROM HoaDon, inserted
		WHERE HoaDon.MaKH = inserted.MaKH

		SELECT @DoanhSo = DoanhSo FROM inserted

		IF (@DoanhSo <> @TongTriGia)
		BEGIN
			PRINT('Doanh so cua mot khach hang la tong tri gia cac hoa don khach hang thanh vien do da mua')
			ROLLBACK TRANSACTION
		END
	END


					--QuanLyGiaoVu--
						--Bai02--

-- I.9 
	CREATE TRIGGER trg_ins_udt_LopTruong ON LOP
	FOR INSERT, UPDATE
	AS
	BEGIN
		IF NOT EXISTS (SELECT * FROM INSERTED I, HOCVIEN HV
		WHERE I.TRGLOP = HV.MAHV AND I.MALOP = HV.MALOP)
		BEGIN
			PRINT 'Error: Lop truong cua mot lop phai la hoc vien cua lop do'
			ROLLBACK TRANSACTION
		END
	END

	CREATE TRIGGER trg_del_HOCVIEN ON HOCVIEN
	FOR DELETE
	AS
	BEGIN
		IF EXISTS (SELECT * FROM DELETED D, INSERTED I, LOP L 
		WHERE D.MAHV = L.TRGLOP AND D.MALOP = L.MALOP)
		BEGIN
			PRINT 'Error: Hoc vien hien tai dang la truong lop'
			ROLLBACK TRANSACTION
		END
	END


--I.15
	CREATE TRIGGER trg_kt_thi_mon ON KETQUATHI
	FOR INSERT
	AS
	BEGIN
		-- Kiểm tra nếu học viên trong lớp đã học xong môn học
		IF EXISTS (
			SELECT 1
			FROM INSERTED i
			JOIN GIANGDAY gd ON i.MALOP = gd.MALOP AND i.MAMH = gd.MAMH
			WHERE GETDATE() < gd.DENNGAY
		)
		BEGIN
			-- Thông báo lỗi và hủy bỏ giao dịch
			RAISERROR ('LOI: Lop cua hoc vien chua hoc xong mon nay!', 16, 1);
			ROLLBACK TRANSACTION;
		END
	END;


--I.16
	GO
	CREATE TRIGGER TRG16_INSERT_GIANGDAY ON GIANGDAY
	FOR INSERT ,UPDATE
	AS
	BEGIN
     	  IF(SELECT COUNT(*)
     	  FROM inserted I , GIANGDAY GD
     	  WHERE I.MALOP=GD.MALOP AND I.HOCKY=GD.HOCKY)>3
     	  BEGIN
           		PRINT 'ERROR';
           		ROLLBACK TRANS
     	  END
     	  ELSE
           		BEGIN
           		PRINT 'THANHCONG'
     	  END
	END

--I.17
--- Sửa, THÊM sỉ số 
	GO
	CREATE TRIGGER TRG17_INSERT_LOP ON LOP
	FOR INSERT, UPDATE
	AS
	BEGIN
     	  DECLARE @SISO TINYINT, @DEMHOCVIEN TINYINT, @MALOP CHAR(3)
     	  SELECT @SISO = SISO, @MALOP = MALOP
     	  FROM INSERTED I
     	  SELECT @DEMHOCVIEN = COUNT(MAHV)
     	  FROM HOCVIEN
     	  WHERE MALOP =@MALOP
     	  IF(@SISO<>@DEMHOCVIEN)
     	  BEGIN
           		PRINT 'Khong cho sua si so'
           		ROLLBACK TRANSACTION
     	  END
     	  ELSE
     	  BEGIN
           		PRINT 'Sua si so thanh cong'
     	  END
	END

--I.18
	CREATE TRIGGER trg_check_dieukien_symmetric
	ON DIEUKIEN
	FOR INSERT, UPDATE
	AS
	BEGIN
		-- Kiểm tra nếu tồn tại hai bộ giá trị đảo ngược
		IF EXISTS (
			SELECT 1
			FROM INSERTED i
			JOIN DIEUKIEN d
			ON i.MAMH = d.MAMH_TRUOC AND i.MAMH_TRUOC = d.MAMH
		)
		BEGIN
			-- Thông báo lỗi và hủy bỏ giao dịch
			RAISERROR ('LOI: Khong duoc ton tai hai bo gia tri dao nguoc!', 16, 1);
			ROLLBACK TRANSACTION;
		END
	END;


--I.19
	
	GO
	CREATE TRIGGER TRG19_INSERTED_GIAOVIEN ON GIAOVIEN
	FOR INSERT , UPDATE
	AS
	BEGIN
     	  IF(SELECT COUNT (*)
     	  FROM inserted I , GIAOVIEN GV
     	  WHERE I.HOCHAM=GV.HOCHAM AND I.HOCVI=GV.HOCVI AND I.HESO=GV.HESO AND I.MUCLUONG!=GV.MUCLUONG)>0
     	  BEGIN
           		PRINT 'ERROR'
           		ROLLBACK TRAN
     	  END
     	  ELSE
     	  BEGIN
           		PRINT 'THANHCONG'
     	  END
	END

--I.20

	GO
	CREATE TRIGGER TRG20_INSERT_KQT ON KETQUATHI
	FOR INSERT
	AS
	BEGIN
     	  DECLARE @LANTHI TINYINT, @MAHV CHAR(5), @DIEM NUMERIC(4,2)
     	  SELECT @LANTHI = KETQUATHI.LANTHI +1, @MAHV = I.MAHV, @DIEM = KETQUATHI.DIEM
     	  FROM INSERTED I JOIN KETQUATHI ON I.MAHV =KETQUATHI.MAHV
     	  WHERE I.MAMH = KETQUATHI.MAMH
     	  IF(@DIEM>5)
     	  BEGIN
           		PRINT 'Khong duoc thi lan nua!'
           		ROLLBACK TRANSACTION
     	  END
     	  ELSE
     	  BEGIN
           		PRINT 'Them lan thi thanh cong!'
     	  END
	END

--I.21
	GO
	CREATE TRIGGER TRG21_INSERT_KQT ON KETQUATHI
	FOR INSERT , UPDATE
	AS
	BEGIN
     	  IF(SELECT COUNT(*)
     	  FROM INSERTED I , KETQUATHI K
     	  WHERE I.LANTHI> K.LANTHI AND I.MAHV=K.MAHV AND I.MAMH=I.MAMH AND I.NGTHI>K.NGTHI)=0
     	  BEGIN
           		PRINT 'ERROR'
           		ROLLBACK TRAN
     	  END
     	  ELSE
     	  BEGIN
           		PRINT 'THANHCONG'
     	  END
	END

--I.22
	ALTER TABLE KETQUATHI
	ADD MALOP CHAR(3);

	CREATE TRIGGER trg_kt_thi_mon2 ON KETQUATHI
	FOR INSERT
	AS
	BEGIN
		-- Kiểm tra nếu học viên trong lớp đã học xong môn học
		IF EXISTS (
			SELECT 1
			FROM INSERTED i
			JOIN GIANGDAY gd ON i.MALOP = gd.MALOP AND i.MAMH = gd.MAMH
			WHERE GETDATE() < gd.DENNGAY
		)
		BEGIN
			-- Thông báo lỗi và hủy bỏ giao dịch
			RAISERROR ('LOI: Lop cua hoc vien chua hoc xong mon nay!', 16, 1);
			ROLLBACK TRANSACTION;
		END
	END;


--I.23

	CREATE TRIGGER trg_phanc_giangday ON GIANGDAY
	FOR INSERT
	AS
	BEGIN
		-- Kiểm tra nếu các môn học điều kiện đã được hoàn thành
		IF EXISTS (
			SELECT 1
			FROM INSERTED i
			JOIN DIEUKIEN dk ON i.MAMH = dk.MAMH
			JOIN GIANGDAY gd ON dk.MAMH_TRUOC = gd.MAMH AND i.MALOP = gd.MALOP
			WHERE gd.DENNGAY > GETDATE()
		)
		BEGIN
			-- Thông báo lỗi và hủy bỏ giao dịch
			RAISERROR ('LOI: Phai hoc xong cac mon hoc truoc do!', 16, 1);
			ROLLBACK TRANSACTION;
		END
	END;

--I.24
	CREATE TRIGGER trg_phancong_gv ON GIANGDAY
	FOR INSERT
	AS
	BEGIN
		-- Kiểm tra nếu giáo viên dạy môn học thuộc khoa mình phụ trách
		IF EXISTS (
			SELECT 1
			FROM INSERTED i
			JOIN MONHOC mh ON i.MAMH = mh.MAMH
			JOIN GIAOVIEN gv ON i.MAGV = gv.MAGV
			WHERE mh.MAKHOA <> gv.MAKHOA
		)
		BEGIN
			-- Thông báo lỗi và hủy bỏ giao dịch
			RAISERROR ('LOI: Giao vien chi duoc day cac mon thuoc khoa cua minh!', 16, 1);
			ROLLBACK TRANSACTION;
		END
	END;
