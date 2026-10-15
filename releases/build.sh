#!/usr/bin/env bash
#
# Đóng gói lại các phiên bản đã phát hành vào releases/<version>/ từ đúng commit trong git.
#
#   releases/build.sh            # đóng gói mọi phiên bản trong releases/versions.tsv
#   releases/build.sh 1.4.9      # chỉ một (hoặc vài) phiên bản
#
# Mỗi thư mục releases/<version>/ gồm:
#   <slug>-<version>[-<variant>].zip      plugin, cài bằng Plugins → Add New Plugin → Upload Plugin
#   README.md                              thông tin phiên bản, lưu ý cài đặt + README gốc của phiên bản
#   CHANGELOG.md                           thay đổi đến phiên bản này
#   SHA256SUMS.txt
#
# Kết quả tái lập được: chạy lại trên cùng commit cho ra ZIP giống hệt (thời gian file = thời gian commit).
# Cần git >= 2.42, python3, sha256sum hoặc shasum.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$ROOT"

fail() { echo "LỖI: $*" >&2; exit 1; }
if command -v sha256sum >/dev/null 2>&1; then SHA256="sha256sum"; else SHA256="shasum -a 256"; fi

ALWAYS_EXCLUDE=(.git .github .gitignore .distignore .gitattributes CONTRIBUTING.md SECURITY.md
    tools docs addons dist tests releases)

excluded() {
    local p
    for p in "${EXCLUDE[@]}"; do
        [[ "$1" == "$p" || "$1" == "$p/"* ]] && return 0
    done
    return 1
}

header_version() {
    git show "$1:$2" 2>/dev/null | sed -n 's/^ \* Version: *//p' | head -1 | tr -d '\r'
}

build_one() {
    local version="$1" variant="$2" commit="$3" date="$4" slug="$5"
    git cat-file -e "$commit^{commit}" 2>/dev/null \
        || fail "Không có commit $commit ($version). Chạy: git fetch origin '+refs/heads/*:refs/remotes/origin/*' --tags"

    local main="$slug.php"
    local got
    got="$(header_version "$commit" "$main")"
    if [[ -z "$got" ]]; then
        # Có thể commit cũ đang nằm trong thư mục con
        got="$(header_version "$commit" "wp-content/plugins/$slug/$main")"
    fi
    [[ "$got" == "$version" ]] || fail "$commit:$main có Version '$got', không phải $version."

    local out="$HERE/$version"
    local suffix=""
    [[ "$variant" != "-" ]] && suffix="-$variant"
    mkdir -p "$out"
    local mtime
    mtime="@$(git log -1 --format=%ct "$commit")"

    # 1. Plugin chính.
    EXCLUDE=("${ALWAYS_EXCLUDE[@]}")
    if git cat-file -e "$commit:.distignore" 2>/dev/null; then
        while IFS= read -r line; do
            line="${line%%#*}"; line="${line%/}"; line="$(echo "$line" | xargs)"
            [[ -n "$line" ]] && EXCLUDE+=("$line")
        done < <(git show "$commit:.distignore")
    fi
    local files=()
    while IFS= read -r f; do
        excluded "$f" || files+=("$f")
    done < <(git ls-tree -r --name-only "$commit")
    local zip="$out/$slug-$version$suffix.zip"
    git --literal-pathspecs archive --format=zip --prefix="$slug/" -o "$zip" "$commit" -- "${files[@]}"
    echo "   $(basename "$zip")  (${#files[@]} file)"

    if [[ "$variant" == "-" ]]; then
        if git cat-file -e "$commit:README.md" 2>/dev/null; then
            git show "$commit:README.md" > "$out/.readme-goc.md"
        elif git cat-file -e "$commit:wp-content/plugins/$slug/README.md" 2>/dev/null; then
            git show "$commit:wp-content/plugins/$slug/README.md" > "$out/.readme-goc.md"
        fi
        python3 "$HERE/render.py" "$version" "$commit" "$date" "$slug" "$out"
        rm -f "$out/.readme-goc.md"
    fi

    (cd "$out" && $SHA256 -- *.zip > SHA256SUMS.txt)
}

WANT=("$@")
found=0
while IFS=$'\t' read -r version variant commit date slug; do
    [[ -z "$version" || "$version" == \#* ]] && continue
    if [[ ${#WANT[@]} -gt 0 ]]; then
        match=0
        for w in "${WANT[@]}"; do [[ "$w" == "$version" ]] && match=1; done
        [[ $match -eq 1 ]] || continue
    fi
    found=1
    label="$version"; [[ "$variant" != "-" ]] && label="$version-$variant"
    echo "== $label ($commit)"
    build_one "$version" "$variant" "$commit" "$date" "$slug"
done < "$HERE/versions.tsv"
[[ $found -eq 1 ]] || fail "Không có phiên bản phù hợp trong releases/versions.tsv."

(cd "$HERE" && find . -mindepth 2 -name '*.zip' | sort -V | sed 's#^\./##' | xargs $SHA256 > SHA256SUMS.txt)
echo "== Xong. Mã kiểm tra: releases/SHA256SUMS.txt"
