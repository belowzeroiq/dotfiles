#!/bin/bash
# Hyprland Installation Script for Arch Linux
# Run this script as your regular user (not root)

set -e

echo "🚀 Starting Hyprland installation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root. Please run as your regular user."
   exit 1
fi

# Check if config directory exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HYPR_CONFIG_DIR="$SCRIPT_DIR/hypr"
WAYBAR_CONFIG_DIR="$SCRIPT_DIR/waybar"
WOFI_CONFIG_DIR="$SCRIPT_DIR/wofi"
DUNST_CONFIG_DIR="$SCRIPT_DIR/dunst"

if [ ! -d "$HYPR_CONFIG_DIR" ]; then
    print_error "Hyprland config directory not found at $HYPR_CONFIG_DIR"
    print_error "Please run this script from the repository root directory"
    exit 1
fi

# Update system
print_status "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install Hyprland and essential packages
print_status "Installing Hyprland and core components..."
sudo pacman -S --noconfirm \
    hyprland \
    hyprlock \
    hypridle \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent

# Install additional Wayland utilities
print_status "Installing Wayland utilities..."
sudo pacman -S --noconfirm \
    waybar \
    rofi \
    dunst \
    grim \
    slurp \
    wl-clipboard \
    swayimg \
    cliphist \
    brightnessctl \
    playerctl \
    pavucontrol \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    gammastep

# Install terminal and file manager
print_status "Installing terminal and utilities..."
sudo pacman -S --noconfirm \
    kitty \
    thunar \
    thunar-archive-plugin \
    file-roller \
    nwg-look \
    gtk3 \
    gtk4 \
    nautilus \
    nautilus-open-any-terminal \
    gvfs-mtp \
    gnome-keyring

# Install fonts for aesthetics
print_status "Installing fonts..."
sudo pacman -S --noconfirm \
    ttf-font-awesome \
    ttf-fira-code \
    ttf-jetbrains-mono \
    noto-fonts \
    noto-fonts-emoji \
    noto-fonts-cjk \
    ttf-liberation

# Install AUR helper if not present
if ! command -v yay &> /dev/null; then
    print_status "Installing yay AUR helper..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
fi

# Install additional AUR packages
print_status "Installing AUR packages..."
yay -S --noconfirm \
    hyprshot \
    wlogout \
    swww    \
    ttf-cascadia-code \
    ttf-jetbrains-mono-nerd \
    ttf-fira-code-nerd \
    ttf-cascadia-code-nerd \
    rofi-power-menu

# Create necessary directories
print_status "Creating configuration directories..."
mkdir -p ~/.config
mkdir -p ~/Wallpaper

# Copy Hyprland configuration files
print_status "Copying Hyprland configuration files..."
rsync -av --progress "$HYPR_CONFIG_DIR/" ~/.config/hypr/
rsync -av --progress "$WAYBAR_CONFIG_DIR/" ~/.config/waybar/
rsync -av --progress "$WOFI_CONFIG_DIR/" ~/.config/wofi/
rsync -av --progress "$DUNST_CONFIG_DIR/" ~/.config/dunst/

# Make scripts executable
print_status "Making scripts executable..."
chmod +x ~/.config/hypr/*.sh 2>/dev/null || true
find ~/.config/hypr -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
find ~/.config/waybar/scripts -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Create a sample wallpaper if none exists
if [ ! -f ~/Pictures/wallpaper.jpg ] && [ ! -f ~/Wallpaper/wallpaper1.jpg ]; then
    print_status "Creating wallpaper directories and downloading sample wallpaper..."
    mkdir -p ~/Wallpapers
    
    cp $SCRIPT_DIR/wallpapers/wallpaper.jpg ~/Wallpaper/wallpaper.jpg
fi

# Set up GTK theme
print_status "Setting up GTK theme..."
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrains Mono 11
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
EOF

cat > ~/.config/gtk-4.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrains Mono 11
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

# Install Papirus icon theme
print_status "Installing Papirus icon theme..."
yay -S --noconfirm papirus-icon-theme 2>/dev/null || print_warning "Could not install Papirus icons"

# Enable services
print_status "Enabling services..."
systemctl --user enable pipewire pipewire-pulse wireplumber

# Add aliases to bashrc/zshrc
print_status "Adding Hyprland aliases to shell config..."
SHELL_CONFIG=""
if [ -f ~/.zshrc ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f ~/.bashrc ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    echo "" >> "$SHELL_CONFIG"
    echo "# Hyprland aliases" >> "$SHELL_CONFIG"
    echo "source ~/.config/hypr/aliases.sh" >> "$SHELL_CONFIG"
fi

print_status "✅ Installation complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Reboot your system"
echo "   2. Select Hyprland from your display manager"
echo "   3. Add your own wallpapers to ~/Pictures/wallpaper.jpg and ~/Wallpaper/"
echo "   4. Run 'source ~/.config/hypr/aliases.sh' to load aliases"
echo ""
echo "💡 Useful aliases:"
echo "   - ss-full, ss-window, ss-region (screenshots)"
echo "   - game-mode, normal-mode (performance modes)"
echo "   - edit-hypr, edit-waybar, edit-wofi (quick config edits)"
echo ""
echo "🔄 Please reboot to complete the installation!"