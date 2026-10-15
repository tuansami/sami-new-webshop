# Hướng dẫn cấu hình & Tài liệu kỹ thuật 2 Step Webshop

## 1. Shortcode sử dụng

- Shortcode chính: `[two_step_webshop_layout]` (hoặc bí danh tương thích `[custom_shop]`).
- Trang webshop tự động được khởi tạo tại `/webshop/` khi kích hoạt plugin lần đầu.

## 2. Các tab cấu hình trong WordPress Admin

Truy cập: **WooCommerce → 2-Step Webshop**

### Tab 1: General Settings (Cài đặt chung)
- **Restaurant Information**:
  - Tên nhà hàng (Restaurant Name): ghi đè Site Title trên layout webshop.
  - Địa chỉ (Store Address): ghi đè địa chỉ WooCommerce.
  - Logo cửa hàng: chọn từ WordPress Media Library.
  - Hero Banner Image: banner đầu trang webshop.
  - Google Maps URL: URL bản đồ nhúng vào popup Store Info.
  - Delivery Zone Info: mô tả khu vực và điều kiện giao hàng.
- **Fulfillment Methods (Phương thức nhận hàng)**:
  - Bật / tắt **Local Pickup** (Nhận tại quán).
  - Bật / tắt **Delivery** (Giao hàng tận nơi).
- **Opening Hours & Pickup Scheduler (Lịch mở cửa)**:
  - Tùy chọn giờ mở cửa chung hoặc theo từng thứ trong tuần (Thứ Hai → Chủ Nhật).
  - Khoảng chia khung giờ đặt (Time Slot Step): 15, 30, 45, 60 phút.
  - Thời gian chuẩn bị trước (Lead time buffer mins): số phút tối thiểu từ hiện tại tới ca đặt đầu tiên.

### Tab 2: Style (Tùy biến giao diện)
- Bảng chọn màu sắc theo Palette và mã màu Hex tùy chọn.
- Font chữ, kích thước tiêu đề, giá tiền, mô tả món ăn.
- Độ bo góc (Border radius) của thẻ sản phẩm, popup modal, nút bấm.
- Độ rộng khung hiển thị (Container Max Width, Drawer Width, Modal Width).

### Tab 3: Email Templates (Mẫu Email HTML)
- Mẫu email xác nhận cho Khách hàng (Customer Confirmation).
- Mẫu email thông báo cho Quản trị viên (Admin Order Notification).
- Hỗ trợ đa ngôn ngữ EN và DE.
- Các biến placeholder được hỗ trợ:
  - `{restaurant_name}`, `{restaurant_address}`, `{restaurant_logo}`
  - `{customer_name}`, `{customer_email}`, `{customer_phone}`
  - `{order_number}`, `{order_date}`
  - `{order_table}` (Bảng chi tiết món ăn)
  - `{fulfillment_method}` (Pickup hoặc Delivery)
  - `{pickup_delivery_time}` (Khung giờ đã chọn)
  - `{special_request}` (Ghi chú món ăn)

