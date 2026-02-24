//
//  Buttons.swift
//  SwiftUIBasic
//
//  Button styles and configurations
//

import SwiftUI

// MARK: - Basic Button Styles

struct BasicButtonExamples: View {
    var body: some View {
        VStack(spacing: 20) {
            // Simple text button
            Button("Tap me") {
                print("Button tapped")
            }
            
            // Button with system image
            Button("Settings", systemImage: "gear") {
                print("Settings tapped")
            }
            
            // Button with custom label
            Button {
                print("Custom label tapped")
            } label: {
                Label("Download", systemImage: "arrow.down.circle")
            }
            
            // Image only button
            Button {
                print("Image button tapped")
            } label: {
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
            }
        }
    }
}

// MARK: - Button Roles

struct ButtonRoleExamples: View {
    var body: some View {
        VStack(spacing: 20) {
            // Destructive role - red color, read by VoiceOver
            Button("Delete", role: .destructive) {
                print("Delete tapped")
            }
            
            // Cancel role
            Button("Cancel", role: .cancel) {
                print("Cancel tapped")
            }
        }
    }
}

// MARK: - Built-in Button Styles

struct BuiltInButtonStyleExamples: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Bordered") {}
                .buttonStyle(.bordered)
            
            Button("Bordered Prominent") {}
                .buttonStyle(.borderedProminent)
            
            Button("Borderless") {}
                .buttonStyle(.borderless)
            
            // Bordered with tint
            Button("Custom Tint") {}
                .buttonStyle(.bordered)
                .tint(.purple)
            
            // Destructive with prominent style
            Button("Delete", role: .destructive) {}
                .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Custom Styled Button

struct CustomStyledButton: View {
    var body: some View {
        Button {
            print("Custom styled button tapped")
        } label: {
            Text("Custom Button")
                .padding()
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(.capsule)
        }
    }
}

// MARK: - Reusable Custom Button Style

struct CapsuleButtonStyle: ButtonStyle {
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == CapsuleButtonStyle {
    static var capsule: CapsuleButtonStyle { CapsuleButtonStyle() }
    
    static func capsule(background: Color, foreground: Color = .white) -> CapsuleButtonStyle {
        CapsuleButtonStyle(backgroundColor: background, foregroundColor: foreground)
    }
}

struct CustomButtonStyleExamples: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Default Capsule") {}
                .buttonStyle(.capsule)
            
            Button("Red Capsule") {}
                .buttonStyle(.capsule(background: .red))
            
            Button("Green Capsule") {}
                .buttonStyle(.capsule(background: .green, foreground: .black))
        }
    }
}

// MARK: - Toggle Button with State

struct ToggleButtonExample: View {
    @State private var isLiked = false
    
    var body: some View {
        Button {
            isLiked.toggle()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.largeTitle)
                .foregroundStyle(isLiked ? .red : .gray)
        }
    }
}

// MARK: - Preview

#Preview("Basic Buttons") {
    BasicButtonExamples()
}

#Preview("Button Roles") {
    ButtonRoleExamples()
}

#Preview("Built-in Styles") {
    BuiltInButtonStyleExamples()
}

#Preview("Custom Styles") {
    CustomButtonStyleExamples()
}

#Preview("Toggle Button") {
    ToggleButtonExample()
}
