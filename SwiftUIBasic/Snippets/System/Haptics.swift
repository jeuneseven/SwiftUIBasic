//
//  Haptics.swift
//  SwiftUIBasic
//
//  Haptic feedback - vibration and tactile responses
//

import SwiftUI
import CoreHaptics

// MARK: - Simple Impact Feedback

struct ImpactFeedbackExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Impact Feedback")
                .font(.headline)
            
            Text("Different impact styles")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
                Button("Light") {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
                
                Button("Medium") {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }
                
                Button("Heavy") {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
                
                Button("Soft") {
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.impactOccurred()
                }
                
                Button("Rigid") {
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

// MARK: - Notification Feedback

struct NotificationFeedbackExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Notification Feedback")
                .font(.headline)
            
            Text("Used for success, warning, error states")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 16) {
                Button {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                } label: {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.green)
                        Text("Success")
                            .font(.caption)
                    }
                }
                
                Button {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                } label: {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.yellow)
                        Text("Warning")
                            .font(.caption)
                    }
                }
                
                Button {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                } label: {
                    VStack {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        Text("Error")
                            .font(.caption)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}

// MARK: - Selection Feedback

struct SelectionFeedbackExample: View {
    @State private var selectedIndex = 0
    let options = ["Option A", "Option B", "Option C", "Option D"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Selection Feedback")
                .font(.headline)
            
            Text("Light tap when selection changes")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                ForEach(0..<options.count, id: \.self) { index in
                    Button {
                        if selectedIndex != index {
                            let generator = UISelectionFeedbackGenerator()
                            generator.selectionChanged()
                            selectedIndex = index
                        }
                    } label: {
                        HStack {
                            Text(options[index])
                            Spacer()
                            if selectedIndex == index {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding()
                        .background(selectedIndex == index ? .blue.opacity(0.1) : .gray.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - SwiftUI SensoryFeedback (iOS 17+)

struct SensoryFeedbackExample: View {
    @State private var counter = 0
    @State private var isSuccess = false
    @State private var hasError = false
    @State private var sliderValue = 0.5
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Sensory Feedback (iOS 17+)")
                .font(.headline)
            
            // Trigger on value change
            VStack {
                Text("Counter: \(counter)")
                    .font(.title2)
                
                Button("Increment") {
                    counter += 1
                }
                .buttonStyle(.borderedProminent)
                .sensoryFeedback(.increase, trigger: counter)
            }
            
            Divider()
            
            // Success feedback
            VStack {
                Button("Toggle Success") {
                    isSuccess.toggle()
                }
                .buttonStyle(.bordered)
                .sensoryFeedback(.success, trigger: isSuccess)
                
                if isSuccess {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.largeTitle)
                }
            }
            
            Divider()
            
            // Error feedback
            VStack {
                Button("Trigger Error") {
                    hasError.toggle()
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .sensoryFeedback(.error, trigger: hasError)
            }
            
            Divider()
            
            // Selection feedback with slider
            VStack {
                Text("Slider: \(sliderValue, specifier: "%.1f")")
                Slider(value: $sliderValue)
                    .sensoryFeedback(.selection, trigger: sliderValue)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - All Sensory Feedback Types

struct AllSensoryFeedbackTypesExample: View {
    @State private var trigger = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("All Feedback Types")
                .font(.headline)
            
            ScrollView {
                VStack(spacing: 12) {
                    FeedbackButton(title: "Success", feedback: .success)
                    FeedbackButton(title: "Warning", feedback: .warning)
                    FeedbackButton(title: "Error", feedback: .error)
                    FeedbackButton(title: "Selection", feedback: .selection)
                    FeedbackButton(title: "Increase", feedback: .increase)
                    FeedbackButton(title: "Decrease", feedback: .decrease)
                    FeedbackButton(title: "Start", feedback: .start)
                    FeedbackButton(title: "Stop", feedback: .stop)
                    FeedbackButton(title: "Alignment", feedback: .alignment)
                    FeedbackButton(title: "Level Change", feedback: .levelChange)
                    FeedbackButton(title: "Impact (Light)", feedback: .impact(weight: .light))
                    FeedbackButton(title: "Impact (Medium)", feedback: .impact(weight: .medium))
                    FeedbackButton(title: "Impact (Heavy)", feedback: .impact(weight: .heavy))
                    FeedbackButton(title: "Impact (Flexible)", feedback: .impact(flexibility: .soft))
                    FeedbackButton(title: "Impact (Rigid)", feedback: .impact(flexibility: .rigid))
                }
                .padding()
            }
        }
    }
}

struct FeedbackButton: View {
    let title: String
    let feedback: SensoryFeedback
    @State private var trigger = false
    
    var body: some View {
        Button {
            trigger.toggle()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .sensoryFeedback(feedback, trigger: trigger)
    }
}

// MARK: - CoreHaptics Custom Pattern

struct CoreHapticsExample: View {
    @State private var engine: CHHapticEngine?
    @State private var supportsHaptics = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("CoreHaptics")
                .font(.headline)
            
            if supportsHaptics {
                VStack(spacing: 12) {
                    Button("Single Tap") {
                        playTap()
                    }
                    
                    Button("Double Tap") {
                        playDoubleTap()
                    }
                    
                    Button("Continuous Buzz") {
                        playContinuous()
                    }
                    
                    Button("Rising Pattern") {
                        playRisingPattern()
                    }
                    
                    Button("Heartbeat") {
                        playHeartbeat()
                    }
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("Haptics not supported on this device")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .onAppear {
            prepareHaptics()
        }
    }
    
    private func prepareHaptics() {
        supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        
        guard supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            
            // Restart engine if it stops
            engine?.stoppedHandler = { reason in
                print("Haptic engine stopped: \(reason)")
            }
            
            engine?.resetHandler = {
                do {
                    try self.engine?.start()
                } catch {
                    print("Failed to restart haptic engine: \(error)")
                }
            }
        } catch {
            print("Failed to create haptic engine: \(error)")
        }
    }
    
    private func playTap() {
        guard supportsHaptics, let engine else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play tap: \(error)")
        }
    }
    
    private func playDoubleTap() {
        guard supportsHaptics, let engine else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        
        let tap1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0
        )
        
        let tap2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0.15
        )
        
        do {
            let pattern = try CHHapticPattern(events: [tap1, tap2], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play double tap: \(error)")
        }
    }
    
    private func playContinuous() {
        guard supportsHaptics, let engine else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensity, sharpness],
            relativeTime: 0,
            duration: 0.5
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play continuous: \(error)")
        }
    }
    
    private func playRisingPattern() {
        guard supportsHaptics, let engine else { return }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0.0, to: 1.0, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: i
            )
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play rising pattern: \(error)")
        }
    }
    
    private func playHeartbeat() {
        guard supportsHaptics, let engine else { return }
        
        let intensity1 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness1 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        
        let intensity2 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness2 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        
        var events = [CHHapticEvent]()
        
        // Two beats pattern repeated
        for i in 0..<3 {
            let offset = Double(i) * 0.6
            
            events.append(CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity1, sharpness1],
                relativeTime: offset
            ))
            
            events.append(CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity2, sharpness2],
                relativeTime: offset + 0.15
            ))
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play heartbeat: \(error)")
        }
    }
}

// MARK: - Haptic Manager

class HapticManager {
    static let shared = HapticManager()
    
    private var engine: CHHapticEngine?
    private let supportsHaptics: Bool
    
    private init() {
        supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        
        if supportsHaptics {
            prepareEngine()
        }
    }
    
    private func prepareEngine() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine failed: \(error)")
        }
    }
    
    // Simple feedback methods
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // Custom pattern
    func playPattern(_ events: [CHHapticEvent]) {
        guard supportsHaptics, let engine else { return }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error)")
        }
    }
}

struct HapticManagerExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Haptic Manager")
                .font(.headline)
            
            VStack(spacing: 12) {
                Button("Impact Light") {
                    HapticManager.shared.impact(.light)
                }
                
                Button("Impact Heavy") {
                    HapticManager.shared.impact(.heavy)
                }
                
                Button("Success") {
                    HapticManager.shared.notification(.success)
                }
                
                Button("Error") {
                    HapticManager.shared.notification(.error)
                }
                
                Button("Selection") {
                    HapticManager.shared.selection()
                }
            }
            .buttonStyle(.bordered)
            
            Text("Singleton pattern for easy access")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("Impact Feedback") {
    ImpactFeedbackExample()
}

#Preview("Notification Feedback") {
    NotificationFeedbackExample()
}

#Preview("Selection Feedback") {
    SelectionFeedbackExample()
}

#Preview("Sensory Feedback") {
    SensoryFeedbackExample()
}

#Preview("All Feedback Types") {
    AllSensoryFeedbackTypesExample()
}

#Preview("CoreHaptics") {
    CoreHapticsExample()
}

#Preview("Haptic Manager") {
    HapticManagerExample()
}
