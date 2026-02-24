//
//  AppLifecycle.swift
//  SwiftUIBasic
//
//  App lifecycle, scene phases, and view lifecycle
//

import SwiftUI

// MARK: - Scene Phase

struct ScenePhaseExample: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var phaseLog: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Scene Phase")
                .font(.headline)
            
            HStack(spacing: 16) {
                PhaseIndicator(
                    title: "Active",
                    isActive: scenePhase == .active,
                    color: .green
                )
                PhaseIndicator(
                    title: "Inactive",
                    isActive: scenePhase == .inactive,
                    color: .yellow
                )
                PhaseIndicator(
                    title: "Background",
                    isActive: scenePhase == .background,
                    color: .red
                )
            }
            
            Text("Current: \(phaseDescription)")
                .font(.title3)
                .fontWeight(.semibold)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Phase Log:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(phaseLog.reversed(), id: \.self) { log in
                            Text(log)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(height: 100)
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 8))
            
            Text("Minimize app to see phase changes")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onChange(of: scenePhase) { oldPhase, newPhase in
            let timestamp = Date().formatted(date: .omitted, time: .standard)
            phaseLog.append("\(timestamp): \(phaseString(oldPhase)) → \(phaseString(newPhase))")
        }
    }
    
    private var phaseDescription: String {
        phaseString(scenePhase)
    }
    
    private func phaseString(_ phase: ScenePhase) -> String {
        switch phase {
        case .active: return "Active"
        case .inactive: return "Inactive"
        case .background: return "Background"
        @unknown default: return "Unknown"
        }
    }
}

struct PhaseIndicator: View {
    let title: String
    let isActive: Bool
    let color: Color
    
    var body: some View {
        VStack {
            Circle()
                .fill(isActive ? color : color.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay {
                    if isActive {
                        Circle()
                            .stroke(color, lineWidth: 3)
                            .scaleEffect(1.3)
                    }
                }
            Text(title)
                .font(.caption)
        }
    }
}

// MARK: - View Lifecycle

struct ViewLifecycleExample: View {
    @State private var showDetail = false
    @State private var events: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View Lifecycle")
                .font(.headline)
            
            Button("Toggle Detail View") {
                showDetail.toggle()
            }
            .buttonStyle(.borderedProminent)
            
            if showDetail {
                DetailLifecycleView(events: $events)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Events:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(events.reversed(), id: \.self) { event in
                            Text(event)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(height: 150)
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 8))
            
            Button("Clear Log") {
                events.removeAll()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .animation(.default, value: showDetail)
    }
}

struct DetailLifecycleView: View {
    @Binding var events: [String]
    
    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)
            Text("Detail View")
        }
        .padding()
        .background(.blue.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
        .onAppear {
            logEvent("onAppear")
        }
        .onDisappear {
            logEvent("onDisappear")
        }
    }
    
    private func logEvent(_ event: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        events.append("\(timestamp): \(event)")
    }
}

// MARK: - Task Modifier (Lifecycle version)

struct LifecycleTaskExample: View {
    @State private var data: String = "Loading..."
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Task Modifier")
                .font(.headline)
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                Text(data)
                    .padding()
                    .background(.green.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 8))
            }
            
            Button("Reload") {
                isLoading = true
                data = "Loading..."
            }
            .buttonStyle(.bordered)
            .disabled(isLoading)
            
            Text(".task auto-cancels when view disappears")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .task(id: isLoading) {
            guard isLoading else { return }
            
            try? await Task.sleep(for: .seconds(2))
            
            if !Task.isCancelled {
                data = "Data loaded at \(Date().formatted(date: .omitted, time: .standard))"
                isLoading = false
            }
        }
    }
}

// MARK: - Task with Cancellation (Lifecycle version)

struct LifecycleTaskCancellationExample: View {
    @State private var counter = 0
    @State private var isRunning = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Task Cancellation")
                .font(.headline)
            
            Text("Counter: \(counter)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
            
            HStack(spacing: 16) {
                Button(isRunning ? "Stop" : "Start") {
                    isRunning.toggle()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    counter = 0
                }
                .buttonStyle(.bordered)
                .disabled(isRunning)
            }
            
            Text("Task cancels when isRunning becomes false")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .task(id: isRunning) {
            guard isRunning else { return }
            
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if !Task.isCancelled {
                    counter += 1
                }
            }
        }
    }
}

// MARK: - OnChange Modifier

struct OnChangeExample: View {
    @State private var text = ""
    @State private var characterCount = 0
    @State private var wordCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("onChange Modifier")
                .font(.headline)
            
            TextField("Type something...", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            HStack(spacing: 24) {
                VStack {
                    Text("\(characterCount)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Characters")
                        .font(.caption)
                }
                
                VStack {
                    Text("\(wordCount)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Words")
                        .font(.caption)
                }
            }
        }
        .padding()
        .onChange(of: text) { _, newValue in
            characterCount = newValue.count
            wordCount = newValue.split(separator: " ").count
        }
    }
}

// MARK: - Background Task

struct BackgroundTaskExample: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var lastBackgroundTime: Date?
    @State private var savedData = "No data saved"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Background Task")
                .font(.headline)
            
            Image(systemName: "arrow.down.doc.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text(savedData)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            if let time = lastBackgroundTime {
                Text("Last background: \(time.formatted(date: .omitted, time: .standard))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text("Move app to background to trigger save")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                saveData()
                lastBackgroundTime = Date()
            case .active:
                loadData()
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func saveData() {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        UserDefaults.standard.set("Saved at \(timestamp)", forKey: "backgroundData")
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.string(forKey: "backgroundData") {
            savedData = data
        }
    }
}

// MARK: - Preview

#Preview("Scene Phase") {
    ScenePhaseExample()
}

#Preview("View Lifecycle") {
    ViewLifecycleExample()
}

#Preview("Task Modifier") {
    LifecycleTaskExample()
}

#Preview("Task Cancellation") {
    LifecycleTaskCancellationExample()
}

#Preview("OnChange") {
    OnChangeExample()
}

#Preview("Background Task") {
    BackgroundTaskExample()
}
