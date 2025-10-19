#!/usr/bin/env bash
# sddm-hacker-theme install script
# Installs SDDM Hacker Theme with correct dependencies and configuration

set -e

echo "==> Detecting Linux distribution..."

if [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/void-release ]; then
    DISTRO="void"
elif grep -qi "fedora" /etc/os-release; then
    DISTRO="fedora"
elif grep -qi "opensuse" /etc/os-release; then
    DISTRO="opensuse"
elif grep -qi "debian" /etc/os-release || grep -qi "ubuntu" /etc/os-release; then
    DISTRO="debian"
else
    echo "Unsupported or unrecognized distribution. Please install dependencies manually."
    exit 1
fi

echo "==> Detected distro: $DISTRO"
echo "==> Installing dependencies..."

case "$DISTRO" in
    arch)
        sudo pacman -Sy --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
        ;;
    void)
        sudo xbps-install -Sy sddm qt6-svg qt6-virtualkeyboard qt6-multimedia
        ;;
    fedora)
        sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia
        ;;
    opensuse)
        sudo zypper install -y sddm-qt6 libQt6Svg6 qt6-virtualkeyboard qt6-virtualkeyboard-imports qt6-multimedia qt6-multimedia-imports
        ;;
    debian)
        sudo apt update
        sudo apt install -y sddm libqt6svg6 qt6-virtualkeyboard-plugin libqt6multimedia6 qml6-module-qtquick-controls qml6-module-qtquick-effects libxcb-cursor0
        ;;
esac

echo "==> Cloning theme repository..."
sudo git clone -b master --depth 1 https://github.com/ColonialKreeper/sddm-hacker-theme.git /usr/share/sddm/themes/sddm-hacker-theme

echo "==> Copying fonts..."
sudo mkdir -p /usr/share/fonts
sudo cp -r /usr/share/sddm/themes/sddm-hacker-theme/Fonts/* /usr/share/fonts/ || echo "No fonts directory found."

echo "==> Applying SDDM configuration..."
sudo mkdir -p /etc/sddm.conf.d
echo "[Theme]
Current=sddm-hacker-theme" | sudo tee /etc/sddm.conf >/dev/null

echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null

echo "==> Reloading font cache..."
sudo fc-cache -fv >/dev/null

echo "==> Installation complete!"
echo "Theme installed at: /usr/share/sddm/themes/sddm-hacker-theme"
echo "SDDM is now configured to use the Hacker Theme."
