import SwiftUI

@main
struct BusyBoxApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var windowManager = WindowManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(windowManager)
                .frame(minWidth: 800, minHeight: 600)
                .onAppear {
                    DispatchQueue.main.async {
                        if let window = NSApplication.shared.windows.first {
                            appDelegate.configureWindow(window)
                        }
                    }
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
        }
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {}
    
    func configureWindow(_ window: NSWindow) {
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.styleMask.insert(.fullSizeContentView)
        window.isOpaque = false
        window.backgroundColor = .clear
    }
}
