//
//  GeometryReaderExamples.swift
//  SwiftUIBasic
//
//  GeometryReader for reading view sizes and positions
//

import SwiftUI

// MARK: - Basic GeometryReader

struct BasicGeometryReaderExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic GeometryReader")
                .font(.headline)
            
            GeometryReader { geometry in
                VStack {
                    Text("Width: \(Int(geometry.size.width))")
                    Text("Height: \(Int(geometry.size.height))")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blue.opacity(0.2))
            }
            .frame(height: 150)
            .padding(.horizontal)
            
            Text("GeometryReader fills available space")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Proportional Sizing

struct ProportionalSizingExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Proportional Sizing")
                .font(.headline)
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.red)
                        .frame(width: geometry.size.width * 0.3)
                    
                    Rectangle()
                        .fill(.green)
                        .frame(width: geometry.size.width * 0.5)
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: geometry.size.width * 0.2)
                }
            }
            .frame(height: 100)
            .clipShape(.rect(cornerRadius: 12))
            .padding(.horizontal)
            
            HStack {
                Text("30%").foregroundStyle(.red)
                Text("50%").foregroundStyle(.green)
                Text("20%").foregroundStyle(.blue)
            }
            .font(.caption)
        }
        .padding()
    }
}

// MARK: - Responsive Image

struct ResponsiveImageExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Responsive Image")
                .font(.headline)
            
            GeometryReader { geometry in
                Image(systemName: "photo.artframe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(height: 200)
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            .padding(.horizontal)
            
            Text("Image is 80% of container width")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Coordinate Spaces

struct CoordinateSpacesExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Coordinate Spaces")
                .font(.headline)
            
            VStack {
                Text("Outer View")
                    .font(.caption)
                
                HStack {
                    Text("Left")
                        .font(.caption2)
                    
                    GeometryReader { geometry in
                        VStack(spacing: 4) {
                            Text("Local: \(Int(geometry.frame(in: .local).minX)), \(Int(geometry.frame(in: .local).minY))")
                            Text("Global: \(Int(geometry.frame(in: .global).minX)), \(Int(geometry.frame(in: .global).minY))")
                            Text("Named: \(Int(geometry.frame(in: .named("outer")).minX)), \(Int(geometry.frame(in: .named("outer")).minY))")
                        }
                        .font(.caption2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.blue.opacity(0.2))
                    }
                    
                    Text("Right")
                        .font(.caption2)
                }
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
            .coordinateSpace(name: "outer")
            .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - Safe Area Insets

struct SafeAreaInsetsExample: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                Text("Safe Area Insets")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Top: \(Int(geometry.safeAreaInsets.top))")
                    Text("Bottom: \(Int(geometry.safeAreaInsets.bottom))")
                    Text("Leading: \(Int(geometry.safeAreaInsets.leading))")
                    Text("Trailing: \(Int(geometry.safeAreaInsets.trailing))")
                }
                .font(.body.monospaced())
                .padding()
                .background(.blue.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
                
                Spacer()
                
                Text("Safe area values vary by device")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

// MARK: - Scroll View Offset

struct ScrollViewOffsetExample: View {
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Scroll Offset: \(Int(scrollOffset))")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            
            ScrollView {
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).minY
                        )
                }
                .frame(height: 0)
                
                VStack(spacing: 16) {
                    ForEach(0..<20, id: \.self) { index in
                        Text("Row \(index)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 8))
                    }
                }
                .padding()
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Sticky Header Effect

struct StickyHeaderExample: View {
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let minY = geometry.frame(in: .global).minY
                
                Image(systemName: "mountain.2.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: minY > 0 ? 250 + minY : 250
                    )
                    .offset(y: minY > 0 ? -minY : 0)
                    .foregroundStyle(.blue.gradient)
            }
            .frame(height: 250)
            
            VStack(spacing: 16) {
                Text("Sticky Header")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Pull down to see the stretchy header effect")
                    .foregroundStyle(.secondary)
                
                ForEach(0..<10, id: \.self) { index in
                    Text("Content Row \(index)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 8))
                }
            }
            .padding()
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Parallax Effect

struct ParallaxEffectExample: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<5, id: \.self) { index in
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .global).minY
                        
                        ZStack {
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.white.opacity(0.5))
                                .offset(y: -minY * 0.3)
                            
                            Text("Card \(index + 1)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    .frame(height: 200)
                }
            }
            .padding()
        }
    }
}

// MARK: - 3D Rotation Effect

struct Rotation3DEffectExample: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<10, id: \.self) { index in
                    GeometryReader { geometry in
                        let midX = geometry.frame(in: .global).midX
                        let screenWidth = UIScreen.main.bounds.width
                        let rotation = Double((midX - screenWidth / 2) / screenWidth) * 30
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay {
                                Text("Card \(index + 1)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            .rotation3DEffect(
                                .degrees(-rotation),
                                axis: (x: 0, y: 1, z: 0)
                            )
                    }
                    .frame(width: 200, height: 280)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical)
        }
    }
}

// MARK: - Visual Effect (iOS 17+)

struct VisualEffectExample: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<15, id: \.self) { number in
                    Text("Item \(number)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .background(.blue.gradient)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .padding(.horizontal, 8)
                        .frame(width: 180, height: 200)
                        .visualEffect { content, proxy in
                            content
                                .rotation3DEffect(
                                    .degrees(-proxy.frame(in: .global).minX / 8),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .scaleEffect(
                                    max(0.8, 1 - abs(proxy.frame(in: .global).minX) / 1000)
                                )
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, 40)
    }
}

// MARK: - Container Relative Frame

struct ContainerRelativeFrameExample: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Container Relative Frame")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.blue.gradient)
                            .overlay {
                                Text("Card \(index + 1)")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                            }
                            .containerRelativeFrame(.horizontal) { size, _ in
                                size * 0.8
                            }
                            .frame(height: 200)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal)
            
            Text("Each card is 80% of container width")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview("Basic") {
    BasicGeometryReaderExample()
}

#Preview("Proportional Sizing") {
    ProportionalSizingExample()
}

#Preview("Responsive Image") {
    ResponsiveImageExample()
}

#Preview("Coordinate Spaces") {
    CoordinateSpacesExample()
}

#Preview("Safe Area Insets") {
    SafeAreaInsetsExample()
}

#Preview("Scroll Offset") {
    ScrollViewOffsetExample()
}

#Preview("Sticky Header") {
    StickyHeaderExample()
}

#Preview("Parallax Effect") {
    ParallaxEffectExample()
}

#Preview("3D Rotation") {
    Rotation3DEffectExample()
}

#Preview("Visual Effect") {
    VisualEffectExample()
}

#Preview("Container Relative") {
    ContainerRelativeFrameExample()
}
