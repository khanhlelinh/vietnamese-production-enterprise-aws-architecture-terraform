# 📘 Cẩm nang Triển khai AWS Console (GUI Playbook)
**Phần 2:** Core Enterprise (Hệ thống ERP & Khối Quản trị Tài chính)

---

## 2.1 Cấu hình Máy chủ chạy SAP HANA (EC2 Memory Optimized)
*Hệ thống ERP SAP production đòi hỏi máy chủ cấu hình cực lớn và hệ điều hành SUSE Linux chuyên dụng.*

**Điều hướng:** 🔍 Ô tìm kiếm trên cùng 👉 Gõ `EC2` 👉 Bấm vào **EC2** 👉 Trình đơn trái chọn **Instances** 👉 Bấm nút màu cam **[Launch instances]**

### 🖼️ Màn hình "Launch an instance"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Name and tags** | Nhập `vpe-sap-hana-prod` |
| **Application and OS Images (Amazon Machine Image)** | 🔍 Gõ `SUSE Linux Enterprise Server for SAP` vào thanh tìm kiếm. <br> 🔘 Chọn đúng phiên bản được AWS chứng nhận cho SAP. |
| **Instance type** | 🔽 Bấm mũi tên xổ xuống, chọn `r6i.16xlarge` (64 vCPUs, 512 GiB Memory) |
| **Key pair (login)** | 🔽 Chọn `vpe-prod-key` (Hoặc bấm *Create new key pair* nếu chưa có) |
| **Network settings** | |
| ↳ VPC | 🔽 Chọn `vpe-prod-core-vpc` |
| ↳ Subnet | 🔽 Chọn `vpe-core-app-subnet-1a` |
| ↳ Auto-assign public IP | 🔘 Chọn `Disable` *(Bảo mật)* |
| **Configure storage** | |
| ↳ Root volume | Nhập `50` GiB, Chọn loại `gp3` |
| ↳ Bấm **[Add new volume]** | Nhập `1000` GiB, Chọn loại `io2` (Dành cho SAP Data & Logs) |
| *Bảng bên phải (Summary)* | Bấm nút cam **[Launch instance]** |

---

## 2.2 Khởi tạo Cơ sở dữ liệu Khối Tài chính (Oracle RDS)
*Thay vì quản lý máy chủ tự chạy Oracle, AWS RDS giúp tự động sao lưu và vá lỗi.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `RDS` 👉 Bấm vào **RDS** 👉 Chọn **Databases** 👉 Bấm nút màu cam **[Create database]**

### 🖼️ Màn hình "Create database"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Choose a database creation method**| 🔘 Chọn `Standard create` |
| **Engine options** | 🔘 Chọn biểu tượng **Oracle** |
| **Edition** | 🔘 Chọn `Oracle Enterprise Edition` |
| **Version** | 🔽 Chọn `Oracle 19.c` |
| **Templates** | 🔘 Chọn `Production` |
| **Settings** | |
| ↳ DB instance identifier | Nhập `vpe-finance-oracle` |
| ↳ Master username | Nhập `admin` |
| ↳ Master password | Nhập mật khẩu bảo mật của bạn |
| **Instance configuration** | 🔘 Chọn `Memory Optimized classes` 👉 Chọn `db.m5.2xlarge` |
| **Storage** | |
| ↳ Storage type | 🔽 Chọn `Provisioned IOPS (io1)` |
| ↳ Allocated storage | Nhập `500` GiB |
| ↳ Provisioned IOPS | Nhập `3000` |
| **Connectivity** | |
| ↳ Virtual private cloud (VPC) | 🔽 Chọn `vpe-prod-core-vpc` |
| ↳ Public access | 🔘 Chọn `No` |
| *Nút bấm cuối trang* | Bấm nút cam **[Create database]** |

*(Quá trình khởi tạo Oracle RDS mất khoảng 15-30 phút)*

---
Hoàn thành Phần 2. Mời bạn tiếp tục với Phần 3.
