//
//  NavigationBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/11.
//

import SwiftUI

struct NavigationBasic: View {
    @State private var title = "SwiftUI"
    var body: some View {
        NavigationStack {
            Text("Hello World!")
            // This is great for times when that title reflects the name of something entered by the user
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct NavigationBasic: View {
//    var body: some View {
//        NavigationStack {
//            Text("Hello World!")
//                .toolbar { // If you want multiple buttons using the same placement, you can either repeat ToolbarItem or use ToolbarItemGroup
//                    ToolbarItemGroup {
//                        Button("Group Tap me") {
//
//                        }
//
//                        Button("Or Group Tap me") {
//
//                        }
//                    }
//
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button("Tap me") {
//
//                        }
//                    }
//
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button("Or Tap me") {
//
//                        }
//                    }
//                }
//            // If you need the user to decide between saving a change or discarding it, you might want to add the navigationBarBackButtonHidden() modifier so that they can't tap Back to exit without making a choice.
//                .navigationBarBackButtonHidden()
//        }
//    }
//}

//struct NavigationBasic: View {
//    var body: some View {
//        NavigationStack {
//            List(0..<100) { number in
//                Text("Row \(number)")
//            }
//            .navigationTitle("SwiftUI")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(.blue, for: .navigationBar)
//            .toolbarColorScheme(.dark, for: .navigationBar)
//            .toolbar(.hidden, for: .navigationBar)
//        }
//    }
//}

//@Observable
//class PathStore {
//    var path: NavigationPath {
//        didSet {
//            save()
//        }
//    }
//
//    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")
//
//    init() {
//        if let data = try? Data(contentsOf: savePath) {
//            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
//                path = NavigationPath(decoded)
//                return
//            }
//        }
//
//        path = NavigationPath()
//    }
//    // can save the path when app relaunch
//    func save() {
//        // return either the path data ready to encode to JSON or at least one object in the path does not conform to codable
//        guard let representation = path.codable else { return }
//
//        do {
//            let data = try JSONEncoder().encode(representation)
//            try data.write(to: savePath)
//        } catch {
//            print("Failed to save navigation data")
//        }
//    }
//}
//
//struct DetailView: View {
//    let number: Int
//    @Binding var path: NavigationPath
//
//    var body: some View {
//        NavigationLink("Go to random number \(number)", value: Int.random(in: 0...100))
//            .navigationTitle("Number \(number)")
//            .toolbar {
//                Button("Home") {
//                    path = NavigationPath()
//                }
//            }
//    }
//}
//struct NavigationBasic: View {
//    @State private var pathStore = PathStore()
//    var body: some View {
//        NavigationStack(path: $pathStore.path) {
//            DetailView(number: 0, path: $pathStore.path)
//                .navigationDestination(for: Int.self) { number in
//                    DetailView(number: number, path: $pathStore.path)
//                }
//        }
//    }
//}

//struct DetailView: View {
//    let number: Int
//    //@Binding let's pass a piece of state into another view, and let it modify it in here
//    @Binding var path: [Int]
////    @Binding var path: NavigationPath
//    
//    var body: some View {
//        NavigationLink("Go to random number \(number)", value: Int.random(in: 0...100))
//            .navigationTitle("Number \(number)")
//            .toolbar {
//                Button("Home") {
////                    path = NavigationPath()
//                    path.removeAll()
//                }
//            }
//    }
//}
//struct NavigationBasic: View {
//    @State private var path = [Int]()
////    @State private var path = NavigationPath()
//    var body: some View {
//        NavigationStack(path: $path) {
//            DetailView(number: 0, path: $path)
//                .navigationDestination(for: Int.self) { number in
//                    DetailView(number: number, path: $path)
//                }
//        }
//    }
//}

//struct NavigationBasic: View {
//    // NavigationPath is type eraser, it stores any kind of hashable data inside it, without exposing exactly what type of data each item is
//    @State private var path = NavigationPath()
//    var body: some View {
//        // use navigationDestination() with different data types
//        NavigationStack(path: $path) {
//            List {
//                Section("Navigation programmatic") {
//                    NavigationLink("number 1", value: 1)
//                    NavigationLink("string 2", value: "2")
//                }
//
//                Section("Number section") {
//                    ForEach(0..<5) { number in
//                        NavigationLink("number \(number)", value: number)
//                    }
//                }
//
//                Section("String section") {
//                    ForEach(0..<5) { number in
//                        NavigationLink("string \(number)", value: String(number))
//                    }
//                }
//            }
//            .toolbar {
//                Button("select number 1") {
//                    path.append(1)
//                }
//                Button("select string 2") {
//                    path.append(String(2))
//                }
////                Button("select number 1 then string 2") {
////                    path.append(1)
////                    path.append(String(2))
////                }
//            }
//            .navigationDestination(for: Int.self) { number in
//                Text("You selected number \(number)")
//            }
//            .navigationDestination(for: String.self) { number in
//                Text("You selected string \(number)")
//            }
//        }
//    }
//}

//struct NavigationBasic: View {
//    @State private var path = [Int]()
//    var body: some View {
//        // You can mix user navigation and programmatic navigation as much as you want – SwiftUI will take care of making sure your path array stays in sync with whatever data you show, regardless of how it's shown.
//        NavigationStack(path: $path) {
//            VStack {
//                ForEach(0..<10) { number in
//                    NavigationLink("Tap \(number)", value: number)
//                }
//                Button("1") {
//                    path = [1]
//                }
//                
//                Button("2") {
//                    path = [2]
//                }
//                
//                Button("1 and 2") {
//                    path = [1, 2]
//                }
//            }
//            .navigationDestination(for: Int.self) { selection in
//                Text("You selected \(selection)")
//            }
//        }
//    }
//}

//struct Student: Hashable {
//    var id = UUID()
//    let name: String
//    let age: Int
//}
//
//struct NavigationBasic: View {
//    var body: some View {
//        /* sepatate Destination from the value
//            1. the value must conform protocol Hashable
//            2. attach navigation destination modifier inside the navigation stack tell it what to do when it receive data
//         Hashable is common in Swift e.g. Set, ForEach(id: \.self)
//         */
//        NavigationStack {
//            List(0..<100) { number in
//                NavigationLink("number \(number)", value: number)
//            }
////            .navigationDestination(for: Int.self) { number in
////                Text("You selected \(number)")
////            }
//            .navigationDestination(for: Student.self) { student in
//                Text("You selected \(student.id)")
//            }
//        }
//    }
//}

//struct DetailView: View {
//    let number: Int
//
//    var body: some View {
//        Text("Detail View \(number)")
//    }
//
//    init(number: Int) {
//        print("Create DetailView \(number)")
//        self.number = number
//    }
//}
//
//struct NavigationBasic: View {
//    var body: some View {
//        NavigationStack {
//            List(0..<100) { number in
//                NavigationLink("Tap me") {
//                    // DetailView will be created a lot of times
//                    DetailView(number: number)
//                }
//            }
//        }
//    }
//}

#Preview {
    NavigationBasic()
}
