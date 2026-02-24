//
//  NavigationPath.swift
//  SwiftUIBasic
//
//  Programmatic navigation, NavigationPath, and state restoration
//

import SwiftUI

// MARK: - Value-Based Navigation

struct ValueBasedNavigationExample: View {
    var body: some View {
        NavigationStack {
            List(0..<10) { number in
                // NavigationLink with value - separates destination from link
                NavigationLink("Number \(number)", value: number)
            }
            .navigationTitle("Numbers")
            // Define what to show for each value type
            .navigationDestination(for: Int.self) { number in
                Text("You selected \(number)")
                    .font(.largeTitle)
                    .navigationTitle("Detail")
            }
        }
    }
}

// MARK: - Multiple Data Types

struct MultipleDataTypesExample: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Numbers") {
                    ForEach(1...3, id: \.self) { number in
                        NavigationLink("Number \(number)", value: number)
                    }
                }
                
                Section("Strings") {
                    ForEach(["Apple", "Banana", "Cherry"], id: \.self) { fruit in
                        NavigationLink(fruit, value: fruit)
                    }
                }
            }
            .navigationTitle("Mixed Types")
            .navigationDestination(for: Int.self) { number in
                Text("Number: \(number)")
                    .font(.title)
            }
            .navigationDestination(for: String.self) { text in
                Text("String: \(text)")
                    .font(.title)
            }
        }
    }
}

// MARK: - Custom Hashable Type

struct Person: Hashable {
    var id = UUID()
    var name: String
    var age: Int
}

struct CustomTypeNavigationExample: View {
    let people = [
        Person(name: "Alice", age: 25),
        Person(name: "Bob", age: 30),
        Person(name: "Charlie", age: 35)
    ]
    
    var body: some View {
        NavigationStack {
            List(people, id: \.id) { person in
                NavigationLink(value: person) {
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.headline)
                        Text("Age: \(person.age)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("People")
            .navigationDestination(for: Person.self) { person in
                VStack(spacing: 20) {
                    Text(person.name)
                        .font(.largeTitle)
                    Text("Age: \(person.age)")
                        .font(.title2)
                }
            }
        }
    }
}

// MARK: - Programmatic Navigation with Path Array

struct ProgrammaticNavigationExample: View {
    @State private var path = [Int]()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Text("Current path: \(path.map(String.init).joined(separator: " → "))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button("Go to 1") {
                    path = [1]
                }
                
                Button("Go to 1 → 2 → 3") {
                    path = [1, 2, 3]
                }
                
                Button("Clear Path") {
                    path.removeAll()
                }
            }
            .navigationTitle("Home")
            .navigationDestination(for: Int.self) { number in
                VStack(spacing: 20) {
                    Text("Screen \(number)")
                        .font(.largeTitle)
                    
                    Button("Push \(number + 1)") {
                        path.append(number + 1)
                    }
                    
                    Button("Go Home") {
                        path.removeAll()
                    }
                }
                .navigationTitle("Screen \(number)")
            }
        }
    }
}

// MARK: - NavigationPath (Type-Erased)

struct NavigationPathExample: View {
    // NavigationPath is type-erased - stores any Hashable type
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Button("Push Number 42") {
                    path.append(42)
                }
                
                Button("Push String 'Hello'") {
                    path.append("Hello")
                }
                
                Button("Push Both") {
                    path.append(1)
                    path.append("World")
                }
                
                Button("Clear All") {
                    path = NavigationPath()
                }
                
                Text("Path count: \(path.count)")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Home")
            .navigationDestination(for: Int.self) { number in
                Text("Number: \(number)")
                    .font(.largeTitle)
            }
            .navigationDestination(for: String.self) { text in
                Text("String: \(text)")
                    .font(.largeTitle)
            }
        }
    }
}

// MARK: - Deep Link Navigation

struct DeepLinkDetailView: View {
    let number: Int
    @Binding var path: [Int]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail \(number)")
                .font(.largeTitle)
            
            NavigationLink("Go Deeper → \(number + 1)", value: number + 1)
            
            Button("Back to Root") {
                path.removeAll()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Detail \(number)")
    }
}

struct DeepLinkNavigationExample: View {
    @State private var path = [Int]()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Text("Tap buttons to simulate deep links")
                    .foregroundStyle(.secondary)
                
                Button("Open Detail 5") {
                    path = [5]
                }
                
                Button("Open Detail 1 → 2 → 3") {
                    path = [1, 2, 3]
                }
            }
            .navigationTitle("Deep Link Demo")
            .navigationDestination(for: Int.self) { number in
                DeepLinkDetailView(number: number, path: $path)
            }
        }
    }
}

// MARK: - Persistent Navigation State

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "NavigationPath")
    
    init() {
        // Load saved path on init
        if let data = try? Data(contentsOf: savePath),
           let decoded = try? JSONDecoder().decode(
            NavigationPath.CodableRepresentation.self,
            from: data
           ) {
            path = NavigationPath(decoded)
        } else {
            path = NavigationPath()
        }
    }
    
    func save() {
        // NavigationPath.codable returns nil if any item doesn't conform to Codable
        guard let representation = path.codable else { return }
        
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation path: \(error)")
        }
    }
}

struct PersistentNavigationExample: View {
    @State private var pathStore = PathStore()
    
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            VStack(spacing: 20) {
                Text("Navigation state persists across app launches")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding()
                
                NavigationLink("Go to Detail", value: 1)
                
                Button("Clear Saved State") {
                    pathStore.path = NavigationPath()
                }
            }
            .navigationTitle("Persistent Nav")
            .navigationDestination(for: Int.self) { number in
                VStack(spacing: 20) {
                    Text("Screen \(number)")
                        .font(.largeTitle)
                    
                    NavigationLink("Next Screen", value: number + 1)
                }
                .navigationTitle("Screen \(number)")
            }
        }
    }
}

// MARK: - Navigation with Environment Dismiss

struct ChildView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Child View")
                .font(.title)
            
            Button("Go Back Programmatically") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct EnvironmentDismissExample: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Go to Child") {
                ChildView()
            }
            .navigationTitle("Parent")
        }
    }
}

// MARK: - Preview

#Preview("Value-Based") {
    ValueBasedNavigationExample()
}

#Preview("Multiple Types") {
    MultipleDataTypesExample()
}

#Preview("Custom Type") {
    CustomTypeNavigationExample()
}

#Preview("Programmatic") {
    ProgrammaticNavigationExample()
}

#Preview("NavigationPath") {
    NavigationPathExample()
}

#Preview("Deep Link") {
    DeepLinkNavigationExample()
}

#Preview("Persistent") {
    PersistentNavigationExample()
}

#Preview("Environment Dismiss") {
    EnvironmentDismissExample()
}
