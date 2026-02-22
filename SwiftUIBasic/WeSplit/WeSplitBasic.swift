//
//  WeSplitBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/8.
//
// contains the initial user interface (UI) for your program, and is where we’ll be doing all the work in this project.
import SwiftUI

struct WeSplitBasic: View {
    let options = ["A", "B", "C", "D"]
    @State private var selectedOption: String
    var body: some View {
        Form {
            Picker("Select a option", selection: $selectedOption) {
                // id: \.self: SwiftUI needs to be able to identify every view on the screen uniquely, the strings themselves are unique. If the options is ["A", "A" ...] will be have problems
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    init(selectedOption: String) {
        // @State can be init in here
        _selectedOption = State(initialValue: "B")
    }
}

//struct WeSplitBasic: View {
//    var body: some View {
//        Form {
//            ForEach(0..<100) {
//                Text("Row \($0)")
//            }
//        }
//    }
//}

//struct WeSplitBasic: View {
//    @State private var name = ""
//    var body: some View {
//        Form {
//            // $name is two way binding, change both write and read
//            TextField("Enter your name", text: $name)
//                .textContentType(.username) // tell iOS provide name in keychain
//            Text("Hello \(name)") // only read
//        }
//    }
//}

//struct WeSplitBasic: View {
//    // @State is property wraper
//    @State private var tapCount = 0
//    var body: some View {
//        Button("Tap count \(tapCount)") {
//            tapCount += 1
//        }
//    }
//}

//struct WeSplitBasic: View {
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section("Section title") {
//                    Text("Text")
//                }
//                
//                Section("Section title") {
//                    Text("Text")
//                    Text("Text")
//                    Text("Text")
//                }
//                
//                Section("Section title") {
//                    Text("Text")
//                    Text("Text")
//                    Text("Text")
//                }
//            }
//            // inside navigationTitle can make them changed freely rather than outside the NavigationStack
//            .navigationTitle("SwiftUI")
//            .navigationBarTitleDisplayMode(.automatic)
//        }
//    }
//}

// This is a special piece of code that won’t actually form part of your final app that goes to the App Store, but is instead specifically for Xcode to use so it can show a preview of your UI design alongside your code.
#Preview {
    WeSplitBasic(selectedOption: "A")
}
