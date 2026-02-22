//
//  FlashzillaBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/14.
//

import SwiftUI

struct FlashzillaBasic: View {
    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency
    
    var body: some View {
        Text("Hello world!")
            .padding()
            .background(accessibilityReduceTransparency ? .black : .black.opacity(0.5))
            .foregroundStyle(.white)
            .clipShape(.capsule)
    }
}

//func withOptionAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
//    if UIAccessibility.isReduceMotionEnabled {
//        return try body()
//    } else {
//        return try withAnimation(animation, body)
//    }
//}
//
//struct FlashzillaBasic: View {
//    @Environment(\.accessibilityReduceMotion) var accessibilityReduceMotion
//    @State private var scale = 1.0
//
//    var body: some View {
//        Button("Hello world!") {
//            withOptionAnimation {
//                scale *= 1.5
//            }
////            if accessibilityReduceMotion {
////                scale *= 1.5
////            } else {
////                withAnimation {
////                    scale *= 1.5
////                }
////            }
//        }
//        .scaleEffect(scale)
//    }
//}

//struct FlashzillaBasic: View {
//    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
//    
//    var body: some View {
//        HStack {
//            if accessibilityDifferentiateWithoutColor {
//                Image(systemName: "checkmark.circle")
//            }
//
//            Text("Success")
//        }
//        .padding()
//        // setting - accessibility - DifferentiateWithoutColor
//        .background(accessibilityDifferentiateWithoutColor ? .black : .green)
//        .foregroundStyle(.white)
//        .clipShape(.capsule)
//    }
//}

//struct FlashzillaBasic: View {
//    @Environment(\.scenePhase) var scenePhase
//    
//    var body: some View {
//        Text("Hello World!")
//            .onChange(of: scenePhase) { oldPhase, newPhase in
//                if newPhase == .active {
//                    print("Active")
//                } else if newPhase == .inactive { // app is runing and visible, but user isn't access it for some reason
//                    print("inactive")
//                } else if newPhase == .background { // app will be terminated in the future
//                    print("background")
//                }
//            }
//    }
//}

//struct FlashzillaBasic: View {
//    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
//    @State private var count = 0
//    
//    var body: some View {
//        Text("Hello World!")
//            .onReceive(timer) { time in
//                if count == 5 {
//                    timer.upstream.connect().cancel()
//                } else {
//                    print("time is now \(time)")
//                }
//
//                count += 1
//            }
//    }
//}

//struct FlashzillaBasic: View {
//    var body: some View {
//        VStack {
//            Text("Hello")
//
//            Spacer()
//                .frame(height: 100)
//
//            Text("World")
//        }
//        .contentShape(.rect) // another way to perform gesture
//        .onTapGesture {
//            print("vstack tapped")
//        }
//    }
//}

//struct FlashzillaBasic: View {
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(.blue)
//                .frame(width: 300, height: 300)
//                .onTapGesture {
//                    print("Rectangle tapped") // TapGesture will transparented
//                }
//
//            Circle()
//                .fill(.red)
//                .frame(width: 300, height: 300)
////                .contentShape(.rect)
//                .onTapGesture {
//                    print("Circle tapped")
//                }
////                .allowsHitTesting(false) // ignored circle
//        }
//    }
//}

//struct FlashzillaBasic: View {
//    @State private var offset = CGSize.zero
//    @State private var isDragging = false
//    
//    var body: some View {
//        let dragGesture = DragGesture()
//            .onChanged { value in
//                offset = value.translation
//            }
//            .onEnded { _ in
//                withAnimation {
//                    offset = .zero
//                    isDragging = false
//                }
//            }
//
//        let pressGesture = LongPressGesture()
//            .onEnded { value in
//                isDragging = true
//            }
//
//        let combined = pressGesture.sequenced(before: dragGesture)
//
//        Circle()
//            .fill(.red)
//            .frame(width: 80, height: 80)
//            .scaleEffect(isDragging ? 1.5 : 1)
//            .offset(offset)
//            .gesture(combined)
//    }
//}

//struct FlashzillaBasic: View {
//    var body: some View {
//        VStack {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                .onTapGesture {
//                    print("text tapped") // always perform children gesture
//                }
//        }
//        .simultaneousGesture( // both parent and children's gesture will be triggered
//            TapGesture()
//                .onEnded {
//                    print("vstack tapped")
//                }
//        )
//        .onTapGesture {
//            print("vstack tapped")
//        }
//        .highPriorityGesture( // want parent perform, must use high priority gesture
//            TapGesture()
//                .onEnded {
//                    print("vstack tapped")
//                }
//        )
//    }
//}

//struct FlashzillaBasic: View {
//    @State private var currentAmount = Angle.zero
//    @State private var finalAmount = Angle.zero
//    
//    var body: some View {
//        Text("Hello")
//            .rotationEffect(currentAmount + finalAmount)
//            .gesture(
//                RotateGesture()
//                    .onChanged { value in
//                        currentAmount = value.rotation
//                    }
//                    .onEnded { value in
//                        finalAmount += currentAmount
//                        currentAmount = .zero
//                    }
//            )
//    }
//}

//struct FlashzillaBasic: View {
//    @State private var currentAmount = 0.0
//    @State private var finalAmount = 1.0
//    
//    var body: some View {
//        Text("Hello")
//            .scaleEffect(finalAmount + currentAmount)
//            .gesture( // zoom in and zoom out
//                MagnifyGesture()
//                    .onChanged { value in
//                        currentAmount = value.magnification - 1
//                    }
//                    .onEnded{ value in
//                        finalAmount += currentAmount
//                        currentAmount = 0
//                    }
//            )
//    }
//}

//struct FlashzillaBasic: View {
//    var body: some View {
//        Text("Hello")
//            .onLongPressGesture(minimumDuration: 2) {
//                print("long pressed!")
//            } onPressingChanged: { inProgress in
//                print("In progress: \(inProgress)")
//            }
//    }
//}

//struct FlashzillaBasic: View {
//    var body: some View {
//        Text("Hello")
//            .onTapGesture(count: 2) {
//                print("double tapped!")
//            }
//    }
//}

#Preview {
    FlashzillaBasic()
}
