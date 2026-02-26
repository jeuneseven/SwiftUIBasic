//
//  AccessibilityExamples.swift
//  SwiftUIBasic
//
//  Accessibility features in SwiftUI
//

import SwiftUI

// MARK: - Accessibility Labels

struct AccessibilityLabelsExample: View {
    @State private var isFavorite = false
    @State private var rating = 3
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Accessibility Labels")
                .font(.headline)
            
            // Basic label
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)
                .accessibilityLabel("Favorite star")
            
            // Button with label
            Button {
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.largeTitle)
                    .foregroundStyle(isFavorite ? .red : .gray)
            }
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            
            // Rating with combined label
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundStyle(index <= rating ? .yellow : .gray)
                        .onTapGesture {
                            rating = index
                        }
                }
            }
            .font(.title)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Rating")
            .accessibilityValue("\(rating) out of 5 stars")
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    if rating < 5 { rating += 1 }
                case .decrement:
                    if rating > 1 { rating -= 1 }
                @unknown default:
                    break
                }
            }
            
            Text("VoiceOver reads these with proper context")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Accessibility Hints

struct AccessibilityHintsExample: View {
    @State private var isSubscribed = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Accessibility Hints")
                .font(.headline)
            
            Button {
                isSubscribed.toggle()
            } label: {
                Label(
                    isSubscribed ? "Subscribed" : "Subscribe",
                    systemImage: isSubscribed ? "bell.fill" : "bell"
                )
                .font(.title3)
            }
            .buttonStyle(.borderedProminent)
            .tint(isSubscribed ? .green : .blue)
            .accessibilityHint(isSubscribed ? "Double tap to unsubscribe from notifications" : "Double tap to subscribe to notifications")
            
            Image(systemName: "info.circle")
                .font(.largeTitle)
                .foregroundStyle(.blue)
                .accessibilityLabel("Information")
                .accessibilityHint("Double tap to view more details")
            
            Text("Hints provide additional context")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Accessibility Traits

struct AccessibilityTraitsExample: View {
    @State private var isSelected = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Accessibility Traits")
                .font(.headline)
            
            // Header trait
            Text("Section Title")
                .font(.title2)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            
            // Button trait (automatically added to Button)
            Text("Tap me")
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 8))
                .accessibilityAddTraits(.isButton)
                .onTapGesture { }
            
            // Selected trait
            HStack(spacing: 16) {
                ForEach(["A", "B", "C"], id: \.self) { letter in
                    Text(letter)
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .background(isSelected && letter == "B" ? .blue : .gray.opacity(0.2))
                        .foregroundStyle(isSelected && letter == "B" ? .white : .primary)
                        .clipShape(.rect(cornerRadius: 8))
                        .accessibilityAddTraits(isSelected && letter == "B" ? .isSelected : [])
                        .onTapGesture {
                            isSelected = (letter == "B")
                        }
                }
            }
            
            // Image trait
            Image(systemName: "photo")
                .font(.largeTitle)
                .accessibilityAddTraits(.isImage)
                .accessibilityLabel("Sample photo")
            
            Text("Traits describe element behavior")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Grouping Elements

struct AccessibilityGroupingExample: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Grouping Elements")
                .font(.headline)
            
            // Card that should be read as one element
            VStack(alignment: .leading, spacing: 8) {
                Text("John Doe")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Software Engineer")
                    .foregroundStyle(.secondary)
                
                Text("San Francisco, CA")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            .accessibilityElement(children: .combine)
            
            // Card with ignored children and custom label
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading) {
                    Text("Jane Smith")
                        .fontWeight(.semibold)
                    Text("Designer")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Jane Smith, Designer")
            .accessibilityHint("Double tap to view profile")
            .accessibilityAddTraits(.isButton)
            
            Text("Combine or ignore children for cleaner VoiceOver")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Accessibility Actions

struct AccessibilityActionsExample: View {
    @State private var messages = ["Hello!", "How are you?", "SwiftUI is great"]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Accessibility Actions")
                .font(.headline)
            
            ForEach(messages, id: \.self) { message in
                HStack {
                    Text(message)
                    Spacer()
                }
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
                .accessibilityElement(children: .combine)
                .accessibilityAction(named: "Delete") {
                    if let index = messages.firstIndex(of: message) {
                        messages.remove(at: index)
                    }
                }
                .accessibilityAction(named: "Reply") {
                    print("Reply to: \(message)")
                }
                .accessibilityAction(named: "Forward") {
                    print("Forward: \(message)")
                }
            }
            
            Text("Custom actions available via VoiceOver rotor")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Dynamic Type Support

struct DynamicTypeExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Dynamic Type Support")
                .font(.headline)
            
            // Scales with Dynamic Type
            Text("This text scales automatically")
                .font(.body)
            
            // Fixed size (doesn't scale)
            Text("This text has fixed size")
                .font(.system(size: 16, weight: .regular))
            
            // Scaled metric for custom values
            ScaledMetricExample()
            
            // Minimum scale factor
            Text("This is a very long text that will scale down if needed to fit on one line")
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal)
            
            Text("Test with Settings > Accessibility > Display & Text Size")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct ScaledMetricExample: View {
    @ScaledMetric(relativeTo: .body) private var iconSize = 24
    @ScaledMetric(relativeTo: .body) private var spacing = 8
    
    var body: some View {
        HStack(spacing: spacing) {
            Image(systemName: "star.fill")
                .font(.system(size: iconSize))
                .foregroundStyle(.yellow)
            
            Text("Scaled icon and spacing")
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(.rect(cornerRadius: 8))
    }
}

// MARK: - Reduce Motion

struct ReduceMotionExample: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Reduce Motion")
                .font(.headline)
            
            Circle()
                .fill(.blue.gradient)
                .frame(width: 100, height: 100)
                .offset(y: isAnimating ? -50 : 50)
                .animation(
                    reduceMotion ? .none : .easeInOut(duration: 1).repeatForever(),
                    value: isAnimating
                )
            
            Text("Reduce Motion: \(reduceMotion ? "ON" : "OFF")")
                .font(.caption)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            Button("Toggle Animation") {
                isAnimating.toggle()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Settings > Accessibility > Motion > Reduce Motion")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Reduce Transparency

struct ReduceTransparencyExample: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Reduce Transparency")
                .font(.headline)
            
            ZStack {
                Image(systemName: "photo.artframe")
                    .font(.system(size: 100))
                    .foregroundStyle(.blue)
                
                Text("Overlay Text")
                    .font(.title)
                    .padding()
                    .background(reduceTransparency ? .white : .white.opacity(0.8))
                    .clipShape(.rect(cornerRadius: 8))
            }
            
            Text("Reduce Transparency: \(reduceTransparency ? "ON" : "OFF")")
                .font(.caption)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            Text("Settings > Accessibility > Display > Reduce Transparency")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Color Contrast

struct ColorContrastExample: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Differentiate Without Color")
                .font(.headline)
            
            HStack(spacing: 16) {
                // Status indicators
                StatusIndicator(status: .success, differentiateWithoutColor: differentiateWithoutColor)
                StatusIndicator(status: .warning, differentiateWithoutColor: differentiateWithoutColor)
                StatusIndicator(status: .error, differentiateWithoutColor: differentiateWithoutColor)
            }
            
            Text("Differentiate Without Color: \(differentiateWithoutColor ? "ON" : "OFF")")
                .font(.caption)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            Text("Settings > Accessibility > Display > Differentiate Without Color")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct StatusIndicator: View {
    enum Status {
        case success, warning, error
        
        var color: Color {
            switch self {
            case .success: return .green
            case .warning: return .yellow
            case .error: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark"
            case .warning: return "exclamationmark"
            case .error: return "xmark"
            }
        }
        
        var label: String {
            switch self {
            case .success: return "Success"
            case .warning: return "Warning"
            case .error: return "Error"
            }
        }
    }
    
    let status: Status
    let differentiateWithoutColor: Bool
    
    var body: some View {
        VStack {
            Circle()
                .fill(status.color)
                .frame(width: 40, height: 40)
                .overlay {
                    if differentiateWithoutColor {
                        Image(systemName: status.icon)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                }
            
            Text(status.label)
                .font(.caption)
        }
    }
}

// MARK: - VoiceOver Focus

struct VoiceOverFocusExample: View {
    @AccessibilityFocusState private var isFocused: Bool
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text("VoiceOver Focus")
                .font(.headline)
            
            Text(message.isEmpty ? "No message" : message)
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
                .accessibilityFocused($isFocused)
            
            Button("Show Message") {
                message = "Hello, VoiceOver!"
                isFocused = true
            }
            .buttonStyle(.borderedProminent)
            
            Text("Button moves VoiceOver focus to message")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Accessibility Sorting

struct AccessibilitySortingExample: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Accessibility Sort Priority")
                .font(.headline)
            
            HStack {
                Text("Read Third")
                    .padding()
                    .background(.red.opacity(0.2))
                    .accessibilitySortPriority(1)
                
                Text("Read First")
                    .padding()
                    .background(.green.opacity(0.2))
                    .accessibilitySortPriority(3)
                
                Text("Read Second")
                    .padding()
                    .background(.blue.opacity(0.2))
                    .accessibilitySortPriority(2)
            }
            
            Text("Higher priority = read first by VoiceOver")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("Labels") {
    AccessibilityLabelsExample()
}

#Preview("Hints") {
    AccessibilityHintsExample()
}

#Preview("Traits") {
    AccessibilityTraitsExample()
}

#Preview("Grouping") {
    AccessibilityGroupingExample()
}

#Preview("Actions") {
    AccessibilityActionsExample()
}

#Preview("Dynamic Type") {
    DynamicTypeExample()
}

#Preview("Reduce Motion") {
    ReduceMotionExample()
}

#Preview("Reduce Transparency") {
    ReduceTransparencyExample()
}

#Preview("Color Contrast") {
    ColorContrastExample()
}

#Preview("VoiceOver Focus") {
    VoiceOverFocusExample()
}

#Preview("Sort Priority") {
    AccessibilitySortingExample()
}
