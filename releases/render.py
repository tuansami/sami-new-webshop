#!/usr/bin/env python3
"""Tạo README.md và CHANGELOG.md cho releases/<version>/. Được gọi từ releases/build.sh.

render.py <version> <commit> <date> <slug> <thư mục ra>

- README.md = thông tin phiên bản + releases/notes/<version>.md + README gốc của commit
  (link tương đối trong README gốc được đổi thành link GitHub tại đúng commit).
- CHANGELOG.md = các mục trong CHANGELOG.md gốc từ phiên bản này trở về trước.
"""
import os
import re
import subprocess
import sys

REPO_URL = "https://github.com/nguyenaclong/SAMI-webshop"


def vkey(v):
    return tuple(int(x) for x in re.findall(r"\d+", v))


def changelog_sections(path):
    text = open(path, encoding="utf-8").read()
    parts = re.split(r"^## \[([^\]]+)\][^\n]*\n", text, flags=re.M)
    sections = {}
    for i in range(1, len(parts), 2):
        version = parts[i]
        body = parts[i + 1].strip()
        body = re.sub(r"^Tải về: .*\n+", "", body, flags=re.M)
        header = re.search(r"^## \[" + re.escape(version) + r"\][^\n]*", text, flags=re.M).group(0)
        sections[version] = (header, body)
    return sections


def rewrite_links(markdown, commit):
    def fix(m):
        label, target = m.group(1), m.group(2)
        if re.match(r"^(https?:|mailto:|#)", target):
            return m.group(0)
        return f"[{label}]({REPO_URL}/blob/{commit}/{target})"

    return re.sub(r"\[([^\]]+)\]\(([^)\s]+)\)", fix, markdown)


def demote_headings(markdown):
    """Hạ một cấp tiêu đề Markdown, bỏ qua khối code."""
    out, fence = [], False
    for line in markdown.splitlines():
        if line.startswith("```"):
            fence = not fence
        elif not fence and line.startswith("#"):
            line = "#" + line
        out.append(line)
    return "\n".join(out)


def main():
    version, commit, date, slug, out = sys.argv[1:6]
    here = os.path.dirname(os.path.abspath(__file__))
    root = os.path.dirname(here)
    try:
        full = subprocess.check_output(["git", "rev-parse", commit], cwd=root, text=True).strip()
    except subprocess.CalledProcessError:
        full = commit
    short = full[:7]

    # CHANGELOG.md tích lũy.
    sections = changelog_sections(os.path.join(root, "CHANGELOG.md"))
    if version not in sections:
        sys.exit(f"CHANGELOG.md chưa có mục [{version}]")
    lines = [f"# Changelog – đến phiên bản {version}", "",
             f"Các thay đổi đến {version}, mới nhất ở trên. "
             f"Bản đầy đủ mới nhất: [CHANGELOG.md]({REPO_URL}/blob/main/CHANGELOG.md).", ""]
    for v in sorted(sections, key=vkey, reverse=True):
        if vkey(v) <= vkey(version):
            header, body = sections[v]
            lines += [header, "", body, ""]
    with open(os.path.join(out, "CHANGELOG.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(lines).rstrip() + "\n")

    # README.md.
    zips = sorted(n for n in os.listdir(out) if n.endswith(".zip"))
    name = "2 Step Webshop"
    rows = []
    for z in zips:
        size = os.path.getsize(os.path.join(out, z))
        what = "Plugin chính"
        if z != f"{slug}-{version}.zip":
            what += " – biến thể " + z[len(f"{slug}-{version}-"):-4]
        rows.append(f"| [`{z}`]({z}) | {what} | {size / 1024:.0f} KB |")

    notes_path = os.path.join(here, "notes", f"{version}.md")
    notes = open(notes_path, encoding="utf-8").read().strip() if os.path.exists(notes_path) else ""
    original = ""
    orig_path = os.path.join(out, ".readme-goc.md")
    if os.path.exists(orig_path):
        original = open(orig_path, encoding="utf-8").read().strip()
        original = demote_headings(original)

    readme = [
        f"# {name} {version}",
        "",
        "| | |",
        "| --- | --- |",
        f"| Phiên bản | `{version}` |",
        f"| Ngày | {date} |",
        f"| Thư mục plugin | `wp-content/plugins/{slug}/` |",
        f"| Commit | [`{short}`]({REPO_URL}/commit/{full}) |",
        f"| Mã nguồn đầy đủ | [Duyệt]({REPO_URL}/tree/{full}) · [Tải ZIP mã nguồn]({REPO_URL}/archive/{full}.zip) |",
        "",
        "## Tải về",
        "",
        "| File | Nội dung | Dung lượng |",
        "| --- | --- | --- |",
        *rows,
        "",
        "Mã kiểm tra SHA-256: [`SHA256SUMS.txt`](SHA256SUMS.txt). Thay đổi: [`CHANGELOG.md`](CHANGELOG.md).",
        "",
        "> ZIP trong thư mục này đúng mã nguồn của commit trên, sẵn sàng cài đặt cho website WordPress & WooCommerce.",
        "",
    ]
    if notes:
        readme += ["## Lưu ý cho phiên bản này", "", notes, ""]
    if original:
        readme += [
            "---",
            "",
            f"# README gốc của phiên bản {version}",
            "",
            "*Nguyên văn `README.md` tại commit trên; link đã trỏ về đúng commit trên GitHub.*",
            "",
            rewrite_links(original, full),
        ]
    with open(os.path.join(out, "README.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(readme).rstrip() + "\n")


if __name__ == "__main__":
    main()

