# BusyBox

> 假装很忙的工具箱 - A "Look Busy" Toolbox for macOS
> 
> 让老板觉得你在认真工作的摸鱼神器

[English](#english) | [中文](#中文)

---

## English

### Overview

BusyBox is a macOS native application designed for... well, looking busy. It features a beautiful Liquid Glass UI (macOS Tahoe style) and a fake terminal that continuously outputs AI coding content, making it appear like you're hard at work with Cursor, Copilot, or Claude.

### Features

- 🪟 **Liquid Glass UI**: Native macOS Tahoe glass effect using NSVisualEffectView
- 💻 **Fake Terminal**: Realistic terminal interface with dark background and monospace font
- 🤖 **AI Coding Output**: Continuously generates realistic code output (React, Python, Rust, etc.)
- 🪟 **Multi-Window**: Open multiple terminal windows simultaneously
- ⌨️ **Keyboard Shortcut**: `Cmd + N` to open new terminal window
- 🎨 **macOS Native**: Built with Swift and SwiftUI for the best macOS experience

### Installation

#### Option 1: Download Release

1. Go to [Releases](https://github.com/t3rhetto/BusyBox/releases)
2. Download `BusyBox-macOS-universal.zip`
3. Unzip and drag `BusyBox.app` to your Applications folder
4. Right-click and select "Open" (first time only, due to Gatekeeper)

#### Option 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/t3rhetto/BusyBox.git
cd BusyBox

# Build for your architecture
swift build -c release

# Or build universal binary (Intel + Apple Silicon)
swift build -c release --arch x86_64 --arch arm64

# Run
swift run
```

### Requirements

- macOS 14.0+ (Sonoma)
- Xcode 15.0+ (for building from source)
- Swift 5.9+ (for building from source)

### Usage

1. Launch BusyBox
2. A fake terminal window will appear
3. It will continuously output AI coding content
4. Press `Cmd + N` to open more terminal windows
5. Minimize or resize windows to your liking
6. Look busy! 😎

### Coming Soon

- 📊 Fake progress bars
- 🔔 Fake notifications
- 📝 More "busy" tools
- 🎨 Customizable themes
- 🔧 Plugin system

---

## 中文

### 概述

BusyBox 是一款 macOS 原生应用，专为...嗯，假装很忙而设计。它拥有漂亮的液态玻璃 UI（macOS Tahoe 风格）和一个假终端，可以持续输出 AI 编程内容，让老板以为你在用 Cursor、Copilot 或 Claude 认真写代码。

### 功能特点

- 🪟 **液态玻璃 UI**: 使用 NSVisualEffectView 实现原生 macOS Tahoe 玻璃效果
- 💻 **假终端**: 逼真的终端界面，深色背景 + 等宽字体
- 🤖 **AI 编程输出**: 持续生成逼真的代码输出（React、Python、Rust 等）
- 🪟 **多窗口**: 同时打开多个终端窗口
- ⌨️ **快捷键**: `Cmd + N` 快速打开新终端窗口
- 🎨 **原生体验**: 使用 Swift 和 SwiftUI 构建，最佳 macOS 体验

### 安装方式

#### 方式一：下载发布版本

1. 前往 [Releases](https://github.com/t3rhetto/BusyBox/releases)
2. 下载 `BusyBox-macOS-universal.zip`
3. 解压后将 `BusyBox.app` 拖入应用程序文件夹
4. 首次打开需右键选择"打开"（因 Gatekeeper 限制）

#### 方式二：从源码编译

```bash
# 克隆仓库
git clone https://github.com/t3rhetto/BusyBox.git
cd BusyBox

# 编译当前架构版本
swift build -c release

# 或编译通用二进制版本（Intel + Apple Silicon）
swift build -c release --arch x86_64 --arch arm64

# 运行
swift run
```

### 系统要求

- macOS 14.0+ (Sonoma)
- Xcode 15.0+（从源码编译时）
- Swift 5.9+（从源码编译时）

### 使用方法

1. 启动 BusyBox
2. 假终端窗口会自动出现
3. 它会持续输出 AI 编程内容
4. 按 `Cmd + N` 打开更多终端窗口
5. 最小化或调整窗口大小
6. 假装很忙！😎

### 即将推出

- 📊 假进度条
- 🔔 假通知
- 📝 更多"摸鱼"工具
- 🎨 可自定义主题
- 🔧 插件系统

---

## License / 许可证

MIT License - See [LICENSE](LICENSE) for details

---

## Contributing / 贡献

Contributions are welcome! Please feel free to submit a Pull Request.

欢迎贡献！请随时提交 Pull Request。
