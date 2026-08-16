# 📘 Cẩm nang Triển khai AWS Console (GUI Playbook)
**Phần 4:** Containers & Microservices (Ứng dụng & Nền tảng SOP)

---

## 4.1 Khởi tạo ECR Repository (Kho chứa Docker Image)
*Nơi lưu trữ mã nguồn đã đóng gói của VPE Sales App, SOP Platform và Poultry API.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `ECR` 👉 Bấm vào **Elastic Container Registry** 👉 Bấm nút màu cam **[Create repository]**

### 🖼️ Màn hình "Create repository"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Visibility settings** | 🔘 Chọn `Private` |
| **Repository name** | Nhập `vpe/sales-app-backend` |
| **Tag mutability** | 🔘 Chọn `Mutable` |
| **Image scan settings** | ☑️ Bật tính năng `Scan on push` |
| *Nút bấm cuối trang* | Bấm nút cam **[Create repository]** |

*(Lặp lại bước này để tạo thêm 2 repo: `vpe/sop-platform` và `vpe/poultry-production-api`)*

---

## 4.2 Khởi tạo EKS Cluster (Cụm Kubernetes)
*Trung tâm điều phối toàn bộ các Microservices của VPE.*

**Điều hướng:** 🔍 Ô tìm kiếm 👉 Gõ `EKS` 👉 Bấm vào **Elastic Kubernetes Service** 👉 Bấm nút **[Add cluster]** 👉 Chọn **[Create]**

### 🖼️ Màn hình "Configure cluster"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Name** | Nhập `vpe-prod-eks-cluster` |
| **Kubernetes version** | 🔽 Chọn phiên bản mới nhất (Ví dụ: `1.28`) |
| **Cluster service role** | 🔽 Chọn IAM Role có tên `vpe-eks-cluster-role` |
| **Secrets encryption** | ☑️ Bật và chọn một KMS Key (Tùy chọn bảo mật cao) |
| *Bấm Next sang phần Mạng* | |
| **VPC** | 🔽 Chọn `vpe-prod-core-vpc` |
| **Subnets** | ☑️ Chỉ chọn các Subnet `Private` |
| **Cluster endpoint access** | 🔘 Chọn `Private` *(Vì bảo mật nội bộ)* |
| *Nút bấm cuối trang* | Bấm nút cam **[Create]** |

*(Đợi cụm EKS tạo xong sẽ mất từ 10-15 phút)*

---

## 4.3 Cấu hình EKS Fargate Profiles
*Đổi từ kiến trúc chạy máy chủ EC2 truyền thống sang Serverless Fargate để tiết kiệm chi phí.*

**Điều hướng:** Trong màn hình chi tiết của Cluster `vpe-prod-eks-cluster` vừa tạo 👉 Chọn tab **Compute** 👉 Kéo xuống mục Fargate profiles 👉 Bấm nút **[Add Fargate profile]**

### 🖼️ Màn hình "Configure Fargate profile"

| 🎯 Khu vực trên màn hình | 📝 Thao tác / Giá trị bạn cần nhập |
| :--- | :--- |
| **Name** | Nhập `vpe-sales-workloads` |
| **Pod execution role** | 🔽 Chọn IAM Role có tên `vpe-fargate-execution-role` |
| **Subnets** | ☑️ Chọn các Private Subnets |
| *Bấm Next* | |
| **Namespace match** | Nhập `vpe-sales` (Mọi Pod trong namespace này sẽ tự động được chạy trên Fargate) |
| *Nút bấm cuối trang* | Bấm nút cam **[Create]** |

---
Hoàn thành Phần 4. Mời bạn tiếp tục với Phần 5.
