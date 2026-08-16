# 📘 Cẩm nang Triển khai AWS Console (GUI Playbook)
**Phần 3:** Databases & Analytics (Dữ liệu Thanh toán & Phân tích quy mô lớn)

---

## 3.1 Khởi tạo DynamoDB cho Hệ thống Ví điện tử (PayOn)
*DynamoDB cung cấp tốc độ phản hồi tính bằng mili-giây, lý tưởng cho giao dịch ví điện tử.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `DynamoDB` 👉 Bấm vào **DynamoDB** 👉 Trình đơn trái chọn **Tables** 👉 Bấm nút màu cam **[Create table]**

### 🖼️ Màn hình "Create table"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Table details** | |
| ↳ Table name | Nhập `vpe-ewallet-transactions` |
| ↳ Partition key | Nhập `TransactionId` (Kiểu: `String`) |
| ↳ Sort key | Nhập `Timestamp` (Kiểu: `Number`) |
| **Table settings** | 🔘 Chọn `Customize settings` |
| **Read/write capacity settings**| 🔘 Chọn `On-demand` *(Phù hợp cho E-Wallet vì lưu lượng biến động)* |
| **Global secondary indexes** | Bấm **[Create global secondary index]** |
| ↳ GSI Partition key | Nhập `UserId` (Kiểu: `String`) |
| ↳ GSI Sort key | Nhập `Timestamp` (Kiểu: `Number`) |
| *Nút bấm cuối trang* | Bấm nút cam **[Create table]** |

---

## 3.2 Khởi tạo Aurora PostgreSQL cho CRM & Sales
*Hệ thống CRM cần một Database quan hệ có khả năng auto-scaling mạnh mẽ.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `RDS` 👉 Bấm vào **RDS** 👉 Chọn **Databases** 👉 Bấm nút màu cam **[Create database]**

### 🖼️ Màn hình "Create database" (Aurora)

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Choose a database creation method**| 🔘 Chọn `Standard create` |
| **Engine options** | 🔘 Chọn biểu tượng **Amazon Aurora** |
| **Edition** | 🔘 Chọn `Amazon Aurora PostgreSQL-Compatible Edition` |
| **Templates** | 🔘 Chọn `Production` |
| **Settings** | |
| ↳ DB cluster identifier | Nhập `vpe-sales-crm-aurora` |
| ↳ Master username | Nhập `crmadmin` |
| ↳ Master password | Nhập mật khẩu bảo mật của bạn |
| **Instance configuration** | 🔘 Chọn `Memory Optimized classes` 👉 Chọn `db.r6g.large` |
| **Availability & durability**| 🔘 Chọn `Create an Aurora Replica/Reader in a different AZ` |
| **Connectivity** | |
| ↳ Virtual private cloud (VPC) | 🔽 Chọn `vpe-prod-sales-vpc` |
| *Nút bấm cuối trang* | Bấm nút cam **[Create database]** |

---

## 3.3 Thiết lập Data Lake & Analytics (S3, Glue, Athena)
*Tập trung dữ liệu từ trang trại và doanh nghiệp để chạy báo cáo QuickSight.*

### Thao tác 1: Tạo S3 Bucket chứa dữ liệu
**Điều hướng:** 🔍 Gõ `S3` 👉 Bấm **[Create bucket]**
- Tên bucket: `vpe-datalake-raw-data` (Phải là tên duy nhất)
- AWS Region: `ap-southeast-1`
- Block Public Access: ☑️ Đánh dấu tick tất cả.
- Bấm **[Create bucket]**. Tạo thêm 1 bucket nữa tên `vpe-datalake-processed`.

### Thao tác 2: Tạo Glue Crawler quét dữ liệu tự động
**Điều hướng:** 🔍 Gõ `Glue` 👉 Chọn **Crawlers** 👉 Bấm **[Create crawler]**
- **Name:** Nhập `vpe-farm-data-crawler` 👉 Bấm Next.
- **Data sources:** Bấm **[Add a data source]** 👉 Chọn đường dẫn S3 trỏ tới bucket `vpe-datalake-processed/farm-telemetry/`.
- **IAM Role:** Bấm **[Create new IAM role]** 👉 Nhập tên `vpe-glue-service-role`.
- **Output:** Bấm **[Add database]** 👉 Nhập tên `vpe_analytics_db` 👉 Bấm Next.
- Bấm **[Create crawler]** và ấn nút **[Run crawler]**.

### Thao tác 3: Truy vấn bằng Athena
**Điều hướng:** 🔍 Gõ `Athena` 👉 Chọn **Query editor**
- Cửa sổ hiện ra yêu cầu thiết lập nơi lưu kết quả 👉 Bấm **Settings** 👉 Trỏ S3 location về bucket `vpe-athena-results`.
- Quay lại tab **Editor**, chọn Database `vpe_analytics_db` (vừa được Glue tạo). 
- Viết câu lệnh SQL trực tiếp vào khung trắng để truy vấn dữ liệu Farm!

---
Hoàn thành Phần 3. Mời bạn tiếp tục với Phần 4.
