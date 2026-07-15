import SwiftUI

// MARK: - 设置视图
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var settings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            HStack {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Divider()
            
            // 设置内容
            Form {
                // 终端设置
                Section("Terminal") {
                    // 输出速度
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Output Speed")
                        
                        HStack {
                            Text("Slow")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Slider(value: $settings.outputSpeed, in: 0.1...2.0, step: 0.1)
                            
                            Text("Fast")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text("Current: \(String(format: "%.1f", settings.outputSpeed))s per batch")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    
                    // 字体大小
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Font Size")
                        
                        HStack {
                            Text("10")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Slider(value: $settings.fontSize, in: 10...20, step: 1)
                            
                            Text("20")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text("Current: \(Int(settings.fontSize))pt")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    
                    // 最大行数
                    Picker("Max Lines", selection: $settings.maxLines) {
                        Text("200 lines").tag(200)
                        Text("400 lines").tag(400)
                        Text("600 lines").tag(600)
                        Text("1000 lines").tag(1000)
                    }
                }
                
                // 外观设置
                Section("Appearance") {
                    // 终端主题
                    Picker("Terminal Theme", selection: $settings.terminalTheme) {
                        ForEach(TerminalTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    
                    // 显示思考动画
                    Toggle("Show Thinking Animation", isOn: $settings.showThinkingAnimation)
                    
                    // 显示状态栏
                    Toggle("Show Status Bar", isOn: $settings.showStatusBar)
                }
                
                // 行为设置
                Section("Behavior") {
                    // 自动滚动
                    Toggle("Auto Scroll to Bottom", isOn: $settings.autoScroll)
                    
                    // 启动时自动开始
                    Toggle("Start on Launch", isOn: $settings.startOnLaunch)
                    
                    // 保持窗口在最前
                    Toggle("Keep Window on Top", isOn: $settings.keepOnTop)
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
        }
        .frame(width: 500, height: 550)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

// MARK: - 应用设置
@MainActor
class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    // 终端设置
    @AppStorage("outputSpeed") var outputSpeed: Double = 0.5
    @AppStorage("fontSize") var fontSize: Double = 13
    @AppStorage("maxLines") var maxLines: Int = 600
    
    // 外观设置
    @AppStorage("terminalTheme") var terminalTheme: TerminalTheme = .classic
    @AppStorage("showThinkingAnimation") var showThinkingAnimation: Bool = true
    @AppStorage("showStatusBar") var showStatusBar: Bool = true
    
    // 行为设置
    @AppStorage("autoScroll") var autoScroll: Bool = true
    @AppStorage("startOnLaunch") var startOnLaunch: Bool = false
    @AppStorage("keepOnTop") var keepOnTop: Bool = false
    
    private init() {}
}

// MARK: - 终端主题
enum TerminalTheme: String, CaseIterable {
    case classic
    case monokai
    case dracula
    case solarized
    case nord
    
    var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .monokai: return "Monokai"
        case .dracula: return "Dracula"
        case .solarized: return "Solarized"
        case .nord: return "Nord"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .classic: return Color(red: 0.08, green: 0.08, blue: 0.10)
        case .monokai: return Color(red: 0.15, green: 0.14, blue: 0.12)
        case .dracula: return Color(red: 0.11, green: 0.11, blue: 0.15)
        case .solarized: return Color(red: 0.0, green: 0.17, blue: 0.21)
        case .nord: return Color(red: 0.11, green: 0.13, blue: 0.18)
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .classic: return .white
        case .monokai: return Color(red: 0.97, green: 0.97, blue: 0.93)
        case .dracula: return Color(red: 0.97, green: 0.97, blue: 0.95)
        case .solarized: return Color(red: 0.83, green: 0.87, blue: 0.82)
        case .nord: return Color(red: 0.87, green: 0.89, blue: 0.93)
        }
    }
    
    var accentColor: Color {
        switch self {
        case .classic: return Color(red: 0.4, green: 0.8, blue: 1.0)
        case .monokai: return Color(red: 0.98, green: 0.82, blue: 0.35)
        case .dracula: return Color(red: 0.75, green: 0.56, blue: 1.0)
        case .solarized: return Color(red: 0.52, green: 0.60, blue: 0.0)
        case .nord: return Color(red: 0.54, green: 0.74, blue: 0.91)
        }
    }
}

#Preview {
    SettingsView()
}
