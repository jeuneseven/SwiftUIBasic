//
//  Lists.swift
//  SwiftUIBasic
//
//  List, ForEach, and row operations
//

import SwiftUI

// MARK: - Basic List

struct BasicListExample: View {
    var body: some View {
        List {
            Text("Row 1")
            Text("Row 2")
            Text("Row 3")
        }
    }
}

// MARK: - List with ForEach

struct ListWithForEachExample: View {
    let items = ["Apple", "Banana", "Cherry", "Date"]
    
    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
    }
}

// MARK: - List with Sections

struct ListWithSectionsExample: View {
    var body: some View {
        List {
            Section("Fruits") {
                Text("Apple")
                Text("Banana")
                Text("Cherry")
            }
            
            Section("Vegetables") {
                Text("Carrot")
                Text("Broccoli")
                Text("Spinach")
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - List with Mixed Content

struct ListMixedContentExample: View {
    var body: some View {
        List {
            Section("Static") {
                Text("Static Row 1")
                Text("Static Row 2")
            }
            
            Section("Dynamic") {
                ForEach(0..<5) { index in
                    Text("Dynamic Row \(index)")
                }
            }
        }
    }
}

// MARK: - List Styles

struct ListStylesExample: View {
    let items = ["Item 1", "Item 2", "Item 3"]
    
    var body: some View {
        TabView {
            List(items, id: \.self) { Text($0) }
                .listStyle(.automatic)
                .tabItem { Text("Automatic") }
            
            List(items, id: \.self) { Text($0) }
                .listStyle(.plain)
                .tabItem { Text("Plain") }
            
            List(items, id: \.self) { Text($0) }
                .listStyle(.insetGrouped)
                .tabItem { Text("Inset Grouped") }
            
            List(items, id: \.self) { Text($0) }
                .listStyle(.grouped)
                .tabItem { Text("Grouped") }
        }
    }
}

// MARK: - List with Delete

struct ListWithDeleteExample: View {
    @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    var body: some View {
        NavigationStack {
            List {
                // onDelete only works on ForEach
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Swipe to Delete")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

// MARK: - List with Move

struct ListWithMoveExample: View {
    @State private var items = ["First", "Second", "Third", "Fourth", "Fifth"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
                .onMove(perform: moveItems)
            }
            .navigationTitle("Drag to Reorder")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: - List with Swipe Actions

struct ListWithSwipeActionsExample: View {
    @State private var items = ["Email 1", "Email 2", "Email 3"]
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            if let index = items.firstIndex(of: item) {
                                items.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            print("Archive \(item)")
                        } label: {
                            Label("Archive", systemImage: "archivebox")
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            print("Pin \(item)")
                        } label: {
                            Label("Pin", systemImage: "pin")
                        }
                        .tint(.orange)
                    }
            }
        }
    }
}

// MARK: - List with Selection (Single)

struct ListSingleSelectionExample: View {
    let options = ["Option A", "Option B", "Option C", "Option D"]
    @State private var selection: String?
    
    var body: some View {
        VStack {
            List(options, id: \.self, selection: $selection) { option in
                Text(option)
            }
            
            if let selection {
                Text("Selected: \(selection)")
                    .padding()
            }
        }
    }
}

// MARK: - List with Selection (Multiple)

struct ListMultipleSelectionExample: View {
    let options = ["Option A", "Option B", "Option C", "Option D"]
    @State private var selections = Set<String>()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(options, id: \.self, selection: $selections) { option in
                    Text(option)
                }
                
                if !selections.isEmpty {
                    Text("Selected: \(selections.sorted().joined(separator: ", "))")
                        .padding()
                }
            }
            .navigationTitle("Multi-Select")
            .toolbar {
                EditButton()
            }
        }
    }
}

// MARK: - Preview

#Preview("Basic List") {
    BasicListExample()
}

#Preview("List with ForEach") {
    ListWithForEachExample()
}

#Preview("List with Sections") {
    ListWithSectionsExample()
}

#Preview("Mixed Content") {
    ListMixedContentExample()
}

#Preview("List Styles") {
    ListStylesExample()
}

#Preview("Delete") {
    ListWithDeleteExample()
}

#Preview("Move") {
    ListWithMoveExample()
}

#Preview("Swipe Actions") {
    ListWithSwipeActionsExample()
}

#Preview("Single Selection") {
    ListSingleSelectionExample()
}

#Preview("Multiple Selection") {
    ListMultipleSelectionExample()
}
