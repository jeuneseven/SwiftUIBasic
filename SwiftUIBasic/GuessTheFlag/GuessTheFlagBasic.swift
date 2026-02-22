//
//  GuessTheFlagBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/8.
//

import SwiftUI

struct GuessTheFlagBasic: View {
    // use state to control the alert condition
    @State private var showingAlert = false
    
    var body: some View {
        Button("Tap me to show a alert") {
            showingAlert = true
        }
        .alert("Alert title", isPresented: $showingAlert) {
            // systemImage not work here
            Button("Cancel", systemImage: "globe", role: .cancel) {}
            Button("Delete", role: .destructive) {}
        } message: {
            Text("Detail message")
        }
    }
}

//struct GuessTheFlagBasic: View {
//    var body: some View {
//        Button("Tap me", systemImage: "globe") {
//            print("Tap me")
//        }
//
//        Button {
//            print("Tap me")
//        } label: {
//            Label("Tap me", systemImage: "globe")
//        }
//
//        Button {
//            print("Tap me")
//        } label: {
//            Image(systemName: "globe")
//                .font(.largeTitle)
//                .foregroundStyle(.black)
//        }
//
//        Button {
//            print("button tap")
//        } label: {
//            Text("Tap")
//                .padding()
//                .foregroundStyle(.black)
//                .background(.blue)
//        }
//
//        Button("button") {}
//            .buttonStyle(.bordered)
//            .tint(.black)
//        Button("Delete", role: .destructive) {}
//            // Apple recommand
//            .buttonStyle(.borderedProminent)
//        // role: can be read by voice over
//        Button("Delete", role: .destructive) {}
//        Button("button", systemImage: "globe", action: buttonTapAction)
//    }
//    
//    func buttonTapAction() {
//        print("button tapped")
//    }
//}

/*
 In order to achieve gradients:
 1. an array of colors
 2. show size and direction information
 3. the kind of gradients
 */
//struct GuessTheFlagBasic: View {
//    let colors: [Color] = [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.indigo, Color.purple]
//    
//    var body: some View {
//        Text("Content") // another gradient, often used in foregroundStyle and background
//            .frame(width:400, height: 400)
//            .foregroundStyle(.white.gradient)
//            .background(.blue.gradient)
//        
//        AngularGradient(colors: colors, center: .center)
//            .ignoresSafeArea()
//        
//        RadialGradient(colors: colors, center: .center, startRadius: 10, endRadius: 100)
//        
//        LinearGradient(colors: [.black, .white], startPoint: .top, endPoint: .bottom)
//        
//        LinearGradient(stops: [
////            Gradient.Stop(color: .white, location: 0.15),
////            Gradient.Stop(color: .black, location: 0.85),
//            .init(color: .black, location: 0.1),
//            .init(color: .white, location: 0.9)
//        ], startPoint: .top, endPoint: .bottom)
//    }
//}

//struct GuessTheFlagBasic: View {
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
//                Color.red
//                Color.blue
//            }
//
//            Text("Hello") // vibrancy effect
//                .foregroundStyle(.secondary) // semantic colors
//                .padding(50)
//                .background(.ultraThinMaterial)
//        }
//        .ignoresSafeArea()
//    }
//}

//struct GuessTheFlagBasic: View {
//    var body: some View {
//        ZStack { // use shift+command+a to toggle appearance
//            Color.secondary // it is not gray color, it is transparency
//                .frame(width: 200, height: 200)
//            Text("Hello")
//        }
//    }
//}

//struct GuessTheFlagBasic: View {
//    var body: some View {
//        VStack(alignment: .trailing, spacing: 10) {
//            Text("Hello")
//            Text("World!")
//        }
//
//        Spacer() // spacer can fill the space in the gap
//
//        HStack(alignment: .top, spacing: 10) {
//            Text("Hello")
//                .background(.blue)
//            Text("World!")
//                .background(.yellow)
//        }
//        .background(.red)
//
//        Spacer()
//        Spacer()
//
//        ZStack(alignment: .bottom) { // zstack doesn't have space
//            Text("Hello")
//            Text("World!")
//        }
//
//        Spacer()
//
//        HStack(alignment: .center) {
//            VStack(alignment: .leading) {
//                Text("Hello")
//                Text(",")
//                Text("World!")
//            }
//            VStack(alignment: .center) {
//                Text("Hello")
//                Text(",")
//                Text("World!")
//            }
//            VStack(alignment: .trailing) {
//                Text("Hello")
//                Text(",")
//                Text("World!")
//            }
//        }
//    }
//}

#Preview {
    GuessTheFlagBasic()
}
