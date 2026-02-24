//
//  CustomModifiers.swift
//  SwiftUIBasic
//
//  ViewModifier protocol and custom modifier examples
//

import SwiftUI

// MARK: - Basic Custom Modifier

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(TitleStyle())
    }
}

struct TitleStyleExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Using Modifier Directly")
                .modifier(TitleStyle())
            
            Text("Using Extension")
                .titleStyle()
        }
    }
}

// MARK: - Modifier with Parameters

struct RoundedBackground: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat
    var padding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(color)
            .clipShape(.rect(cornerRadius: cornerRadius))
    }
}

extension View {
    func roundedBackground(
        color: Color = .blue,
        cornerRadius: CGFloat = 10,
        padding: CGFloat = 16
    ) -> some View {
        modifier(RoundedBackground(
            color: color,
            cornerRadius: cornerRadius,
            padding: padding
        ))
    }
}

struct RoundedBackgroundExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Default Style")
                .foregroundStyle(.white)
                .roundedBackground()
            
            Text("Custom Color")
                .foregroundStyle(.white)
                .roundedBackground(color: .purple)
            
            Text("Custom Everything")
                .foregroundStyle(.black)
                .roundedBackground(color: .yellow, cornerRadius: 20, padding: 24)
        }
    }
}

// MARK: - Card Modifier

struct CardStyle: ViewModifier {
    var shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.background)
            .clipShape(.rect(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }
}

extension View {
    func cardStyle(shadowRadius: CGFloat = 5) -> some View {
        modifier(CardStyle(shadowRadius: shadowRadius))
    }
}

struct CardStyleExample: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Card Title")
                    .font(.headline)
                Text("This is some card content that demonstrates the card modifier.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("Featured Item")
            }
            .cardStyle(shadowRadius: 10)
        }
        .padding()
    }
}

// MARK: - Watermark Modifier

struct Watermark: ViewModifier {
    var text: String
    var opacity: Double
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black.opacity(opacity))
                .clipShape(.rect(cornerRadius: 4))
                .padding(8)
        }
    }
}

extension View {
    func watermarked(with text: String, opacity: Double = 0.7) -> some View {
        modifier(Watermark(text: text, opacity: opacity))
    }
}

struct WatermarkExample: View {
    var body: some View {
        Image(systemName: "photo.artframe")
            .font(.system(size: 100))
            .frame(width: 300, height: 200)
            .background(.blue.gradient)
            .watermarked(with: "© 2024 MyApp")
    }
}

// MARK: - Conditional Modifier

struct ConditionalModifier: ViewModifier {
    var condition: Bool
    var transform: (Content) -> any View
    
    func body(content: Content) -> some View {
        if condition {
            AnyView(transform(content))
        } else {
            AnyView(content)
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct ConditionalModifierExample: View {
    @State private var isHighlighted = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Conditional Style")
                .padding()
                .if(isHighlighted) { view in
                    view
                        .background(.yellow)
                        .clipShape(.rect(cornerRadius: 8))
                }
            
            Toggle("Highlight", isOn: $isHighlighted)
                .padding(.horizontal)
        }
    }
}

// MARK: - Loading Overlay Modifier

struct LoadingOverlay: ViewModifier {
    var isLoading: Bool
    var message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)
            
            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(1.5)
                    
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(24)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 12))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

extension View {
    func loadingOverlay(isLoading: Bool, message: String = "Loading...") -> some View {
        modifier(LoadingOverlay(isLoading: isLoading, message: message))
    }
}

struct LoadingOverlayExample: View {
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Content Area")
                .font(.title)
            
            Text("This is the main content that will be blurred when loading.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Start Loading") {
                isLoading = true
                
                // Simulate async work
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .loadingOverlay(isLoading: isLoading, message: "Please wait...")
    }
}

// MARK: - Badge Modifier

struct BadgeModifier: ViewModifier {
    var count: Int
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                if count > 0 {
                    Text(count > 99 ? "99+" : "\(count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color)
                        .clipShape(Capsule())
                        .offset(x: 8, y: -8)
                }
            }
    }
}

extension View {
    func badge(count: Int, color: Color = .red) -> some View {
        modifier(BadgeModifier(count: count, color: color))
    }
}

struct BadgeModifierExample: View {
    @State private var notificationCount = 5
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "bell.fill")
                .font(.largeTitle)
                .badge(count: notificationCount)
            
            Image(systemName: "message.fill")
                .font(.largeTitle)
                .badge(count: 123, color: .blue)
            
            Stepper("Count: \(notificationCount)", value: $notificationCount, in: 0...150)
                .padding(.horizontal)
        }
    }
}

// MARK: - Shake Effect Modifier

struct ShakeEffect: ViewModifier {
    var shakes: Int
    
    func body(content: Content) -> some View {
        content
            .offset(x: CGFloat(shakes) * 2)
    }
}

extension View {
    func shake(shakes: Int) -> some View {
        modifier(ShakeEffect(shakes: shakes))
    }
}

struct ShakeEffectExample: View {
    @State private var shakeCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter text", text: .constant(""))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .shake(shakes: shakeCount)
            
            Button("Trigger Shake") {
                withAnimation(.linear(duration: 0.5)) {
                    shakeCount = 6
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    shakeCount = 0
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Title Style") {
    TitleStyleExample()
}

#Preview("Rounded Background") {
    RoundedBackgroundExample()
}

#Preview("Card Style") {
    CardStyleExample()
}

#Preview("Watermark") {
    WatermarkExample()
}

#Preview("Conditional") {
    ConditionalModifierExample()
}

#Preview("Loading Overlay") {
    LoadingOverlayExample()
}

#Preview("Badge") {
    BadgeModifierExample()
}

#Preview("Shake Effect") {
    ShakeEffectExample()
}
