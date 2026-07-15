import SwiftUI

// MARK: - 关于视图
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            HStack {
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            // 内容
            VStack(spacing: 32) {
                Spacer()
                
                // App Icon
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            }
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "terminal.fill")
                            .font(.system(size: 48, weight: .medium))
                            .foregroundStyle(.green)
                    }
                    
                    VStack(spacing: 4) {
                        Text("BusyBox")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        
                        Text("v1.0.0")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // 简介
                VStack(spacing: 12) {
                    Text("A \"Look Busy\" Toolbox for macOS")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text("Pretend you're hard at work with this fake terminal tool.\nDisplays realistic AI coding output to keep you looking busy.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 40)
                
                Divider()
                    .padding(.horizontal, 60)
                
                // 开发者信息
                VStack(spacing: 16) {
                    Text("Developer")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 8) {
                        Text("T3Rhetto")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Button {
                            if let url = URL(string: "https://github.com/t3rhetto") {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "person.fill")
                                Text("GitHub Profile")
                            }
                            .font(.subheadline)
                        }
                        .buttonStyle(.link)
                    }
                }
                
                // 项目信息
                VStack(spacing: 16) {
                    Text("Project")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 12) {
                        InfoRow(icon: "link", title: "Repository") {
                            Button {
                                if let url = URL(string: "https://github.com/t3rhetto/BusyBox") {
                                    NSWorkspace.shared.open(url)
                                }
                            } label: {
                                Text("github.com/t3rhetto/BusyBox")
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(.link)
                        }
                        
                        InfoRow(icon: "doc.text", title: "License") {
                            Text("MIT License")
                        }
                        
                        InfoRow(icon: "swift", title: "Built with") {
                            Text("Swift & SwiftUI")
                        }
                        
                        InfoRow(icon: "desktopcomputer", title: "Platform") {
                            Text("macOS 14.0+ (Sonoma)")
                        }
                    }
                }
                .padding(.horizontal, 60)
                
                Spacer()
                
                // 版权信息
                VStack(spacing: 4) {
                    Text("© 2024 T3Rhetto. All rights reserved.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    
                    Text("Made with ❤️ for developers who need to look busy")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.bottom, 20)
            }
        }
        .frame(width: 480, height: 620)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

// MARK: - 信息行
struct InfoRow<Content: View>: View {
    let icon: String
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .frame(width: 20)
                    .foregroundStyle(.secondary)
                
                Text(title)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            content()
        }
        .font(.subheadline)
    }
}

#Preview {
    AboutView()
}
