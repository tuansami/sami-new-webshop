#!/usr/bin/env bash
#
# Đóng gói ZIP cài đặt cho 2 Step Webshop.
#
#   tools/build.sh
#
# Nguồn đóng gói: CHỈ các file đã được git theo dõi (git ls-files), bỏ các mục trong .distignore.
# Nếu file sẽ đóng gói đang có thay đổi chưa commit, script dừng lại. SAMI_ALLOW_DIRTY=1 để vẫn build (chỉ khi thử nghiệm).
#
# Kết quả trong dist/:
#   2-step-webshop-<version>.zip   plugin (không có tools/, docs/, tests/, releases/)
#   SHA256SUMS.txt

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="2-step-webshop"
VERSION="$(sed -n "s/^ \* Version: *//p" "$ROOT/$SLUG.php" | head -1 | tr -d '\r')"
DIST="$ROOT/dist"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

fail() { echo "LỖI: $*" >&2; exit 1; }

for tool in git zip; do
    command -v "$tool" >/dev/null 2>&1 || fail "Thiếu chương trình '$tool'."
done
if command -v sha256sum >/dev/null 2>&1; then SHA256="sha256sum"; else SHA256="shasum -a 256"; fi
[[ -n "$VERSION" ]] || fail "Không đọc được Version trong $SLUG.php."
grep -q "define( 'TSW_VERSION', '$VERSION' );" "$ROOT/$SLUG.php" \
    || fail "TSW_VERSION khác Version ($VERSION) trong $SLUG.php."

echo "== Đóng gói $SLUG $VERSION"
mkdir -p "$DIST" "$WORK/$SLUG"

IGNORE=()
while IFS= read -r line; do
    [[ -n "$line" ]] && IGNORE+=("$line")
done < <(grep -v '^[[:space:]]*$' "$ROOT/.distignore" | sed 's#/$##')
shipped() {
    local pattern
    for pattern in "${IGNORE[@]}"; do
        [[ "$1" == "$pattern" || "$1" == "$pattern/"* ]] && return 1
    done
    return 0
}
cd "$ROOT"
DIRTY=""
while IFS= read -r file; do
    [[ -n "$file" ]] && shipped "$file" && DIRTY="$DIRTY  $file"$'\n'
done < <(git diff --name-only HEAD -- 2>/dev/null || true)
if [[ -n "$DIRTY" ]]; then
    if [[ "${SAMI_ALLOW_DIRTY:-0}" == "1" ]]; then
        printf "CẢNH BÁO: đóng gói cả thay đổi chưa commit (SAMI_ALLOW_DIRTY=1):\n%s" "$DIRTY" >&2
    else
        printf "Các file sẽ đóng gói có thay đổi chưa commit:\n%s" "$DIRTY" >&2
        fail "Commit (hoặc git stash) trước khi build. Chỉ khi thử nghiệm: SAMI_ALLOW_DIRTY=1."
    fi
fi
git ls-files | while IFS= read -r file; do
    shipped "$file" || continue
    [[ -f "$file" ]] || continue
    mkdir -p "$WORK/$SLUG/$(dirname "$file")"
    cp "$file" "$WORK/$SLUG/$file"
done

grep -q "^ \* Plugin Name: 2 Step Webshop" "$WORK/$SLUG/$SLUG.php" || fail "File chính mất phần đầu plugin."

if command -v php >/dev/null 2>&1; then
    echo "   Kiểm tra cú pháp PHP ..."
    while IFS= read -r -d '' file; do
        php -l "$file" >/dev/null || fail "Lỗi cú pháp: $file"
    done < <(find "$WORK/$SLUG" -name '*.php' -print0)
else
    echo "   (Bỏ qua kiểm tra cú pháp PHP vì chưa cài đặt binary php trên môi trường này)"
fi

ZIP="$DIST/$SLUG-$VERSION.zip"
rm -f "$ZIP"
(cd "$WORK" && zip -qrX "$ZIP" "$SLUG")
echo "   -> $ZIP"

(cd "$DIST" && $SHA256 "$(basename "$ZIP")" > SHA256SUMS.txt)
echo "== Xong. Mã kiểm tra: $DIST/SHA256SUMS.txt"

