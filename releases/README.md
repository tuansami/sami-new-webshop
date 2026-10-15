# Các phiên bản phát hành (Releases)

Mỗi thư mục chứa ZIP cài đặt, `README.md` (thông tin, lưu ý cài đặt và README gốc của phiên bản), `CHANGELOG.md` và `SHA256SUMS.txt`.

Tải về: mở thư mục phiên bản trên GitHub → bấm vào file ZIP → **Download raw file**. Cài bằng `Plugins → Add New Plugin → Upload Plugin`.

## Bảng phiên bản

| Phiên bản | Ngày | Tên plugin / thư mục | Điểm chính | Tải về |
| --- | --- | --- | --- | --- |
| **1.4.9** (mới nhất) | 2026-10-14 | SAMI · `2-step-webshop` | Chuẩn hóa Admin UI full-width block layout, sửa checkbox phương thức nhận hàng, full-resolution popup ảnh | [1.4.9](1.4.9/README.md) |
| 1.4.8 | 2026-10-12 | SAMI · `2-step-webshop` | Sửa lỗi "No shipping method", tự ẩn shipping fields khi Local Pickup | [CHANGELOG](../CHANGELOG.md#148--2026-10-12) |
| 1.4.7 | 2026-10-11 | SAMI · `2-step-webshop` | Tùy chọn ảnh và mô tả danh mục dạng cột đứng, tự động khởi tạo trang webshop | [CHANGELOG](../CHANGELOG.md#147--2026-10-11) |
| 1.4.6 | 2026-10-10 | SAMI · `2-step-webshop` | Tùy chọn hiển thị khoảng giá variable, mẫu email HTML EN/DE | [CHANGELOG](../CHANGELOG.md#146--2026-10-10) |
| 1.4.5 | 2026-10-09 | SAMI · `2-step-webshop` | Rà soát 53 tùy chọn Admin UI, sửa lỗi giờ mở cửa qua đêm | [CHANGELOG](../CHANGELOG.md#145--2026-10-09) |

Changelog đầy đủ mọi phiên bản: [CHANGELOG.md](../CHANGELOG.md). Mã kiểm tra mọi ZIP: [SHA256SUMS.txt](SHA256SUMS.txt).

## Cài đặt & Cập nhật

Nên dùng **1.4.9** cho mọi website chạy WooCommerce.

- **Cài đặt mới**: Cài đặt WooCommerce trước, sau đó upload file ZIP `2-step-webshop-1.4.9.zip` và kích hoạt. Plugin sẽ tự động tạo trang `/webshop/` và khởi tạo cài đặt mẫu.
- **Cập nhật**: Tải file ZIP lên qua `Plugins → Add New Plugin → Upload Plugin` và chọn **Thay thế bản hiện tại** (Replace current with uploaded). Cấu hình và dữ liệu đơn hàng được bảo toàn 100%.

## Thêm phiên bản mới

1. Tăng `Version` trong `2-step-webshop.php` và `define( 'TSW_VERSION', 'x.y.z' );`.
2. Thêm mục `## [x.y.z] – YYYY-MM-DD` vào [CHANGELOG.md](../CHANGELOG.md).
3. Thêm một dòng vào [versions.tsv](versions.tsv) (phiên bản, biến thể, commit, ngày, thư mục plugin).
4. Tùy chọn: viết lưu ý vào `notes/x.y.z.md`.
5. Đóng gói bằng `tools/build.sh` (hoặc `releases/build.sh x.y.z`), commit thư mục `releases/`.

