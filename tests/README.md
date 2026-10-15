# Kiểm thử (Testing)

Thư mục chứa kịch bản kiểm thử tích hợp và luồng trải nghiệm người dùng (E2E User Behavior Test Suite).
Thư mục này được loại trừ khỏi ZIP cài đặt phân phối (`.distignore`).

## Các file kiểm thử

| File | Mô tả |
| --- | --- |
| `setup_gateways.php` | Kịch bản tự động kích hoạt và cấu hình các cổng thanh toán thử nghiệm (COD / BACS) |
| `test_user_flows.php` | Kịch bản kiểm thử luồng người dùng: thêm món vào giỏ hàng, chọn lịch Pickup / Delivery, tạo đơn hàng và kiểm tra email gửi qua Mailpit |

## Cách chạy kiểm thử

Chạy trong môi trường staging có WordPress, WooCommerce và Mailpit:

```bash
php tests/test_user_flows.php
```

