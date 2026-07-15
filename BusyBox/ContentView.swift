import SwiftUI

// MARK: - 主内容视图
struct ContentView: View {
    @EnvironmentObject var windowManager: WindowManager
    
    var body: some View {
        HomeView()
    }
}

// MARK: - 首页视图
struct HomeView: View {
    @EnvironmentObject var windowManager: WindowManager
    @State private var hoveredCard: String?
    @State private var showSettings = false
    @State private var showAbout = false
    
    private let columns = [
        GridItem(.fixed(220), spacing: 24),
        GridItem(.fixed(220), spacing: 24),
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            // 标题区
            VStack(spacing: 12) {
                Text("BusyBox")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                
                Text("假装很忙的工具箱")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 60)
            
            // 工具卡片网格
            LazyVGrid(columns: columns, spacing: 24) {
                ToolCard(
                    icon: "terminal.fill",
                    title: "假终端",
                    description: "假装在写代码\n让老板觉得你很忙",
                    tint: .green,
                    isHovered: hoveredCard == "terminal"
                ) {
                    windowManager.openNewTerminal()
                }
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        hoveredCard = hovering ? "terminal" : nil
                    }
                }
                
                ToolCard(
                    icon: "gearshape.fill",
                    title: "设置",
                    description: "自定义终端外观\n调整输出速度等",
                    tint: .blue,
                    isHovered: hoveredCard == "settings"
                ) {
                    showSettings = true
                }
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        hoveredCard = hovering ? "settings" : nil
                    }
                }
                
                ToolCard(
                    icon: "info.circle.fill",
                    title: "关于",
                    description: "项目信息\n开发者: T3Rhetto",
                    tint: .purple,
                    isHovered: hoveredCard == "about"
                ) {
                    showAbout = true
                }
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        hoveredCard = hovering ? "about" : nil
                    }
                }
                
                ToolCard(
                    icon: "hammer.fill",
                    title: "更多工具",
                    description: "更多摸鱼工具\n正在开发中...",
                    tint: .orange,
                    isHovered: hoveredCard == "more"
                ) {
                    // TODO: 后续添加工具列表
                }
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        hoveredCard = hovering ? "more" : nil
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}

// MARK: - 工具卡片（液态玻璃风格）
struct ToolCard: View {
    let icon: String
    let title: String
    let description: String
    let tint: Color
    let isHovered: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // 图标
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(tint.opacity(0.3), lineWidth: 1)
                        }
                        .frame(width: 72, height: 72)
                    
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(tint)
                }
                
                // 标题
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // 描述
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(28)
            .frame(width: 220)
            .background {
                // 液态玻璃卡片背景
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
            }
            .shadow(
                color: .black.opacity(isHovered ? 0.15 : 0.08),
                radius: isHovered ? 20 : 10,
                y: isHovered ? 10 : 5
            )
            .scaleEffect(isHovered ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
        .environmentObject(WindowManager())
        .frame(width: 800, height: 600)
}
