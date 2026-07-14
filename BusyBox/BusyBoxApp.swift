import SwiftUI

@main
struct BusyBoxApp: App {
    @StateObject private var windowManager = WindowManager()
    
    var body: some Scene {
        // 主窗口
        WindowGroup {
            ContentView()
                .environmentObject(windowManager)
                .frame(minWidth: 800, minHeight: 600)
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("新建假终端窗口") {
                    windowManager.openNewTerminal()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}
