import SwiftUI
import AppKit

// MARK: - 窗口管理器
@MainActor
class WindowManager: ObservableObject {
    @Published var windowCount = 0
    
    private var windows: [NSWindow] = []
    // 保持对 TerminalState 的强引用，防止被提前释放
    private var terminalStates: [UUID: TerminalState] = [:]
    
    func openNewTerminal() {
        windowCount += 1
        
        let terminalState = TerminalState()
        let windowID = UUID()
        let contentView = FakeTerminalView(state: terminalState)
            .frame(minWidth: 700, minHeight: 500)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.title = "AI Coding — busybox \(windowCount)"
        window.contentView = NSHostingView(rootView: contentView)
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        // 配置液态玻璃效果
        configureGlassEffect(for: window)
        
        // 保存 state 强引用
        terminalStates[windowID] = terminalState
        
        // 添加关闭通知
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.removeWindow(window, windowID: windowID)
            }
        }
        
        windows.append(window)
    }
    
    /// 为窗口配置液态玻璃效果
    private func configureGlassEffect(for window: NSWindow) {
        // 标题栏透明
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
        // 窗口背景透明（让毛玻璃效果可见）
        window.isOpaque = false
        window.backgroundColor = .clear
        
        // 添加液态玻璃背景
        if let contentView = window.contentView {
            let glassView = TerminalGlassView(frame: contentView.bounds)
            glassView.autoresizingMask = [.width, .height]
            contentView.addSubview(glassView, positioned: .below, relativeTo: nil)
        }
    }
    
    private func removeWindow(_ window: NSWindow, windowID: UUID) {
        windows.removeAll { $0 === window }
        terminalStates.removeValue(forKey: windowID)
        windowCount -= 1
    }
    
    func closeAllWindows() {
        windows.forEach { $0.close() }
        windows.removeAll()
        terminalStates.removeAll()
        windowCount = 0
    }
}

// MARK: - 终端液态玻璃背景视图
class TerminalGlassView: NSView {
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // 毛玻璃效果（深色主题）
        let visualEffect = NSVisualEffectView(frame: bounds)
        visualEffect.autoresizingMask = [.width, .height]
        visualEffect.material = .hudWindow
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        // 强制深色外观
        visualEffect.appearance = NSAppearance(named: .darkAqua)
        addSubview(visualEffect)
    }
    
    override func layout() {
        super.layout()
        subviews.forEach { $0.frame = bounds }
    }
}
