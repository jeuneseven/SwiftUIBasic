//
//  Gradients.swift
//  SwiftUIBasic
//
//  Linear, Radial, Angular gradients and gradient modifiers
//

import SwiftUI

// MARK: - Linear Gradient

struct LinearGradientExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Basic linear gradient
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 200, height: 100)
            .clipShape(.rect(cornerRadius: 10))
            
            // Horizontal gradient
            LinearGradient(
                colors: [.red, .orange, .yellow],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 200, height: 100)
            .clipShape(.rect(cornerRadius: 10))
            
            // Diagonal gradient
            LinearGradient(
                colors: [.green, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: 200, height: 100)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

// MARK: - Linear Gradient with Stops

struct LinearGradientStopsExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Custom stops for precise color positions
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .red, location: 0.0),
                    Gradient.Stop(color: .yellow, location: 0.3),
                    Gradient.Stop(color: .green, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 200, height: 150)
            .clipShape(.rect(cornerRadius: 10))
            
            // Shorthand syntax
            LinearGradient(
                stops: [
                    .init(color: .black, location: 0.1),
                    .init(color: .white, location: 0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 200, height: 150)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

// MARK: - Radial Gradient

struct RadialGradientExample: View {
    let rainbowColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .indigo, .purple
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Basic radial gradient
            RadialGradient(
                colors: [.white, .blue],
                center: .center,
                startRadius: 10,
                endRadius: 100
            )
            .frame(width: 200, height: 200)
            .clipShape(.rect(cornerRadius: 10))
            
            // Rainbow radial gradient
            RadialGradient(
                colors: rainbowColors,
                center: .center,
                startRadius: 20,
                endRadius: 150
            )
            .frame(width: 300, height: 300)
            .clipShape(Circle())
            
            // Off-center radial gradient
            RadialGradient(
                colors: [.yellow, .orange, .red],
                center: .topLeading,
                startRadius: 5,
                endRadius: 200
            )
            .frame(width: 200, height: 200)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

// MARK: - Angular Gradient (Conic)

struct AngularGradientExample: View {
    let rainbowColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .indigo, .purple
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Basic angular gradient
            AngularGradient(
                colors: [.red, .blue, .red],
                center: .center
            )
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            
            // Rainbow wheel
            AngularGradient(
                colors: rainbowColors + [.red], // Add red at end for seamless loop
                center: .center
            )
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            
            // With angle range
            AngularGradient(
                colors: [.blue, .purple, .pink],
                center: .center,
                startAngle: .degrees(0),
                endAngle: .degrees(180)
            )
            .frame(width: 200, height: 200)
            .clipShape(Circle())
        }
    }
}

// MARK: - Simple Gradient Modifier

struct SimpleGradientModifierExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // .gradient modifier - subtle gradient effect
            Text("Gradient Text")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.blue.gradient)
            
            Rectangle()
                .fill(.orange.gradient)
                .frame(width: 200, height: 100)
                .clipShape(.rect(cornerRadius: 10))
            
            Circle()
                .fill(.purple.gradient)
                .frame(width: 150, height: 150)
        }
    }
}

// MARK: - Gradient as Background

struct GradientBackgroundExample: View {
    var body: some View {
        ZStack {
            // Full screen gradient background
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Hello World")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Button("Get Started") {
                    print("Button tapped")
                }
                .padding()
                .background(.white)
                .foregroundStyle(.purple)
                .clipShape(.capsule)
            }
        }
    }
}

// MARK: - Gradient with Material

struct GradientWithMaterialExample: View {
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [.red, .blue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Content with Material")
                    .font(.title)
                    .padding()
            }
            .frame(width: 300, height: 200)
            // Material creates a frosted glass effect
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 20))
        }
    }
}

// MARK: - Gradient Button

struct GradientButtonExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Button {
                print("Gradient button tapped")
            } label: {
                Text("Gradient Button")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 50)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(.capsule)
            }
            
            Button {
                print("Border gradient tapped")
            } label: {
                Text("Border Gradient")
                    .fontWeight(.semibold)
                    .foregroundStyle(.purple)
                    .frame(width: 200, height: 50)
                    .background(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 3
                            )
                    )
            }
        }
    }
}

// MARK: - Animated Gradient (Mesh Gradient - iOS 18+)

struct AnimatedGradientExample: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            colors: [
                animateGradient ? .purple : .blue,
                animateGradient ? .blue : .purple
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .frame(width: 300, height: 200)
        .clipShape(.rect(cornerRadius: 20))
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

// MARK: - Preview

#Preview("Linear Gradient") {
    LinearGradientExample()
}

#Preview("Linear with Stops") {
    LinearGradientStopsExample()
}

#Preview("Radial Gradient") {
    ScrollView {
        RadialGradientExample()
    }
}

#Preview("Angular Gradient") {
    ScrollView {
        AngularGradientExample()
    }
}

#Preview("Simple .gradient") {
    SimpleGradientModifierExample()
}

#Preview("Background") {
    GradientBackgroundExample()
}

#Preview("With Material") {
    GradientWithMaterialExample()
}

#Preview("Gradient Button") {
    GradientButtonExample()
}

#Preview("Animated") {
    AnimatedGradientExample()
}
