#!/bin/bash
# Linux Installer - MIME 类型安装脚本
# 用法: sudo ./install-mime.sh

set -e

INSTALL_DIR="/usr/local/bin"
DESKTOP_DIR="/usr/share/applications"
MIME_DIR="/usr/share/mime/packages"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== 安装 Linux Installer MIME 类型 ==="

# 复制安装脚本
echo "1. 安装主程序..."
cp "$SCRIPT_DIR/installer.sh" "$INSTALL_DIR/linux-installer"
chmod +x "$INSTALL_DIR/linux-installer"

# 安装桌面文件
echo "2. 安装桌面快捷方式..."
cat > "$DESKTOP_DIR/linux-installer.desktop" << 'EOF'
[Desktop Entry]
Name=Linux Installer
Comment=Ubuntu/Debian 软件安装器
Exec=/usr/local/bin/linux-installer %f
Icon=linux-installer
Terminal=true
Type=Application
MimeType=application/vnd.debian.binary-package;application/x-rpm;application/x-appimage;application/x-flatpak;application/vnd.flatpak.ref;application/x-msdos-executable;
Categories=System;Utility;
EOF

# 安装 MIME 类型
echo "3. 安装 MIME 类型..."
cp "$SCRIPT_DIR/x-appimage.xml" "$MIME_DIR/"

# 更新 MIME 数据库
echo "4. 更新 MIME 数据库..."
update-mime-database /usr/share/mime 2>/dev/null || true
update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true

# 设置默认应用
echo "5. 设置默认打开方式..."
xdg-mime default linux-installer.desktop application/vnd.debian.binary-package 2>/dev/null || true
xdg-mime default linux-installer.desktop application/x-rpm 2>/dev/null || true
xdg-mime default linux-installer.desktop application/x-appimage 2>/dev/null || true
xdg-mime default linux-installer.desktop application/x-flatpak 2>/dev/null || true
xdg-mime default linux-installer.desktop application/vnd.flatpak.ref 2>/dev/null || true

echo ""
echo "=== 安装完成 ==="
echo ""
echo "现在你可以："
echo "  1. 双击 .deb/.rpm/.AppImage 文件，选择 'Linux Installer' 打开"
echo "  2. 或右键 → 打开方式 → Linux Installer"
echo "  3. 终端运行: linux-installer file.deb"
echo ""
