
# 📚 LetTutor – Ứng dụng học tập bằng Flutter

## 🔖 Giới thiệu đề tài

**LetTutor** là một ứng dụng học tập trực tuyến được xây dựng bằng **Flutter**, cho phép người dùng tìm kiếm, đăng ký và tham gia các khóa học chất lượng cao. Ứng dụng hỗ trợ học thông qua các chủ đề, giáo viên và bài quiz, đồng thời cung cấp các chức năng quản lý tài khoản, đa ngôn ngữ và thông báo tiện lợi.

---

## 👥 Thành viên nhóm

| MSSV       | Họ tên              | Email                        | SĐT         | Vai trò & chức năng chính |
|------------|---------------------|------------------------------|-------------|----------------------------|
| 22IT.B189  | Nguyễn Tiến Thành   | thanhnt.22itb@vku.udn.vn     | 0394281107  | **Nhóm trưởng**<br>– Giao diện Course<br>– Course Detail<br>– Topic, Quiz<br>– Tìm kiếm và sắp xếp khóa học<br>– Phân trang<br>– Giao diện và chức năng Đăng ký, Quên mật khẩu |
| 22IT.B061  | Nguyễn Đăng Hạ      | hand.22itb@vku.udn.vn        | 0388529096  | – Giao diện Login<br>– List Teacher, Teacher Detail<br>– Ứng dụng đa ngôn ngữ<br>– Notifications<br>– Giao diện Setting, Profile<br>– Đăng nhập bằng tài khoản và Google |

---

## ✅ Các chức năng chính đã hoàn thành

- 🔍 **Tìm kiếm khóa học, ebook** theo tên, cấp độ, danh mục
- 📋 **Phân trang và sắp xếp** danh sách khóa học
- 🧠 **Xem chi tiết khóa học, chủ đề và làm quiz**
- 🔐 **Đăng ký, đăng nhập, quên mật khẩu**
- 🌍 **Ứng dụng đa ngôn ngữ (đa quốc gia)**
- 👨‍🏫 **Danh sách và chi tiết giáo viên**
- 🔔 **Thông báo cá nhân hóa**
- ⚙️ **Cập nhật thông tin cá nhân**
- 🔑 **Đăng nhập bằng tài khoản hoặc Google Account**

---

## 🛠️ Công nghệ & Thư viện sử dụng

### 🔧 Ngôn ngữ & SDK
- Flutter SDK: `>=3.7.2`
- Dart
- Firebase (Auth, Firestore, Storage, App Check)

### 🌍 Đa ngôn ngữ & Localization
- `flutter_localizations`
- `intl`

### 🔐 Xác thực & Đăng nhập
- `firebase_auth`
- `google_sign_in`
- `firebase_app_check`

### 🔄 Quản lý trạng thái & Lưu trữ
- `provider`
- `shared_preferences`

### 🧭 Điều hướng & Hiệu ứng chuyển trang
- `persistent_bottom_nav_bar`
- `page_transition`

### 🎨 Giao diện người dùng (UI/UX)
- `animated_splash_screen`
- `number_paginator`
- `flutter_countdown_timer`
- `multiselect`
- `expandable_text`
- `syncfusion_flutter_calendar`
- `cupertino_icons`
- `ionicons`

### 🖼️ Hình ảnh & Media
- `flutter_svg`
- `cached_network_image`
- `video_player`
- `chewie`
- `image_picker`
- `country_picker`

### 🔔 Tiện ích & Hệ thống
- `url_launcher`
- `syncfusion_flutter_pdfviewer`
- `flutter_local_notifications`
- `flutter_launcher_icons`
- `permission_handler`
- `flutter_timezone`
- `app_settings`
- `syncfusion_flutter_core`

### 🧪 Kiểm thử & Phát triển
- `flutter_test`
- `flutter_lints`

---

## 🔗 Liên kết

- 💻 **Github**: [https://github.com/hand240503/vku_lettutor](https://github.com/hand240503/vku_lettutor)
- 🎬 **Link demo**: [Xem tại đây](https://drive.google.com/drive/folders/1Gq8dV8CKlnIIWOVuw3Ms8Sau5VgNBjxj?usp=sharing)
- 🗃️ **Database**: [Xem tại đây](https://drive.google.com/drive/folders/1Gq8dV8CKlnIIWOVuw3Ms8Sau5VgNBjxj?usp=sharing)

---

## 🚀 Hướng dẫn chạy ứng dụng

1. **Clone repository**:
   ```bash
   git clone https://github.com/hand240503/vku_lettutor.git
   cd vku_lettutor
   ```

2. **Cài đặt Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng trên thiết bị giả lập hoặc thật**:
   ```bash
   flutter run
   ```

---

## 📌 Ghi chú

- Yêu cầu Flutter SDK phiên bản >=3.7.2
- Cấu hình Firebase đã được tích hợp trong project
- Ứng dụng tương thích Android và iOS
- Có thể mở rộng thêm các chức năng như lịch học, tích điểm, bài học video...
