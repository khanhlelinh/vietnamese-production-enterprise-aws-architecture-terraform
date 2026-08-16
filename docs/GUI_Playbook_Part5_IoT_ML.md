# 📘 Cẩm nang Triển khai AWS Console (GUI Playbook)
**Phần 5:** IoT & Machine Learning (Nông nghiệp thông minh)

---

## 5.1 Quản lý Thiết bị Farm bằng AWS IoT Core
*Kết nối hàng nghìn cảm biến tại các chuồng heo để giám sát thời gian thực.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `IoT Core` 👉 Bấm vào **IoT Core**

### Thao tác 1: Khởi tạo Thiết bị (Thing)
- Trình đơn trái chọn **Manage** 👉 **All devices** 👉 **Things** 👉 Bấm **[Create things]**.
- Chọn `Create single thing`.
- **Thing name:** Nhập `vpe-swine-monitor-001`. Bấm Next.
- Chọn `Auto-generate a new certificate`. Bấm Next.
- **Policy:** Bấm `Create policy` (mở tab mới), đặt tên `vpe-farm-sensor-policy`, cho phép mọi Action `iot:*` và Resource `*`. Quay lại tab cũ chọn Policy vừa tạo.
- Bấm **[Create thing]** và tải toàn bộ chứng chỉ (Certificates & Keys) về máy tính để nạp vào cảm biến.

### Thao tác 2: Tạo Rule đẩy dữ liệu về DB
- Trình đơn trái chọn **Message routing** 👉 **Rules** 👉 Bấm **[Create rule]**.
- **Rule name:** Nhập `vpe_farm_telemetry_rule`. Bấm Next.
- **SQL statement:** Nhập `SELECT * FROM 'vpe/farms/+/telemetry'`. Bấm Next.
- **Rule actions:** Chọn `Timestream table`.
- Chọn Database `vpe-farm-telemetry-db` và Table `SensorData`.
- Bấm **[Create rule]**.

---

## 5.2 Xử lý Video với Kinesis Video Streams
*Truyền hình ảnh từ Camera AI nhà máy ấp trứng lên AWS liên tục.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `Kinesis` 👉 Bấm vào **Kinesis** 👉 Chọn **Video streams** 👉 Bấm **[Create video stream]**

### 🖼️ Màn hình "Create a new video stream"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Stream name** | Nhập `vpe-hatchery-ai-stream` |
| **Data retention** | Nhập `24` (Giờ) |
| *Nút bấm cuối trang* | Bấm nút cam **[Create video stream]** |

---

## 5.3 Nhận diện bằng AI trên Amazon SageMaker
*Dùng AI phân loại sức khỏe vật nuôi (Heo, Gà).*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `SageMaker` 👉 Bấm vào **Amazon SageMaker**

### Thao tác 1: Tạo Inference Model
- Trình đơn trái cuộn xuống phần **Inference** 👉 Chọn **Models** 👉 Bấm **[Create model]**.
- **Model name:** Nhập `vpe-animal-health-model`.
- **IAM role:** Chọn Role `vpe-sagemaker-role`.
- **Container input options:** Cung cấp đường dẫn ảnh Docker Image chứa model AI của bạn trên ECR.

### Thao tác 2: Tạo Endpoint Configuration
- Trình đơn trái chọn **Endpoint configurations** 👉 Bấm **[Create endpoint configuration]**.
- Đặt tên `vpe-animal-health-endpoint-cfg`.
- **Variants:** Thêm model vừa tạo, chọn Instance Type là `ml.c5.xlarge`.

### Thao tác 3: Triển khai Endpoint
- Trình đơn trái chọn **Endpoints** 👉 Bấm **[Create endpoint]**.
- Đặt tên `vpe-animal-health-endpoint`.
- Chọn Endpoint configuration vừa tạo ở trên.
- Bấm **[Create endpoint]**. (Chờ khoảng 5-10 phút để Endpoint chuyển trạng thái `InService`).

---
Hoàn thành Phần 5. Mời bạn tiếp tục với Phần 6.
