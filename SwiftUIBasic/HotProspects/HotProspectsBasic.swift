//
//  HotProspectsBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/13.
//

import SwiftUI
import UserNotifications
import SamplePackage

//@MainActor
//class DelayUpdater: ObservableObject {
//    var value = 0 {
//        willSet {
//            objectWillChange.send() // same as @Publish, Manually publishing ObservableObject changes
//        }
//    }
//    
//    init() {
//        for i in 1...10 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//                self.value += 1
//            }
//        }
//    }
//}
//
//struct HotProspectsBasic: View {
//    @StateObject private var updater = DelayUpdater()
//
//    var body: some View {
//        Text("Value is \(updater.value)")
//    }
//}

//@MainActor
//class UserClass: ObservableObject {
//    @Published var name = "Swift"
//}
//
//struct EditView: View {
//    /**
//     @EnvironmentObject
//     A dependency injection mechanism in SwiftUI.
//
//     Lets you put an ObservableObject into the environment so any descendant view can access and subscribe to it.
//
//     Eliminates the need to manually pass data down through multiple layers of views.
//     */
//    @EnvironmentObject var user: UserClass
//    
//    var body: some View {
//        TextField("Enter user name", text: $user.name)
//    }
//}
//
//struct DisplayView: View {
//    @EnvironmentObject var user: UserClass
//    
//    var body: some View {
//        Text("User name \(user.name)")
//    }
//}
//
//struct HotProspectsBasic: View {
//    @StateObject var user = UserClass()
//    
//    var body: some View {
//        Form {
//            VStack {
//                EditView()
//                DisplayView()
//            }
//            .environmentObject(user)
//        }
//    }
//}

//struct HotProspectsBasic: View {
//    let possableNumbers = Array(1...50) // or 1...50
//    
//    var results: String {
//        let selected = possableNumbers.random(7).sorted()
//        let strings = selected.map(String.init)
//        return strings.formatted()
//    }
//    
//    var body: some View {
//        Text(results)
//    }
//}

//struct HotProspectsBasic: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            Button("Request Permission") {
//                UNUserNotificationCenter.current().requestAuthorization(
//                    options: [.alert, .badge, .sound]) { success, error in
//                    if success {
//                        print("All set!")
//                    } else if let error {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//            
//            Button("Schedule Notification") {
//                let content = UNMutableNotificationContent()
//                content.title = "Feed the cat"
//                content.subtitle = "Po is hungry"
//                content.sound = UNNotificationSound.default
//                
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//                
//                UNUserNotificationCenter.current().add(request)
//            }
//        }
//    }
//}

//struct HotProspectsBasic: View {
//    var body: some View {
//        List {
//            Text("Swift")
//                .swipeActions(edge: .trailing) {
//                    Button("Delete", systemImage: "minus.circle", role: .destructive) {
//                        print("Delete")
//                    }
//
//                    Button("Read", systemImage: "circle", role: .cancel) {
//                        print("Read")
//                    }
//                }
//                .swipeActions(edge: .leading) {
//                    Button("Pin", systemImage: "pin") {
//                        print("Pinning")
//                    }
//                    .tint(.orange)
//                }
//        }
//    }
//}

//struct HotProspectsBasic: View {
//    @State private var backgroundColor = Color.red
//    @State private var currentSelectColor = Color.red
//    
//    var body: some View {
//        VStack {
//            Text("Hello World!")
//                .padding()
//                .background(backgroundColor)
//
//            Text("Change Color")
//                .padding()
//                .contextMenu {
//                    Button("Red", systemImage: currentSelectColor == .red ? "checkmark.circle.fill" : "", role: .destructive) {
//                        backgroundColor = .red
//                        currentSelectColor = backgroundColor
//                    }
//                    .foregroundStyle(.green) // not working
//
//                    Button("Green", systemImage: currentSelectColor == .green ? "checkmark.circle.fill" : "") {
//                        backgroundColor = .green
//                        currentSelectColor = backgroundColor
//                    }
//
//                    Button("Blue", systemImage: currentSelectColor == .blue ? "checkmark.circle.fill" : "") {
//                        backgroundColor = .blue
//                        currentSelectColor = backgroundColor
//                    }
//                }
//        }
//    }
//}

//struct HotProspectsBasic: View {
//    var body: some View {
//        Image(.blend)
//            // control how the pixel blending is applied
//            .interpolation(.none)
//            .resizable()
//            .scaledToFit()
//            .background(.black)
//    }
//}

struct HotProspectsBasic: View {
    @State private var output = ""
    
    var body: some View {
        Text(output)
            .task {
                await fetchReading()
            }
    }
    
    func fetchReading() async {
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://www.hackingwithswift.com/samples/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings"
        }

        let result = await fetchTask.result

        switch result {
        case .success(let str):
            output = str
        case .failure(let error):
            output = error.localizedDescription
        }
//        do {
//            output = try result.get()
//        } catch {
//            output = "Error: \(error.localizedDescription)"
//        }
    }
}

//struct HotProspectsBasic: View {
//    @State private var selectedTab = "One"
//    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            Tab("Tab One", systemImage: "circle", value: "One") {
//                Button("Show Tab Two") {
//                    selectedTab = "Two"
//                }
//            }
//            
//            Tab("Tab Two", systemImage: "star", value: "Two") {
//                Text("Tab Two")
//            }
//        }
//    }
//}

//struct HotProspectsBasic: View {
//    let options = [
//        "A",
//        "B",
//        "C",
//        "D"
//    ]
//    
////    @State private var selection: String?
//    @State private var selections = Set<String>()
//    
//    var body: some View {
//        List(options, id:\.self, selection: $selections) { option in
//            Text(option)
//        }
//        
////        if let selection = selection {
////            Text("You selected \(selection)")
////        }
//
//        if selections.isEmpty == false {
//            Text("You selected \(selections)")
//        }
//        EditButton()
//    }
//}

#Preview {
    HotProspectsBasic()
}
