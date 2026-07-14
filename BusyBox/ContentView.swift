import SwiftUI

// MARK: - 主内容视图
struct ContentView: View {
    @EnvironmentObject var windowManager: WindowManager
    
    var body: some View {
        HomeView()
            .background {
                GlassBackground()
            }
    }
}

// MARK: - 首页视图
struct HomeView: View {
    @EnvironmentObject var windowManager: WindowManager
    @State private var hoveredCard: String?
    
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
    }
}

// MARK: - 工具卡片
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
                        .fill(tint.opacity(0.15))
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
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(tint.opacity(isHovered ? 0.5 : 0.1), lineWidth: 1)
            }
            .shadow(
                color: tint.opacity(isHovered ? 0.2 : 0.08),
                radius: isHovered ? 16 : 8,
                y: isHovered ? 8 : 4
            )
            .scaleEffect(isHovered ? 1.04 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 液态玻璃背景
struct GlassBackground: View {
    var body: some View {
        ZStack {
            // 底层：系统毛玻璃效果
            VisualEffectBlur(
                material: .underWindowBackground,
                blendingMode: .behindWindow
            )
            
            // 叠加层：微妙渐变模拟 Tahoe 折射感
            LinearGradient(
                colors: [
                    .blue.opacity(0.03),
                    .purple.opacity(0.02),
                    .cyan.opacity(0.03),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - NSVisualEffectView 包装器
struct VisualEffectBlur: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.wantsLayer = true
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

#Preview {
    ContentView()
        .environmentObject(WindowManager())
        .frame(width: 800, height: 600)
}
