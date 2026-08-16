# 📘 Cẩm nang Triển khai AWS Console (GUI Playbook)
**Phần 6:** Serverless & Messaging (Giao tiếp API Mobile App)

---

## 6.1 Tạo Hàng đợi SQS cho Đơn hàng (Sales Orders)
*Hàng đợi giúp tách biệt Mobile App và Backend, không sợ quá tải khi nhiều đại lý đặt cám cùng lúc.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `SQS` 👉 Bấm vào **Simple Queue Service** 👉 Bấm nút màu cam **[Create queue]**

### 🖼️ Màn hình "Create queue"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Type** | 🔘 Chọn `Standard` |
| **Name** | Nhập `vpe-sales-orders-queue` |
| **Configuration** | |
| ↳ Visibility timeout | Nhập `30` Seconds |
| ↳ Message retention period | Nhập `4` Days |
| ↳ Delivery delay | Nhập `0` Seconds |
| ↳ Maximum message size | Nhập `256` KB |
| ↳ Receive message wait time | Nhập `10` Seconds |
| *Nút bấm cuối trang* | Bấm nút cam **[Create queue]** |

---

## 6.2 Thiết lập Amazon SNS cho Thông báo khách hàng
*Dùng để gửi Push Notification/SMS khi đơn hàng đổi trạng thái.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `SNS` 👉 Bấm vào **Simple Notification Service** 👉 Chọn **Topics** 👉 Bấm **[Create topic]**

### 🖼️ Màn hình "Create topic"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Type** | 🔘 Chọn `Standard` |
| **Name** | Nhập `vpe-customer-alerts` |
| **Display name** | Nhập `VPE-Alerts` *(Tên này sẽ hiện trong SMS)* |
| *Nút bấm cuối trang* | Bấm nút cam **[Create topic]** |

*(Sau khi tạo xong, bạn có thể bấm `Create subscription` để đăng ký Email hoặc Số điện thoại nhận tin thử).*

---

## 6.3 Xây dựng API Mobile Backend với API Gateway
*Điểm truy cập duy nhất (Entry point) cho Mobile App kết nối vào AWS.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `API Gateway` 👉 Bấm vào **API Gateway**

### Thao tác 1: Khởi tạo API
- Tại mục **REST API** (Loại không có chữ Private) 👉 Bấm **[Build]**.
- Chọn **New API**.
- **API name:** Nhập `vpe-sales-api`.
- **Endpoint Type:** Chọn `Regional`.
- Bấm **[Create API]**.

### Thao tác 2: Tạo Resources & Methods
- Trong giao diện API, chọn **Resources** 👉 Bấm **[Create Resource]**.
- **Resource Name:** Nhập `orders` 👉 Bấm **[Create Resource]**.
- Click vào thư mục `/orders` vừa tạo 👉 Bấm **[Create Method]**.
- **Method type:** Chọn `POST`.
- **Integration type:** Chọn `Lambda function`.
- Gõ tên Lambda function (Ví dụ `vpe-order-processor`) vào ô nhập liệu.
- Bấm **[Create method]**.

### Thao tác 3: Public API (Deploy)
- Bấm vào nút cam **[Deploy API]** ở góc trên cùng.
- **Stage:** Chọn `[New Stage]`.
- **Stage name:** Nhập `prod`.
- Bấm **[Deploy]**.
👉 *AWS sẽ cung cấp cho bạn một đường link URL để gán vào mã nguồn Mobile App (Android/iOS).*

---
> [!SUCCESS] Hoàn thành toàn bộ Playbook!
> Chúc mừng bạn! Nếu bạn thực hiện theo đúng 6 Phần của bộ Playbook này, bạn đã thiết lập bằng tay thành công cấu trúc hạ tầng khổng lồ của Enterprise trên AWS. Mặc dù cấu hình bằng tay (ClickOps) mất nhiều thời gian hơn so với Terraform, nhưng nó giúp bạn hiểu sâu sắc bản chất của từng dịch vụ!
