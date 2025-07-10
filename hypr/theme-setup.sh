#!/bin/bash

# Hyprland Theme Setup Script

echo "🎨 Setting up Hyprland theme..."

# Create Pictures directory and download a sample wallpaper
mkdir -p ~/Pictures
if [ ! -f ~/Pictures/wallpaper.jpg ]; then
    echo "📸 Downloading sample wallpaper..."
    curl -L "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop" -o ~/Pictures/wallpaper.jpg 2>/dev/null || echo "Could not download wallpaper - please add your own to ~/Pictures/wallpaper.jpg"
fi

# Set GTK theme
echo "🎭 Setting GTK theme..."
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

cat > ~/.config/gtk-3.0/settings.ini << 'GTKEOF'
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
GTKEOF

cat > ~/.config/gtk-4.0/settings.ini << 'GTKEOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrains Mono 11
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
GTKEOF

# Install Papirus icon theme
echo "🎯 Installing Papirus icon theme..."
yay -S --noconfirm papirus-icon-theme 2>/dev/null || echo "Could not install Papirus icons"

# Set cursor theme
echo "🖱️ Setting cursor theme..."
mkdir -p ~/.icons/default
cat > ~/.icons/default/index.theme << 'CURSOREOF'
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Adwaita
CURSOREOF

echo "✅ Theme setup complete!"
echo "💡 Tips:"
echo "   - Add your own wallpaper to ~/Pictures/wallpaper.jpg"
echo "   - Run 'nwg-look' to customize GTK themes"
echo "   - Use 'game-mode' alias to disable effects for gaming"
echo "   - Use 'normal-mode' alias to re-enable effects"
