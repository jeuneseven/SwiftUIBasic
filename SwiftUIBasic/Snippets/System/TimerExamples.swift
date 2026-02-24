//
//  TimerExamples.swift
//  SwiftUIBasic
//
//  Timer usage in SwiftUI
//

import SwiftUI

// MARK: - Basic Timer with TimelineView

struct BasicTimerExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic Timer")
                .font(.headline)
            
            // TimelineView updates on schedule
            TimelineView(.periodic(from: .now, by: 1.0)) { context in
                Text(context.date.formatted(date: .omitted, time: .standard))
                    .font(.system(size: 48, weight: .light, design: .rounded))
                    .monospacedDigit()
            }
            
            Text("Updates every second using TimelineView")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Countdown Timer

struct CountdownTimerExample: View {
    @State private var timeRemaining = 60
    @State private var isRunning = false
    @State private var timerTask: Task<Void, Never>?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Countdown Timer")
                .font(.headline)
            
            ZStack {
                Circle()
                    .stroke(.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / 60)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: timeRemaining)
                
                Text("\(timeRemaining)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }
            
            HStack(spacing: 16) {
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    stopTimer()
                    timeRemaining = 60
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    private func startTimer() {
        isRunning = true
        timerTask = Task {
            while !Task.isCancelled && timeRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                if !Task.isCancelled && timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
            if timeRemaining == 0 {
                isRunning = false
            }
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }
}

// MARK: - Stopwatch

struct StopwatchExample: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var timerTask: Task<Void, Never>?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Stopwatch")
                .font(.headline)
            
            Text(formatTime(elapsedTime))
                .font(.system(size: 56, weight: .thin, design: .rounded))
                .monospacedDigit()
            
            HStack(spacing: 16) {
                Button(isRunning ? "Stop" : "Start") {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(isRunning ? .red : .green)
                
                Button("Reset") {
                    stopTimer()
                    elapsedTime = 0
                }
                .buttonStyle(.bordered)
                .disabled(isRunning)
            }
        }
        .padding()
    }
    
    private func startTimer() {
        isRunning = true
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(10))
                if !Task.isCancelled {
                    elapsedTime += 0.01
                }
            }
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

// MARK: - Interval Timer

struct IntervalTimerExample: View {
    @State private var workTime = 25
    @State private var breakTime = 5
    @State private var currentTime = 0
    @State private var isWorking = true
    @State private var isRunning = false
    @State private var timerTask: Task<Void, Never>?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Pomodoro Timer")
                .font(.headline)
            
            Text(isWorking ? "Work" : "Break")
                .font(.title2)
                .foregroundStyle(isWorking ? .red : .green)
                .fontWeight(.semibold)
            
            Text(formatMinutesSeconds(currentTime))
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(isWorking ? .red : .green)
            
            HStack(spacing: 16) {
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        stopTimer()
                    } else {
                        if currentTime == 0 {
                            currentTime = workTime * 60
                        }
                        startTimer()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    stopTimer()
                    isWorking = true
                    currentTime = workTime * 60
                }
                .buttonStyle(.bordered)
            }
            
            Divider()
            
            VStack(spacing: 12) {
                Stepper("Work: \(workTime) min", value: $workTime, in: 1...60)
                Stepper("Break: \(breakTime) min", value: $breakTime, in: 1...30)
            }
            .padding(.horizontal)
            .disabled(isRunning)
        }
        .padding()
        .onAppear {
            currentTime = workTime * 60
        }
    }
    
    private func startTimer() {
        isRunning = true
        timerTask = Task {
            while !Task.isCancelled && currentTime > 0 {
                try? await Task.sleep(for: .seconds(1))
                if !Task.isCancelled && currentTime > 0 {
                    currentTime -= 1
                }
            }
            
            if !Task.isCancelled && currentTime == 0 {
                // Switch between work and break
                isWorking.toggle()
                currentTime = (isWorking ? workTime : breakTime) * 60
                // Continue running
                if isRunning {
                    startTimer()
                }
            }
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }
    
    private func formatMinutesSeconds(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Auto-Refresh Data

struct AutoRefreshExample: View {
    @State private var data = "Initial Data"
    @State private var lastUpdate = Date()
    @State private var isAutoRefresh = true
    @State private var refreshTask: Task<Void, Never>?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Auto-Refresh Data")
                .font(.headline)
            
            VStack(spacing: 8) {
                Text(data)
                    .font(.title3)
                
                Text("Last update: \(lastUpdate.formatted(date: .omitted, time: .standard))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            
            Toggle("Auto-refresh every 5 seconds", isOn: $isAutoRefresh)
                .padding(.horizontal)
            
            Button("Refresh Now") {
                refreshData()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onChange(of: isAutoRefresh) { _, newValue in
            if newValue {
                startAutoRefresh()
            } else {
                stopAutoRefresh()
            }
        }
        .onAppear {
            if isAutoRefresh {
                startAutoRefresh()
            }
        }
        .onDisappear {
            stopAutoRefresh()
        }
    }
    
    private func startAutoRefresh() {
        refreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(5))
                if !Task.isCancelled {
                    refreshData()
                }
            }
        }
    }
    
    private func stopAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = nil
    }
    
    private func refreshData() {
        data = "Data #\(Int.random(in: 1000...9999))"
        lastUpdate = Date()
    }
}

// MARK: - Debounce Input

struct DebounceInputExample: View {
    @State private var searchText = ""
    @State private var searchResults: [String] = []
    @State private var isSearching = false
    @State private var searchTask: Task<Void, Never>?
    
    let allItems = ["Apple", "Apricot", "Banana", "Blueberry", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Debounced Search")
                .font(.headline)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search fruits...", text: $searchText)
                
                if isSearching {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal)
            
            List(searchResults, id: \.self) { result in
                Text(result)
            }
            .listStyle(.plain)
            
            Text("Waits 500ms after typing stops before searching")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .onChange(of: searchText) { _, newValue in
            debounceSearch(query: newValue)
        }
    }
    
    private func debounceSearch(query: String) {
        // Cancel previous search
        searchTask?.cancel()
        
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        searchTask = Task {
            // Wait for debounce delay
            try? await Task.sleep(for: .milliseconds(500))
            
            guard !Task.isCancelled else { return }
            
            // Simulate search
            let results = allItems.filter { $0.localizedCaseInsensitiveContains(query) }
            
            searchResults = results
            isSearching = false
        }
    }
}

// MARK: - Animated Progress

struct AnimatedProgressExample: View {
    @State private var progress: Double = 0
    @State private var isRunning = false
    @State private var progressTask: Task<Void, Never>?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Animated Progress")
                .font(.headline)
            
            ZStack {
                Circle()
                    .stroke(.gray.opacity(0.2), lineWidth: 15)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
            }
            .frame(width: 180, height: 180)
            
            HStack(spacing: 16) {
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        stopProgress()
                    } else {
                        startProgress()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    stopProgress()
                    progress = 0
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    private func startProgress() {
        guard progress < 1 else { return }
        
        isRunning = true
        progressTask = Task {
            while !Task.isCancelled && progress < 1 {
                try? await Task.sleep(for: .milliseconds(50))
                if !Task.isCancelled {
                    withAnimation(.linear(duration: 0.05)) {
                        progress = min(progress + 0.01, 1.0)
                    }
                }
            }
            
            if progress >= 1 {
                isRunning = false
            }
        }
    }
    
    private func stopProgress() {
        isRunning = false
        progressTask?.cancel()
        progressTask = nil
    }
}

// MARK: - Preview

#Preview("Basic Timer") {
    BasicTimerExample()
}

#Preview("Countdown") {
    CountdownTimerExample()
}

#Preview("Stopwatch") {
    StopwatchExample()
}

#Preview("Interval Timer") {
    IntervalTimerExample()
}

#Preview("Auto-Refresh") {
    AutoRefreshExample()
}

#Preview("Debounce") {
    DebounceInputExample()
}

#Preview("Animated Progress") {
    AnimatedProgressExample()
}
