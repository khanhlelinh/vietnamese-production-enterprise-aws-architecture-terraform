# 📘 Cẩm nang Triển khai AWS Console (GUI Playbook)
**Dự án:** Vietnamese Production Enterprise (VPE)
**Phần 1:** Network & Security (Mạng lưới & Bảo mật)

Tài liệu này thay thế hoàn toàn cho code Terraform, hướng dẫn bạn từng click chuột trên giao diện AWS Management Console. Các bảng thông số dưới đây được thiết kế chính xác 100% theo giao diện của AWS.

---

## 1.1 Khởi tạo Virtual Private Cloud (VPC)
*Lặp lại các bước này 3 lần để tạo 3 VPC: `Core Enterprise`, `Sales & Commerce`, và `IoT & Analytics`.*

**Điều hướng:** 🔍 Ô tìm kiếm trên cùng (Search) 👉 Gõ `VPC` 👉 Bấm vào **VPC** 👉 Trình đơn trái chọn **VPCs** 👉 Bấm nút màu cam **[Create VPC]**

### 🖼️ Màn hình "VPC settings" (Tạo Core VPC)

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Resources to create** | 🔘 Chọn `VPC only` |
| **Name tag** | Nhập `vpe-prod-core-vpc` |
| **IPv4 CIDR block** | 🔘 Chọn `IPv4 CIDR manual input` <br> Nhập `10.0.0.0/16` |
| **IPv6 CIDR block** | 🔘 Chọn `No IPv6 CIDR block` |
| **Tenancy** | 🔘 Chọn `Default` |
| *Nút bấm cuối trang* | Bấm nút cam **[Create VPC]** |

*(Thực hiện tương tự cho Sales VPC với dải IP `10.1.0.0/16` và IoT VPC dải `10.2.0.0/16`)*

---

## 1.2 Cắt chia Subnets (Mạng con)
*Bạn cần tạo các mạng con Public và Private cho từng VPC.*

**Điều hướng:** Trình đơn trái chọn **Subnets** 👉 Bấm nút màu cam **[Create subnet]**

### 🖼️ Màn hình "Create subnet" (Tạo Subnet cho Database trong Core VPC)

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **VPC ID** | 🔽 Bấm mũi tên xổ xuống, chọn `vpe-prod-core-vpc` |
| **Subnet settings (Subnet 1)** | |
| ↳ Subnet name | Nhập `vpe-core-db-subnet-1a` |
| ↳ Availability Zone | 🔽 Chọn `ap-southeast-1a` |
| ↳ IPv4 CIDR block | Nhập `10.0.10.0/24` |
| Bấm nút **[Add new subnet]** để tạo tiếp Subnet 2 | |
| **Subnet settings (Subnet 2)** | |
| ↳ Subnet name | Nhập `vpe-core-db-subnet-1b` |
| ↳ Availability Zone | 🔽 Chọn `ap-southeast-1b` |
| ↳ IPv4 CIDR block | Nhập `10.0.11.0/24` |
| *Nút bấm cuối trang* | Bấm nút cam **[Create subnet]** |

---

## 1.3 Thiết lập cầu nối Transit Gateway (TGW)
*Để 3 VPC có thể giao tiếp nội bộ an toàn (Ví dụ: Ứng dụng Sales gọi về Database ERP Core).*

**Điều hướng:** Trình đơn trái cuộn xuống mục **TRANSIT GATEWAYS** 👉 Chọn **Transit gateways** 👉 Bấm **[Create transit gateway]**

### 🖼️ Màn hình "Create transit gateway"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Name tag** | Nhập `vpe-prod-tgw` |
| **Description** | Nhập `TGW routing traffic between Core, Sales and IoT VPCs` |
| **Amazon side ASN** | Nhập `64512` *(Giá trị mặc định)* |
| **DNS support** | ☑️ Đánh dấu tick (Enable) |
| **VPN ECMP support** | ☑️ Đánh dấu tick (Enable) |
| **Default route table association**| ☑️ Đánh dấu tick (Enable) |
| **Default route table propagation**| ☑️ Đánh dấu tick (Enable) |
| *Nút bấm cuối trang* | Bấm nút cam **[Create transit gateway]** |

*(Đợi khoảng 2-5 phút cho TGW chuyển trạng thái sang `Available`)*

---

## 1.4 Gắn VPC vào Transit Gateway (TGW Attachments)
**Điều hướng:** Trình đơn trái chọn **Transit gateway attachments** 👉 Bấm **[Create transit gateway attachment]**

### 🖼️ Màn hình "Create transit gateway attachment" (Gắn Core VPC)

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Name tag** | Nhập `vpe-tgw-attach-core` |
| **Transit gateway ID** | 🔽 Chọn `vpe-prod-tgw` (Vừa tạo ở bước trên) |
| **Attachment type** | 🔘 Chọn `VPC` |
| **VPC ID** | 🔽 Chọn `vpe-prod-core-vpc` |
| **Subnet IDs** | ☑️ Tích chọn các Subnet Private trong Core VPC |
| *Nút bấm cuối trang* | Bấm nút cam **[Create transit gateway attachment]** |

*(Lặp lại bước này để gắn tiếp Sales VPC và IoT VPC vào TGW)*

---
Hoàn thành Phần 1.
