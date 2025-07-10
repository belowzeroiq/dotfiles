# 🌟 My Hyprland Setup

Personal Hyprland configuration for Arch Linux with smooth animations and productivity keybindings.

## 🚀 Installation

```bash
git clone --depth 1 https://github.com/belowzeroiq/dotfiles ~/dotfiles
cd dotfiles
chmod +x install.sh
./install.sh
```

Reboot and select Hyprland from your display manager.

## ⌨️ Keybindings

### Basic
| Key | Action |
|---|---|
| `Super + Return` | Terminal |
| `Super + Q` | Close window |
| `Super + Space` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + L` | Lock screen |

### Apps
| Key | Action |
|---|---|
| `Super + A` | App launcher |
| `Super + B` | Firefox |
| `Super + C` | VS Code |
| `Super + E` | File manager |

### Screenshots
| Key | Action |
|---|---|
| `Print` | Full screen |
| `Shift + Print` | Window |
| `Super + Print` | Region |

### Workspaces
| Key | Action |
|---|---|
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + S` | Special workspace |

### Window Management
| Key | Action |
|---|---|
| `Super + Arrow Keys` | Move focus |
| `Super + R` | Resize mode |
| `Super + Mouse` | Move/resize window |

## 📁 Structure

```
~/.config/hypr/
├── hyprland.conf       # Main config
├── hyprlock.conf       # Lock screen
├── aliases.sh          # Aliases
└── configs/            # Split configs
    ├── keybindings.conf
    ├── animations.conf
    └── ...
```

## 💻 Preview

![20250710_15h00m59s_grim](https://github.com/user-attachments/assets/cf5c42d7-f263-4f7f-b00b-df5dd07bcc82)

## 🎯 Tips

- Add wallpapers to `~/Wallpapers/wallpaper.jpg`
- Reload config: `hypr-reload`

## 📝 Credits

- [Hyprland](https://hyprland.org/)
- [End-4](https://github.com/end-4/dots-hyprland) - Animations
- [ML4W](https://github.com/mylinuxforwork) - Decorations
