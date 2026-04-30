# xfce4 配置

## 文件说明

| 文件 | 用途 |
|------|------|
| `terminalrc` | xfce4-terminal 字体、外观等设置 |
| `accels.scm` | xfce4-terminal 快捷键 |
| `keyboard-shortcuts.xml` | xfwm4 快捷键（X11 会话用） |
| `labwc/rc.xml` | labwc 快捷键配置（Wayland 会话用） |

## 部署

```bash
# terminal 配置
ln -sf ~/dotfiles/xfce4/terminalrc ~/.config/xfce4/terminal/terminalrc
ln -sf ~/dotfiles/xfce4/accels.scm ~/.config/xfce4/terminal/accels.scm

# X11 会话：xfwm4 全局快捷键
ln -sf ~/dotfiles/xfce4/keyboard-shortcuts.xml \
  ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml

# Wayland 会话：labwc 快捷键（窗口管理相关，含工作区切换/全屏等）
ln -sf ~/dotfiles/xfce4/labwc/rc.xml ~/.config/xfce4/labwc/rc.xml
```

## 快捷键

### 全局
| 快捷键 | 功能 |
|--------|------|
| `Super+Return` | 打开终端 |
| `Super+d` | 运行对话框 |
| `Super+r` | 运行对话框（备选） |
| `Super+e` | 文件管理器 |
| `Print` | 截图 |
| `Ctrl+Alt+t` | 打开终端（备选） |

### 窗口管理（参考 i3/sway 习惯）
| 快捷键 | 功能 |
|--------|------|
| `Super+1~9,0` | 切换到工作区 1~10 |
| `Super+Shift+1~9,0` | 移动窗口到工作区 1~10 |
| `Super+f` | 全屏 |
| `Super+Shift+q` | 关闭窗口 |

### xfce4-terminal
| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Shift+C` | 复制 |
| `Ctrl+Shift+V` | 粘贴 |
| `Ctrl++` | 放大字体 |
| `Ctrl+-` | 缩小字体 |
| `Ctrl+0` | 重置字体大小 |
