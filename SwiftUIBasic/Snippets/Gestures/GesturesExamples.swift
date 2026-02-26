//
//  GesturesExamples.swift
//  SwiftUIBasic
//
//  Gesture recognizers in SwiftUI
//

import SwiftUI

// MARK: - Tap Gesture

struct TapGestureExample: View {
    @State private var tapCount = 0
    @State private var doubleTapCount = 0
    @State private var backgroundColor: Color = .blue
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tap Gestures")
                .font(.headline)
            
            // Single tap
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.gradient)
                .frame(width: 150, height: 100)
                .overlay {
                    VStack {
                        Text("Single Tap")
                            .foregroundStyle(.white)
                        Text("\(tapCount)")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .onTapGesture {
                    tapCount += 1
                }
            
            // Double tap
            RoundedRectangle(cornerRadius: 16)
                .fill(.green.gradient)
                .frame(width: 150, height: 100)
                .overlay {
                    VStack {
                        Text("Double Tap")
                            .foregroundStyle(.white)
                        Text("\(doubleTapCount)")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .onTapGesture(count: 2) {
                    doubleTapCount += 1
                }
            
            // Triple tap changes color
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor.gradient)
                .frame(width: 150, height: 100)
                .overlay {
                    Text("Triple Tap")
                        .foregroundStyle(.white)
                }
                .onTapGesture(count: 3) {
                    backgroundColor = Color(
                        hue: Double.random(in: 0...1),
                        saturation: 0.8,
                        brightness: 0.8
                    )
                }
        }
        .padding()
    }
}

// MARK: - Long Press Gesture

struct LongPressGestureExample: View {
    @State private var isPressed = false
    @State private var isComplete = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Long Press Gesture")
                .font(.headline)
            
            Circle()
                .fill(isComplete ? Color.green.gradient : (isPressed ? Color.yellow.gradient : Color.blue.gradient))
                .frame(width: 150, height: 150)
                .overlay {
                    VStack {
                        Image(systemName: isComplete ? "checkmark" : "hand.tap.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        
                        Text(isComplete ? "Done!" : (isPressed ? "Hold..." : "Press & Hold"))
                            .foregroundStyle(.white)
                    }
                }
                .scaleEffect(isPressed ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .onChanged { _ in
                            isPressed = true
                        }
                        .onEnded { _ in
                            isPressed = false
                            isComplete = true
                            
                            // Reset after delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isComplete = false
                            }
                        }
                )
            
            Text("Hold for 1 second")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Drag Gesture

struct DragGestureExample: View {
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Drag Gesture")
                .font(.headline)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .frame(width: 300, height: 300)
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue.gradient)
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
            }
            
            Button("Reset") {
                withAnimation(.spring) {
                    offset = .zero
                    lastOffset = .zero
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

// MARK: - Drag with Snap Back

struct DragSnapBackExample: View {
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Drag with Snap Back")
                .font(.headline)
            
            Circle()
                .fill(.orange.gradient)
                .frame(width: 100, height: 100)
                .overlay {
                    Image(systemName: "hand.draw.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .shadow(radius: isDragging ? 10 : 0)
                .scaleEffect(isDragging ? 1.1 : 1.0)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            offset = value.translation
                        }
                        .onEnded { _ in
                            isDragging = false
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                offset = .zero
                            }
                        }
                )
                .animation(.easeInOut(duration: 0.1), value: isDragging)
            
            Text("Drag and release to snap back")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Magnification Gesture

struct MagnificationGestureExample: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Magnification Gesture")
                .font(.headline)
            
            Image(systemName: "photo.artframe")
                .font(.system(size: 100))
                .foregroundStyle(.blue.gradient)
                .scaleEffect(scale)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            scale = lastScale * value.magnification
                        }
                        .onEnded { _ in
                            lastScale = scale
                        }
                )
            
            Text("Scale: \(scale, specifier: "%.2f")x")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Button("Reset") {
                withAnimation(.spring) {
                    scale = 1.0
                    lastScale = 1.0
                }
            }
            .buttonStyle(.bordered)
            
            Text("Pinch to zoom (use Option + drag in simulator)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Rotation Gesture

struct RotationGestureExample: View {
    @State private var rotation: Angle = .zero
    @State private var lastRotation: Angle = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Rotation Gesture")
                .font(.headline)
            
            Image(systemName: "gear")
                .font(.system(size: 100))
                .foregroundStyle(.purple.gradient)
                .rotationEffect(rotation)
                .gesture(
                    RotateGesture()
                        .onChanged { value in
                            rotation = lastRotation + value.rotation
                        }
                        .onEnded { _ in
                            lastRotation = rotation
                        }
                )
            
            Text("Rotation: \(rotation.degrees, specifier: "%.1f")°")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Button("Reset") {
                withAnimation(.spring) {
                    rotation = .zero
                    lastRotation = .zero
                }
            }
            .buttonStyle(.bordered)
            
            Text("Two-finger rotate (use Option + drag in simulator)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Combined Gestures

struct CombinedGesturesExample: View {
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var lastRotation: Angle = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Combined Gestures")
                .font(.headline)
            
            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow.gradient)
                .scaleEffect(scale)
                .rotationEffect(rotation)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            scale = lastScale * value.magnification
                        }
                        .onEnded { _ in
                            lastScale = scale
                        }
                )
                .gesture(
                    RotateGesture()
                        .onChanged { value in
                            rotation = lastRotation + value.rotation
                        }
                        .onEnded { _ in
                            lastRotation = rotation
                        }
                )
            
            Button("Reset All") {
                withAnimation(.spring) {
                    offset = .zero
                    lastOffset = .zero
                    scale = 1.0
                    lastScale = 1.0
                    rotation = .zero
                    lastRotation = .zero
                }
            }
            .buttonStyle(.borderedProminent)
            
            Text("Drag, pinch, and rotate")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Simultaneous Gestures

struct SimultaneousGesturesExample: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Simultaneous Gestures")
                .font(.headline)
            
            Image(systemName: "square.stack.3d.up.fill")
                .font(.system(size: 100))
                .foregroundStyle(.teal.gradient)
                .scaleEffect(scale)
                .rotationEffect(rotation)
                .gesture(
                    SimultaneousGesture(
                        MagnifyGesture()
                            .onChanged { value in
                                scale = value.magnification
                            }
                            .onEnded { _ in
                                withAnimation(.spring) {
                                    scale = 1.0
                                }
                            },
                        RotateGesture()
                            .onChanged { value in
                                rotation = value.rotation
                            }
                            .onEnded { _ in
                                withAnimation(.spring) {
                                    rotation = .zero
                                }
                            }
                    )
                )
            
            Text("Pinch and rotate at the same time")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Sequenced Gestures

struct SequencedGesturesExample: View {
    @State private var isLongPressed = false
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sequenced Gestures")
                .font(.headline)
            
            Circle()
                .fill(isLongPressed ? Color.green.gradient : Color.red.gradient)
                .frame(width: 100, height: 100)
                .overlay {
                    Image(systemName: isLongPressed ? "lock.open.fill" : "lock.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .offset(offset)
                .gesture(
                    SequenceGesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                isLongPressed = true
                            },
                        DragGesture()
                            .onChanged { value in
                                if isLongPressed {
                                    offset = value.translation
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.spring) {
                                    offset = .zero
                                    isLongPressed = false
                                }
                            }
                    )
                )
            
            Text(isLongPressed ? "Now drag!" : "Long press to unlock, then drag")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Swipe Actions

struct SwipeActionsExample: View {
    @State private var items = ["Email 1", "Email 2", "Email 3", "Email 4", "Email 5"]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Swipe Actions")
                .font(.headline)
                .padding()
            
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = items.firstIndex(of: item) {
                                    items.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                // Archive action
                            } label: {
                                Label("Archive", systemImage: "archivebox")
                            }
                            .tint(.orange)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                // Mark as read
                            } label: {
                                Label("Read", systemImage: "envelope.open")
                            }
                            .tint(.blue)
                            
                            Button {
                                // Flag
                            } label: {
                                Label("Flag", systemImage: "flag")
                            }
                            .tint(.yellow)
                        }
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Gesture State

struct GestureStateExample: View {
    @GestureState private var dragOffset = CGSize.zero
    @GestureState private var isDetectingLongPress = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("@GestureState")
                .font(.headline)
            
            // Drag with GestureState (auto-resets)
            Circle()
                .fill(.blue.gradient)
                .frame(width: 100, height: 100)
                .overlay {
                    Text("Drag")
                        .foregroundStyle(.white)
                }
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                )
            
            // Long press with GestureState
            Circle()
                .fill(isDetectingLongPress ? Color.green.gradient : Color.orange.gradient)
                .frame(width: 100, height: 100)
                .overlay {
                    Text(isDetectingLongPress ? "Pressing" : "Hold")
                        .foregroundStyle(.white)
                }
                .scaleEffect(isDetectingLongPress ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isDetectingLongPress)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .updating($isDetectingLongPress) { currentState, state, _ in
                            state = currentState
                        }
                )
            
            Text("@GestureState auto-resets when gesture ends")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("Tap Gesture") {
    TapGestureExample()
}

#Preview("Long Press") {
    LongPressGestureExample()
}

#Preview("Drag") {
    DragGestureExample()
}

#Preview("Drag Snap Back") {
    DragSnapBackExample()
}

#Preview("Magnification") {
    MagnificationGestureExample()
}

#Preview("Rotation") {
    RotationGestureExample()
}

#Preview("Combined") {
    CombinedGesturesExample()
}

#Preview("Simultaneous") {
    SimultaneousGesturesExample()
}

#Preview("Sequenced") {
    SequencedGesturesExample()
}

#Preview("Swipe Actions") {
    SwipeActionsExample()
}

#Preview("GestureState") {
    GestureStateExample()
}
