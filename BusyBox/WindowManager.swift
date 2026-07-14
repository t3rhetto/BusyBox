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
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "AI Coding — busybox \(windowCount)"
        window.contentView = NSHostingView(rootView: contentView)
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        // 标题栏透明，使用全尺寸内容视图让背景延伸到标题栏下方
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.styleMask.insert(.fullSizeContentView)
        window.isOpaque = false
        // 窗口背景设为终端深色，避免红绿灯区域透明
        window.backgroundColor = NSColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 1.0)
        
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
