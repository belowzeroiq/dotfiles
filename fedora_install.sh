#!/bin/bash
# Hyprland Installation Script for Fedora Linux (DNF5 Compatible)
# Run this script as your regular user (not root)

set -e

echo "🚀 Starting Hyprland installation for Fedora..."

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

# Detect DNF version
DNF_CMD="dnf"
if command -v dnf5 &> /dev/null; then
    DNF_CMD="dnf5"
    print_status "Detected DNF5, using compatible commands"
elif command -v dnf &> /dev/null; then
    DNF_CMD="dnf"
    print_status "Using traditional DNF"
else
    print_error "Neither dnf nor dnf5 found!"
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
sudo $DNF_CMD upgrade -y

# Enable RPM Fusion repositories
print_status "Enabling RPM Fusion repositories..."
sudo $DNF_CMD install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable COPR repositories for Hyprland
print_status "Enabling COPR repositories..."
sudo $DNF_CMD copr enable -y solopasha/hyprland
sudo $DNF_CMD copr enable -y erikreider/SwayNotificationCenter

# Install development tools - DNF5 compatible way
print_status "Installing development tools..."
if [ "$DNF_CMD" = "dnf5" ]; then
    # For DNF5, install group management plugin and individual packages
    sudo $DNF_CMD install -y dnf5-plugins
    # Install individual development packages instead of groups
    sudo $DNF_CMD install -y \
        gcc \
        gcc-c++ \
        make \
        autoconf \
        automake \
        libtool \
        flex \
        bison \
        kernel-devel \
        kernel-headers \
        glibc-devel \
        git \
        cmake \
        meson \
        ninja-build \
        pkgconfig \
        wayland-devel \
        wayland-protocols-devel \
        libdrm-devel \
        libxkbcommon-devel \
        libinput-devel \
        pixman-devel \
        cairo-devel \
        pango-devel
else
    # Traditional DNF with group install
    sudo $DNF_CMD groupinstall -y "Development Tools" "C Development Tools and Libraries"
    sudo $DNF_CMD install -y \
        git \
        cmake \
        meson \
        ninja-build \
        pkgconfig \
        gcc-c++ \
        wayland-devel \
        wayland-protocols-devel \
        libdrm-devel \
        libxkbcommon-devel \
        libinput-devel \
        pixman-devel \
        cairo-devel \
        pango-devel
fi

# Install Hyprland and essential packages
print_status "Installing Hyprland and core components..."
sudo $DNF_CMD install -y \
    hyprland \
    hyprlock \
    hypridle \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt5-qtwayland \
    qt6-qtwayland \
    polkit-kde \
    polkit-gnome

# Install additional Wayland utilities
print_status "Installing Wayland utilities..."
sudo $DNF_CMD install -y \
    waybar \
    rofi-wayland \
    dunst \
    grim \
    slurp \
    wl-clipboard \
    swayimg \
    brightnessctl \
    playerctl \
    pavucontrol \
    pipewire \
    pipewire-pulseaudio \
    pipewire-alsa \
    pipewire-jack-audio-connection-kit \
    wireplumber \
    gammastep

# Install terminal and file manager
print_status "Installing terminal and utilities..."
sudo $DNF_CMD install -y \
    kitty \
    thunar \
    thunar-archive-plugin \
    file-roller \
    gtk3 \
    gtk4 \
    nautilus \
    gvfs-mtp \
    gnome-keyring

# Install fonts for aesthetics
print_status "Installing fonts..."
sudo $DNF_CMD install -y \
    fontawesome-fonts \
    fira-code-fonts \
    jetbrains-mono-fonts \
    google-noto-fonts \
    google-noto-emoji-fonts \
    google-noto-cjk-fonts \
    liberation-fonts \
    dejavu-fonts-common

# Install Flatpak for additional applications
print_status "Setting up Flatpak..."
sudo $DNF_CMD install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install additional tools from repositories
print_status "Installing additional utilities..."
sudo $DNF_CMD install -y \
    ImageMagick \
    jq \
    curl \
    wget \
    unzip \
    rsync \
    tree \
    htop \
    neofetch \
    ffmpeg \
    mpv

# Install Go if needed for cliphist
print_status "Installing Go for additional tools..."
sudo $DNF_CMD install -y golang

# Clone and build hyprshot (screenshot tool)
print_status "Installing hyprshot..."
if [ ! -d /tmp/hyprshot ]; then
    git clone https://github.com/Gustash/hyprshot.git /tmp/hyprshot
    cd /tmp/hyprshot
    make install
    cd -
fi

# Clone and build wlogout
print_status "Installing wlogout..."
if [ ! -d /tmp/wlogout ]; then
    git clone https://github.com/ArtsyMacaw/wlogout.git /tmp/wlogout
    cd /tmp/wlogout
    meson build
    ninja -C build
    sudo ninja -C build install
    cd -
fi

# Clone and build swww (wallpaper daemon)
print_status "Installing swww..."
if ! command -v swww &> /dev/null; then
    sudo $DNF_CMD install -y cargo rust
    cargo install swww
    # Add cargo bin to PATH if not already there
    if ! grep -q 'cargo/bin' ~/.bashrc; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    fi
fi

# Install cliphist (clipboard manager)
print_status "Installing cliphist..."
if ! command -v cliphist &> /dev/null; then
    go install github.com/sentriz/cliphist@latest
    # Add go bin to PATH if not already there
    if ! grep -q 'go/bin' ~/.bashrc; then
        echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.bashrc
    fi
fi

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
    
    if [ -f "$SCRIPT_DIR/wallpapers/wallpaper.jpg" ]; then
        cp "$SCRIPT_DIR/wallpapers/wallpaper.jpg" ~/Wallpaper/wallpaper.jpg
    else
        print_warning "No wallpaper found in $SCRIPT_DIR/wallpapers/"
    fi
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
sudo $DNF_CMD install -y papirus-icon-theme 2>/dev/null || print_warning "Could not install Papirus icons"

# Enable services
print_status "Enabling services..."
systemctl --user enable pipewire pipewire-pulse wireplumber

# Set up environment variables for Wayland
print_status "Setting up Wayland environment variables..."
if [ ! -f ~/.config/environment.d/wayland.conf ]; then
    mkdir -p ~/.config/environment.d
    cat > ~/.config/environment.d/wayland.conf << 'EOF'
MOZ_ENABLE_WAYLAND=1
QT_QPA_PLATFORM=wayland
QT_WAYLAND_DISABLE_WINDOWDECORATION=1
GDK_BACKEND=wayland
XDG_CURRENT_DESKTOP=Hyprland
XDG_SESSION_TYPE=wayland
XDG_SESSION_DESKTOP=Hyprland
EOF
fi

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

# Create a desktop entry for Hyprland
print_status "Creating Hyprland desktop entry..."
sudo mkdir -p /usr/share/wayland-sessions
sudo cat > /usr/share/wayland-sessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=A dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF

# Set SELinux context if SELinux is enabled
if command -v getenforce &> /dev/null && [ "$(getenforce)" != "Disabled" ]; then
    print_status "Setting SELinux contexts..."
    sudo setsebool -P use_nfs_home_dirs 1 2>/dev/null || true
fi

print_status "✅ Installation complete!"
echo ""
echo "🎯 Key changes for DNF5 compatibility:"
echo "   - Automatic detection of DNF vs DNF5"
echo "   - Individual package installation instead of group install for DNF5"
echo "   - Uses 'upgrade' instead of 'update' for DNF5"
echo ""
echo "🔄 Please reboot to complete the installation!"
