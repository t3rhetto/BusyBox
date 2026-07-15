import SwiftUI

// MARK: - 终端状态
@MainActor
class TerminalState: ObservableObject {
    @Published var lines: [TerminalLine] = []
    @Published var isRunning = true
    @Published var thinkingState: ThinkingState = .idle
    
    private var thinkingTimer: Timer?
    private let generator = AICodeGenerator()
    private var generationID = 0
    private let settings = AppSettings.shared
    
    enum ThinkingState: Equatable {
        case idle
        case thinking(dots: Int)
        case done
    }
    
    init() {
        startCycle()
    }
    
    // MARK: - 链式输出循环
    
    private func startCycle() {
        let genID = generationID
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self, self.generationID == genID else { return }
            self.addInitialOutput()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.scheduleNextThinking()
            }
        }
    }
    
    private func scheduleNextThinking() {
        guard isRunning else { return }
        let genID = generationID
        
        let thinkDuration = Double.random(in: 2.0...4.0)
        thinkingState = .thinking(dots: 1)
        
        var dotCount = 1
        thinkingTimer?.invalidate()
        thinkingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self, case .thinking = self.thinkingState else { return }
                dotCount = (dotCount % 3) + 1
                self.thinkingState = .thinking(dots: dotCount)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + thinkDuration) { [weak self] in
            guard let self = self, self.generationID == genID else { return }
            self.thinkingTimer?.invalidate()
            self.thinkingTimer = nil
            self.thinkingState = .done
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                guard let self = self, self.generationID == genID else { return }
                self.thinkingState = .idle
                self.addNewOutput { [weak self] in
                    let delay = self?.settings.outputSpeed ?? 2.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self?.scheduleNextThinking()
                    }
                }
            }
        }
    }
    
    // MARK: - 输出方法
    
    private func addInitialOutput() {
        let initialLines = [
            TerminalLine(text: "", color: .white, kind: .spacer),
            TerminalLine(text: "  Connected to claude-sonnet-4-20250514", color: .gray, kind: .toolResult),
            TerminalLine(text: "  Project: ~/projects/awesome-app", color: .gray, kind: .toolResult),
            TerminalLine(text: "  5 files modified · 0 errors", color: .gray, kind: .toolResult),
            TerminalLine(text: "", color: .white, kind: .spacer),
            TerminalLine(text: "  ──────────────────────────────────────────────────", color: Color(white: 0.25), kind: .separator),
            TerminalLine(text: "", color: .white, kind: .spacer),
        ]
        lines.append(contentsOf: initialLines)
    }
    
    private func addNewOutput(completion: @escaping () -> Void) {
        let output = generator.generateNextOutput()
        let genID = generationID
        
        let separator = TerminalLine(
            text: "  ──────────────────────────────────────────────────",
            color: Color(white: 0.25), kind: .separator
        )
        var allLines = [separator, TerminalLine(text: "", color: .white, kind: .spacer)]
        allLines.append(contentsOf: output)
        allLines.append(TerminalLine(text: "", color: .white, kind: .spacer))
        
        let batchSize = 5
        let batches = stride(from: 0, to: allLines.count, by: batchSize).map { start in
            Array(allLines[start..<min(start + batchSize, allLines.count)])
        }
        
        for (index, batch) in batches.enumerated() {
            let delay = Double(index) * 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self, self.generationID == genID else { return }
                self.lines.append(contentsOf: batch)
                
                let maxLines = self.settings.maxLines
                if self.lines.count > maxLines {
                    self.lines.removeFirst(100)
                }
                
                if index == batches.count - 1 {
                    completion()
                }
            }
        }
    }
    
    // MARK: - 控制方法
    
    func stop() {
        isRunning = false
        generationID += 1
        thinkingTimer?.invalidate()
        thinkingTimer = nil
        thinkingState = .idle
    }
    
    func resume() {
        isRunning = true
        scheduleNextThinking()
    }
    
    func clear() {
        generationID += 1
        lines.removeAll()
        thinkingTimer?.invalidate()
        thinkingTimer = nil
        thinkingState = .idle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.scheduleNextThinking()
        }
    }
}

// MARK: - 假终端视图
struct FakeTerminalView: View {
    @ObservedObject var state: TerminalState
    @StateObject private var settings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 1) {
                        ForEach(state.lines) { line in
                            TerminalLineView(line: line, fontSize: settings.fontSize)
                                .id(line.id)
                        }
                        
                        if settings.showThinkingAnimation {
                            if case .thinking(let dots) = state.thinkingState {
                                ThinkingLineView(dots: dots, fontSize: settings.fontSize)
                                    .id("thinking")
                            } else if state.thinkingState == .done {
                                ThoughtDoneView(fontSize: settings.fontSize)
                                    .id("thought-done")
                            }
                        }
                        
                        Color.clear
                            .frame(height: 1)
                            .id("bottom-anchor")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: state.lines.count) { _, _ in
                    if settings.autoScroll {
                        proxy.scrollTo("bottom-anchor", anchor: .bottom)
                    }
                }
                .onChange(of: state.thinkingState) { _, _ in
                    if settings.autoScroll {
                        proxy.scrollTo("bottom-anchor", anchor: .bottom)
                    }
                }
            }
            
            if settings.showStatusBar {
                Rectangle()
                    .fill(Color(white: 0.2))
                    .frame(height: 1)
                
                FakeInputBox()
            }
        }
        .safeAreaPadding(.top, 28)
        .background(settings.terminalTheme.backgroundColor)
    }
}

// MARK: - Thinking 动画行
struct ThinkingLineView: View {
    let dots: Int
    let fontSize: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            Text("  ")
            Image(systemName: "brain.head.profile")
                .font(.system(size: fontSize - 1))
                .foregroundStyle(Color(red: 0.6, green: 0.5, blue: 1.0))
                .symbolEffect(.pulse, options: .repeating)
            
            Text(" Thinking" + String(repeating: ".", count: dots))
                .font(.system(size: fontSize, design: .monospaced))
                .foregroundStyle(Color(red: 0.6, green: 0.5, blue: 1.0))
        }
    }
}

// MARK: - Thought 完成行
struct ThoughtDoneView: View {
    let fontSize: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            Text("  ")
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: fontSize - 1))
                .foregroundStyle(.green)
            
            Text(" Thought for a moment")
                .font(.system(size: fontSize, design: .monospaced))
                .foregroundStyle(.green.opacity(0.8))
        }
    }
}

// MARK: - 终端行视图
struct TerminalLineView: View {
    let line: TerminalLine
    let fontSize: CGFloat
    
    var body: some View {
        Text(line.text)
            .font(.system(size: fontSize, design: .monospaced))
            .foregroundStyle(line.color)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - 底部假输入框
struct FakeInputBox: View {
    @State private var cursorVisible = true
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 12))
                .foregroundStyle(Color(red: 0.4, green: 0.8, blue: 1.0))
            
            Rectangle()
                .fill(Color(red: 0.4, green: 0.8, blue: 1.0))
                .frame(width: 2, height: 16)
                .opacity(cursorVisible ? 1 : 0)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                        cursorVisible.toggle()
                    }
                }
            
            Spacer()
            
            HStack(spacing: 12) {
                shortcutHint("esc", "interrupt")
                shortcutHint("enter", "send")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(white: 0.12))
        .focusable()
        .focused($isFocused)
        .onAppear {
            isFocused = true
        }
    }
    
    @ViewBuilder
    private func shortcutHint(_ key: String, _ action: String) -> some View {
        HStack(spacing: 4) {
            Text(key)
                .font(.system(size: 10, design: .monospaced))
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(Color(white: 0.2))
                .cornerRadius(3)
                .foregroundStyle(.white.opacity(0.5))
            
            Text(action)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.25))
        }
    }
}

#Preview {
    FakeTerminalView(state: TerminalState())
        .frame(width: 800, height: 600)
}
