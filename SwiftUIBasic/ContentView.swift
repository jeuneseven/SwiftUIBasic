//
//  ContentView.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/8.
//

import SwiftUI

// MySingleton.shared.doSomething()
final class MySingleton {
    static let shared = MySingleton()
    private init() {}
    
    func doSomething() { }
}

// In SwiftUI, view is a function of our app's state
struct ContentView: View {
    var body: some View {  // can be a specific view e.g Text, but can not a View e.g var body: View, opaque return type
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
