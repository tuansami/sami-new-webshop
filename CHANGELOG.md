# Nhật ký thay đổi (Changelog)

Toàn bộ thay đổi của plugin **2 Step Webshop**, mới nhất ở trên.

- ZIP cài đặt của từng phiên bản nằm trong [`releases/`](releases/README.md).
- Plugin hoạt động độc lập với theme, yêu cầu WordPress 6.0+ và WooCommerce 7.0+.

## [1.4.9] – 2026-10-14

Tải về: [releases/1.4.9/](releases/1.4.9/README.md)

Sửa lỗi & Cải tiến:
- **Giao diện Quản trị (Admin UI)**:
  - Chuẩn hóa toàn bộ cấu trúc Admin UI: chuyển sang dạng block layout 100% width, loại bỏ hoàn toàn lỗi lệch cột 3 trên màn hình Desktop.
  - Khôi phục thẻ cấu hình Bật/Tắt phương thức nhận hàng (Local Pickup & Delivery) trong Admin UI Tab 1.
  - Sửa lỗi lồng thẻ HTML `<div>` gây đẩy lệch Tab 2 và Tab 3 ra ngoài container chính.
  - Bổ sung tính năng tự động khởi tạo danh sách kiểm tra cài đặt (Checklist & Prerequisites) và liên kết cấu hình nhanh trong Admin UI.
- **Giao diện Cửa hàng (Shop Layout)**:
  - Nâng cấp độ phân giải ảnh hiển thị trong Modal xem chi tiết sản phẩm (Product Info Popup) từ medium thumbnail sang full-resolution.
  - Tự động điều chỉnh khớp lề Brand Header khi không tải ảnh logo cửa hàng.

## [1.4.8] – 2026-10-12

- **Vận chuyển & Thanh toán (Shipping & Checkout)**:
  - Sửa lỗi *"No shipping method has been selected"* bằng cơ chế tự động tạo phương thức giao hàng dự phòng (Fallback Rate).
  - Tự động ẩn checkbox *"Ship to a different address?"* và các trường địa chỉ giao hàng riêng khi khách chọn Local Pickup.

## [1.4.7] – 2026-10-11

- **Danh mục sản phẩm**:
  - Thêm tùy chọn hiển thị Ảnh danh mục, Mô tả danh mục dạng cột đứng (`Image -> Title -> Description -> Products`).
  - Thêm tùy chọn Căn chỉnh văn bản (`Text Alignment: Left, Center, Right`).
- **Khởi tạo tự động**:
  - Tự động khởi tạo trang Webshop (`/webshop/`) và bật COD khi kích hoạt plugin trên trang WordPress mới tinh.

## [1.4.6] – 2026-10-10

- **Sản phẩm & Giá**:
  - Thêm tùy chọn hiển thị giá sản phẩm Variable (`Cheapest Price Only` vs `Full Price Range`).
- **Email HTML Đa ngôn ngữ**:
  - Thêm mẫu Email HTML mặc định chuẩn đẹp phân loại theo Tiếng Anh (EN) và Tiếng Đức (DE).
  - Tối ưu Admin UI: thêm nút Sao chép Shortcode 1-click và cảnh báo bảo vệ phương thức đặt hàng.

## [1.4.5] – 2026-10-09

- **Admin UI & Lịch mở cửa**:
  - Kiểm tra và rà soát toàn bộ 53 tùy chọn cấu hình trong Admin UI.
  - Sửa lỗi PHP Undefined variable `$yesterday_day` trong bộ lịch mở cửa qua đêm.

