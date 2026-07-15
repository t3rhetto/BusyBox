import SwiftUI

@main
struct BusyBoxApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var windowManager = WindowManager()
    @State private var showSettings = false
    @State private var showAbout = false
    
    var body: some Scene {
        // 主窗口
        WindowGroup {
            ContentView()
                .environmentObject(windowManager)
                .frame(minWidth: 800, minHeight: 600)
                .onAppear {
                    // 配置主窗口的液态玻璃效果
                    DispatchQueue.main.async {
                        if let window = NSApplication.shared.windows.first {
                            appDelegate.configureGlassWindow(window)
                        }
                    }
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(isPresented: $showAbout) {
                    AboutView()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Terminal") {
                    windowManager.openNewTerminal()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            
            CommandGroup(after: .appSettings) {
                Button("Settings...") {
                    showSettings = true
                }
                .keyboardShortcut(",", modifiers: .command)
            }
            
            CommandGroup(replacing: .appInfo) {
                Button("About BusyBox") {
                    showAbout = true
                }
            }
        }
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 应用启动完成
    }
    
    /// 配置液态玻璃窗口效果
    func configureGlassWindow(_ window: NSWindow) {
        // 标题栏透明
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
        // 全尺寸内容视图
        window.styleMask.insert(.fullSizeContentView)
        
        // 窗口背景透明
        window.isOpaque = false
        window.backgroundColor = .clear
        
        // 添加液态玻璃效果背景
        if let contentView = window.contentView {
            // 检查是否已经添加过
            if contentView.subviews.first(where: { $0 is GlassVisualEffectView }) == nil {
                let glassView = GlassVisualEffectView(frame: contentView.bounds)
                glassView.autoresizingMask = [.width, .height]
                contentView.addSubview(glassView, positioned: .below, relativeTo: nil)
            }
        }
    }
}

// MARK: - 液态玻璃效果视图
class GlassVisualEffectView: NSView {
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // 创建主毛玻璃效果
        let visualEffect = NSVisualEffectView(frame: bounds)
        visualEffect.autoresizingMask = [.width, .height]
        visualEffect.material = .hudWindow  // 更透明的材质
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.appearance = nil  // 跟随系统外观
        addSubview(visualEffect)
        
        // 添加渐变叠加层模拟液态玻璃折射
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            NSColor.systemBlue.withAlphaComponent(0.03).cgColor,
            NSColor.systemPurple.withAlphaComponent(0.02).cgColor,
            NSColor.systemCyan.withAlphaComponent(0.03).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer = gradientLayer
        wantsLayer = true
    }
    
    override func layout() {
        super.layout()
        subviews.forEach { $0.frame = bounds }
    }
}
